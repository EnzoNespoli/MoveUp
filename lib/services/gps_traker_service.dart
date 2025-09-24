import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GpsTrackerService {
  final int gpsSampleSec; // es. 5
  final int gpsMinDistanceM; // es. 8
  final int gpsBatchSec; // es. 30

  final String apiBase; // es. https://mytrak.app/move/api
  final String jwt; // Bearer token
  final int utenteId; // opzionale: se admin, altrimenti usa token lato server

  Timer? _sampleTimer;
  Timer? _batchTimer;
  Position? _lastSavedPos;
  final List<Map<String, dynamic>> _buffer = [];

  GpsTrackerService({
    required this.gpsSampleSec,
    required this.gpsMinDistanceM,
    required this.gpsBatchSec,
    required this.apiBase,
    required this.jwt,
    required this.utenteId,
  });

  Future<void> start() async {
    await _ensurePermissions();

    // Timer di campionamento
    _sampleTimer?.cancel();
    _sampleTimer = Timer.periodic(Duration(seconds: gpsSampleSec), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: gpsSampleSec),
        );

        // distanza minima
        final shouldStore = () {
          if (_lastSavedPos == null) return true;
          final d = Geolocator.distanceBetween(
            _lastSavedPos!.latitude,
            _lastSavedPos!.longitude,
            pos.latitude,
            pos.longitude,
          );
          return d >= gpsMinDistanceM;
        }();

        if (shouldStore) {
          _lastSavedPos = pos;
          // ISO 8601 con timezone
          final tsIso = DateTime.now().toIso8601String();
          _buffer.add({
            "lat": pos.latitude,
            "lon": pos.longitude,
            "tsIso": tsIso,
            // opzionali se disponibili:
            "accM": pos.accuracy,
            "altM": pos.altitude,
          });
        }
      } catch (_) {
        // opzionale: log
      }
    });

    // Timer di invio batch + ricalcolo
    _batchTimer?.cancel();
    _batchTimer = Timer.periodic(Duration(seconds: gpsBatchSec), (_) async {
      await _flushBatch();
    });
  }

  Future<void> stop() async {
    _sampleTimer?.cancel();
    _batchTimer?.cancel();
    await _flushBatch(); // invia ciò che resta
  }

  Future<void> _flushBatch() async {
    if (_buffer.isEmpty) return;

    final points = List<Map<String, dynamic>>.from(_buffer);
    _buffer.clear();

    final uri = Uri.parse(
        "$apiBase/posizioni_batch.php?utente_id=$utenteId"); // se non admin, puoi rimuovere la query
    final res = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer $jwt",
      },
      body: jsonEncode({"points": points}),
    );

    if (res.statusCode != 200) {
      // fallito: rimetto in coda
      _buffer.insertAll(0, points);
      return;
    }

    // opzionale: se vuoi un ricalcolo esplicito separato
    // await _recalcAttivitaOggi();
  }

  Future<void> _recalcAttivitaOggi() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final uri = Uri.parse(
        "$apiBase/ricalcola_attivita.php?utente_id=$utenteId&data=$today");
    try {
      await http.post(
        uri,
        headers: {"Authorization": "Bearer $jwt"},
      );
    } catch (_) {}
  }

  Future<void> _ensurePermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // chiedi all’utente di abilitare il GPS: Geolocator.openLocationSettings();
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // per background su Android/iOS: gestisci le policy/permessi specifici dell’OS
  }
}
