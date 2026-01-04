import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GpsQueue {
  GpsQueue({
    required this.apiBaseUrl,
    required this.utenteId,
    required this.authHeaders, // () => Map<String,String>
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

  String? lastRejectReason; // <-- NUOVO
  int get length => _queue.length;

  void enqueue({
    required double lat,
    required double lon,
    required String tsIso, // UTC ISO8601
    required double accM,
    required double altM,
    String? lvl, // "L0"/"L1"/"L2" opzionale
  }) {
    _queue.add({
      'ts': tsIso,
      'lat': lat,
      'lon': lon,
      'acc_m': accM,
      'alt_m': altM,
      if (lvl != null) 'lvl': lvl,
      'src': 'app',
    });
  }

  Future<void> maybeFlush({bool force = false}) async {
    if (_inFlight) return;
    final now = DateTime.now();

    final ageOk = now.difference(_lastFlushAt) >= uploadEvery;
    final sizeOk = _queue.length >= batchSize;
    final backoffOk = now.isAfter(_nextRetryAt);

    if (!(force || sizeOk || ageOk) || !backoffOk || _queue.isEmpty) return;

    await _flushOnce();
  }

  Future<void> flushNow() => _flushOnce();

  Future<void> _flushOnce() async {
    if (_queue.isEmpty) return;
    _inFlight = true;
    try {
      // Prendi un batch
      final take = _queue.length > batchSize ? batchSize : _queue.length;
      final points = _queue.take(take).toList();

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

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data['success'] == true) {
          // rimuovi il batch inviato
          _queue.removeRange(0, take);
          _lastFlushAt = DateTime.now();
          _retryStep = 0; // reset backoff
          _nextRetryAt = _lastFlushAt;

          // se rimane roba, prova a continuare (evita loop infinito)
          if (_queue.isNotEmpty) {
            // breve respiro per evitare saturazione
            await Future.delayed(const Duration(milliseconds: 150));
            await _flushOnce();
          }
          return;
        }
      }

      // Fallimento: setta backoff
      _retryStep = (_retryStep + 1).clamp(1, 6);
      final wait = Duration(seconds: 15 * _retryStep); // 15,30,45,60,60,60...
      _nextRetryAt = DateTime.now().add(wait);
    } catch (_) {
      _retryStep = (_retryStep + 1).clamp(1, 6);
      final wait = Duration(seconds: 15 * _retryStep);
      _nextRetryAt = DateTime.now().add(wait);
    } finally {
      _inFlight = false;
    }
  }
}
