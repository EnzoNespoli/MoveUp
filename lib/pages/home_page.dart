import 'dart:async';

import 'dart:convert';
import 'onboarding_page.dart';
import 'card_sceltastorico.dart';
import 'card_diario_gps.dart';
import 'card_mappaposizione.dart';
import 'dashboard_header.dart';
import 'card_trakinggps.dart';
import 'card_reportgiornaliero.dart';
import 'card_reportsettimanale.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'bottom_navigationbar.dart';
import 'gps_log.dart';
import 'auto_image_carousel.dart';
import '../services/marketing_content.dart';
import '../services/slide.dart';

import '../services/gps_log_entry.dart';
import '../services/app_header_bar.dart';
import '../services/app_footer.dart';
import '../services/app_banner.dart'; // <-- importa AppBanner
import '../services/gps_queue.dart';

import '../db.dart'; // Importa la costante globale
import '../lingua.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import '../native_timezone.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage extends StatefulWidget {
  final void Function(Locale?) onChangeLocale; // <-- aggiungi
  const HomePage({super.key, required this.onChangeLocale});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = const FlutterSecureStorage();
  String? _jwtToken;

  bool prtDbg = false; // da mettere a false in produzione

  bool trackingAttivo = false;
  int countdown = 19;
  int countdownLevel = 25;
  Timer? countdownTimer;
  String utenteId = '';
  String nomeId = '';
  String debugUtente = '';
  String ultimaPosizione = '';
  String gpsErrore = '';

  List<Map<String, dynamic>> livelli = [
    {'durata': '--', 'trend': '--'},
    {'durata': '--', 'trend': '--'},
    {'durata': '--', 'trend': '--'},
  ];

  List<List<Map<String, dynamic>>> sessioniLivelli = [[], [], []];
  Map<int, List<Map<String, dynamic>>> dettagliLivello = {};
  List<int> livelliInCaricamento = [];

  bool utenteTemporaneo = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 1) State
  late final MapController _mapController;
  double _zoom = 13; // es.
  LatLng? posizioneUtente;

  bool consensoTrackingGps = true; // valore di default
  String appVersion = '';

  Map<int, List<dynamic>> datiLivelli = {0: [], 1: [], 2: []};
  Map<int, List<dynamic>> datiLivelliSett = {0: [], 1: [], 2: []};
  bool loading = true;

  (List<OraStat>, List<Periodo>)? datiGiornalieri;

  String livelloUtente = 'Free'; // oppure Start, Basic, Plus, Pro
  int giorniRimanenti = 0;
  int livelloUtenteId = 0;

  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> features = {}; // permessi del piano
  int limitsHistoryDaysMax = 1; // limite consultazione (server-side)

  bool _gpsInFlight = false;
  double? _lastLat, _lastLon;
  DateTime? _lastTs;

  DateTime? _lastRecalcAt;
  final Duration _recalcInterval = const Duration(minutes: 3); // cambia se vuoi
  bool _loaderOpen = false;

  GpsQueue? gpsQueue;

  //------------------------------------------------------
  // main line page
  //------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _mapController = MapController(); // <<< aggiungi questo

    // configura il logger GPS
    GpsLogE.instance.configureE(
      onAuthExpired: () {
        // opzionale: mostra snackbar / forza relogin / refresh token
        //debugPrint('JWT expired while flushing gps logs');
      },
      enabled: true, // metti false se vuoi spegnere la telemetria in prod
    );

    _checkOnboarding();
    _getVersion();
    _getToken();

    // Se hai già un token in RAM al boot:
    GpsLogE.instance.setToken(_jwtToken);
  }

  //----------------------------------------------------------
  // reperisce la versione
  //-----------------------------------------------------------
  Future<void> _getVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  //----------------------------------------------------------
  // posizione gps
  //-----------------------------------------------------------
  Future<void> _ottieniPosizione() async {
    try {
      // 1) Servizi attivi?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          gpsErrore = context.t.errore_004;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            gpsErrore = context.t.errore_001;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          gpsErrore = context.t.errore_002;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();

      setState(() {
        posizioneUtente = LatLng(pos.latitude, pos.longitude);
        ultimaPosizione =
            '${pos.latitude}, ${pos.longitude} (±${pos.accuracy.toStringAsFixed(1)} m, alt. ${pos.altitude.toStringAsFixed(1)} m)';
        gpsErrore = '';
      });
    } catch (e) {
      setState(() {
        gpsErrore = '${context.t.errore_003} $e';
      });
    }
  }

  //-------------------------------------------------------------
  // centra la mappa (con zoom opzionale)
  //--------------------------------------------------------------
  void _centerOn(LatLng target, {double? zoom}) {
    final currentZoom = (() {
      try {
        // flutter_map >=5
        return _mapController.camera.zoom;
      } catch (_) {
        // flutter_map <=4 fallback
        return _zoom;
      }
    })();

    final z = (zoom ?? currentZoom).clamp(1.0, 18.0).toDouble();
    _mapController.move(target, z); // sposta davvero la mappa
    setState(() => _zoom = z); // tieni in sync lo stato
  }

  //---------------------------------------------------------------
  // 2) Handlers
  //---------------------------------------------------------------
  Future<void> _refreshPosizione() async {
    await _ottieniPosizione(); // qui aggiorna posizioneUtente con setState
    if (posizioneUtente != null) {
      _centerOn(posizioneUtente!, zoom: _zoom);
    }
  }

  //---------------------------------------------------------------
  // Zoom
  //---------------------------------------------------------------
  void _zoomDelta(double delta) {
    final next =
        (_mapController.camera.zoom + delta).clamp(1.0, 18.0).toDouble();
    setState(() => _zoom = next);
    _mapController.move(_mapController.camera.center, next);
  }

  //------------------------------------------------------
  // inizializza token e le procedure
  //-------------------------------------------------------
  Future<void> _getToken() async {
    _jwtToken = await _storage.read(key: 'jwt_token');

    if (_jwtToken == null || _jwtToken!.isEmpty) {
      final ok = await _login(); // ⬅️ fai login e salva il token

      if (!ok) {
        // Login fallito → passa ad anonimo per non bloccare l’app
        utenteTemporaneo = true;

        setState(() {});
        return;
      }
      await _loadAll();
      return;
    }

    // Controlla se il token è scaduto
    final isExpired = JwtDecoder.isExpired(_jwtToken!);

    if (!isExpired) {
      // Token valido → procedo
      await _loadAll();
      return;
    }

    // 4) Token scaduto → provo il refresh (se disponibile)
    final refreshed = await _login(); // ⬅️ fai login e salva il token
    if (refreshed) {
      // Refresh riuscito → aggiorno token e continuo
      _jwtToken = await _storage.read(key: 'jwt_token');
      await _loadAll();
      return;
    }

    // 5) Refresh fallito o non presente → passo ad anonimo
    utenteTemporaneo = true;
    await _loadAll();
    return;
  }

  //------------------------------------------------------
  // carica tutto (usato dopo onboarding)
  //-------------------------------------------------------
  Future<void> _loadAll() async {
    _jwtToken = await _storage.read(key: 'jwt_token');

    // Mostra la rotella SOLO se non è temporaneo/anonimo
    final showLoader = (utenteTemporaneo != true);
    if (showLoader) {
      _showBlockingLoader(context.t.storico_14 ?? 'Your data in progress …');
    }

    try {

      await caricaUtente(); // carica o crea utente
      await caricaLivelloUtente();

      //await ricalcolaEaggiornaAttivita('loadAll'); // ricalcola attività
      //await _caricaDatiGiornalieri();
      //await _ottieniPosizione(); // carica la posizione la prima volta
      //await caricaTuttiLivelli();
      //await _maybeRecalc(force: true);
      //await aggiornaDataUltimoAccesso();
      //await callAppOpen();

      final futures = [
  ricalcolaEaggiornaAttivita('loadAll'),
  _caricaDatiGiornalieri(),
  _ottieniPosizione(),
  caricaTuttiLivelli(),
  _maybeRecalc(force: true),
  aggiornaDataUltimoAccesso(),
  callAppOpen(),
];
await Future.wait(futures);

      _lastLat = _lastLon = null;
      _initQueue();
    } finally {
      if (showLoader) _hideBlockingLoader();
    }
  }

  //---------------------------------------------------------
  // crea token chiamando login anonimo per avere autenticazione
  //---------------------------------------------------------
  Future<bool> _login() async {
    final uri = Uri.parse('$apiBaseAut/anon.php');
    final res = await http.get(uri);
    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final token = data['token'] as String;

    await _storage.write(key: 'jwt_token', value: token);

    // salva token e usalo negli header:
    // headers: {'Authorization': 'Bearer $token'}
    return data['ok'] == true;
  }

  //---------------------------------------------------
  // imposta l'heder
  //----------------------------------------------------
  Map<String, String> _authHeaders() {
    return {
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  //---------------------------------------------------------------
  // carica l'utente se esite altrimenti lo crea
  //----------------------------------------------------------------
  Future<void> caricaUtente() async {
    final prefs = await SharedPreferences.getInstance();

    // 1) Utente loggato
    String? idLogin = prefs.getString("utenteIdLogin");
    String? nomeLogin = prefs.getString("nomeIdLogin");
    //debugPrint("caricaUtente: idLogin=$idLogin nomeLogin=$nomeLogin");
    if (idLogin != null && idLogin.isNotEmpty) {
      final ok = await verificaEsistenzaUtente(idLogin);
      if (ok) {
        setState(() {
          utenteId = idLogin;
          nomeId = nomeLogin ?? '';
          utenteTemporaneo = false;
          debugUtente = "Nome: $nomeId";
        });
        //debugPrint("caricaUtente: utente loggato trovato $utenteId");
        return;
      } else {
        // ripulisci login scaduto
        await prefs.remove("utenteIdLogin");
        await prefs.remove("nomeIdLogin");
        //debugPrint("caricaUtente: utente loggato NON trovato pulito idLogin");
      }
    }

    // 2) Utente anonimo
    String? idAnonimo = prefs.getString("utenteIdAnonimo");
    String? nomeAnonimo = prefs.getString("nomeIdAnonimo");
    //debugPrint("caricaUtente: idAnonimo=$idAnonimo nomeAnonimo=$nomeAnonimo");
    if (idAnonimo != null && idAnonimo.isNotEmpty) {
      final ok = await verificaEsistenzaUtente(idAnonimo);
      if (ok) {
        setState(() {
          utenteId = idAnonimo;
          nomeId = nomeAnonimo ?? '';
          utenteTemporaneo = true;
          debugUtente = "Nome: $nomeId";
        });
        //debugPrint("caricaUtente: utente anonimo trovato $utenteId");
        return;
      } else {
        // ripulisci anonimo scaduto
        await prefs.remove("utenteIdAnonimo");
        await prefs.remove("nomeIdAnonimo");
        //debugPrint("caricaUtente: utente anonimo NON trovato pulito idAnonimo");
        await inizializzaUtente();
        return;
      }
    }
    //debugPrint("caricaUtente: nessun utente trovato, crea utente anonimo");
    // 3. Se non esiste nulla, crea utente anonimo
    await inizializzaUtente();
  }

  //-------------------------------------------------------------------------
  // verifica esistenza utente
  //-------------------------------------------------------------------------
  Future<bool> verificaEsistenzaUtente(String utenteId) async {
    try {
      final res = await http.get(
        Uri.parse("$apiBaseUrl/utenti_read.php?utente_id=$utenteId"),
        headers: _jwtToken != null ? _authHeaders() : null,
      );

      if (res.statusCode != 200) return false;

      final body = json.decode(res.body);

      return body['success'] == true;
    } catch (_) {
      return false; // in caso di errore rete, non bloccare l'app
    }
  }

  //----------------------------------------------------------------
  // inizializza utente generico
  //----------------------------------------------------------------
  Future<void> inizializzaUtente() async {
    if (utenteTemporaneo) {
      try {
        final res = await http.post(
          Uri.parse("$apiBaseUrl/crea_utente.php"),
          headers: _jwtToken != null ? _authHeaders() : null,
          body: jsonEncode({'tipo': 'anonimo'}),
        );

        final data = json.decode(res.body);

        if (data['success'] == true) {
          setState(() {
            utenteId = data['utente_id'].toString();
            nomeId = data['nome']?.toString() ?? 'Error User';
            debugUtente = "Nome: $nomeId";
          });
          // ...dopo aver ottenuto utenteId e nomeId...
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("utenteIdAnonimo", utenteId);
          await prefs.setString("nomeIdAnonimo", nomeId);

          //imposta timezone
          syncTimezone(utenteId);
        }
      } catch (e) {
        utenteId = '';
        nomeId = 'Utente ERRATO $e';

        setState(() {
          gpsErrore = '❌ ${context.t.user_err01} $e';
        });
      }
    } else {
      //
    }
  }

  //-------------------------------------------------------------------------
  // sincronizza timezone
  //-------------------------------------------------------------------------
  Future<void> syncTimezone(String userId) async {
    String? tz;
    try {
      tz = await NativeTimezone.getLocalTimezone(); // "Europe/Rome"
    } catch (e) {
      tz = null;
    }

    if (tz == null || tz.isEmpty) {
      tz = 'Europe/Rome'; // fallback oppure scegli una timezone di default
    }

    final res = await http.post(
      Uri.parse('$apiBaseUrl/timezone.php'),
      headers: _jwtToken != null ? _authHeaders() : null,
      body: jsonEncode({'utente_id': userId, 'timezone': tz}),
    );
    final data = json.decode(res.body);

    if (data['success'] == true) {
    } else {}
  }

  //-------------------------------------------------------------------------
  // Per il logout:
  //-------------------------------------------------------------------------
  Future<void> eseguiLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("utenteIdLogin");
    await prefs.remove("nomeIdLogin");
    //await _storage.delete(key: 'jwt_token');
    loading = true;
    utenteTemporaneo = true;
    stopCountdown();

    await callAppClose();
    await _loadAll();
    await onLogoutFlow();

    setState(() {
      consensoTrackingGps = true;
      _lastLat = _lastLon = null;
    });
  }

  //-------------------------------------------------------------------------
  // Ricalcola e aggiorna le attività
  //-------------------------------------------------------------------------
  Future<void> aggiornaLivelliAttivita() async {
    try {
      final res = await http.get(
        Uri.parse("$apiBaseUrl/attivita_utente.php?utente_id=$utenteId"),
        headers: _jwtToken != null ? _authHeaders() : null,
      );

      final dati = json.decode(res.body);

      if (dati['success'] == true) {
        List dettagli = dati['dettagli'] ?? [];

        // Aggiorna sessioni per ogni livello in modo compatto
        for (int livello = 0; livello <= 2; livello++) {
          sessioniLivelli[livello] = dettagli
              .where((s) => s['tipo_attivita'] == livello)
              .map<Map<String, dynamic>>(
                (s) => {
                  'inizio': s['data_ora_inizio'],
                  'fine': s['data_ora_fine'],
                  'durata': (s['durata_sec'] / 60).round(),
                  'distanza': s['distanza_metri'],
                  'fonte': s['fonte'],
                  'passi': ((s['distanza_metri'] ?? 0) / 0.7).round(),
                },
              )
              .toList();
        }

        setState(() {
          for (int livello = 0; livello <= 2; livello++) {
            livelli[livello]['durata'] = formattaMinuti(
              dati['livello$livello'],
            );
            livelli[livello]['trend'] = trendTesto(
              dati['livello${livello}_diff'],
            );
          }
        });
      } else if (res.statusCode == 401) {
        await _storage.delete(key: 'jwt_token');
        await _login(); // ricreo il token
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.t.session_expired),
            ),
          );
          await eseguiLogout();
        }
      }
    } catch (e) {
      setState(() {
        gpsErrore = '❌ error http 500 : $e';
      });
    }
  }

  //-------------------------------------------------------------------------
  // Ricalcola e aggiorna il riepilogo
  //-------------------------------------------------------------------------
  Future<void> aggiornaRiepilogoLivelli() async {
    try {
      final res = await http.get(
        Uri.parse("$apiBaseUrl/attivita_utente.php?utente_id=$utenteId"),
        headers: _jwtToken != null ? _authHeaders() : null,
      );

      final dati = json.decode(res.body);

      if (dati['success'] == true) {
        setState(() {
          // Livello 0: solo durata e metri
          livelli[0]['durata'] = formattaMinuti(dati['livello0'] ?? 0);
          livelli[0]['trend'] = trendTesto(dati['livello0_diff'] ?? 0);
          livelli[0]['metri'] = dati['livello0_m'] ?? 0;

          // Livello 1: durata, metri, passi
          livelli[1]['durata'] = formattaMinuti(dati['livello1'] ?? 0);
          livelli[1]['trend'] = trendTesto(dati['livello1_diff'] ?? 0);
          livelli[1]['metri'] = dati['livello1_m'] ?? 0;
          livelli[1]['passi'] = ((dati['livello1_m'] ?? 0) / 0.7).round();

          // Livello 2: durata, metri, km
          livelli[2]['durata'] = formattaMinuti(dati['livello2'] ?? 0);
          livelli[2]['trend'] = trendTesto(dati['livello2_diff'] ?? 0);
          livelli[2]['metri'] = dati['livello2_m'] ?? 0;
          livelli[2]['km'] = ((dati['livello2_m'] ?? 0) / 1000);
        });
      } else if (res.statusCode == 401) {
        await _storage.delete(key: 'jwt_token');
        await _login(); // ricreo il token
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.t.session_expired),
            ),
          );
          await eseguiLogout();
        }
      }
    } catch (e) {
      setState(() {
        gpsErrore = '❌ Error http 500 : $e';
      });
    }
  }

  //-------------------------------------------------------------------------
  // Widget principale della pagina
  //-------------------------------------------------------------------------
  void attivaTracking(bool attiva) {
    if (!mounted) return; // widget ancora vivo?

    if (!consensoTrackingGps && attiva) {
      final err = context.t.gps_err01; // prendo la stringa subito
      if (!mounted) return;
      callTrackingToggle(false); // disattiva
      setState(() {
        trackingAttivo = false;
        gpsErrore = err;
      });
      return;
    }

    callTrackingToggle(attiva); // attiva

    setState(() {
      trackingAttivo = attiva;

      if (attiva) {
        startCountdown();
      } else {
        stopCountdown();
        ultimaPosizione = '';
      }
    });
  }

  //-------------------------------------------------------------------------
  // imposta contdown e le routine di salvataggio
  //-------------------------------------------------------------------------
  void startCountdown() {
    // chiudo eventuale timer precedente
    countdownTimer?.cancel();

    if (!mounted) return; // widget ancora vivo?

    setState(() {
      countdown = countdownLevel;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        // se il widget non esiste più -> stop
        timer.cancel();
        return;
      }
      if (!trackingAttivo) return;

      setState(() {
        countdown--;
      });

      if (countdown <= 0) {
        setState(() {
          countdown = countdownLevel;
        });

        salvaPosizioneReale().catchError((e) {
          // prendo la stringa PRIMA, fuori da async
          final err = context.t.gps_err02;
          if (mounted) {
            setState(() {
              gpsErrore = '$err $e';
            });
          }
        });
      }
    });
  }

  //-------------------------------------------------------------------------
  // Ferma il countdown e resetta il timer
  //-------------------------------------------------------------------------
  void stopCountdown() {
    countdownTimer?.cancel();
    countdownTimer = null;
    setState(() {
      countdown = countdownLevel;
    });
  }

  //-------------------------------------------------------------------------
  // Salva i dati del gps _gpslog a video _gpslogE su file
  //-------------------------------------------------------------------------
  Future<void> salvaPosizioneReale() async {
    if (!consensoTrackingGps) {
      setState(() => gpsErrore = context.t.gps_err03);
      return;
    }

    if (_gpsInFlight) return; // evita overlap

    _gpsInFlight = true;
    try {
      // Permessi
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => gpsErrore = context.t.gps_err04);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => gpsErrore = context.t.gps_err05);
        return;
      }

      // Parametri dal piano (con default)
      final f = (features ?? {}) as Map<String, dynamic>;
      final accMode = (f['gps_accuracy_mode'] as String?) ?? 'balanced';
      final acc = _accFromPlan(accMode);
      final accMax =
          (f['gps_max_acc_m'] as num?)?.toDouble() ?? _accMaxFromPlan(accMode);
      final minMoveM = (f['gps_min_distance_m'] as num?)?.toDouble() ?? 20.0;

      // Fix con timeout (evita attese infinite)
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: acc,
        timeLimit: const Duration(seconds: 10),
      );

      final precisione = pos.accuracy;
      final altitudine = pos.altitude;

      // Filtro precisione
      if (precisione.isNaN || precisione > accMax) {
        GpsLog.instance.logError(
          'Accuracy filter failed: $precisione > $accMax',
        );

        // su errore:
        GpsLogE.instance.add(GpsLogEntryE(
          ts: DateTime.now(),
          status: GpsLogStatusE.error,
          lat: pos.latitude,
          lon: pos.longitude,
          accM: precisione,
          altM: altitudine,
          msg: 'Accuracy filter failed: $precisione > $accMax',
          errorCode: 'HTTP_500',
        ));

        setState(() => gpsErrore = context.t.gps_err06);
        return;
      }

      // Filtro movimento minimo
      double deltaM = 999999;
      if (_lastLat != null && _lastLon != null) {
        deltaM = Geolocator.distanceBetween(
          _lastLat!,
          _lastLon!,
          pos.latitude,
          pos.longitude,
        );
        if (deltaM < minMoveM) {
          GpsLog.instance.logError(
            'Minimum motion filter failed: $deltaM < $minMoveM',
          );

          // su errore:
          GpsLogE.instance.add(GpsLogEntryE(
            ts: DateTime.now(),
            status: GpsLogStatusE.error,
            lat: pos.latitude,
            lon: pos.longitude,
            accM: precisione,
            altM: altitudine,
            msg: 'Minimum motion filter failed: $deltaM < $minMoveM',
            errorCode: 'HTTP_500',
          ));

          // troppo vicino all’ultimo punto utile: ignora silenziosamente
          return;
        }
      }

      // Timestamp safe (alcune piattaforme possono dare null)
      final ts = (pos.timestamp ?? DateTime.now()).toUtc().toIso8601String();

      // Salva via API
      //await salvaPosizione(
      //  utenteId,
      //  pos.latitude,
      //  pos.longitude,
      //  ts,
      //  precisione,
      //  altitudine,
      //);

      await _ensureQueue();

      final q = gpsQueue!; // ora è safe usarla
      if (q == null) {
        return;
      }

      // timestamp ISO 8601 in UTC
      final DateTime tsDt =
          (pos.timestamp != null ? pos.timestamp as DateTime : DateTime.now())
              .toUtc();
      final String tsIso = tsDt.toIso8601String();

      // metti in coda
      final ok_gps = q.enqueue(
        lat: pos.latitude,
        lon: pos.longitude,
        tsIso: tsIso,
        accM: precisione,
        altM: altitudine,
        // lvl: opzionale se già calcoli L0/L1/L2 lato client
      );

      // dopo i filtri, PRIMA dell'enqueue
      GpsLog.instance.logQueued(
        lat: pos.latitude,
        lon: pos.longitude,
        accM: precisione,
        altM: altitudine.isNaN ? 0.0 : altitudine,
      );

      // Log/feedback
      try {
        q.enqueue(
          lat: pos.latitude,
          lon: pos.longitude,
          tsIso: tsIso,
          accM: precisione,
          altM: altitudine,
        );

        await q.maybeFlush();
      } catch (e) {
        //
      }

      // Aggiorna stato locale
      _lastLat = pos.latitude;
      _lastLon = pos.longitude;
      _lastTs = DateTime.now();

      setState(() {
        gpsErrore = '';
        ultimaPosizione =
            '${pos.latitude}, ${pos.longitude} (±${precisione.toStringAsFixed(1)} m, alt. ${altitudine.toStringAsFixed(1)} m)';
      });

      // (Consiglio) non chiamare ricalcolo ad ogni fix: farlo ogni N fix o a intervalli
      //await ricalcolaEaggiornaAttivita();
      await _maybeRecalc(); // ricalcola solo se è passato l’intervallo
    } on TimeoutException {
      setState(() => gpsErrore = '${context.t.gps_err07} Timeout');
    } catch (e) {
      setState(() => gpsErrore = '❌ ${context.t.gps_err07} $e');
    } finally {
      _gpsInFlight = false;
    }
  }

  //-------------------------------------------------------------------------
  // Salva la posizione tramite API
  //-------------------------------------------------------------------------
  Future<void> salvaPosizione(
    String utenteId,
    double latitudine,
    double longitudine,
    String timestamp,
    double precisioneM,
    double altitudineM,
  ) async {
    try {
      final uri = Uri.parse("$apiBaseUrl/posizioni.php");
      final headers = {
        'Content-Type': 'application/json; charset=utf-8',
        if (_jwtToken != null)
          ..._authHeaders(), // deve includere Authorization
      };
      final body = json.encode({
        'utente_id': utenteId,
        'latitudine': latitudine,
        'longitudine': longitudine,
        'timestamp': timestamp,
        'precisione_m': precisioneM,
        'altitudine_m': altitudineM,
      });

      final res = await http.post(uri, headers: headers, body: body);

      if (res.statusCode != 200) {
        return;
      }
      final data = json.decode(res.body);
      if (data['success'] == true) {
        //ok
      } else {
        // errore API
      }
    } catch (e) {
      // errore rete
    }
  }

  //-------------------------------------------------------------------------
  // Ricalcola e aggiorna le attività
  //-------------------------------------------------------------------------
  Future<void> ricalcolaEaggiornaAttivita(String txt) async {
    try {
      final res = await http.get(
        Uri.parse("$apiBaseUrl/ricalcola_attivita.php?utente_id=$utenteId"),
        headers: _jwtToken != null ? _authHeaders() : null,
      );
      //debugPrint("ricalcolaEaggiornaAttivita $txt");
      final data = json.decode(res.body);
      if (data['success'] == true) {
        // 2. Solo se la ricalcolazione è andata a buon fine, aggiorna i livelli
        await aggiornaRiepilogoLivelli();
      } else {
        setState(() {
          gpsErrore = '❌ ${context.t.att_err01} ${data['message'] ?? ''}';
        });
      }
    } catch (e) {
      setState(() {
        gpsErrore = '❌ ${context.t.att_err01} $e';
      });
    }
  }

  //-------------------------------------------------------------------------
  // Formatta i minuti in ore e minuti
  //-------------------------------------------------------------------------
  String formattaMinuti(int minuti) {
    if (minuti == 0) return '';
    final ore = minuti ~/ 60;
    final restantiMin = minuti % 60;
    return ore > 0 ? '${ore}h ${restantiMin}min' : '${restantiMin}min';
  }

  //-------------------------------------------------------------------------
  // Restituisce il testo del trend in base alla differenza
  //-------------------------------------------------------------------------
  String trendTesto(int diff) {
    final diffAbs = formattaMinuti(diff.abs());
    if (diff == 0) return context.t.att_err02;
    final freccia = diff > 0 ? '🔺' : '🔻';
    final segno = diff > 0 ? '+' : '-';
    return '$freccia $segno$diffAbs ${context.t.att_err03}';
  }

  //-------------------------------------------------------------------------
  // Carica i dettagli del livello specificato
  //-------------------------------------------------------------------------
  Future<void> caricaDettagliLivello(int livello) async {
    if (livelliInCaricamento.contains(livello)) return;
    livelliInCaricamento.add(livello);
    setState(() {}); // Per mostrare eventuale caricamento

    final oggi = DateTime.now();
    String zero = '0';
    final dataStr =
        "${oggi.year.toString().padLeft(4, zero)}${oggi.month.toString().padLeft(2, zero)}${oggi.day.toString().padLeft(2, zero)}";

    try {
      final res = await http.get(
        Uri.parse(
          "$apiBaseUrl/dettagli_livello.php?utente_id=$utenteId&livello=$livello&data=$dataStr",
        ),
        headers: _jwtToken != null ? _authHeaders() : null,
      );

      final dati = json.decode(res.body);

      if (dati['success'] == true) {
        dettagliLivello[livello] = List<Map<String, dynamic>>.from(
          dati['dettagli'] ?? [],
        );
      } else {
        dettagliLivello[livello] = [];
      }
    } catch (e) {
      dettagliLivello[livello] = [];
    }
    livelliInCaricamento.remove(livello);
    setState(() {});
  }

  //-------------------------------------------------------------------------
  // Gestione della chiusura della pagina
  //-------------------------------------------------------------------------
  @override
  void dispose() {
    countdownTimer?.cancel();
    _mapController.dispose();
    callAppClose();
    super.dispose();
  }

  //-------------------------------------------------------------------------
  // Costruisce la card per ogni livello di attività nel dettaglio
  //-------------------------------------------------------------------------
  Widget livelloCard(int livello, String titolo, Color color) {
    return Card(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      child: ExpansionTile(
        title: Text('$titolo: ${livelli[livello]['durata']}'),
        subtitle: Text('${livelli[livello]['trend']}'),
        onExpansionChanged: (expanded) {
          if (expanded) {
            caricaDettagliLivello(livello);
          }
        },
        children: [
          if (livelliInCaricamento.contains(livello))
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (dettagliLivello[livello] == null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(context.t.att_err04),
            )
          else if (dettagliLivello[livello]!.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(context.t.att_err05),
            )
          else
            ...dettagliLivello[livello]!.map(
              (sessione) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '🕒 ${context.t.info_mes01} ${sessione['data_ora_inizio']}'),
                    Text(
                        '⏱️ ${context.t.info_mes02} ${sessione['data_ora_fine']}'),
                    Text(
                      '⏳ ${context.t.info_mes03} ${(sessione['durata_sec'] / 60).round()} min',
                    ),
                    Text(
                        '📏 ${context.t.info_mes04} ${sessione['distanza_metri']} m'),
                    Text('🛰️ ${context.t.info_mes05} ${sessione['fonte']}'),
                    if (livello == 1)
                      Text(
                        '👣 ${context.t.info_mes06} ${((sessione['distanza_metri'] ?? 0) / 0.7).round()}',
                      ),
                    Divider(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Costruisce la card per ogni livello di attività in riepilogo
  //-------------------------------------------------------------------------
  Widget riepilogoLivelloCard(int livello, String titolo, Color color) {
    final riepilogo = riepilogoLivello(livello);

    IconData icona;
    Color iconaColor;
    switch (livello) {
      case 0:
        icona = Icons.hotel;
        iconaColor = Colors.blueGrey;
        break;
      case 1:
        icona = Icons.directions_walk;
        iconaColor = Colors.green[700]!;
        break;
      case 2:
        icona = Icons.directions_run;
        iconaColor = Colors.red[700]!;
        break;
      default:
        icona = Icons.help;
        iconaColor = Colors.grey;
    }

    return Card(
      color: Colors.blueGrey[50],
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icona, color: iconaColor, size: 22),
            SizedBox(width: 8),
            Text(
              titolo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(width: 12),
            Text(
              riepilogo['durata'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            if (livello == 1) ...[
              SizedBox(width: 12),
              Text(
                'Metri: ${riepilogo['metri'].toStringAsFixed(1)}',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(width: 8),
              Text(
                'Passi: ${riepilogo['passi']}',
                style: TextStyle(fontSize: 13),
              ),
            ],
            if (livello == 2) ...[
              SizedBox(width: 12),
              Text(
                'Km: ${riepilogo['km'].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Imposta i vai livelli di attività
  //-------------------------------------------------------------------------
  String descrizioneLivello(int livello) {
    switch (livello) {
      case 0:
        return context.t.mov_inattivo;
      case 1:
        return context.t.mov_leggero;
      case 2:
        return context.t.mov_veloce;
      default:
        return '';
    }
  }

  //-------------------------------------------------------------------------
  // Costruisce l'interfaccia della pagina
  //-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeaderBar(
        showBack: false,
        onChangeLocale: widget.onChangeLocale, // <-- QUI
        banner: Container(
          margin: EdgeInsets.only(bottom: 4),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 238, 237, 235),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              context.t.header_page_banner,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              //--------------------------------------------------------
              // HEADER DASHBOARD
              //--------------------------------------------------------
              DashboardHeader(
                consensoTrackingGps: consensoTrackingGps,
                utenteId: utenteId,
                nomeId: nomeId,
                livelloUtente: livelloUtente,
                giorniRimanenti: giorniRimanenti,
                labelGiorni: _labelGiorni,
                coloreGiorni: _coloreGiorni,
                chipGiorni: _ChipGiorni(
                  text: _labelGiorni(giorniRimanenti, livelloUtente),
                  color: _coloreGiorni(giorniRimanenti, livelloUtente),
                ),
              ),
              SizedBox(height: 20),
              //--------------------------------------------------------
              // CARD TRACKING GPS
              //--------------------------------------------------------
              CardTrackingGps(
                trackingAttivo: trackingAttivo,
                consensoTrackingGps: consensoTrackingGps,
                countdown: countdown,
                countdownLevel: countdownLevel,
                onTrackingChanged: attivaTracking,
                ultimaPosizione: ultimaPosizione,
              ),
              SizedBox(height: 20),
              //---------------------------------------------
              // CAROSELLO IMMAGINI inizio
              //---------------------------------------------
              const HeroCarousel(),
              //-------------------------------------------------
              // report inizio
              //---------------------------------------------------
              CardReportGiornaliero(
                riepilogo0: riepilogoLivello(0),
                riepilogo1: riepilogoLivello(1),
                riepilogo2: riepilogoLivello(2),
                ultimaPosizione: ultimaPosizione,
                features: features, // object dall’API
                historyDaysMax:
                    limitsHistoryDaysMax, // min(history_days, retention)
                isAnonymous: utenteTemporaneo, // bool
                planName: livelloUtente, // "Free" | "Start" | "Basic"...
                date: DateTime.now(),
              ),
              //-------------------------
              //report fine
              //-------------------
              SizedBox(height: 20),
              //-------------------------------------------------
              // report settimanale inizio
              //---------------------------------------------------
              CardReportSettimanale(
                riepilogo0: datiLivelliSett[0] ?? [],
                riepilogo1: datiLivelliSett[1] ?? [],
                riepilogo2: datiLivelliSett[2] ?? [],
                ultimaPosizione: ultimaPosizione,
                features: features, // object dall’API
                historyDaysMax:
                    limitsHistoryDaysMax, // min(history_days, retention)
                isAnonymous: utenteTemporaneo, // bool
                planName: livelloUtente, // "Free" | "Start" | "Basic"...
                date: DateTime.now(),
              ),
              //-------------------------
              //report fine
              //-------------------
              //-------------------------
              //grafici
              //-------------------
              if (datiGiornalieri == null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      context.t.chart_mes01,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                cardDistribuzioneLivelli(datiGiornalieri!.$1),
                cardTimelineLivelli(datiGiornalieri!.$2),
              ],
              //-------------------------
              //grafici fine
              //-------------------

              //-----------------------------------------------------
              // LIVELLI DI ATTIVITÀ
              //-----------------------------------------------------
              cardLivelloConGrafico(
                livello: 0,
                titolo: '🛌 ${context.t.mov_inattivo}',
                color: Colors.blueGrey[50]!,
                datiSettimanali: datiSettimanali(datiLivelli[0]),
              ),

              cardLivelloConGrafico(
                livello: 1,
                titolo: '🚶 ${context.t.mov_leggero}',
                color: Colors.blueGrey[50]!,
                datiSettimanali: datiSettimanali(datiLivelli[1]),
              ),

              cardLivelloConGrafico(
                livello: 2,
                titolo: '🚗 ${context.t.mov_veloce}',
                color: Colors.blueGrey[50]!,
                datiSettimanali: datiSettimanali(datiLivelli[2]),
              ),

              SizedBox(height: 30),
              //--------------------------------------------------------
              //Text('Ultima posizione: $ultimaPosizione'),  // uso stringa
              Text(gpsErrore),
              SizedBox(height: 24), // Spazio prima del footer
              //----------------------------------------------
              // mappa posizione
              //-----------------------------------------------
              CardMappaPosizione(
                mapController: _mapController,
                posizioneUtente: posizioneUtente,
                zoom: _zoom,
                onRefresh: _refreshPosizione,
                onZoomIn: () => _zoomDelta(1),
                onZoomOut: () => _zoomDelta(-1),
              ),
              SizedBox(height: 24),
              //----------------------------------
              // --- MAPPA POSIZIONE UTENTE fine ---
              //------------------------------------------
              //---------------------------------------------------------
              // --- SEZIONE SCELTA STORICO
              //-----------------------------------------------------------
              CardDiarioGps(),
              SizedBox(height: 24),

              //---------------------------------------------------------
              // --- SEZIONE SCELTA STORICO
              //-----------------------------------------------------------
              CardSceltaStorico(pianoDescrizioneBuilder: _pianoDescrizione),
              SizedBox(height: 24),
              // --- FINE SEZIONE SCELTA STORICO ---
              AppFooter(), // <-- AGGIUNGI QUI IL FOOTER!
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        utenteTemporaneo: utenteTemporaneo,
        utenteId: utenteId,
        nomeId: nomeId,
        leggiConsensi: leggiConsensi,
        mostraLoginDialog: mostraLoginDialog,
        eseguiLogout: eseguiLogout,
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Card con grafico per il livello di attività
  //--------------------------------------------------------------------------
  Widget cardLivelloConGrafico({
    required int livello,
    required String titolo,
    required Color color,
    required List<int> datiSettimanali,
    IconData? icona,
    Color? iconaColor,
  }) {
    final riepilogo = riepilogoLivello(livello);

    icona ??= livello == 0
        ? Icons.hotel
        : livello == 1
            ? Icons.directions_walk
            : Icons.directions_run;
    iconaColor ??= livello == 0
        ? Colors.blueGrey
        : livello == 1
            ? Colors.green[700]!
            : Colors.red[700]!;

    return Card(
      color: Colors.blueGrey[50],
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intestazione
            Row(
              children: [
                //Icon(icona, color: iconaColor, size: 22),
                SizedBox(width: 8),
                Text(
                  titolo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueGrey[900],
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  riepilogo['durata'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                if (livello == 1) ...[
                  SizedBox(width: 12),
                  Text(
                    '${context.t.um_metri} ${riepilogo['metri'].toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${context.t.um_passi} ${riepilogo['passi']}',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
                if (livello == 2) ...[
                  SizedBox(width: 12),
                  Text(
                    '${context.t.um_km} ${riepilogo['km'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8),
            // Grafico settimanale
            SizedBox(
              height: 120,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: false),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 25, // 0,25,50,75,100
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (v) => FlLine(
                      color: Colors.black.withOpacity(0.08),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.blueGrey, width: 1),
                  ),
                  barGroups: List.generate(
                    datiSettimanali.length,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: datiSettimanali[i].toDouble(),
                          color: livello == 0
                              ? Colors.blueGrey
                              : livello == 1
                                  ? Colors.redAccent
                                  : Colors.amber,
                          width: 14,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(datiSettimanali.length, (i) {
                  final oggi = DateTime.now();
                  final d = oggi.subtract(Duration(days: 6 - i));
                  final dateLabel =
                      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}";
                  final minuti = datiSettimanali[i];
                  final ore = minuti ~/ 60;
                  final min = minuti % 60;
                  final minutiLabel =
                      ore > 0 ? '${ore}h ${min}min' : '${min}min';
                  return Column(
                    children: [
                      Text(dateLabel, style: TextStyle(fontSize: 11)),
                      Text(minutiLabel, style: TextStyle(fontSize: 11)),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Funzioni di login e registrazione
  //-------------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$apiBaseUrl/login.php"),
        headers: _jwtToken != null ? _authHeaders() : null,
        //headers: {'Content-Type': 'application/json; charset=utf-8'}, // niente Bearer qui
        body: json.encode({'email': email, 'password': password}),
      );

      final data = json.decode(res.body);

      if (res.statusCode == 403 && data['error'] == 'email_not_verified') {
        await mostraVerificaEmailDialog(context, email);
        return false;
      }

      if (data['success'] == true) {
        await callAppClose();

        setState(() {
          utenteId = data['user_id'].toString();
          nomeId = data['nome'].toString();
          debugUtente = "Nome: $nomeId";
          utenteTemporaneo = false; // <-- AGGIUNGI QUESTO!
        });

        //imposta timezone
        syncTimezone(utenteId);

        // ...dopo aver ottenuto utenteId e nomeId...
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("utenteIdLogin", utenteId);
        await prefs.setString("nomeIdLogin", nomeId);

        loading = true;

        await _loadAll();

        // --- Controllo consensi ---
        final consensiOk = await controllaConsensi(utenteId);
        _lastLat = _lastLon = null;

        if (!consensiOk) {
          await mostraDialogConsensi(context, utenteId);
        } else {
          await leggiConsensi();
        }

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //------------------------------------------------------
  // legge i consensi per derminare gps
  //-------------------------------------------------------
  Future<void> leggiConsensi() async {
    final res = await http.get(
      Uri.parse("$apiBaseUrl/consensi_read.php?utente_id=$utenteId"),
      headers: _jwtToken != null ? _authHeaders() : null,
    );

    final data = json.decode(res.body);

    if (data['success'] == true &&
        data['impostazioni'] != null &&
        data['impostazioni'].isNotEmpty) {
      setState(() {
        consensoTrackingGps = data['impostazioni'][0]['tracking_gps'] == 1;
      });
    }
  }

  //------------------------------------------------------------------
  // Funzione per controllare se i consensi esistono
  //------------------------------------------------------------------
  Future<bool> controllaConsensi(String utenteId) async {
    try {
      final res = await http.get(
        Uri.parse("$apiBaseUrl/consensi_esiste.php?utente_id=$utenteId"),
        headers: _jwtToken != null ? _authHeaders() : null,
      );

      final data = json.decode(res.body);

      if (data['status'] == 'success') {
        return data['consensi'];
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //------------------------------------------------------------------
  // Funzione per controllare se i consensi esistono
  //------------------------------------------------------------------
  Future<bool> aggiornaDataUltimoAccesso() async {
    try {
      final res = await http.post(
        Uri.parse("$apiBaseUrl/utenti_ultimo_accesso.php?utente_id=$utenteId"),
        headers: _jwtToken != null ? _authHeaders() : null,
      );
      final data = json.decode(res.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  //-------------------------------------------------------------------------
  // Mostra il dialog di login o registrazione
  //-------------------------------------------------------------------------
  void mostraLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => mostraPasswordResetDialog(context),
                child: Text(context.t.password_dimenticata),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final success = await login(
                emailController.text,
                passwordController.text,
              );
              Navigator.pop(context);
              if (!success) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(context.t.user_err05)));
              }
            },
            child: Text(context.t.user_err06),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              mostraRegistrazioneDialog(
                context,
              ); // Chiama la dialog di registrazione
            },
            child: Text(context.t.user_err07),
          ),
        ],
      ),
    );
  }

//---------------------------------------------------------------
// Mostra il dialog di reimpostazione password
//---------------------------------------------------------------
  Future<void> mostraPasswordResetDialog(BuildContext context) async {
    final emailController = TextEditingController();
    bool loading = false;
    String? errore;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.t.reimposta_password),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.t.inserisci_mail),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              if (errore != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child:
                      Text(errore!, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: loading
                  ? null
                  : () async {
                      final email = emailController.text.trim();
                      if (email.isEmpty) {
                        setState(() => errore = context.t.inserisci_tua_mail);
                        return;
                      }
                      setState(() => loading = true);
                      await http.post(
                        Uri.parse('$apiBaseUrl/password_reset_request.php'),
                        headers: {
                          'Content-Type': 'application/json; charset=utf-8'
                        },
                        body: jsonEncode({'email': email}),
                      );
                      setState(() => loading = false);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.t.link_mail_password,
                          ),
                        ),
                      );
                    },
              child: Text(context.t.invia_richiesta_label),
            ),
          ],
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Mostra il dialog di registrazione
  //-------------------------------------------------------------------------
  void mostraRegistrazioneDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confermaPasswordController =
        TextEditingController(); // <--- aggiungi questo

    String? errore;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.t.form_reg_testa),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: context.t.form_reg_nome),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: context.t.form_reg_mail),
              ),
              TextField(
                controller: passwordController,
                decoration:
                    InputDecoration(labelText: context.t.form_reg_password),
                obscureText: true,
              ),
              TextField(
                controller: confermaPasswordController,
                decoration: InputDecoration(
                    labelText: 'Conferma password'), // <--- aggiungi questo
                obscureText: true,
              ),
              if (errore != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(errore!, style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text;
                final confermaPassword =
                    confermaPasswordController.text; // <--- aggiungi questo

                final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                final passwordRegExp = RegExp(
                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
                );

                if (nome.isEmpty) {
                  setState(() => errore = context.t.form_reg_err01);
                  return;
                }
                if (!emailRegExp.hasMatch(email)) {
                  setState(() => errore = context.t.form_reg_err02);
                  return;
                }
                if (!passwordRegExp.hasMatch(password)) {
                  setState(() => errore = context.t.form_reg_err03);
                  return;
                }
                if (password != confermaPassword) {
                  // <--- controllo doppia password
                  setState(() => errore = context.t.form_reg_err06);
                  return;
                }

                final success = await registraUtente(nome, email, password);
                Navigator.pop(context);
                if (success) {
                  // Dopo la registrazione, mostra il dialog di verifica email
                  await mostraVerificaEmailDialog(context, email);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? context.t.form_reg_err04
                          : context.t.form_reg_err05,
                    ),
                  ),
                );
              },
              child: Text(context.t.user_err07),
            ),
          ],
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Funzione per registrare un nuovo utente
  //-------------------------------------------------------------------------
  Future<bool> registraUtente(
    String nome,
    String email,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$apiBaseUrl/registrazione_verifica.php"),
        headers: _jwtToken != null ? _authHeaders() : null,
        body: json.encode({
          'nome': nome,
          'email': email,
          'password': password,
          'id_anonimo': utenteId, // usa l'ID utente temporaneo
          'livello': 'base', // sempre utente base
        }),
      );

      final data = json.decode(res.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  //-------------------------------------------------------------------------
  // Mostra il dialog per i consensi
  //-------------------------------------------------------------------------
  Future<void> mostraDialogConsensi(
    BuildContext context,
    String utenteId,
  ) async {
    bool consensoPrivacy = false;
    bool consensoMarketing = false;
    bool consensoPremi = false;
    bool consensoTrackingGps = false; // valore di default

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.t.form_consensi_01),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                value: consensoPrivacy,
                onChanged: (v) => setState(() => consensoPrivacy = v ?? false),
                title: Text(context.t.form_consensi_02),
              ),
              CheckboxListTile(
                value: consensoMarketing,
                onChanged: (v) =>
                    setState(() => consensoMarketing = v ?? false),
                title: Text(context.t.form_consensi_03),
              ),
              CheckboxListTile(
                value: consensoPremi,
                onChanged: (v) => setState(() => consensoPremi = v ?? false),
                title: Text(context.t.form_consensi_04),
              ),
              CheckboxListTile(
                value: consensoTrackingGps,
                onChanged: (v) =>
                    setState(() => consensoTrackingGps = v ?? false),
                title: Text(context.t.form_consensi_05),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await salvaConsensi(
                  utenteId,
                  consensoPrivacy,
                  consensoMarketing,
                  consensoPremi,
                  consensoTrackingGps, // passa anche questo
                );
                Navigator.pop(context);
              },
              child: Text(context.t.form_consensi_06),
            ),
          ],
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Funzione per salvare i consensi
  //-------------------------------------------------------------------------
  Future<void> salvaConsensi(
    String utenteId,
    bool privacy,
    bool marketing,
    bool premi,
    bool trackingGps, // nuovo parametro
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$apiBaseUrl/salva_consensi.php"),
        headers: _jwtToken != null ? _authHeaders() : null,
        body: json.encode({
          'utente_id': utenteId,
          'consenso_privacy': privacy ? 1 : 0,
          'consenso_marketing': marketing ? 1 : 0,
          'consenso_premi': premi ? 1 : 0,
          'tracking_gps': trackingGps ? 1 : 0, // qui usi il valore scelto
          'tracking_modalita': 'preciso',
          'frequenza_tracking_sec': 200,
          'notifiche_attive': 0,
        }),
      );

      final data = json.decode(res.body);
      if (data['success'] != true) {
        setState(() {
          consensoTrackingGps =
              trackingGps; // <-- aggiorna la variabile globale
        });
      }
    } catch (e) {
      // errore rete
    }
  }

  //-------------------------------------------------------------------------
  // riepilogo al livello
  //-------------------------------------------------------------------------
  Map<String, dynamic> riepilogoLivello(int livello) {
    final mappa = livelli[livello];
    return {
      'durata': mappa['durata'] ?? '--',
      'metri': mappa['metri'] ?? 0,
      'passi': mappa['passi'] ?? 0,
      'km': mappa['km'] ?? 0.0,
    };
  }

  //-------------------------------------------------------------------------
  // Riempie le des crizione dei consensi
  //-------------------------------------------------------------------------
  Widget _pianoDescrizione({
    required String titolo,
    required String descrizione,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titolo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 2),
          Text(
            descrizione,
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------
  // grafico
  // ---------------------------------------------
  Widget graficoSettimana(List<int> dati) {
    final oggi = DateTime.now();
    final dateLabels = List.generate(7, (i) {
      final d = oggi.subtract(Duration(days: 6 - i));
      return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}";
    });

    String formattaMinuti(int minuti) {
      final ore = minuti ~/ 60;
      final min = minuti % 60;
      return ore > 0 ? '${ore}h ${min}min' : '${min}min';
    }

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: false),
              gridData: FlGridData(
                show: true, // <-- mostra linee orizzontali e verticali
                drawVerticalLine: true,
                horizontalInterval: 20, // puoi regolare l'intervallo
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.blueGrey[100], strokeWidth: 1),
                getDrawingVerticalLine: (value) =>
                    FlLine(color: Colors.blueGrey[100], strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true, // <-- mostra il bordo
                border: Border.all(color: Colors.blueGrey, width: 1),
              ),
              barGroups: List.generate(
                dati.length,
                (i) => BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: dati[i].toDouble(),
                      color: Colors.blueAccent,
                      width: 14,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(dati.length, (i) {
              return Column(
                children: [
                  Text(dateLabels[i], style: TextStyle(fontSize: 11)),
                  Text(
                    formattaMinuti(dati[i]),
                    style: TextStyle(fontSize: 11),
                  ), // ore/minuti
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  //--------------------------------------------------------------
  // Carica i dati per tutti i livelli
  //--------------------------------------------------------------
  Future<void> caricaTuttiLivelli() async {
    setState(() => loading = true);

    for (int livello = 0; livello <= 2; livello++) {
      await caricaSettimana(livello);
    }

    setState(() => loading = false);
  }

  //--------------------------------------------------------------
  // legge i dati di 7 giorni per livello
  //--------------------------------------------------------------
  Future<void> caricaSettimana(int livello) async {
    final oggi = DateTime.now();
    final dataStr =
        "${oggi.year.toString().padLeft(4, '0')}${oggi.month.toString().padLeft(2, '0')}${oggi.day.toString().padLeft(2, '0')}";
    final url =
        "$apiBaseUrl/settimana_livello_totale.php?utente_id=$utenteId&livello=$livello&data=$dataStr";
    final res = await http.get(Uri.parse(url), headers: _authHeaders());

    if (res.statusCode == 200) {
      final dettagli = json.decode(res.body)['totali'];

        final body = json.decode(res.body);
        final List totali = (body['totali'] as List? ?? []);
        totali.sort((a, b) => a['data'].toString().compareTo(b['data'].toString())); // lun→dom

      setState(() {
        datiLivelli[livello] = dettagli is List ? dettagli : [];
        //datiLivelliSett[livello] = json.decode(res.body)['dettagli'] ?? [];
        datiLivelliSett[livello] = totali; // <-- la card settimanale userà questo
        


      });
    } else if (res.statusCode == 401) {
      await _storage.delete(key: 'jwt_token');
      await _login(); // ricreo il token
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.session_expired),
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      setState(() {
        datiLivelli[livello] = [];
        datiLivelliSett[livello] = [];
      });
    }
  }

  //----------------------------------------------------------------
  // riempie se nessun dato
  //-----------------------------------------------------------------
  List<int> datiSettimanali(List<dynamic>? lista) {
    //debugPrint("datiSettimanali: lista=$lista");
    // 1. Calcola le 7 date (da oggi a oggi-6) in formato 'YYYY-MM-DD'
    final oggi = DateTime.now();
    final giorni = List.generate(7, (i) {
      final d = oggi.subtract(Duration(days: 6 - i));
      return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
    });

    // 2. Crea una mappa data -> valore
    final mappa = <String, int>{};
    for (final e in (lista ?? [])) {
      final data = e['data']?.toString() ?? '';
      final valore =
          (int.tryParse(e['durata_sec']?.toString() ?? '0') ?? 0) ~/ 60;
      mappa[data] = valore;
    }

    // 3. Costruisci la lista dei valori per ogni giorno (0 se manca)
    return giorni.map((data) => mappa[data] ?? 0).toList();
  }

  //--------------------------------------------------------------
  // Controlla se l'onboarding è stato completato
  //--------------------------------------------------------------
  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final visto = prefs.getBool('onboarding_completato') ?? false;
    if (!visto) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingPage(
            onChangeLocale: widget.onChangeLocale, // <— qui il parametro
          ),
        ),
      );
    }
  }

  //---------------------------------------------------------------------------
  // Funzione per recuperare le attività delle ultime 24 ore
  //----------------------------------------------------------------------------
  Future<(List<OraStat>, List<Periodo>)> fetchAttivita24h(
    int utenteId,
    DateTime giorno,
    String apiBaseUrl,
    Map<String, String> headers,
  ) async {
    final d = '${giorno.year.toString().padLeft(4, '0')}-'
        '${giorno.month.toString().padLeft(2, '0')}-'
        '${giorno.day.toString().padLeft(2, '0')}';

    final url = "$apiBaseUrl/attivita_24h.php?utente_id=$utenteId&data=$d";
    final res = await http.get(Uri.parse(url), headers: _authHeaders());

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    if (data['ok'] != true) {
      throw Exception(data['error'] ?? 'Errore API');
    }

    final oraria =
        (data['oraria'] as List).map((e) => OraStat.fromJson(e)).toList();
    final periodi =
        (data['periodi'] as List).map((e) => Periodo.fromJson(e)).toList();
    return (oraria, periodi);
  }

  //----------------------------------------------------------------------
// Timeline livelli basata sui PERIODI dell'API (non per ora)
//----------------------------------------------------------------------
  Widget cardTimelineLivelli(List<Periodo> periodi) {
    final bool csvEnabled = features['export_csv'] == true; // se ti serve
    if (utenteTemporaneo) {/* ... tua card per anonimo, invariata ... */}

    // helper: 0..24 in ore decimali dal DateTime locale
    double _hOf(DateTime dt) => dt.hour + dt.minute / 60 + dt.second / 3600;

    // Costruisci spots "a scalini" dai periodi.
    // Inserisco anche eventuali gap come OFF (-1).
    final List<FlSpot> spots = [];
    const int OFF = -1;
    double? lastX;
    int? lastLvl;

    // I periodi sono già clampati dal server, ma ordiniamoli per sicurezza
    final seg = [...periodi]..sort((a, b) => a.inizio.compareTo(b.inizio));

    // Definisci inizio/fine giornate per tagliare in 0..24 (safety)
    final dayStart = DateTime(
        seg.isNotEmpty ? seg.first.inizio.year : DateTime.now().year,
        seg.isNotEmpty ? seg.first.inizio.month : DateTime.now().month,
        seg.isNotEmpty ? seg.first.inizio.day : DateTime.now().day);

    final startX = 0.0;
    final endX = 24.0;

    // cursore X
    double cursorX = startX;

    for (final p in seg) {
      final sx = _hOf(p.inizio).clamp(startX, endX);
      final ex = _hOf(p.fine).clamp(startX, endX);
      if (ex <= startX || sx >= endX || ex <= sx) continue;

      // gap tra cursorX e sx -> OFF
      if (sx > cursorX) {
        if (lastLvl != OFF) {
          // salto verticale
          spots.add(FlSpot(sx, (lastLvl ?? OFF).toDouble()));
          spots.add(FlSpot(sx, OFF.toDouble()));
        }
        // segmento OFF piatto
        spots.add(FlSpot(sx, OFF.toDouble()));
      }

      // segmento del livello corrente p.livello
      if (lastLvl != p.livello) {
        // verticale
        spots.add(FlSpot(sx, (lastLvl ?? OFF).toDouble()));
        spots.add(FlSpot(sx, p.livello.toDouble()));
      }
      // piatto sul livello
      spots.add(FlSpot(ex, p.livello.toDouble()));

      cursorX = ex;
      lastLvl = p.livello;
    }

    // coda finale fino a 24:00 come OFF
    if (cursorX < endX) {
      if (lastLvl != OFF) {
        spots.add(FlSpot(cursorX, lastLvl?.toDouble() ?? OFF.toDouble()));
        spots.add(FlSpot(cursorX, OFF.toDouble()));
      }
      spots.add(FlSpot(endX, OFF.toDouble()));
    }

    // ---- resto della tua card (titolo, share, axes) INVARIATO ----
    // Usa 'spots' al posto dei punti costruiti per OraStat
    final GlobalKey captureKey = GlobalKey();
    Future<void> _condividi() async {/* ... tuo codice invariato ... */}

    return RepaintBoundary(
      key: captureKey,
      child: Card(
        color: Colors.blueGrey[50],
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.blueGrey, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(context.t.chart_mes02,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]))),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: Text(context.t.condividi_button),
                  onPressed: _condividi,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white),
                ),
              ]),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    minY: -1,
                    maxY: 2,
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (v) => FlLine(
                          color: Colors.black.withOpacity(0.08),
                          strokeWidth: 1),
                      drawVerticalLine: false,
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 1,
                          getTitlesWidget: (v, _) {
                            switch (v.toInt()) {
                              case -1:
                                return const Text('OFF');
                              case 0:
                                return const Text('L0');
                              case 1:
                                return const Text('L1');
                              case 2:
                                return const Text('L2');
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 26,
                          interval: 1,
                          getTitlesWidget: (v, _) => v.toInt().isEven
                              ? Text('${v.toInt()}')
                              : const SizedBox.shrink(),
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: false,
                        color: Colors.indigo,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(context.t.chart_mes03,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------
  // Widget per la visualizzazione della distribuzione dei livelli
  //----------------------------------------------------------------------
  Widget cardDistribuzioneLivelli(List<OraStat> datiOrari) {
    // abilita/disabilita come preferisci
    final bool gpxEnabled = features['export_gpx'] == true;
    final bool csvEnabled = features['export_csv'] == true;
    final bool canAdvanced = features['report_advanced'] == true;

    // se utente temporaneo: messaggio come prima
    if (utenteTemporaneo) {
      return Card(
        color: Colors.blueGrey[50],
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t.chart_mes04,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  context.t.msg_abilitato_01,
                  style: TextStyle(color: Colors.red[700], fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- NUOVO: key per catturare la card visibile ---
    final GlobalKey captureKey = GlobalKey();

    // --- NUOVO: funzione locale di condivisione ---
    // Assumi: final captureKey = GlobalKey(); avvolge un RepaintBoundary

    Future<void> condividi() async {
      try {
        // assicura il frame
        await WidgetsBinding.instance.endOfFrame;

        final renderObj = captureKey.currentContext?.findRenderObject();
        final boundary = renderObj is RenderRepaintBoundary ? renderObj : null;
        if (boundary == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.t.chart_mes06)),
            );
          }
          return;
        }

        // piccolo retry di pittura
        var tries = 0;
        while (boundary.debugNeedsPaint && tries < 5) {
          await Future.delayed(const Duration(milliseconds: 40));
          tries++;
        }

        final dpr = MediaQuery.of(context).devicePixelRatio;
        final img =
            await boundary.toImage(pixelRatio: (dpr * 2).clamp(2.0, 4.0));
        final bd = await img.toByteData(format: ui.ImageByteFormat.png);
        if (bd == null) {
          throw Exception('toByteData returned null');
        }

        final bytes = bd.buffer.asUint8List();

        final dir = await getTemporaryDirectory(); // path_provider
        final file = File(
          '${dir.path}/move_chart_distribuzione_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(bytes, flush: true);

        // share_plus
        await Share.shareXFiles([XFile(file.path)],
            text: context.t.chart_mes07);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${context.t.cahrt_mes08} $e')), // <-- FIX key
          );
        }
      }
    }

    // share abilitato per utenti registrati (qui già non temporanei)
    final bool shareEnabled = true;

    return RepaintBoundary(
      key: captureKey,
      child: Card(
        color: Colors.blueGrey[50],
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.blueGrey, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con titolo e pulsanti
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.t.chart_mes04,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ---- Sostituito CSV con CONDIVIDI ----
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    label: Text(context.t.condividi_button), // es. "Condividi"
                    onPressed: shareEnabled ? condividi : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: 100, // percentuale
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, _, rod, __) {
                          final h = group.x;
                          final s = rod.rodStackItems;
                          String line(String name, BarChartRodStackItem it) =>
                              '$name: ${(it.toY - it.fromY).toStringAsFixed(0)}%';
                          final lines = <String>[];
                          if (s.isNotEmpty) {
                            if (s.length > 0 && (s[0].toY - s[0].fromY) > 0)
                              lines.add(line('OFF', s[0]));
                            if (s.length > 1 && (s[1].toY - s[1].fromY) > 0)
                              lines.add(line('L0', s[1]));
                            if (s.length > 2 && (s[2].toY - s[2].fromY) > 0)
                              lines.add(line('L1', s[2]));
                            if (s.length > 3 && (s[3].toY - s[3].fromY) > 0)
                              lines.add(line('L2', s[3]));
                          }
                          return BarTooltipItem('h $h\n${lines.join('\n')}',
                              const TextStyle(fontWeight: FontWeight.w600));
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 25,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: Colors.black.withOpacity(0.08),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: 25,
                          getTitlesWidget: (v, _) => Text('${v.toInt()}%'),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 26,
                          interval: 1,
                          getTitlesWidget: (v, _) => v.toInt().isEven
                              ? Text('${v.toInt()}')
                              : const SizedBox.shrink(),
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: true),
                    barGroups: datiOrari.map((e) {
                      const totSec = 3600.0;
                      final l0 = (e.l0 as num).toDouble();
                      final l1 = (e.l1 as num).toDouble();
                      final l2 = (e.l2 as num).toDouble();
                      final off =
                          (totSec - (l0 + l1 + l2)).clamp(0, totSec).toDouble();

                      double acc = 0;
                      BarChartRodStackItem add(num sec, Color c) {
                        final from = acc;
                        final to =
                            acc + (sec.toDouble() / totSec * 100.0); // in %
                        acc = to;
                        return BarChartRodStackItem(from, to, c);
                      }

                      final stacks = <BarChartRodStackItem>[
                        add(off, Colors.grey.shade400), // OFF
                        add(l0, Colors.blueGrey), // L0
                        add(l1, Colors.orange), // L1
                        add(l2, const Color(0xFF1565C0)), // L2
                      ];

                      return BarChartGroupData(
                        x: e.ora,
                        barsSpace: 2,
                        barRods: [
                          BarChartRodData(
                            toY: 100,
                            rodStackItems: stacks,
                            width: 12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _LegendDot(color: Color(0xFF1565C0), label: 'L2'),
                  _LegendDot(color: Colors.orange, label: 'L1'),
                  _LegendDot(color: Colors.blueGrey, label: 'L0'),
                  _LegendDot(color: Color(0xFFBDBDBD), label: 'OFF'),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                context.t.chart_mes05,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),

              // 👇 rimosso l'avviso rosso di export (non serve su questa card)
              // if (!gpxEnabled || !csvEnabled) ...
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------------------------------------
  // Carica i dati giornalieri
  //--------------------------------------------------------------------
  Future<void> _caricaDatiGiornalieri() async {
    //AppBanner.show('Carico riepilogo di oggi…', icon: Icons.today_outlined);
    try {
      final result = await fetchAttivita24h(
        int.tryParse(utenteId) ?? 0,
        DateTime.now(),
        apiBaseUrl,
        _authHeaders(),
      );
      setState(() {
        datiGiornalieri = result;
      });
    } catch (e) {
      setState(() {
        datiGiornalieri = null;
      });
    }
  }

  //-----------------------------------------------------------
  // Carica il livello utente
  //-----------------------------------------------------------
  Future<void> caricaLivelloUtente() async {
    try {
      final url = "$apiBaseUrl/utenti_livello.php?utente_id=$utenteId";
      final res = await http.get(Uri.parse(url), headers: _authHeaders());

      final data = json.decode(res.body);

      if (data['success'] == true) {
        setState(() {
          livelloUtente = data['livello']['nome'] ?? 'Free';
          giorniRimanenti = data['stato']['giorni_rimanenti'] ?? 0;
          livelloUtenteId = data['livello']['id'] ?? 0;
          features = data['features'] ?? {};
          countdownLevel = features['gps_sample_sec'] ?? 30;
          limitsHistoryDaysMax = data['retention_giorni'] ?? 0;
          countdown = features['gps_sample_sec'] ?? 30;
        });
      }
    } catch (e) {
      setState(() {
        livelloUtente = 'Free';
        giorniRimanenti = 0;
        livelloUtenteId = 0;
      });
    }
  }

  //-------------------------------------------------------
  // Etichetta per i giorni rimanenti
  //-------------------------------------------------------
  String _labelGiorni(int? g, String livello) {
    if (livello == 'Free' || livello == 'Start') return context.t.payment_mes1;
    if (g == null) return context.t.payment_mes1;
    if (g <= 0) return context.t.payment_mes2;
    if (g == 1) return context.t.payment_mes3;
    return '${g} ${context.t.payment_mes4}';
  }

  //-----------------------------------------------------------------
  // determina colore giorni rimanenti
  //-------------------------------------------------------------------
  Color _coloreGiorni(int? g, String livello) {
    if (livello == 'Free' || livello == 'Start') return Colors.blueGrey;
    if (g == null) return Colors.blueGrey;
    if (g <= 0) return Colors.red;
    if (g <= 7) return Colors.orange;
    if (g <= 30) return Colors.amber;
    return Colors.green;
  }

//----------------------------------------------------------
// Esporta dati distribuzione livelli in CSV
//----------------------------------------------------------
  void esportaDistribuzioneCsv(List<OraStat> datiOrari) {}

//-----------------------------------------------------------
// Esporta dati timeline livelli in GPX (esempio minimale)
//-----------------------------------------------------------
  void esportaTimelineGpx(List<OraStat> datiOrari) {}

  //-----------------------------------------------------------
  // Esegue un'operazione con un messaggio di stato
  //-----------------------------------------------------------
  Future<T> step<T>(String msg, Future<T> Function() body) async {
    AppBanner.show(msg);
    try {
      final r = await body();
      AppBanner.show('$msg: OK', bg: Colors.green);
      return r;
    } catch (e) {
      AppBanner.show('$msg: errore', bg: Colors.redAccent);
      rethrow;
    }
  }

//-----------------------------------------------------------
// Mappa i livelli di accuratezza della posizione
//-----------------------------------------------------------
  LocationAccuracy _accFromPlan(String? mode) {
    switch ((mode ?? '').toLowerCase()) {
      case 'low':
        return LocationAccuracy.low;
      case 'balanced':
        return LocationAccuracy.medium; // “balanced” = medium
      case 'high':
        return LocationAccuracy.high;
      case 'best':
        return LocationAccuracy.best;
      case 'nav': // best for navigation
        return LocationAccuracy.bestForNavigation;
      default:
        return LocationAccuracy.medium;
    }
  }

//-----------------------------------------------------------
// Mappa i livelli di accuratezza della posizione (metri)
//-----------------------------------------------------------
  double _accMaxFromPlan(String? mode) {
    switch (mode) {
      case 'low':
        return 150;
      case 'balanced':
        return 80;
      case 'high':
        return 50;
      case 'best':
      default:
        return 30;
    }
  }

//-------------------------------------------------------------------
// ricalcolaEaggiornaAttivita
//-------------------------------------------------------------------
  Future<void> _maybeRecalc({bool force = false}) async {
    final now = DateTime.now();
    final gpsuploadsec = (features?['gps_sample_sec'] as num?)?.toInt() ?? 30;
    if (force ||
        _lastRecalcAt == null ||
        now.difference(_lastRecalcAt!).inSeconds >= gpsuploadsec) {
      try {
        debugPrint('Ricalcolo attività...$now');
        await ricalcolaEaggiornaAttivita('maybeRecalc'); // <-- la tua funzione
        _lastRecalcAt = now;
      } catch (_) {
        // opzionale: log/banner
      }
    }
  }

//-------------------------------------------------------------------
// Flusso di logout
//-------------------------------------------------------------------
  Future<void> onLogoutFlow() async {
    countdownTimer?.cancel();
    setState(() {
      trackingAttivo = false;
      countdown = countdownLevel;
      _gpsInFlight = false;
    });
    await _maybeRecalc(force: true);
    // pulizia stato & token...
    _lastLat = _lastLon = null;
    _lastTs = null;
  }

//-----------------------------------------------------------------
// Inizializza la coda GPS
//-----------------------------------------------------------------
  void _initQueue() {
    final uploadSec = (features?['gps_upload_sec'] as num?)?.toInt() ?? 180;
    final uid = utenteId;
    if (uid == null || uid.isEmpty) return; // non loggato
    gpsQueue = GpsQueue(
      apiBaseUrl: apiBaseUrl,
      utenteId: uid,
      authHeaders:
          _authHeaders, // tua funzione che include Authorization: Bearer ...
      uploadEvery: Duration(seconds: uploadSec),
      batchSize: 20,
    );
  }

//-----------------------------------------------------------------
// Assicura che la coda GPS sia inizializzata
//-----------------------------------------------------------------
  Future<void> _ensureQueue() async {
    if (gpsQueue != null) return;
    _initQueue(); // ricrea la coda con i parametri del piano
    if (gpsQueue == null) {
      throw StateError('GPS queue non inizializzata');
    }
  }

//----------------------------------------------------------------------
// Mostra il dialogo di verifica email
//----------------------------------------------------------------------
  Future<void> mostraVerificaEmailDialog(
      BuildContext context, String emailPrecompilata) async {
    bool loading = false;
    String? errore;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(context.t.verifica_mail_titolo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.t.verifica_mail_testo1),
              const SizedBox(height: 12),
              Text(context.t.verifica_mail_testo2),
              if (errore != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child:
                      Text(errore!, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Chiudi la dialog
                // Torna alla dashboard, nessun login automatico
              },
              child: Text(context.t.verifica_mail_testo4),
            ),
            TextButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      final res = await http.post(
                        Uri.parse("$apiBaseUrl/verifica_resend.php"),
                        headers: _jwtToken != null ? _authHeaders() : null,
                        body: json.encode({'email': emailPrecompilata}),
                      );
                      setState(() => loading = false);
                      if (res.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(context.t.verifica_mail_erro1)),
                        );
                      } else {
                        setState(() => errore = context.t.verifica_mail_erro2);
                      }
                    },
              child: Text(context.t.verifica_mail_button),
            ),
          ],
        ),
      ),
    );
  }

//--------------------------------------------------------------------
// Controlla il permesso GPS
//--------------------------------------------------------------------
  Future<String> _permessoGps() async {
    // Se i servizi sono disattivi, consideriamo come "denied"
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return "denied";

    // Stato permessi
    final permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        // Verifica se l'accuratezza è ridotta (iOS: Approximate Location)
        try {
          final acc = await Geolocator
              .getLocationAccuracy(); // requires geolocator >= 9
          if (acc == LocationAccuracyStatus.reduced) return "limited";
        } catch (_) {
          // Se la API non è disponibile sulla piattaforma, ignora
        }
        return "granted";

      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        return "denied";

      case LocationPermission.unableToDetermine:
      default:
        return "unknown";
    }
  }

//----------------------------------------------------------------------
// Chiama /app_open.php con { permesso_gps: ... }
//-----------------------------------------------------------------------
  Future<void> callAppOpen() async {
    try {
      final body = json.encode({
        'utente_id': utenteId.toString(),
        'permesso_gps': await _permessoGps(), // tua funzione helper
      });
      await http.post(
        Uri.parse("$apiBaseUrl/app_open.php"),
        headers: _jwtToken != null ? _authHeaders() : null,
        body: body,
      );
    } catch (e) {
      // best-effort, non blocca l'app
    }
  }

//----------------------------------------------------------------------
// Chiama /app_close.php con { motivo: ... } (default 'exit_user')
//----------------------------------------------------------------------
  Future<void> callAppClose([String motivo = 'exit_user']) async {
    try {
      final body = json.encode({
        'utente_id': utenteId.toString(),
        'motivo': motivo,
      });
      await http.post(
        Uri.parse("$apiBaseUrl/app_close.php"),
        headers: _jwtToken != null ? _authHeaders() : null,
        body: body,
      );
    } catch (e) {
      // best-effort
    }
  }

  //----------------------------------------------------------------------
  /// Chiama /tracking_toggle.php con { azione: 'ON'|'OFF',
  //---------------------------------------------------------------------
  Future<void> callTrackingToggle(bool attivo, {String? nota}) async {
    try {
      final body = json.encode({
        'utente_id': utenteId.toString(),
        'azione': attivo ? 'ON' : 'OFF',
        if (nota != null && nota.isNotEmpty) 'note': nota,
      });

      await http.post(
        Uri.parse("$apiBaseUrl/tracking_toggle.php"),
        headers: _jwtToken != null ? _authHeaders() : null,
        body: body,
      );
    } catch (e) {
      // best-effort, non blocca l'app
    }
  }

  //----------------------------------------------------------------------
  // Mostra un loader bloccante
  //----------------------------------------------------------------------
  void _showBlockingLoader([String? message]) {
    if (_loaderOpen || !mounted) return;
    _loaderOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true, // sta sopra al dialog di login
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // niente back
        child: Dialog(
          insetPadding: const EdgeInsets.all(40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 4),
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    message ?? 'Caricamento in corso…',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------
  // Nasconde il loader bloccante
  //----------------------------------------------------------------------
  void _hideBlockingLoader() {
    if (!_loaderOpen) return;
    _loaderOpen = false;
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // chiude il dialog
    }
  }






  // ----------------------------------------------
  // fine classe
  // ---------------------------------------------
}

//-----------------------------------------------------------
// Classe per le statistiche orarie
//-----------------------------------------------------------
class OraStat {
  final int ora;
  final int l0;
  final int l1;
  final int l2;
  final int lm1; // OFF
  OraStat(this.ora, this.l0, this.l1, this.l2, [this.lm1 = 0]);
  factory OraStat.fromJson(Map<String, dynamic> j) => OraStat(
        j['ora'] as int,
        j['sec_l0'] as int,
        j['sec_l1'] as int,
        j['sec_l2'] as int,
        (j['sec_lm1'] ?? 0) as int,
      );
}

//-------------------------------------------------------------
// Classe per i periodi di attività
//-------------------------------------------------------------
class Periodo {
  final DateTime inizio, fine;
  final int livello;
  Periodo(this.inizio, this.fine, this.livello);
  factory Periodo.fromJson(Map<String, dynamic> j) => Periodo(
        DateTime.parse(j['inizio']).toLocal(),
        DateTime.parse(j['fine']).toLocal(),
        j['livello'].toInt(),
      );
}

//--------------------------------------------------------------
// Widget per visualizzare i giorni rimanenti
//---------------------------------------------------------------
class _ChipGiorni extends StatelessWidget {
  final String text;
  final Color color;
  const _ChipGiorni({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text, style: TextStyle(color: color)),
      );
}

//--------------------------------------------------------------
// Widget per visualizzare i punti della legenda
//---------------------------------------------------------------
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label),
        ],
      );
}

//--------------------------------------------------------------
// HERO CAROUSEL — mettilo in un file o sopra alla tua pagina
//--------------------------------------------------------------
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Slide>>? _future;
  String? _loadedLang;
  List<String>? _imgs, _txts;

  String _bestLang() {
    final code = Localizations.maybeLocaleOf(context)?.languageCode?.toLowerCase() ?? 'en';
    const supported = {'it','en','es','fr','de'};
    return supported.contains(code) ? code : 'en';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = _bestLang();
    if (_future == null || _loadedLang != lang) {
      _loadedLang = lang;
      _future = loadSlides(lang);   // usa la tua funzione
      _imgs = null;                 // reset cache quando cambia lingua
      _txts = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // keepAlive
    return FutureBuilder<List<Slide>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox(height: 220);
        }
        final slides = snap.data ?? const [];
        if (slides.isEmpty) return const SizedBox.shrink();

        _imgs ??= slides.map((s) => s.image).toList(growable: false);
        _txts ??= slides.map((s) => s.title).toList(growable: false);

        return RepaintBoundary(
          child: AutoImageCarousel(
            immagini: _imgs!,   // liste stabili → niente flicker
            testi: _txts!,
            altezza: 220,
          ),
        );
      },
    );
  }
}
