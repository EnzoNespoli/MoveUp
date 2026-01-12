import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../pages/gps_log.dart';

class GpsQueue {
  GpsQueue({
    required this.apiBaseUrl,
    required this.utenteId,
    required this.authHeaders, // () => Map<String, String> con Authorization
    this.onAuthExpired,
    this.batchSize = 20,
    this.uploadEvery = const Duration(seconds: 180),
  });

  final String apiBaseUrl;
  final String utenteId;
  final Map<String, String> Function() authHeaders;

  final int batchSize;
  final Duration uploadEvery;

  final List<Map<String, dynamic>> _queue = [];
  DateTime _lastFlushAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _inFlight = false;
  DateTime _nextRetryAt = DateTime.fromMillisecondsSinceEpoch(0);
  int _retryStep = 0;

  final Future<bool> Function()? onAuthExpired;

  int get length => _queue.length;

  bool _authRequired = false;
  DateTime? _authPausedUntil;

  bool get authRequired => _authRequired;

  bool _isAuthPaused() =>
      _authPausedUntil != null && DateTime.now().isBefore(_authPausedUntil!);

  void clearAuthPause() {
    _authRequired = false;
    _authPausedUntil = null;
    _retryStep = 0;
    _nextRetryAt = DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Stesso schema di posizioni_batch.php
  void enqueue({
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
  }) {
    final m = <String, dynamic>{
      'latitudine': lat,
      'longitudine': lon,
      'timestamp': tsIso,
      'precisione_m': accM,
      'zona': zona,
      'modalita_tracking': modalita,
    };

    if (altM != null && altM.isFinite && altM.abs() < 10000) {
      m['altitudine_m'] = altM;
    }
    if (batteriaPerc != null)
      m['batteria_perc'] = batteriaPerc.clamp(0, 100).toInt();
    if (connessione != null) m['connessione'] = connessione;
    if (deviceId != null && deviceId.isNotEmpty) m['device_id'] = deviceId;
    if (direzioneDeg != null && direzioneDeg.isFinite)
      m['direzione_deg'] = direzioneDeg;
    if (velocitaKmh != null && velocitaKmh.isFinite)
      m['velocita_kmh'] = velocitaKmh;

    _queue.add(m);

    // 👇 Log: appena accodato (per la card)
    GpsLog.instance.logQueued(
      lat: lat,
      lon: lon,
      accM: accM,
      altM: altM ?? 0.0,
    );
  }

  Future<void> maybeFlush({bool force = false}) async {
    if (_authRequired || _isAuthPaused()) return;
    if (_inFlight) return;
    final now = DateTime.now();
    final ageOk = now.difference(_lastFlushAt) >= uploadEvery;
    final sizeOk = _queue.length >= batchSize;
    final backoffOk = now.isAfter(_nextRetryAt);
    if (!(force || sizeOk || ageOk) || !backoffOk || _queue.isEmpty) return;
    await _flushOnce();
  }

  void onLoginOk() {
    _authRequired = false;
    _authPausedUntil = null;
    _retryStep = 0;
    _nextRetryAt = DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<void> flushNow() => _flushOnce();

  Future<void> _flushOnce() async {
    if (_queue.isEmpty) return;
    _inFlight = true;
    try {
      final take = _queue.length > batchSize ? batchSize : _queue.length;
      final points = _queue.take(take).toList();

      // 👇 Log: stai inviando N elementi
      GpsLog.instance.logFlushed(points.length);

      final uri = Uri.parse('$apiBaseUrl/posizioni_batch.php');
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          ...authHeaders(), // Authorization: Bearer <JWT>
        },
        body: json.encode({
          'utente_id': utenteId,
          'points': points,
        }),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          // 👇 Log: segna ogni punto come "salvato"
          for (final p in points) {
            final double lat = (p['latitudine'] as num).toDouble();
            final double lon = (p['longitudine'] as num).toDouble();
            final double acc = (p['precisione_m'] as num).toDouble();
            final double alt = (p['altitudine_m'] is num)
                ? (p['altitudine_m'] as num).toDouble()
                : 0.0;
            GpsLog.instance.logSaved(lat: lat, lon: lon, accM: acc, altM: alt);
          }

          _queue.removeRange(0, take);
          _lastFlushAt = DateTime.now();
          _retryStep = 0;
          _nextRetryAt = _lastFlushAt;

          // Continua a svuotare se restano elementi
          if (_queue.isNotEmpty) {
            await Future.delayed(const Duration(milliseconds: 150));
            await _flushOnce();
          }
          return;
        } else {
          // Server ha risposto 200 ma success=false
          GpsLog.instance
              .logError('Server success=false: ${data['message'] ?? 'errore'}');
        }
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        // AUTH KO: non martellare
        GpsLog.instance.logError('AUTH REQUIRED: HTTP ${res.statusCode}');
        // Prova UNA volta a rigenerare token e ritentare
        if (onAuthExpired != null) {
          final ok = await onAuthExpired!();
          if (ok) {
            GpsLog.instance.logError('AUTH renewed, retrying flush...');
            _authRequired = false;
            _authPausedUntil = null;
            await Future.delayed(const Duration(milliseconds: 150));
            return await _flushOnce(); // retry singolo
          }
        }

        // Se non riesce: pausa lunga e stop
        _authRequired = true;
        _authPausedUntil = DateTime.now().add(const Duration(minutes: 10));
        return; // IMPORTANTISSIMO: esci senza fare backoff corto
      } else {
        GpsLog.instance.logError('HTTP ${res.statusCode} ${res.reasonPhrase}');
      }

      // backoff: 15,30,45,60,60,60...
      _retryStep = ((_retryStep + 1).clamp(1, 6)).toInt();
      _nextRetryAt = DateTime.now().add(Duration(seconds: 15 * _retryStep));
    } catch (e) {
      GpsLog.instance.logError('Eccezione flush: $e');
      _retryStep = ((_retryStep + 1).clamp(1, 6)).toInt();
      _nextRetryAt = DateTime.now().add(Duration(seconds: 15 * _retryStep));
      if (kDebugMode) debugPrint('GPS batch EX: $e');
    } finally {
      _inFlight = false;
    }
  }
}
