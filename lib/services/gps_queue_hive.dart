import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../pages/gps_log.dart';

class GpsQueue {
  GpsQueue({
    required this.apiBaseUrl,
    required this.utenteId,
    required this.authHeaders,
    this.onAuthExpired,
    this.batchSize = 20,
    this.uploadEvery = const Duration(seconds: 180),
  });

  final String apiBaseUrl;
  final String utenteId;
  final Map<String, String> Function() authHeaders;
  final Future<bool> Function()? onAuthExpired;

  final int batchSize;
  final Duration uploadEvery;

  // Hive
  static const String _boxName = 'gps_queue_box';
  Box<dynamic>? _box;

  DateTime _lastFlushAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _inFlight = false;
  DateTime _nextRetryAt = DateTime.fromMillisecondsSinceEpoch(0);
  int _retryStep = 0;

  bool _authRequired = false;
  DateTime? _authPausedUntil;

  bool get authRequired => _authRequired;

  bool _isAuthPaused() =>
      _authPausedUntil != null && DateTime.now().isBefore(_authPausedUntil!);

  Future<void> ensureOpen() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<dynamic>(_boxName);
    await _resetStuckSending();
  }

  Future<void> _resetStuckSending() async {
    // Se l’app crasha mentre "sending", rimetti pending (zombie killer)
    final b = _box!;
    final now = DateTime.now().toUtc();
    final keys = b.keys.toList();

    for (final k in keys) {
      final m = (b.get(k) as Map?)?.cast<String, dynamic>();
      if (m == null) continue;
      if (m['status'] == 'sending') {
        final sentAtIso = (m['sendingAt'] as String?) ?? '';
        DateTime? sentAt;
        try {
          if (sentAtIso.isNotEmpty) sentAt = DateTime.parse(sentAtIso);
        } catch (_) {}
        final ageSec =
            (sentAt == null) ? 999999 : now.difference(sentAt).inSeconds;
        if (ageSec > 120) {
          m['status'] = 'pending';
          m.remove('sendingAt');
          await b.put(k, m);
        }
      }
    }
  }

  void onLoginOk() {
    _authRequired = false;
    _authPausedUntil = null;
    _retryStep = 0;
    _nextRetryAt = DateTime.fromMillisecondsSinceEpoch(0);
  }

  int get length => _box?.length ?? 0;

  Future<void> enqueue({
    required double lat,
    required double lon,
    required String tsIso, // UTC ISO8601
    required double accM,
    double? altM,
    int? batteriaPerc,
    String? connessione,
    String? deviceId,
    double? direzioneDeg,
    double? velocitaKmh,
    String zona = 'auto',
    String modalita = 'preciso',
  }) async {
    await ensureOpen();
    final b = _box!;

    final point = <String, dynamic>{
      'latitudine': lat,
      'longitudine': lon,
      'timestamp': tsIso,
      'precisione_m': accM,
      'zona': zona,
      'modalita_tracking': modalita,
    };

    if (altM != null && altM.isFinite && altM.abs() < 10000) {
      point['altitudine_m'] = altM;
    }
    if (batteriaPerc != null)
      point['batteria_perc'] = batteriaPerc.clamp(0, 100).toInt();
    if (connessione != null) point['connessione'] = connessione;
    if (deviceId != null && deviceId.isNotEmpty) point['device_id'] = deviceId;
    if (direzioneDeg != null && direzioneDeg.isFinite)
      point['direzione_deg'] = direzioneDeg;
    if (velocitaKmh != null && velocitaKmh.isFinite)
      point['velocita_kmh'] = velocitaKmh;

    // record persistito
    final id =
        '${DateTime.now().microsecondsSinceEpoch}_${lat.toStringAsFixed(5)}_${lon.toStringAsFixed(5)}';
    final rec = <String, dynamic>{
      'id': id,
      'status': 'pending',
      'attempts': 0,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'point': point,
    };

    await b.put(id, rec);

    // Log UI
    GpsLog.instance
        .logQueued(lat: lat, lon: lon, accM: accM, altM: altM ?? 0.0);
  }

  Future<void> maybeFlush({bool force = false}) async {
    await ensureOpen();
    if (_inFlight) return;
    if (_authRequired || _isAuthPaused()) return;

    final now = DateTime.now();
    final ageOk = now.difference(_lastFlushAt) >= uploadEvery;
    final backoffOk = now.isAfter(_nextRetryAt);

    if (!backoffOk) return;

    final pendingCount = _countPending();
    final sizeOk = pendingCount >= batchSize;

    if (!(force || sizeOk || ageOk) || pendingCount == 0) return;
    await _flushOnce();
  }

  Future<void> flushNow() async {
    await ensureOpen();
    await _flushOnce();
  }

  int _countPending() {
    final b = _box!;
    int c = 0;
    for (final k in b.keys) {
      final m = (b.get(k) as Map?)?.cast<String, dynamic>();
      if (m == null) continue;
      if (m['status'] == 'pending') c++;
    }
    return c;
  }

  List<Map<String, dynamic>> _takePending(int n) {
    final b = _box!;
    final out = <Map<String, dynamic>>[];
    for (final k in b.keys) {
      final m = (b.get(k) as Map?)?.cast<String, dynamic>();
      if (m == null) continue;
      if (m['status'] == 'pending') {
        out.add(m);
        if (out.length >= n) break;
      }
    }
    return out;
  }

  Future<void> _markSending(List<Map<String, dynamic>> recs) async {
    final b = _box!;
    final nowIso = DateTime.now().toUtc().toIso8601String();
    for (final r in recs) {
      r['status'] = 'sending';
      r['sendingAt'] = nowIso;
      await b.put(r['id'], r);
    }
  }

  Future<void> _markPendingAgain(List<Map<String, dynamic>> recs,
      {String? err}) async {
    final b = _box!;
    for (final r in recs) {
      r['status'] = 'pending';
      r.remove('sendingAt');
      r['attempts'] = ((r['attempts'] as int?) ?? 0) + 1;
      if (err != null) r['lastError'] = err;
      await b.put(r['id'], r);
    }
  }

  Future<void> _deleteSent(List<Map<String, dynamic>> recs) async {
    final b = _box!;
    for (final r in recs) {
      await b.delete(r['id']);
    }
  }

  Future<void> _flushOnce() async {
    if (_inFlight) return;
    await ensureOpen();

    final b = _box!;
    final pending = _takePending(batchSize);
    if (pending.isEmpty) return;

    _inFlight = true;
    try {
      await _markSending(pending);

      final points = pending
          .map((r) => (r['point'] as Map).cast<String, dynamic>())
          .toList();

      GpsLog.instance.logFlushed(points.length);

      final uri = Uri.parse('$apiBaseUrl/posizioni_batch.php');
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          ...authHeaders(),
        },
        body: json.encode({
          'utente_id': utenteId,
          'points': points,
        }),
      );

      if (res.statusCode == 401 || res.statusCode == 403) {
        GpsLog.instance.logError('AUTH EXPIRED: HTTP ${res.statusCode}');

        // Prova UNA volta a rigenerare token
        if (onAuthExpired != null) {
          final ok = await onAuthExpired!();
          if (ok) {
            onLoginOk();
            await _markPendingAgain(pending, err: 'auth renewed');
            await Future.delayed(const Duration(milliseconds: 150));
            return await _flushOnce();
          }
        }

        _authRequired = true;
        _authPausedUntil = DateTime.now().add(const Duration(minutes: 10));
        await _markPendingAgain(pending, err: 'auth required');
        return;
      }

      if (res.statusCode != 200) {
        final err = 'HTTP ${res.statusCode} ${res.reasonPhrase}';
        GpsLog.instance.logError(err);
        await _markPendingAgain(pending, err: err);
        _retryStep = ((_retryStep + 1).clamp(1, 6)).toInt();
        _nextRetryAt = DateTime.now().add(Duration(seconds: 15 * _retryStep));
        return;
      }

      final data = json.decode(res.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        // Log saved
        for (final p in points) {
          final double lat = (p['latitudine'] as num).toDouble();
          final double lon = (p['longitudine'] as num).toDouble();
          final double acc = (p['precisione_m'] as num).toDouble();
          final double alt = (p['altitudine_m'] is num)
              ? (p['altitudine_m'] as num).toDouble()
              : 0.0;
          GpsLog.instance.logSaved(lat: lat, lon: lon, accM: acc, altM: alt);
        }

        await _deleteSent(pending);
        _lastFlushAt = DateTime.now();
        _retryStep = 0;
        _nextRetryAt = _lastFlushAt;

        // continua finché ci sono pending
        if (_countPending() > 0) {
          await Future.delayed(const Duration(milliseconds: 150));
          await _flushOnce();
        }
        return;
      }

      final msg = (data['message'] ?? 'errore').toString();
      GpsLog.instance.logError('Server success=false: $msg');
      await _markPendingAgain(pending, err: msg);

      _retryStep = ((_retryStep + 1).clamp(1, 6)).toInt();
      _nextRetryAt = DateTime.now().add(Duration(seconds: 15 * _retryStep));
    } catch (e) {
      final err = 'Eccezione flush: $e';
      GpsLog.instance.logError(err);
      await _markPendingAgain(pending, err: err);
      _retryStep = ((_retryStep + 1).clamp(1, 6)).toInt();
      _nextRetryAt = DateTime.now().add(Duration(seconds: 15 * _retryStep));
      if (kDebugMode) debugPrint('GPS batch EX: $e');
    } finally {
      _inFlight = false;
    }
  }
}
