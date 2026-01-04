import 'package:flutter/material.dart';
import '../lingua.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../db.dart';
import '../services/locale_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class CardReportGiornaliero extends StatefulWidget {
  final Map<String, dynamic> riepilogo0;
  final Map<String, dynamic> riepilogo1;
  final Map<String, dynamic> riepilogo2;
  final String ultimaPosizione;
  final Map<String, dynamic> features; // dall’API /utenti_livello
  final int
      historyDaysMax; // limits.history_days_max (o features['history_days'])
  final bool isAnonymous; // user.is_anonymous
  final String planName; // livello.nome (es. "Free"/"Plus")
  final DateTime date; // data mostrata (oggi)
  final String utenteId; // ID utente per watermark
  final String jwtToken; // token JWT per autenticazione API

  const CardReportGiornaliero({
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
  }) : super(key: key);

  @override
  State<CardReportGiornaliero> createState() => _CardReportGiornalieroState();
}

class _CardReportGiornalieroState extends State<CardReportGiornaliero> {
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
  // Build widget
  //--------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
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
                      context.t.rep_day_mes01,
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
              const SizedBox(height: 8),

              Text(
                _giornoBreve(context, widget.date),
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
                      text: widget.riepilogo0['durata'],
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
                      text: widget.riepilogo1['durata'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            '  ${context.t.um_metri} ${widget.riepilogo1['metri']}  '),
                    //TextSpan(text: '${context.t.um_passi} ${widget.riepilogo1['passi']}'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(text: '🚗 ${context.t.mov_veloce} '),
                    TextSpan(
                      text: widget.riepilogo2['durata'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            '  ${context.t.um_km} ${widget.riepilogo2['km'].toStringAsFixed(2)}'),
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
                  const Icon(Icons.psychology,
                      color: Colors.deepPurple, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    context.t.rep_day_chiedi_AI,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
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
                      onPressed: _aiLoading
                          ? null
                          : () => _callAiApi('spiega_giornata'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[100],
                        foregroundColor: Colors.deepPurple[900],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        context.t.rep_day_button_01,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _aiLoading
                          ? null
                          : () => _callAiApi('consiglio_semplice'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[100],
                        foregroundColor: Colors.deepPurple[900],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        context.t.rep_day_button_02,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          _aiLoading ? null : () => _callAiApi('perche_fermo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[100],
                        foregroundColor: Colors.deepPurple[900],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        context.t.rep_day_button_03,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
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
                        context.t.rep_day_ai_response,
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
                            Text(context.t.rep_day_ai_loading),
                          ],
                        )
                      else if (_aiResponse.isNotEmpty)
                        Text(
                          _aiResponse,
                          style: const TextStyle(fontSize: 14),
                        )
                      else
                        Text(
                          context.t.rep_day_ai_info,
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
                    r0: widget.riepilogo0,
                    r1: widget.riepilogo1,
                    r2: widget.riepilogo2,
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
  // Restituisce una stringa breve per il giorno (es. "lun 5")
  //----------------------------------------------------------------
  String _giornoBreve(BuildContext context, DateTime d) {
    final giorni = [
      context.t.card_gio_lunedi,
      context.t.card_gio_martedi,
      context.t.card_gio_mercoledi,
      context.t.card_gio_giovedi,
      context.t.card_gio_venerdi,
      context.t.card_gio_sabato,
      context.t.card_gio_domenica,
    ];

    return '${context.t.card_gio_today} • ${giorni[d.weekday - 1]} ${d.day}';
  }

  //----------------------------------------------------------------
  // Formatta i minuti in ore e minuti
  //----------------------------------------------------------------
  String formattaMinuti(dynamic minuti) {
    final intMinuti =
        minuti is int ? minuti : int.tryParse(minuti?.toString() ?? '') ?? 0;
    final ore = intMinuti ~/ 60;
    final restantiMin = intMinuti % 60;
    return ore > 0 ? '${ore}h ${restantiMin}min' : '${restantiMin}min';
  }

  //--------------------------------------------------------------
  // ========== NUOVO: Condivisione immagine ==========
  //--------------------------------------------------------------
  Future<void> _condividi(BuildContext context) async {
    try {
      // Assicura che il frame corrente sia finito
      await WidgetsBinding.instance.endOfFrame;

      final renderObj = _captureKey.currentContext?.findRenderObject();
      final boundary = renderObj is RenderRepaintBoundary ? renderObj : null;
      if (boundary == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    context.t.chart_mes06)), // "Niente da condividere" ecc.
          );
        }
        return;
      }

      // Attendi che abbia pitturato
      var tries = 0;
      while (boundary.debugNeedsPaint && tries < 5) {
        await Future.delayed(const Duration(milliseconds: 40));
        tries++;
      }

      final dpr = MediaQuery.of(context).devicePixelRatio;
      final pixelRatio = (dpr * 2).clamp(2.0, 4.0) as double; // ← cast a double
      final img = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('toByteData null');
      }

      final bytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/move_report_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await File(filePath).writeAsBytes(bytes, flush: true);

      // Condivisione (niente variabile "result")
      try {
        await Share.shareXFiles([XFile(file.path)],
            text: '${context.t.chart_mes07} 💪');
      } catch (_) {
        // Fallback testo semplice
        await Share.share('${context.t.chart_mes09} 💪');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${context.t.cahrt_mes08} $e')), // ← typo corretto
        );
      }
    }
  }

  //--------------------------------------------------------------
  // ========== Export GPX (come prima) ==========
  //--------------------------------------------------------------
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

  //--------------------------------------------------------------
  // ========== Export CSV (come prima) ==========
  //--------------------------------------------------------------
  Future<void> _esportaCsv(BuildContext context) async {
    final csv = StringBuffer();
    csv.writeln('Tipo,Durata,Metri,Passi,KM');
    csv.writeln('Inattivo,${widget.riepilogo0['durata']},,,');
    csv.writeln(
        'Leggero,${widget.riepilogo1['durata']},${widget.riepilogo1['metri']},${widget.riepilogo1['passi']},');
    csv.writeln(
        'Veloce,${widget.riepilogo2['durata']},,,${widget.riepilogo2['km'].toStringAsFixed(2)}');

    final dir = await getTemporaryDirectory();
    final file =
        File('${dir.path}/report_${widget.date.toIso8601String()}.csv');
    await file.writeAsString(csv.toString());

    await Share.shareXFiles([XFile(file.path)], text: 'CSV esportato!');
  }
}

// Azioni del menu Avanzato
enum _AdvAction { csv, gpx }

//--------------------------------------------------------------
// ===== Poster condivisibile (semplice, brandizzabile) =====
//--------------------------------------------------------------
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

  //--------------------------------------------------------------
  // Build widget
  //--------------------------------------------------------------
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
}
