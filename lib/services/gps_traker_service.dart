// lib/services/gps_tracker_service.dart
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

class GpsTrackerService {
  GpsTrackerService({
    required this.enqueue, // funzione che salva in coda (la tua)
    this.intervalSec = 10,
    this.minDistanceM = 5,
  });

  final Future<bool> Function(Position pos)
      enqueue; // esegue il tuo _enqueueFromPosition
  final int intervalSec;
  final int minDistanceM;

  StreamSubscription<Position>? _sub;
  bool get isRunning => _sub != null;

  /// Avvia lo stream (Foreground Service su Android)
  Future<bool> start() async {
    try {
      // 1) servizi & permessi
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        return false;
      }

      var p = await Geolocator.checkPermission();

      // Se non abbiamo i permessi, apri le impostazioni
      if (p == LocationPermission.denied ||
          p == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return false;
      }

      // Su iOS, verifica che abbiamo almeno "While Using"
      if (p == LocationPermission.unableToDetermine) {
        return false;
      }

      // 2) settings (Android → foreground)
      final locationSettings = (Platform.isAndroid && !kIsWeb)
          ? AndroidSettings(
              accuracy: LocationAccuracy.best,
              intervalDuration: Duration(seconds: intervalSec),
              distanceFilter: minDistanceM,
              foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationTitle: 'MoveUP is active',
                notificationText: 'GPS tracking in progress',
                enableWakeLock: true,
              ),
            )
          : LocationSettings(
              accuracy: LocationAccuracy.best,
              distanceFilter: minDistanceM,
            );

      // 3) stream
      await _sub?.cancel();
      _sub = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((pos) async {
        try {
          await enqueue(pos);
        } catch (_) {}
      }, onError: (_) {});

      return true;
    } catch (e) {
      print('Errore generale in start(): $e');
      return false;
    }
  }

  /// Ferma lo stream e fa flush se vuoi (gestiscilo nell'enqueue/queue)
  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }

  /// Fix “una tantum” (per pulsante “acquisisci ora”)
  Future<bool> saveOnce(
      {LocationAccuracy accuracy = LocationAccuracy.best}) async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: const Duration(seconds: 10),
      );
      return await enqueue(pos);
    } catch (_) {
      return false;
    }
  }

  Future<void> dispose() async => stop();
}
