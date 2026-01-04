import 'package:flutter/material.dart';
import '../lingua.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../db.dart';
import '../services/locale_controller.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class CardReportSettimanale extends StatefulWidget {
  final List<dynamic> riepilogo0;
  final List<dynamic> riepilogo1;
  final List<dynamic> riepilogo2;
  final String ultimaPosizione;
  final Map<String, dynamic> features; // dall'API /utenti_livello
  final int
      historyDaysMax; // limits.history_days_max (o features['history_days'])
  final bool isAnonymous; // user.is_anonymous
  final String planName; // livello.nome (es. "Free"/"Plus")
  final DateTime date; // data mostrata (oggi)
  final String utenteId; // ID utente
  final String jwtToken; // token JWT
  final List<Map<String, dynamic>> repeatRoutes;
  final Map<String, dynamic>? costiWeek;

  const CardReportSettimanale({
    Key? key,
    required this.riepilogo0,
    required this.riepilogo1,
    required this.riepilogo2,
    required this.ultimaPosizione,
    required this.features,
    required this.historyDaysMax,
    required this.isAnonymous,
    required this.planName,
    required this.date,
    required this.utenteId,
    required this.jwtToken,
    required this.repeatRoutes,
    this.costiWeek,
  }) : super(key: key);

  @override
  State<CardReportSettimanale> createState() => _CardReportSettimanaleState();
}

class _CardReportSettimanaleState extends State<CardReportSettimanale> {
  // Key per catturare l'immagine della card "poster" offstage
  final GlobalKey _shareKey = GlobalKey();
  final GlobalKey _captureKey = GlobalKey();

  // Stato per AI
  bool _aiLoading = false;
  String _aiResponse = '';
  String _aiStatus = 'info'; // info | ok | blocked | error
  String _aiQuota = ''; // es: "2/3 • restano 1"

  //--------------------------------------------------------------
  // Metodo per chiamare l'API AI
  //--------------------------------------------------------------
  Future<void> _callAiApi(String requestType) async {
    if (_aiLoading) return;

    setState(() {
      _aiLoading = true;
      _aiResponse = '';
      _aiQuota = '';
      _aiStatus = 'info';
    });

    try {
      final day = widget.date.toIso8601String().split('T')[0];
      final uri = Uri.parse(
        '$apiBaseUrl/ai_one.php?utente_id=${widget.utenteId}&lang=${LocaleController.instance.locale?.languageCode ?? 'it'}',
      );

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${widget.jwtToken}',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: json.encode({
          'intent': requestType,
          'date': day,
        }),
      );

      Map<String, dynamic> data;
      try {
        data = json.decode(response.body) as Map<String, dynamic>;
      } catch (_) {
        setState(() {
          _aiStatus = 'error';
          _aiResponse = 'Error server response.';
        });
        return;
      }

      // Gestione HTTP non 200
      if (response.statusCode != 200) {
        final err = (data['error'] ?? 'Error server (${response.statusCode})')
            .toString();
        setState(() {
          _aiStatus = 'error';
          _aiResponse = err;
        });
        return;
      }

      // ✅ OK - controlla sia booleano che valore truthy
      final isOk =
          data['ok'] == true || data['ok'] == 1 || data['ok'] == 'true';
      if (isOk) {
        final reply = (data['reply'] ?? '').toString().trim();

        final used = data['used'];
        final max = data['max'];
        final remaining = data['remaining'];

        setState(() {
          _aiStatus = 'ok';
          _aiResponse =
              reply.isNotEmpty ? reply : context.t.rep_day_ai_error_01;

          if (used != null && max != null && remaining != null) {
            _aiQuota =
                '$used/$max • ${context.t.rep_day_ai_error_02} $remaining';
          } else {
            _aiQuota = '';
          }
        });
        return;
      }

      // 🔒 BLOCCATO - controlla sia booleano che valore truthy
      final isBlocked = data['blocked'] == true ||
          data['blocked'] == 1 ||
          data['blocked'] == 'true';
      if (isBlocked) {
        final reason = (data['reason'] ?? '').toString();
        String msg;

        switch (reason) {
          case 'ai_non_disponibile_su_piano':
            msg = context.t.rep_day_ai_error_03;
            break;
          case 'limite_giornaliero':
            msg = context.t.rep_day_ai_limit;
            break;
          case 'consenso_ai_mancante':
            msg = context.t.rep_day_ai_error_04;
            break;
          default:
            msg = context.t.rep_day_ai_error_05;
        }

        // opzionale: mostra quota se presente
        final used = data['used'];
        final max = data['max'];
        String quota = '';
        if (used != null && max != null) {
          quota = '$used/$max';
        }

        setState(() {
          _aiStatus = 'blocked';
          _aiResponse = quota.isNotEmpty ? '$msg ($quota)' : msg;
          _aiQuota = '';
        });
        return;
      }

      // ❌ 200 ma formato inatteso
      setState(() {
        _aiStatus = 'error';
        _aiResponse = 'Error server response format.';
      });
    } catch (e) {
      setState(() {
        _aiStatus = 'error';
        _aiResponse = 'Error: $e';
      });
    } finally {
      setState(() {
        _aiLoading = false;
      });
    }
  }

  //--------------------------------------------------------------
  // Metodo alternativo per generare l'insight settimanale localmente
  //--------------------------------------------------------------
  Future<void> _onWeeklyInsightPressed() async {
    if (_aiLoading) return;

    setState(() {
      _aiLoading = true;
      _aiResponse = '';
      _aiStatus = 'info';
    });

    try {
      // 👇 micro delay per far percepire l’analisi (e far renderizzare lo spinner)
      await Future.delayed(const Duration(milliseconds: 600));

      // widget.repeatRoutes è la lista che stai già passando
      final routes = widget.repeatRoutes ?? [];

      String frase;
      if (routes.isEmpty) {
        frase = context.t.rep_week_insight_empty;
      } else {
        final top = routes.first;
        final count = top['count'] ?? 0;
        final days = (top['days'] as List?)?.join(', ') ?? '';

        if (count >= 3) {
          frase = context.t.rep_week_insight_01(count, days);
        } else {
          frase = context.t.rep_week_insight_02(count, days);
        }
      }

      setState(() {
        _aiResponse = frase;
        _aiStatus = 'ok';
      });
    } finally {
      setState(() {
        _aiLoading = false;
      });
    }
  }

  //--------------------------------------------------------------
  // Build widget
  //--------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final top =
        widget.repeatRoutes.isNotEmpty ? widget.repeatRoutes.first : null;

    final int topCount =
        (top != null && top['count'] is int) ? top['count'] as int : 0;

    final List<String> topDays = (top != null && top['days'] is List)
        ? (top['days'] as List).map((e) => e.toString()).toList()
        : const [];

    final canExportGpx = widget.features['export_gpx'] == true;
    final canExportCsv = widget.features['export_csv'] == true;
    final canAdvanced = widget.features['report_advanced'] == true;
    final aiEnabled = widget.features['ai_enabled'] == true;

    // opzionale: blocca se data oltre il limite
    final isOverLimit =
        DateTime.now().difference(widget.date).inDays > widget.historyDaysMax;

    // Condivisione immagine: consentita solo a registrati e entro limite (come concordato)
    final shareEnabled = !widget.isAnonymous && !isOverLimit;

    // Esportazioni tecniche: come prima
    final gpxEnabled = !widget.isAnonymous && canExportGpx && !isOverLimit;
    final csvEnabled = !widget.isAnonymous && canExportCsv && !isOverLimit;

    // Mostra il menu "Avanzato" solo se il piano lo prevede e c'è almeno un export possibile
    // forzato per non vedere dopo togliere isAnonymous &&
    final advancedEnabled = widget.isAnonymous &&
        !widget.isAnonymous &&
        !isOverLimit &&
        canAdvanced &&
        (canExportCsv || canExportGpx);

    final costi = widget.costiWeek;
    final kmVeloce = (costi?['km_veloce'] as num?)?.toDouble() ?? 0.0;
    final eurVeloce = (costi?['eur_veloce'] as num?)?.toDouble() ?? 0.0;
    final eurKm = (costi?['eur_km'] as num?)?.toDouble() ?? 0.20;

    return RepaintBoundary(
      key: _captureKey,
      child: Card(
        color: Colors.blueGrey[50],
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.blueGrey, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con titolo e pulsanti
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.today, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.t.form_crono_04,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // ---- Nuovo pulsante CONDIVIDI ----
                  ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    label: Text(context.t.condividi_button),
                    onPressed: shareEnabled ? () => _condividi(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ---- Menu AVANZATO (CSV/GPX) ----
                  if (advancedEnabled)
                    PopupMenuButton<_AdvAction>(
                      tooltip: 'Avanzato',
                      itemBuilder: (ctx) => [
                        if (csvEnabled)
                          const PopupMenuItem(
                            value: _AdvAction.csv,
                            child: Text('Export CSV'),
                          ),
                        if (gpxEnabled)
                          const PopupMenuItem(
                            value: _AdvAction.gpx,
                            child: Text('Export GPX'),
                          ),
                      ],
                      onSelected: (action) {
                        if (action == _AdvAction.csv && csvEnabled) {
                          _esportaCsv(context);
                        } else if (action == _AdvAction.gpx && gpxEnabled) {
                          _esportaGpx(context);
                        }
                      },
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.more_vert),
                        label: const Text('Avanzato'),
                        onPressed: null, // il tap è gestito dal PopupMenuButton
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              Text(
                _settimanaBreve(context, widget.date),
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),

              const Divider(),
              const SizedBox(height: 8),

              // Corpo come prima
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(text: '🛌 ${context.t.mov_inattivo} '),
                    TextSpan(
                      text: '${totaliLivello(widget.riepilogo0, 0)['durata']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(text: '🚶 ${context.t.mov_leggero} '),
                    TextSpan(
                      text: '${totaliLivello(widget.riepilogo1, 1)['durata']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            '  ${context.t.um_metri} ${totaliLivello(widget.riepilogo1, 1)['metri']}  '),
                    //TextSpan(text: '${context.t.um_passi} ${totaliLivello(widget.riepilogo1, 1)['passi']}'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(text: '🚗 ${context.t.mov_veloce} '),
                    TextSpan(
                      text: '${totaliLivello(widget.riepilogo2, 2)['durata']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            '  ${context.t.um_km} ${totaliLivello(widget.riepilogo2, 2)['km'].toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),

              // Messaggio export come prima (resta per CSV/GPX)
              if (!shareEnabled)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      context.t.rep_day_export_locked,
                      style: TextStyle(color: Colors.red[700], fontSize: 13),
                    ),
                  ),
                ),

              // ========== SEZIONE AI ==========
              const Divider(height: 24),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined, // icona preview
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.t.rep_week_insight_03,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Messaggio se AI non abilitata
              if (!aiEnabled)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      context.t.rep_day_function_ai,
                      style: TextStyle(color: Colors.red[700], fontSize: 13),
                    ),
                  ),
                ),

              // Tre pulsanti con richieste fisse (solo se AI abilitata)
              if (aiEnabled)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _aiLoading ? null : () => _onWeeklyInsightPressed(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[100],
                        foregroundColor: Colors.deepPurple[900],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        context.t.rep_week_insight_04,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),

              //------------------------------------------------
              // sezione costi (solo se presenti)
              //--------------------------------------------------
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.costi_impatto,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.deepPurple[900],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Se non è ancora arrivato il dato
                    if (widget.costiWeek == null)
                      Text(
                        context.t.costi_calcolo,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      )
                    else if (kmVeloce <= 0.0)
                      Text(
                        context.t.costi_nessuno,
                        style: const TextStyle(fontSize: 14),
                      )
                    else
                      Text(
                        "${context.t.costi_spostamenti} €${eurVeloce.toStringAsFixed(2)} (≈ ${kmVeloce.toStringAsFixed(1)} km)",
                        style: const TextStyle(fontSize: 14),
                      ),

                    const SizedBox(height: 6),
                    Text(
                      "${context.t.costi_stima} €${eurKm.toStringAsFixed(2)}/km. ${context.t.costi_escluso}.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Area risposta AI (solo se AI abilitata)
              if (aiEnabled) const SizedBox(height: 12),
              if (aiEnabled)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.rep_week_insight_05,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.deepPurple[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_aiLoading)
                        Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(context.t.rep_week_insight_06),
                          ],
                        )
                      else if (_aiResponse.isNotEmpty)
                        Text(
                          _aiResponse,
                          style: const TextStyle(fontSize: 14),
                        )
                      else
                        Text(
                          context.t.rep_week_insight_07,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),

              // --- Versione "poster" OFFSTAGE per la condivisione immagine ---
              Offstage(
                offstage: true,
                child: RepaintBoundary(
                  key: _shareKey,
                  child: _ShareCardPoster(
                    titolo: context.t.rep_day_mes01,
                    data: widget.date,
                    r0: totaliLivello(widget.riepilogo0, 0),
                    r1: totaliLivello(widget.riepilogo1, 1),
                    r2: totaliLivello(widget.riepilogo2, 2),
                    ultimaPosizione: widget.ultimaPosizione,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------
  // Restituisce una stringa per il period di una settimana
  //----------------------------------------------------------------
  String _settimanaBreve(BuildContext context, DateTime d) {
    final primoGiorno = d.subtract(const Duration(days: 6));
    final ultimoGiorno = d;
    String format(DateTime dt) =>
        '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}';
    return '${context.t.card_settimana} • ${format(primoGiorno)} • ${format(ultimoGiorno)}';
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
      'metri': fmtDistanzaM(metriTot),
      'km': (metriTot / 1000),
      'passi': livello == 1 ? (metriTot / 0.7).round() : null,
    };
  }

  //----------------------------------------------------------------
  // Formatta i minuti in ore e minuti
  //----------------------------------------------------------------
  String formattaMinuti(int minuti) {
    final ore = minuti ~/ 60;
    final restantiMin = minuti % 60;
    return ore > 0 ? '${ore}h ${restantiMin}min' : '${restantiMin}min';
  }

  //--------------------------------------------------------------
  // ========== NUOVO: Condivisione immagine ==========
  //--------------------------------------------------------------
  Future<void> _condividi(BuildContext context) async {
    try {
      // assicura che il frame corrente sia completato
      await WidgetsBinding.instance.endOfFrame;

      final renderObj = _captureKey.currentContext?.findRenderObject();
      final boundary = renderObj is RenderRepaintBoundary ? renderObj : null;
      if (boundary == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.t.chart_mes06)),
          );
        }
        return;
      }

      // piccolo retry se non è ancora pitturato
      var tries = 0;
      while (boundary.debugNeedsPaint && tries < 5) {
        await Future.delayed(const Duration(milliseconds: 40));
        tries++;
      }

      final dpr = MediaQuery.of(context).devicePixelRatio;
      final img = await boundary.toImage(pixelRatio: (dpr * 2).clamp(2.0, 4.0));
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('toByteData null');
      }

      final bytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/move_report_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File(filePath).writeAsBytes(bytes, flush: true);

      // Condividi senza affidarti a un "result" interno
      try {
        await Share.shareXFiles([XFile(file.path)],
            text: '${context.t.chart_mes07} 💪');
      } catch (e) {
        // Fallback: se shareXFiles dovesse dare problemi su alcuni device/ROM
        await Share.share('${context.t.chart_mes09} 💪');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.t.cahrt_mes08} $e')),
        );
      }
    }
  }

  // ========== Export GPX (come prima) ==========
  Future<void> _esportaGpx(BuildContext context) async {
    final gpx = '''
<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="MoveApp">
  <trk>
    <name>Report Giornaliero</name>
    <trkseg>
      <trkpt lat="45.0" lon="9.0"><time>${widget.date.toIso8601String()}</time></trkpt>
    </trkseg>
  </trk>
</gpx>
''';

    final dir = await getTemporaryDirectory();
    final file =
        File('${dir.path}/report_${widget.date.toIso8601String()}.gpx');
    await file.writeAsString(gpx);

    await Share.shareXFiles([XFile(file.path)], text: 'GPX esportato!');
  }

  // ========== Export CSV (come prima) ==========
  Future<void> _esportaCsv(BuildContext context) async {
    final csv = StringBuffer();
    final r0 = totaliLivello(widget.riepilogo0, 0);
    final r1 = totaliLivello(widget.riepilogo1, 1);
    final r2 = totaliLivello(widget.riepilogo2, 2);
    csv.writeln('Tipo,Durata,Metri,Passi,KM');
    csv.writeln('Inattivo,${r0['durata']},,,');
    csv.writeln('Leggero,${r1['durata']},${r1['metri']},${r1['passi']},');
    csv.writeln('Veloce,${r2['durata']},,,${r2['km'].toStringAsFixed(2)}');

    final dir = await getTemporaryDirectory();
    final file =
        File('${dir.path}/report_${widget.date.toIso8601String()}.csv');
    await file.writeAsString(csv.toString());

    await Share.shareXFiles([XFile(file.path)], text: 'CSV esportato!');
  }
}

// Azioni del menu Avanzato
enum _AdvAction { csv, gpx }

// ===== Poster condivisibile (semplice, brandizzabile) =====
class _ShareCardPoster extends StatelessWidget {
  final String titolo;
  final DateTime data;
  final Map<String, dynamic> r0, r1, r2;
  final String ultimaPosizione;

  const _ShareCardPoster({
    Key? key,
    required this.titolo,
    required this.data,
    required this.r0,
    required this.r1,
    required this.r2,
    required this.ultimaPosizione,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formato quadrato 1080x1080 pensato per chat/social
    const double w = 1080;
    const double h = 1080;

    // Formattazione data breve
    final dataStr =
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

    return Material(
      color: Colors.transparent,
      child: Container(
        width: w,
        height: h,
        padding: const EdgeInsets.all(48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0EA5E9), Color(0xFF111827)],
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: logo/titolo + data
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: const [
                    Icon(Icons.directions_run, size: 44, color: Colors.white),
                    SizedBox(width: 12),
                    Text('MOVE',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w800)),
                  ]),
                  Text(dataStr,
                      style:
                          const TextStyle(fontSize: 24, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 24),
              Text(titolo,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w700)),
              const Spacer(),
              // Dati
              Text('🛌 Inattivo • ${r0['durata']}',
                  style: const TextStyle(fontSize: 36, height: 1.3)),
              const SizedBox(height: 4),
              Text(
                  '🚶 Leggero • ${r1['durata']}   Metri: ${r1['metri']}   Passi: ${r1['passi']}',
                  style: const TextStyle(fontSize: 36, height: 1.3)),
              const SizedBox(height: 4),
              Text(
                  '🚗 Veloce • ${r2['durata']}   Km: ${(r2['km'] as num).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 36, height: 1.3)),
              const Spacer(),
              // Ultima posizione
              Text('Ultima posizione: $ultimaPosizione',
                  style: const TextStyle(fontSize: 26, color: Colors.white70)),
              const SizedBox(height: 12),
              // Footer/watermark
              const Text('Condiviso con MOVE • mytrak.app',
                  style: TextStyle(fontSize: 22, color: Colors.white60)),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDays(List<dynamic> days) {
    // days = ["2025-12-23","2025-12-24","2025-12-26"]
    // per ora li lasciamo così; poi li renderemo "23, 24, 26 dic"
    return days.map((e) => e.toString()).join(', ');
  }

  String buildWeeklyRoutesInsight(List<Map<String, dynamic>> repeatRoutes) {
    if (repeatRoutes.isEmpty) {
      return "Questa settimana non emergono percorsi ricorrenti. Continua a usare il tracking: appena si forma una routine, te la segnalo qui.";
    }

    final top = repeatRoutes.first;
    final count = (top['count'] ?? 0) as int;
    final days = (top['days'] as List? ?? const []);

    if (count >= 4) {
      return "Ho notato un percorso molto ricorrente: $count volte questa settimana (${_fmtDays(days)}). Sembra una routine stabile.";
    } else if (count == 3) {
      return "Hai ripetuto lo stesso percorso in 3 giorni (${_fmtDays(days)}). Probabile abitudine (lavoro/scuola/attività fissa).";
    } else {
      // count == 2
      return "Un percorso è comparso 2 volte questa settimana (${_fmtDays(days)}). Potrebbe essere una routine che sta iniziando.";
    }
  }
}

final _nfIt =
    NumberFormat("#,##0.##", "it_IT"); // 0 → "0", 2.6 → "2,6", 77.82 → "77,82"
String fmtNum(num x, {int? fixed}) => fixed != null
    ? _nfIt.format(num.parse(x.toStringAsFixed(fixed)))
    : _nfIt.format(x);

String fmtDistanzaM(num metri) {
  return fmtNum(metri, fixed: 1);
}
