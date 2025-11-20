// gps_log.dart
import '../db.dart'; // contiene `apiBaseUrl`

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kIsWeb;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // VoidCallback

enum GpsLogStatusE { queued, flushed, saved, error }

class GpsLogEntryE {
  final DateTime ts;
  final GpsLogStatusE status;
  final double? lat, lon, accM, altM, speedKmh;
  final String msg;
  final String? errorCode;
  final String? batchId;
  final int? seq;
  final Map<String, dynamic>? extra;

  GpsLogEntryE({
    required this.ts,
    required this.status,
    this.lat,
    this.lon,
    this.accM,
    this.altM,
    this.speedKmh,
    this.msg = '',
    this.errorCode,
    this.batchId,
    this.seq,
    this.extra,
  });

  Map<String, dynamic> toJson({
    required String appVersion,
    required String platform,
  }) {
    return {
      'client_ts': ts.toIso8601String(),
      'status': status.name,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (accM != null) 'acc_m': accM,
      if (altM != null) 'alt_m': altM,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (batchId != null) 'batch_id': batchId,
      if (seq != null) 'seq': seq,
      if (msg.isNotEmpty) 'msg': msg,
      if (errorCode != null) 'error_code': errorCode,
      'app_version': appVersion,
      'platform': platform,
      if (extra != null) 'extra': extra,
    };
  }
}

class GpsLogE {
  bool _enabled = true;
  bool _verbose = false; // <— accendi/spegni tracing

  void setVerbose(bool v) => _verbose = v;

  void _log(String msg) {
    if (_verbose){
      //debugPrint('[GpsLogE] $msg');
    }
  }

  GpsLogE._();
  static final GpsLogE instance = GpsLogE._();

  // Auth
  static const _storage = FlutterSecureStorage();
  String? _jwtToken;

  /// Imposta/aggiorna il JWT subito dopo il login/refresh.
  void setToken(String? token) {
    _jwtToken = (token != null && token.isNotEmpty) ? token : null;
  }

  /// Abilita/disabilita a runtime (es. anonimo → false).
  void setEnabled(bool enabled) => _enabled = enabled;

  /// Per forzare l’invio immediato (es. bottone nella card).
  Future<void> flushNow() => _flushNow();

  // Config
  VoidCallback? _onAuthExpired;

  void configureE({
    VoidCallback? onAuthExpired,
    bool enabled = true,
    bool verbose = true,
  }) {
    _onAuthExpired = onAuthExpired;
    _enabled = enabled;
    _verbose = verbose;
    _log('configured enabled=$_enabled verbose=$_verbose');
  }

  // Stream per UI
  final _controller = StreamController<List<GpsLogEntryE>>.broadcast();
  List<GpsLogEntryE> _items = [];
  List<GpsLogEntryE> get current => _items;
  Stream<List<GpsLogEntryE>> get stream => _controller.stream;

  // Coda invii
  final List<GpsLogEntryE> _pending = [];
  Timer? _timer;
  int maxUiItems = 200;
  int batchSize = 25;
  Duration debounceOk = const Duration(seconds: 10);
  Duration debounceError = const Duration(seconds: 1);

  String _platformName() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }

  void add(GpsLogEntryE e) {
    _items = [e, ..._items].take(maxUiItems).toList();
    _controller.add(_items);

    _log(
        'add status=${e.status.name} q=${_pending.length + 1} enabled=$_enabled');
    if (!_enabled) return;

    _pending.add(e);
    if (e.status == GpsLogStatusE.error) {
      _flushSoon(debounceError);
    } else if (_pending.length >= batchSize) {
      _flushNow();
    } else {
      _flushSoon(debounceOk);
    }
  }

  void clear() {
    _items = [];
    _controller.add(_items);
  }

  void _flushSoon(Duration d) {
    _log('flushSoon in ${d.inSeconds}s (pending=${_pending.length})');
    _timer?.cancel();
    _timer = Timer(d, _flushNow);
  }

  // Legge il token; ritorna null se assente
  Future<String?> _getTokenInz() async {
    if (_jwtToken != null && _jwtToken!.isNotEmpty) {
      _log('token from cache OK $_jwtToken');
      return _jwtToken;
    }
    final t = await _storage.read(key: 'jwt_token');
    _jwtToken = (t != null && t.isNotEmpty) ? t : null;
    _log('token from storage: ${_jwtToken == null ? 'NULL' : 'OK'}');
    return _jwtToken;
  }

  Future<void> _flushNow() async {
    if (!_enabled) {
      _log('flushNow skipped: disabled');
      return;
    }
    if (_pending.isEmpty) {
      _log('flushNow skipped: queue empty');
      return;
    }

    final batch = List<GpsLogEntryE>.from(_pending);
    _pending.clear();
    _log('flushNow START items=${batch.length}');

    try {
      final token = await _getTokenInz();
      if (token == null) {
        _log('no token -> requeue ${batch.length} items');
        _pending.insertAll(0, batch);
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      // 1) Utente loggato
      String? idLogin = prefs.getString("utenteIdLogin");
      String? idAnonimo = prefs.getString("utenteIdAnonimo");  
       
      final info = await PackageInfo.fromPlatform();
      final appVersion = '${info.version}+${info.buildNumber}';
      final platform = _platformName();

      final payload = batch
          .map((e) => e.toJson(appVersion: appVersion, platform: platform))
          .toList();

      final utenteId = (idLogin != null && idLogin.isNotEmpty)
    ? idLogin
    : (idAnonimo != null && idAnonimo.isNotEmpty ? idAnonimo : null);

      //debugPrint('utenteId: $utenteId - token: $token ');

      final url = '$apiBaseUrl/gps_debug_log.php?utente_id=$utenteId';

      _log('POST $url items=${payload.length}');
        final res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(payload),
      );
     
      _log('HTTP ${res.statusCode} bodyLen=${res.body.length}');

      if (res.statusCode == 401) {
        _log('401 unauthorized -> notify & requeue');
        _jwtToken = null;
        _onAuthExpired?.call();
        _pending.insertAll(0, batch);
        return;
      }
      if (res.statusCode != 200) {
        _log('server error: ${res.body}');
        throw Exception('HTTP ${res.statusCode}');
      }

      _log('flushNow OK');
    } catch (err) {
      _log('EXCEPTION: $err');
      final e = GpsLogEntryE(
        ts: DateTime.now(),
        status: GpsLogStatusE.error,
        msg: 'log upload failed: $err',
      );
      _items = [e, ..._items].take(maxUiItems).toList();
      _controller.add(_items);
    }
  }
}
