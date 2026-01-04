import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_header.dart';
import '../services/app_footer.dart';
import '../services/date_converter.dart';
import '../services/quality_fix.dart';
import '../services/day_detail_sheet.dart';

import '../db.dart'; // Importa la costante globale
import '../lingua.dart';
import '../safe_state.dart'; // Importa il mixin SafeState
import 'package:intl/intl.dart';
import 'card_percorso_giorno.dart';

import 'today_metrics.dart';
import 'today_insight.dart';
import 'today_card.dart';

import '../class/locked_info.dart';
import '../class/loading_card.dart';
import '../class/dettagli_livello_page.dart';
import 'compare_weeks_chart.dart'; // <-- aggiungi import in cima al file

class CronologiaPage extends StatefulWidget {
  final String utenteId;
  final String nomeId;
  const CronologiaPage({
    super.key,
    required this.utenteId,
    required this.nomeId,
  });

  @override
  State<CronologiaPage> createState() => _CronologiaPageState();
}

//---------------------------------------------------------------
// classe di visualizzazione Cronologia
//----------------------------------------------------------------
class _CronologiaPageState extends State<CronologiaPage> with SafeState {
  final _storage = const FlutterSecureStorage();
  String? _jwtToken;

  Map<int, List<dynamic>> datiLivelli = {0: [], 1: [], 2: []};
  Map<int, List<dynamic>> datiLivelliPrevSett = {0: [], 1: [], 2: []};

  bool loading = true;
  late String utenteId;
  late String nomeId;
  bool utenteTemporaneo = true;
  Map<int, String?> giornoSelezionato = {0: null, 1: null, 2: null};
  bool busy = false; // 👈 la variabile che usi nell'esempio
  late DateTime _selectedDate; // giorno scelto in cronologia
  late Future<Map<String, dynamic>> _trackFuture;

  String livelloUtente = 'Free'; // oppure Start, Basic, Plus, Pro
  int giorniRimanenti = 0;
  int livelloUtenteId = 0;
  int limitsHistoryDaysMax = 1; // limite consultazione (server-side)

  final bool userIsAnonymous = false; // metti il tuo flag
  Map<String, dynamic> features = {}; // permessi del piano};

  final Map<int, List<Map<String, dynamic>>> dettagliLivello = {
    0: [],
    1: [],
    2: [],
  };
  TodayMetrics? todayMetrics;
  bool loadingOggi = false;
  bool _refreshingToken = false;

  final double grandezzaMappa = 320; // altezza fissa della mappa

  // aggiungi questi getter nella classe
  List<int> get weekActiveCur => datiSettimanali(datiLivelli[1]);
  List<int> get weekActivePrev => datiSettimanali(datiLivelliPrevSett[1]);
  int confrontoLivello = 1;

  //-------------------------------------------------------------------
  // main line
  //-------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    utenteId = widget.utenteId;
    nomeId = widget.nomeId;

    _getToken();
  }

  //-----------------------------------------------------------------
  // retrive token per api e inizializza se ok
  //-----------------------------------------------------------------
  Future<void> _getToken() async {
    _jwtToken = await _storage.read(key: 'jwt_token');
    if (_jwtToken == null || _jwtToken!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.session_expired),
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }
    _selectedDate = DateTime.now();
    _trackFuture = _fetchTrack(_selectedDate);

    await caricaLivelloUtente();
    await caricaTuttiLivelli();
    await caricaOggi();
  }

  //-------------------------------------------------------------------
  // automatizza heder
  //-------------------------------------------------------------------
  Map<String, String> _authHeaders() {
    return {
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  //-----------------------------------------------------------
  // Carica il livello utente
  //-----------------------------------------------------------
  Future<void> caricaLivelloUtente() async {
    try {
      final url = "$apiBaseUrl/utenti_livello.php?utente_id=$utenteId";
      final res = await http.get(Uri.parse(url), headers: _authHeaders());

      final data = json.decode(res.body);

      if (res.statusCode == 401 && !_refreshingToken) {
        await handle401(); // <--- refresh token e gestisci eventuale retry
        await caricaLivelloUtente(); // riprova dopo il refresh
        return;
      }

      if (data['success'] == true) {
        setState(() {
          livelloUtente = data['livello']['nome'] ?? 'Free';
          giorniRimanenti = data['stato']['giorni_rimanenti'] ?? 0;
          livelloUtenteId = data['livello']['id'] ?? 0;
          features = data['features'] ?? {};
          limitsHistoryDaysMax = data['retention_giorni'] ?? 0;
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

  //-------------------------------------------------------------------
  // Carica tutti i livelli di dati
  //-------------------------------------------------------------------
  Future<void> caricaTuttiLivelli() async {
    setState(() => loading = true);
    for (int livello = 0; livello <= 2; livello++) {
      await caricaSettimana(livello);
      await caricaDettagliLivello(livello);
    }
    setState(() => loading = false);
  }

  //-------------------------------------------------------------------------
  // Carica i dettagli del livello specificato
  //-------------------------------------------------------------------------
  Future<void> caricaDettagliLivello(int livello) async {
    //setState(() {}); // Per mostrare eventuale caricamento

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

      if (res.statusCode == 401 && !_refreshingToken) {
        await handle401(); // <--- refresh token e gestisci eventuale retry
        await caricaDettagliLivello(livello); // riprova dopo il refresh
        return;
      }

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
  }

  //--------------------------------------------------------------------------
  // Assumo: dettagliLivello è una Map<int, List<dynamic>>
  // dove ogni elemento ha almeno: durata_sec, distanza_metri, data_ora_inizio,
  // data_ora_fine
  // Esempio: dettagliLivello[1] = lista segmenti tipo_attivita = 1 (leggero)
  //--------------------------------------------------------------------------
  int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is String)
      return int.tryParse(v.replaceAll(RegExp(r'[^0-9-]'), '')) ?? 0;
    return 0;
  }

  //--------------------------------------------------------------------------
  // Converte variabile dinamica in double
  //--------------------------------------------------------------------------
  double _asDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
    return 0.0;
  }

  //-------------------------------------------------------------------------
  // RIEPILOGO AL LIVELLO (0=fermo, 1=leggero, 2=veloce)
  // Somma durata_sec e distanza_metri; km calcolati da metri.
  // "passi" lo lasciamo a 0 se non lo fornisce il backend.
  //-------------------------------------------------------------------------
  Map<String, dynamic> riepilogoLivello(int livello) {
    final List segs = (dettagliLivello[livello] ?? []) as List;
    int durata = 0;
    double metri = 0.0;
    int passi = 0; // se non li hai, resta 0

    for (final s in segs) {
      durata += _asInt(s['durata_sec']);
      metri += _asDouble(s['distanza_metri']);
      // se in futuro hai i passi nel segmento: passi += _asInt(s['passi']);
    }

    final km = metri / 1000.0;

    return {
      'durata': durata, // secondi totali del livello
      'metri': metri, // metri totali del livello
      'passi': passi, // se non disponibili, 0
      'km': km, // km derivati
      'count': segs.length,
    };
  }

  //--------------------------------------------------------------
  // Carica i dati della settimana per un livello specifico
  //-------------------------------------------------------------------
  Future<void> caricaSettimana(int livello) async {
    final oggi = DateTime.now();

    final dataStr =
        "${oggi.year.toString().padLeft(4, '0')}${oggi.month.toString().padLeft(2, '0')}${oggi.day.toString().padLeft(2, '0')}";
    final prev = oggi.subtract(const Duration(days: 7));
    final prevDataStr =
        "${prev.year.toString().padLeft(4, '0')}${prev.month.toString().padLeft(2, '0')}${prev.day.toString().padLeft(2, '0')}";

    final url = (String d) =>
        "$apiBaseUrl/settimana_livello.php?utente_id=$utenteId&livello=$livello&data=$d";

    try {
      // chiamata per settimana corrente
      final resCur =
          await http.get(Uri.parse(url(dataStr)), headers: _authHeaders());
      if (resCur.statusCode == 401 && !_refreshingToken) {
        await handle401();
        await caricaSettimana(livello); // retry una sola volta
        return;
      }
      if (resCur.statusCode == 200) {
        final bodyCur = json.decode(resCur.body);
        final dettagliCur = bodyCur['dettagli'] ?? [];
        // ordina se serve
        if (dettagliCur is List) {
          dettagliCur.sort((a, b) => (a['data_ora_inizio'] ?? '')
              .toString()
              .compareTo((b['data_ora_inizio'] ?? '').toString()));
        }
        setState(() {
          datiLivelli[livello] = List<dynamic>.from(dettagliCur);
        });
      } else if (resCur.statusCode == 401) {
        // token invalido persistente
        await _storage.delete(key: 'jwt_token');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t.session_expired)),
          );
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return;
      } else {
        setState(() {
          datiLivelli[livello] = [];
        });
      }

      // chiamata per settimana precedente
      final resPrev =
          await http.get(Uri.parse(url(prevDataStr)), headers: _authHeaders());
      if (resPrev.statusCode == 401 && !_refreshingToken) {
        await handle401();
        await caricaSettimana(livello); // retry una sola volta
        return;
      }
      if (resPrev.statusCode == 200) {
        final bodyPrev = json.decode(resPrev.body);
        final dettagliPrev = bodyPrev['dettagli'] ?? [];
        if (dettagliPrev is List) {
          dettagliPrev.sort((a, b) => (a['data_ora_inizio'] ?? '')
              .toString()
              .compareTo((b['data_ora_inizio'] ?? '').toString()));
        }
        setState(() {
          datiLivelliPrevSett[livello] = List<dynamic>.from(dettagliPrev);
        });
      } else if (resPrev.statusCode == 401) {
        await _storage.delete(key: 'jwt_token');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t.session_expired)),
          );
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        setState(() {
          datiLivelliPrevSett[livello] = [];
        });
      }
    } catch (e) {
      // best-effort fallback
      setState(() {
        datiLivelli[livello] = datiLivelli[livello] ?? [];
        datiLivelliPrevSett[livello] = datiLivelliPrevSett[livello] ?? [];
      });
    }
  }

  //----------------------------------------------------------------
  // Formatta i minuti in ore e minuti
  //----------------------------------------------------------------
  String formattaMinuti(int minuti) {
    final ore = minuti ~/ 60;
    final restantiMin = minuti % 60;
    return ore > 0 ? '${ore}h ${restantiMin}min' : '${restantiMin}min';
  }

  //----------------------------------------------------------------
  // Calcola i totali per un livello specifico
  //----------------------------------------------------------------
  Map<String, dynamic> totaliLivello(List<dynamic> sessioni, int livello) {
    int durataTot = 0;
    double metriTot = 0;
    for (final s in sessioni) {
      durataTot += (s['durata_sec'] ?? 0) as int;
      final dynamic distanza = s['distanza_metri'];
      if (distanza != null) {
        if (distanza is num) {
          metriTot += distanza.toDouble();
        } else if (distanza is String) {
          metriTot += double.tryParse(distanza) ?? 0.0;
        }
      }
    }
    return {
      'durata': formattaMinuti((durataTot / 60).round()),
      'metri': metriTot,
      'km': (metriTot / 1000),
      'passi': livello == 1 ? (metriTot / 0.7).round() : null,
    };
  }

  //-----------------------------------------------------------------
  // Costruisce il widget di intestazione per un livello specifico
  //-----------------------------------------------------------------
  Widget testataLivello(
    int livello,
    List<String> giorni,
    String? giornoSel,
    ValueChanged<String?> onGiornoChanged,
  ) {
    final giornoDefault = giorni.isNotEmpty ? giorni.first : null;
    final dataSelezionata = giornoSel ?? giornoDefault;

    final sessioniData = datiLivelli[livello]!
        .where((giorno) =>
            (ymdLocal(giorno['data_ora_inizio']) ?? '') == dataSelezionata)
        .toList();

    final totaliData = totaliLivello(sessioniData, livello);

    DateTime? _tryParseDate(String? s) {
      if (s == null || s.isEmpty) return null;
      // 1) formato ISO compatibile: yyyy-MM-dd
      final iso = DateTime.tryParse(s);
      if (iso != null) return iso;
      try {
        // 2) formato localizzato comune dd/MM/yyyy o d/M/yyyy
        final f1 = DateFormat('dd/MM/yyyy');
        return f1.parseLoose(s);
      } catch (_) {}
      try {
        final f2 = DateFormat('d/M/yyyy');
        return f2.parseLoose(s);
      } catch (_) {}
      try {
        final f3 = DateFormat('yyyy-MM-dd');
        return f3.parseLoose(s);
      } catch (_) {}
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 👇 area di sinistra: può andare a capo
          Expanded(
            child: Wrap(
              spacing: 16,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('${context.t.info_mes03} ${totaliData['durata']}'),
                if (livello == 1) ...[
                  const SizedBox(width: 16),
                  Text(
                      '${context.t.um_metri} ${totaliData['metri'].toStringAsFixed(1)}'),
                  const SizedBox(width: 16),
                  //Text('${context.t.um_passi} ${totaliData['passi'] ?? '-'}'),
                ],
                if (livello == 2) ...[
                  const SizedBox(width: 16),
                  Text(
                      '${context.t.um_km} ${totaliData['km'].toStringAsFixed(2)}'),
                ],
              ],
            ),
          ),

          // 👇 a destra: la tendina e il pulsante di export
          if (giorni.isNotEmpty) ...[
            DropdownButton<String>(
              value: dataSelezionata,
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              items: giorni
                  .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(g, style: const TextStyle(fontSize: 12)),
                      ))
                  .toList(),
              onChanged: onGiornoChanged,
            ),
            const SizedBox(width: 6),
            IconButton(
              tooltip: context.t.export_day ?? 'Export Day',
              icon: const Icon(Icons.download_outlined, size: 20),
              onPressed: () {
                final dt = _tryParseDate(dataSelezionata);
                if (dt == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(context.t.date_parse_error ??
                            'Format data not recognized')),
                  );
                  return;
                }
                // chiama la tua funzione di export (implementata in classe)
                _downloadCsv(dt);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(context.t.export_started ?? 'Export started')),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  //----------------------------------------------------------------
  // Restituisce la lista dei giorni disponibili per un livello specifico
  //----------------------------------------------------------------
  List<String> giorniDisponibili(int livello) {
    final lista = datiLivelli[livello] ?? [];
    final giorni = lista
        .map<String>(
          (e) => (e['data_ora_inizio'] != null)
              ? ymdLocal(e['data_ora_inizio'])
              : '',
        )
        .toSet()
        .toList();
    giorni.sort((a, b) => b.compareTo(a)); // dal più recente
    return giorni;
  }

  /// ----------------------------------------------------------------
  /// Costruisce il widget di intestazione per un livello specifico
  /// ----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(showBack: true),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.dashboard,
                          size: 22,
                          color: Colors.blue[700],
                        ),
                        SizedBox(width: 8),
                        Text(
                          context.t.form_crono_01,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.history, size: 20, color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Text(
                          context.t.form_crono_02,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${context.t.form_crono_03}  ${nomeId.isNotEmpty ? nomeId : context.t.anonymousUser}!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    SizedBox(height: 20),

                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      color: Colors.blueGrey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            const BorderSide(color: Colors.blueGrey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: buildTodayCard(context),
                      ),
                    ),

                    SizedBox(height: 12),
                    //-----------------------------------------------
                    // card settimana
                    //-----------------------------------------------
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      color: Colors.blueGrey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blueGrey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t.form_crono_04,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 12),
                            // Inattività
                            Row(
                              children: [
                                Text(
                                  '🛌 ${context.t.mov_inattivo}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  totaliLivello(datiLivelli[0]!, 0)['durata'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Movimento leggero
                            Wrap(
                              spacing: 16,
                              runSpacing: 4,
                              children: [
                                Text(
                                  '🚶 ${context.t.mov_leggero}:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  totaliLivello(datiLivelli[1]!, 1)['durata'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${context.t.um_metri} ${totaliLivello(datiLivelli[1]!, 1)['metri'].toStringAsFixed(1)}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                //Text(
                                //'${context.t.um_passi} ${totaliLivello(datiLivelli[1]!, 1)['passi'] ?? '-'}',
                                //style: TextStyle(fontSize: 14),
                                //),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Movimento veloce
                            Wrap(
                              spacing: 16,
                              runSpacing: 4,
                              children: [
                                Text(
                                  '🚗 ${context.t.mov_veloce}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  totaliLivello(datiLivelli[2]!, 2)['durata'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${context.t.um_km} ${totaliLivello(datiLivelli[2]!, 2)['km'].toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12),
                    //-----------------------------------------------
                    // card settimana precedente
                    //-----------------------------------------------
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      color: Colors.blueGrey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blueGrey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t.form_crono_10,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 12),
                            // Inattività
                            Row(
                              children: [
                                Text(
                                  '🛌 ${context.t.mov_inattivo}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  totaliLivello(
                                      datiLivelliPrevSett[0]!, 0)['durata'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Movimento leggero
                            Wrap(
                              spacing: 16,
                              runSpacing: 4,
                              children: [
                                Text(
                                  '🚶 ${context.t.mov_leggero}:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  totaliLivello(
                                      datiLivelliPrevSett[1]!, 1)['durata'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${context.t.um_metri} ${totaliLivello(datiLivelliPrevSett[1]!, 1)['metri'].toStringAsFixed(1)}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                //Text(
                                //'${context.t.um_passi} ${totaliLivello(datiLivelliPrevSett[1]!, 1)['passi'] ?? '-'}',
                                //style: TextStyle(fontSize: 14),
                                //),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Movimento veloce
                            Wrap(
                              spacing: 16,
                              runSpacing: 4,
                              children: [
                                Text(
                                  '🚗 ${context.t.mov_veloce}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  totaliLivello(
                                      datiLivelliPrevSett[2]!, 2)['durata'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${context.t.um_km} ${totaliLivello(datiLivelliPrevSett[2]!, 2)['km'].toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12),
                    //-------------------------------------------------
                    // grafico confronto due settimane con selettore livello
                    //-------------------------------------------------
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      color: Colors.blueGrey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side:
                            const BorderSide(color: Colors.blueGrey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.t.form_crono_11,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                // selettore livello: 0/1/2
                                DropdownButton<int>(
                                  value: confrontoLivello,
                                  items: [
                                    DropdownMenuItem(
                                        value: 0,
                                        child: Text(
                                            'L0 • ${context.t.mov_inattivo}')),
                                    DropdownMenuItem(
                                        value: 1,
                                        child: Text(
                                            'L1 • ${context.t.mov_leggero}')),
                                    DropdownMenuItem(
                                        value: 2,
                                        child: Text(
                                            'L2 • ${context.t.mov_veloce}')),
                                  ],
                                  onChanged: (v) {
                                    if (v == null) return;
                                    setState(() => confrontoLivello = v);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // prepara i dati per il livello selezionato
                            Builder(builder: (ctx) {
                              final today = DateTime.now();
                              final weekA = datiSettimanali(
                                  datiLivelli[confrontoLivello],
                                  endDate: today);
                              final weekB = datiSettimanali(
                                  datiLivelliPrevSett[confrontoLivello],
                                  endDate:
                                      today.subtract(const Duration(days: 7)));
                              return CompareWeeksChart(
                                weekA: weekA,
                                weekB: weekB,
                                labelA: context.t.form_crono_04,
                                labelB: context.t.form_crono_10,
                                colorA: confrontoLivello == 2
                                    ? Colors.purple
                                    : Colors.blue[700]!,
                                colorB: confrontoLivello == 2
                                    ? Colors.pink
                                    : Colors.orange[600]!,
                                height: 220,
                                onBarTap: (day) => debugPrint(
                                    'Toccato giorno idx $day (L$confrontoLivello)'),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    //-------------------------------------------------
                    // card percorso
                    //-------------------------------------------------
                    const SizedBox(height: 8),
                    _buildPercorsoCard(), // <<--- QUI
                    const SizedBox(height: 8),

                    //-------------------------------------------------
                    // Lista dei giorni
                    //-------------------------------------------------
                    ExpansionTile(
                      initiallyExpanded: false,
                      leading: const Icon(Icons.science_outlined),
                      title: Text(
                        context.t.dettagli,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int livello = 0; livello <= 2; livello++)
                              ExpansionTile(
                                //initiallyExpanded: livello == 0,
                                leading: Text(
                                  livello == 0
                                      ? '🛌'
                                      : livello == 1
                                          ? '🚶'
                                          : '🚗',
                                  style: TextStyle(fontSize: 22),
                                ),
                                title: Text(
                                  livello == 0
                                      ? context.t.mov_inattivo
                                      : livello == 1
                                          ? context.t.mov_leggero
                                          : context.t.mov_veloce,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                children: () {
                                  final giorni = giorniDisponibili(livello);
                                  final giornoDefault =
                                      giorni.isNotEmpty ? giorni.first : null;
                                  return [
                                    // --- TESTATA TOTALE ---
                                    testataLivello(
                                      livello,
                                      giorni,
                                      giornoSelezionato[livello] ??
                                          giornoDefault,
                                      (val) {
                                        setState(() {
                                          giornoSelezionato[livello] = val;
                                        });
                                      },
                                    ),

                                    // --- SESSIONI FILTRATE ---
                                    if (datiLivelli[livello]!.isEmpty ||
                                        giorni.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          context.t.form_crono_05,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      )
                                    else
                                      // --- Totali per la data selezionata ---
                                      ...datiLivelli[livello]!
                                          .where(
                                            (giorno) =>
                                                (giornoSelezionato[livello] ??
                                                    giornoDefault) ==
                                                (ymdLocal(giorno[
                                                        'data_ora_inizio']) ??
                                                    ''),
                                          )
                                          .map(
                                            (giorno) => Card(
                                              margin: EdgeInsets.symmetric(
                                                vertical: 6,
                                                horizontal: 12,
                                              ),
                                              elevation: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color:
                                                              Colors.blue[400],
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          ymdLocal(giorno[
                                                                  'data_ora_inizio']) ??
                                                              '',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Icon(
                                                          Icons.timer,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          '${Duration(seconds: (giorno['durata_sec'] as num?)?.toInt() ?? 0).inMinutes} min',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.directions_walk,
                                                          color:
                                                              Colors.green[600],
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          '${context.t.info_mes04} ${(giorno['distanza_metri'] is num ? giorno['distanza_metri'] : double.tryParse(giorno['distanza_metri'] ?? '0') ?? 0).toStringAsFixed(1)} m',
                                                        ),
                                                        Spacer(),
                                                        Icon(
                                                          Icons.sensors,
                                                          color: Colors
                                                              .orange[600],
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          ' ${giorno['fonte'] ?? '-'}',
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color:
                                                              Colors.grey[700],
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          '${context.t.info_mes01} ${hmLocal(giorno['data_ora_inizio']) ?? ''}',
                                                        ),
                                                        Spacer(),
                                                        Icon(
                                                          Icons.stop,
                                                          color:
                                                              Colors.grey[700],
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          '${context.t.info_mes02} ${hmLocal(giorno['data_ora_fine']) ?? ''}',
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ];
                                }(),
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    AppFooter(), // <-- ora scorre con la pagina
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

      // BOTTONE fisso in basso
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.home),
              label: Text(context.t.bottom_dashboard),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  /// --------------------------------------------------------------
  /// Costruisce il widget di intestazione per un livello specifico
  /// -----------------------------------------------------------------
  Widget intestazioneLivello(int livello) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${context.t.form_crono_06} ${livello + 1}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------
  /// Costruisce il widget per un livello specifico
  /// --------------------------------------------------------------
  Widget livelloCard(int livello, String titolo, Color colore) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Naviga alla pagina dei dettagli con i dati del livello selezionato
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DettagliLivelloPage(livello: livello),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colore,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titolo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      context.t.form_crono_07,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  // Callback per la modifica della data
  //----------------------------------------------------------------------
  void _onDateChanged(DateTime d) {
    setState(() {
      _selectedDate = d;
      _trackFuture = _fetchTrack(_selectedDate);
    });
  }

  //----------------------------------------------------------------------
  // Funzione per il recupero dei dati di tracciamento
  //----------------------------------------------------------------------
  Future<Map<String, dynamic>> _fetchTrack(DateTime d) async {
    final qs = {
      'utente_id': utenteId.toString(), // <-- il tuo id
      'date': DateFormat('yyyy-MM-dd').format(d),
      'precision': 'med',
      'max_acc_m': '100',
    };
    final uri = Uri.parse('$apiBaseUrl/traccia_giorno.php')
        .replace(queryParameters: qs);

    final res =
        await http.get(uri, headers: _authHeaders()); // <-- i tuoi header

    if (res.statusCode == 401 && !_refreshingToken) {
      await handle401(); // <--- refresh token e gestisci eventuale retry
      return _fetchTrack(d); // riprova dopo il refresh
    }

    Map<String, dynamic> data;
    try {
      data = json.decode(res.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('track_invalid_json: ${res.statusCode} ${res.body}');
    }

    final ok = (data['success'] == true) || (data['ok'] == true);
    if (!ok) {
      throw Exception(data['error'] ?? 'track_failed');
    }

    return data;
  }

  //------------------------------------------------------------------
  // creazione mappa
  //------------------------------------------------------------------
  Widget _buildPercorsoCard() {
    // gating: anonimo o fuori dallo storico
    if (userIsAnonymous) {
      return LockedInfo(text: context.t.crono_msg_01);
    }
    if (!_withinHistory(_selectedDate, features['history_days'])) {
      return LockedInfo(
        text:
            '${context.t.crono_msg_02} ${features['history_days']} ${context.t.crono_msg_03}',
      );
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: _trackFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const LoadingCard();
        }
        if (snap.hasError) {
          return LockedInfo(text: context.t.crono_msg_04);
        }

        final data = snap.data!;
        final segments = List<dynamic>.from(data['segments'] ?? const []);
        final bbox = (data['bbox'] as List?)?.cast<dynamic>();
        final dist = (data['distance_m'] as num?)?.toDouble() ?? 0.0;
        final durS = (data['duration_s'] as num?)?.toInt() ?? 0;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blueGrey, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // >>> QUI USI IL TUO WIDGET <<<

                CardPercorsoGiorno(
                  framed: false,
                  height: grandezzaMappa,
                  levelsToShow: const {'L0', 'L1', 'L2'},
                  fetchTraccia: (date) async {
                    final d = DateFormat('yyyy-MM-dd').format(date);
                    final uri = Uri.parse(
                      '$apiBaseUrl/traccia_giorno.php?utente_id=$utenteId&date=$d&precision=med&max_acc_m=100',
                    );

                    final res = await http.get(uri, headers: _authHeaders());

                    if (res.statusCode != 200) {
                      throw Exception('HTTP ${res.statusCode}: ${res.body}');
                    }

                    Map<String, dynamic> data;
                    try {
                      final j = json.decode(res.body);
                      if (j is Map<String, dynamic>) {
                        data = j;
                      } else {
                        throw Exception('JSON non è un oggetto');
                      }
                    } catch (e) {
                      throw Exception('track_invalid_json: ${res.body}');
                    }

                    final ok =
                        (data['success'] == true) || (data['ok'] == true);
                    if (!ok) {
                      throw Exception(data['error'] ?? context.t.crono_msg_05);
                    }

                    // Normalizza campi attesi da MappaPercorsi
                    final segments = (data['segments'] is List)
                        ? (data['segments'] as List)
                        : const <dynamic>[];
                    final bbox =
                        (data['bbox'] is List) ? (data['bbox'] as List) : null;

                    return {
                      'segments': segments,
                      'bbox': bbox,
                    };
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //----------------------------------------------------------------------
  // Funzione per il download del file GPX
  //----------------------------------------------------------------------
  Future<void> _downloadGpx(DateTime d) async {
    final s = DateFormat('yyyy-MM-dd').format(d);
    final url = '$apiBaseUrl/export_gpx_giorno.php?utente_id=$utenteId&date=$s';
    await _openOrDownload(url, 'traccia_$s.gpx');
  }

  //----------------------------------------------------------------------
  // Funzione per il download del file CSV
  //----------------------------------------------------------------------
  Future<void> _downloadCsv(DateTime d) async {
    final s = DateFormat('yyyy-MM-dd').format(d);
    final url = '$apiBaseUrl/export_csv_giorno.php?utente_id=$utenteId&date=$s';
    await _downloadInsideApp(url, 'export_$s.csv');
    //await _openOrDownload(url, 'export_$s.csv');
  }

  //----------------------------------------------------------------------
  // helper: scarica il file via HTTP e lo condivide/apre
  //----------------------------------------------------------------------
  Future<void> _downloadInsideApp(String url, String filename) async {
    try {
      final uri = Uri.parse(url);

      // 1. CHIAMO l’API con gli header (qui c’è il token!)
      final res = await http.get(uri, headers: _authHeaders());

      if (res.statusCode == 200) {
        // 2. salvo su tmp
        final tmp = await getTemporaryDirectory();
        final file = File('${tmp.path}/$filename');
        await file.writeAsBytes(res.bodyBytes);

        // 3. condivido/apro
        await Share.shareFiles([file.path],
            text: '${context.t.esportazione_file} $filename');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t.errore_http} ${res.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.t.errore_generico}: $e')),
      );
    }
  }

  //----------------------------------------------------------------------
  // helper: prova ad aprire l'URL;
  //se non possibile scarica e condivide il file
  // attenzione manca token
  //----------------------------------------------------------------------
  Future<void> _openOrDownload(String url, String filename) async {
    try {
      final uri = Uri.parse(url);

      // 1) prima provo ad aprirlo fuori
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t.download_start)),
          );
        }
        return;
      }

      // 2) fallback: scarico io e salvo
      final res = await http.get(uri, headers: _authHeaders());
      if (res.statusCode == 200) {
        // QUI serve path_provider
        final tmpDir = await getTemporaryDirectory();
        final file = File('${tmpDir.path}/$filename');
        await file.writeAsBytes(res.bodyBytes);
        await Share.shareFiles([file.path],
            text: '${context.t.esportazione_file} $filename');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${context.t.errore_http} ${res.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t.errore_generico}: $e')),
        );
      }
    }
  }

  //----------------------------------------------------------------------
  // Funzione per verificare se una data è all'interno dello storico
  //----------------------------------------------------------------------
  bool _withinHistory(DateTime d, int? historyDays) {
    if (historyDays == null || historyDays <= 0) return true;
    final today = DateTime.now();
    final diff = today.difference(DateTime(d.year, d.month, d.day)).inDays;
    return diff <= (historyDays - 1);
  }

  //-------------------------------------------------------------
  // helper: costruisce TodayMetrics usando i tuoi riepiloghi
  //-------------------------------------------------------------
  TodayMetrics buildTodayFromRiepiloghi({
    required Map<String, dynamic> r0, // fermo
    required Map<String, dynamic> r1, // leggero
    required Map<String, dynamic> r2, // veloce
    List<Map<String, dynamic>>? dettagliOggi, // opzionale: per stimare gap%
    int? goalMinutes,
    int? yesterdayActiveMinutes,
  }) {
    final secFermo = _asInt(r0['durata']);
    final secLeggero = _asInt(r1['durata']);
    final secVeloce = _asInt(r2['durata']);

    final metriTot = _asDouble(r0['metri']) +
        _asDouble(r1['metri']) +
        _asDouble(r2['metri']);

    // gap% stimato sullo span [min(inizio), max(fine)] dei segmenti odierni
    double gapRatio = 0.0;
    if (dettagliOggi != null && dettagliOggi.isNotEmpty) {
      DateTime? a, b;
      for (final s in dettagliOggi) {
        final i = DateTime.parse(
            (s['data_ora_inizio'] as String).replaceFirst(' ', 'T'));
        final f = DateTime.parse(
            (s['data_ora_fine'] as String).replaceFirst(' ', 'T'));
        a = (a == null || i.isBefore(a)) ? i : a;
        b = (b == null || f.isAfter(b)) ? f : b;
      }
      final span = (a != null && b != null) ? b.difference(a).inSeconds : 0;
      final covered = secFermo + secLeggero + secVeloce;
      final gapSec = (span > covered) ? (span - covered) : 0;
      gapRatio = (span > 0) ? (gapSec / span).clamp(0.0, 1.0) : 0.0;
    }

    final hasAnyData = (secFermo + secLeggero + secVeloce) > 0 || metriTot > 0;
    final now = DateTime.now();
    final dayClosed = now.hour > 21 || (now.hour == 21 && now.minute >= 30);

    return TodayMetrics(
      secFermo: secFermo,
      secLeggero: secLeggero,
      secVeloce: secVeloce,
      distanceMeters: metriTot,
      gapRatio: gapRatio,
      hasAnyData: hasAnyData,
      dayClosed: dayClosed,
      goalMinutes: goalMinutes,
      yesterdayActiveMinutes: yesterdayActiveMinutes,
    );
  }

  //-----------------------------------------------------------
  // carica i dati di oggi
  //-----------------------------------------------------------
  Future<void> caricaOggi() async {
    setState(() => loadingOggi = true);

    // 1) carica i 3 livelli in parallelo
    await Future.wait([
      caricaDettagliLivello(0),
      caricaDettagliLivello(1),
      caricaDettagliLivello(2),
    ]);

    // 2) calcola i riepiloghi
    final r0 = riepilogoLivello(0);
    final r1 = riepilogoLivello(1);
    final r2 = riepilogoLivello(2);

    // 3) prepara la lista dei segmenti odierni (serve solo per stimare il gap%)
    final dettagliOggi = [
      ...dettagliLivello[0]!,
      ...dettagliLivello[1]!,
      ...dettagliLivello[2]!,
    ];

    // 4) calcola i minuti attivi di IERI dai DETTAGLI SETTIMANALI (livelli 1 e 2)
    final level1Week =
        (datiLivelli[1] ?? const []).cast<Map<String, dynamic>>();
    final level2Week =
        (datiLivelli[2] ?? const []).cast<Map<String, dynamic>>();
    final yesterdayMin = activeMinutesYesterdayFromDetails(
      level1: level1Week,
      level2: level2Week,
    );

    // 4) costruisci il TodayMetrics finale
    todayMetrics = buildTodayFromRiepiloghi(
      r0: r0!, r1: r1!, r2: r2!,
      dettagliOggi: dettagliOggi, // oppure null se non ti interessa il gap% ora
      goalMinutes: null, // metti il tuo obiettivo minuti, se lo hai
      yesterdayActiveMinutes:
          yesterdayMin, // metti i minuti attivi di ieri, se li hai
    );

    setState(() => loadingOggi = false);
  }

  //-----------------------------------------------------------
  // Crea form today
  //-----------------------------------------------------------
  Widget buildTodayCard(BuildContext context) {
    if (loadingOggi || todayMetrics == null) {
      return const SizedBox(height: 140); // placeholder
    }

    // Adatta qui al tuo TodayMetrics reale:
    double _sumMetersTodayFromSegments() {
      double m = 0;
      for (final l in [0, 1, 2]) {
        final list = (dettagliLivello[l] ?? const []) as List;
        for (final s in list) {
          final v = s['distanza_metri'];
          if (v is num)
            m += v.toDouble();
          else if (v is String)
            m += double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
        }
      }
      return m;
    }

    final snap = TodaySnapshot(
      activeMinutes: todayMetrics!.activeMinutes,
      metersToday: _sumMetersTodayFromSegments(),
      sedentaryMinutes: todayMetrics!.sedentaryMinutes ?? 0,
      yesterdayActiveMinutes: todayMetrics!.yesterdayActiveMinutes,
    );

    // Se hai già i segmenti caricati per livello (0/1/2), passali:
    final segs = <int, List<Map<String, dynamic>>>{
      0: List<Map<String, dynamic>>.from(dettagliLivello[0] ?? const []),
      1: List<Map<String, dynamic>>.from(dettagliLivello[1] ?? const []),
      2: List<Map<String, dynamic>>.from(dettagliLivello[2] ?? const []),
    };

    return TodayCard(
      metrics: todayMetrics!,
      rules: InsightRules(gapCritical: 0.20, goalReminderHour: 18),
      now: DateTime.now(),
      t: (k, v) => _t(context, k, v), // il tuo adapter testi
      // Tap sull'intera card -> dettaglio della giornata (se vuoi)
      onTap: () {
        openDayDetailSheet(
          context,
          snapshot: snap,
          segmentsByLevel: segs,
          title: context.t.today_title,
        );
      },
      // Tap sul banner "qualità dati" -> apri il foglio con i fix
      onTapQualityFix: () {
        openQualityFix(context);
      },
    );
  }

  //------------------------------------------------------------------------------
  // Adapter testi per TodayCard.
  // Se hai già un sistema di traduzioni (es. context.t) puoi sostituire i return.
  //------------------------------------------------------------------------------
  String _t(BuildContext ctx, String key, Map<String, dynamic> v) {
    switch (key) {
      case 'today_title':
        return ctx.t.today_title;
      case 'today_title_closed':
        return ctx.t.today_title_closed;
      case 'badge_partial':
        return ctx.t.badge_partial;
      case 'kpi_active':
        return ctx.t.kpi_active;
      case 'kpi_km':
        return ctx.t.kpi_km;
      case 'kpi_sedentary':
        return ctx.t.kpi_sedentary;
      case 'no_data_msg':
        return ctx.t.no_data_msg;
      case 'check_location':
        return ctx.t.check_location;
      case 'check_battery':
        return ctx.t.check_battery;
      case 'check_gps':
        return ctx.t.check_gps;
      case 'insight_quality':
        return ctx.t.insight_quality;
      case 'insight_goal_hit':
        return ctx.t.insight_goal_hit;
      case 'insight_goal_missing':
        return ctx.t.insight_goal_missing(v['n']); //v1
      case 'insight_vs_yesterday':
        return ctx.t.insight_vs_yesterday(v['pct']); //v2
      default:
        return key; // fallback
    }
  }

//--------------------------------------------------------------------
// parse della data
//--------------------------------------------------------------------
  DateTime? _parseTs(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) {
      final s = v.contains('T') ? v : v.replaceFirst(' ', 'T');
      try {
        return DateTime.parse(s);
      } catch (_) {}
    }
    return null;
  }

//---------------------------------------------------------------------
// mette data in ssaammgg
//---------------------------------------------------------------------
  String _ymd(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

//------------------------------------------------------------
  /// level1/level2 = liste “dettagli” dei 7 giorni per livello
//------------------------------------------------------------
  int activeMinutesYesterdayFromDetails({
    required List<Map<String, dynamic>> level1,
    required List<Map<String, dynamic>> level2,
  }) {
    final y = DateTime.now().toLocal().subtract(const Duration(days: 1));
    final ymd = _ymd(y);

    int sec = 0;

    // somma livello 1
    for (final s in level1) {
      final ts = _parseTs(s['inizio_locale'] ?? s['data_ora_inizio']);
      if (ts != null && _ymd(ts.toLocal()) == ymd) {
        sec += _asInt(s['durata_sec']);
      }
    }
    // somma livello 2
    for (final s in level2) {
      final ts = _parseTs(s['inizio_locale'] ?? s['data_ora_inizio']);
      if (ts != null && _ymd(ts.toLocal()) == ymd) {
        sec += _asInt(s['durata_sec']);
      }
    }

    return (sec / 60).round();
  }

//----------------------------------------------------------------------
// Gestione del token 401 (non più valido): login anonimo e reload dati
//----------------------------------------------------------------------
  Future<void> handle401() async {
    if (_refreshingToken) return;
    _refreshingToken = true;
    final ok = await loginAnon();
    _refreshingToken = false;
    if (ok) {
      _jwtToken = await _storage.read(key: 'jwt_token');

      // qui puoi ripetere la richiesta che aveva dato 401
      //await _loadAll();
    }
  }

  //---------------------------------------------------------
  // crea token chiamando login anonimo per avere autenticazione
  //---------------------------------------------------------
  Future<bool> loginAnon() async {
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

  //-----------------------------------------------------------
  // Converte una lista di "dettagli" in 7 valori (minuti) lun→dom
  // per il grafico settimanale
  //-----------------------------------------------------------
  List<int> datiSettimanali(List<dynamic>? lista, {DateTime? endDate}) {
    final end = (endDate ?? DateTime.now()).toLocal();
    final giorni = List.generate(7, (i) {
      final d = end.subtract(Duration(days: 6 - i));
      return _ymd(d);
    });

    final mappa = <String, int>{};

    for (final e in (lista ?? [])) {
      if (e == null) continue;
      String dataStr = '';

      // prova chiavi comuni: 'data' (API older), 'inizio_locale', 'data_ora_inizio'
      if (e is Map<String, dynamic>) {
        if (e.containsKey('data') && (e['data'] != null)) {
          dataStr = e['data'].toString();
        } else {
          final ts = _parseTs(
              e['inizio_locale'] ?? e['data_ora_inizio'] ?? e['data_ora']);
          if (ts != null) dataStr = _ymd(ts.toLocal());
        }
      }

      if (dataStr.isEmpty) continue;

      final durataSec =
          int.tryParse((e['durata_sec'] ?? e['durata'] ?? 0).toString()) ?? 0;
      final valoreMin = (durataSec ~/ 60);

      mappa[dataStr] = (mappa[dataStr] ?? 0) + valoreMin;
    }

    return giorni.map((d) => mappa[d] ?? 0).toList();
  }

  //-----------------------------------------------------------
  // Fonde segmenti contigui dello stesso livello
  //-----------------------------------------------------------
  List<Map<String, dynamic>> fuseSegments(List<Map<String, dynamic>> raw) {
    // raw = datiLivelli[livello]!
    // Assumiamo che ogni elemento abbia:
    //   data_ora_inizio, data_ora_fine, durata_sec, distanza_metri, fonte, livello
    // Ordino per inizio
    raw.sort((a, b) {
      final ai = DateTime.parse(a['data_ora_inizio']);
      final bi = DateTime.parse(b['data_ora_inizio']);
      return ai.compareTo(bi);
    });

    final fused = <Map<String, dynamic>>[];
    for (final seg in raw) {
      if (fused.isEmpty) {
        fused.add({...seg});
        continue;
      }

      final last = fused.last;

      final sameLevel = seg['livello'] == last['livello'];
      final lastEnd = DateTime.parse(last['data_ora_fine']);
      final thisStart = DateTime.parse(seg['data_ora_inizio']);
      final gapSec = thisStart.difference(lastEnd).inSeconds.abs();

      final gapOk = gapSec <= 120; // per esempio: continuità entro 2 minuti

      if (sameLevel && gapOk) {
        // allunga il blocco precedente
        last['data_ora_fine'] = seg['data_ora_fine'];
        last['durata_sec'] =
            (last['durata_sec'] ?? 0) + (seg['durata_sec'] ?? 0);
        last['distanza_metri'] =
            (last['distanza_metri'] ?? 0) + (seg['distanza_metri'] ?? 0);
        // fonte puoi tenerla dalla prima oppure mettere "mix"
      } else {
        fused.add({...seg});
      }
    }

    return fused;
  }

//-----------------------------------------------------------
// fine classe principale
//-----------------------------------------------------------
}
