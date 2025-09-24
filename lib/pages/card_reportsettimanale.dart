import 'package:flutter/material.dart';
import '../lingua.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class CardReportSettimanale extends StatelessWidget {
  final List<dynamic> riepilogo0;
  final List<dynamic> riepilogo1;
  final List<dynamic> riepilogo2;
  final String ultimaPosizione;
  final Map<String, dynamic> features; // dall’API /utenti_livello
  final int
      historyDaysMax; // limits.history_days_max (o features['history_days'])
  final bool isAnonymous; // user.is_anonymous
  final String planName; // livello.nome (es. "Free"/"Plus")
  final DateTime date; // data mostrata (oggi)

  CardReportSettimanale({
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
  }) : super(key: key);

  // Key per catturare l'immagine della card "poster" offstage
  final GlobalKey _shareKey = GlobalKey();
  final GlobalKey _captureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final canExportGpx = features['export_gpx'] == true;
    final canExportCsv = features['export_csv'] == true;
    final canAdvanced = features['report_advanced'] == true;

    // opzionale: blocca se data oltre il limite
    final isOverLimit = DateTime.now().difference(date).inDays > historyDaysMax;

    // Condivisione immagine: consentita solo a registrati e entro limite (come concordato)
    final shareEnabled = !isAnonymous && !isOverLimit;

    // Esportazioni tecniche: come prima
    final gpxEnabled = !isAnonymous && canExportGpx && !isOverLimit;
    final csvEnabled = !isAnonymous && canExportCsv && !isOverLimit;

    // Mostra il menu "Avanzato" solo se il piano lo prevede e c'è almeno un export possibile
    // forzato per non vedere dopo togliere isAnonymous &&
    final advancedEnabled = isAnonymous &&
        !isAnonymous &&
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
          side: const BorderSide(color: Colors.blueGrey, width: 2),
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
                        color: Colors.blue[700],
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
                _settimanaBreve(context, date),
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
        text: '${totaliLivello(riepilogo0, 0)['durata']}',
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
        text: '${totaliLivello(riepilogo1, 1)['durata']}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: '  ${context.t.um_metri} ${totaliLivello(riepilogo1, 1)['metri']}  '),
      TextSpan(text: '${context.t.um_passi} ${totaliLivello(riepilogo1, 1)['passi']}'),
    ],
  ),
),
RichText(
  text: TextSpan(
    style: const TextStyle(fontSize: 15, color: Colors.black),
    children: [
      TextSpan(text: '🚗 ${context.t.mov_veloce} '),
      TextSpan(
        text: '${totaliLivello(riepilogo2, 2)['durata']}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: '  ${context.t.um_km} ${totaliLivello(riepilogo2, 2)['km'].toStringAsFixed(2)}'),
    ],
  ),
),
              const SizedBox(height: 8),
              const Divider(),

              // Messaggio export come prima (resta per CSV/GPX)
              if (!gpxEnabled || !csvEnabled)
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

              // --- Versione "poster" OFFSTAGE per la condivisione immagine ---
              Offstage(
                offstage: true,
                child: RepaintBoundary(
                  key: _shareKey,
                  child: _ShareCardPoster(
                    titolo: context.t.rep_day_mes01,
                    data: date,
                    r0: totaliLivello(riepilogo0, 0),
                    r1: totaliLivello(riepilogo1, 1),
                    r2: totaliLivello(riepilogo2, 2),
                    ultimaPosizione: ultimaPosizione,
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
      <trkpt lat="45.0" lon="9.0"><time>${date.toIso8601String()}</time></trkpt>
    </trkseg>
  </trk>
</gpx>
''';

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/report_${date.toIso8601String()}.gpx');
    await file.writeAsString(gpx);

    await Share.shareXFiles([XFile(file.path)], text: 'GPX esportato!');
  }

  // ========== Export CSV (come prima) ==========
  Future<void> _esportaCsv(BuildContext context) async {
    final csv = StringBuffer();
    final r0 = totaliLivello(riepilogo0, 0);
    final r1 = totaliLivello(riepilogo1, 1);
    final r2 = totaliLivello(riepilogo2, 2);
    csv.writeln('Tipo,Durata,Metri,Passi,KM');
    csv.writeln('Inattivo,${r0['durata']},,,');
    csv.writeln('Leggero,${r1['durata']},${r1['metri']},${r1['passi']},');
    csv.writeln('Veloce,${r2['durata']},,,${r2['km'].toStringAsFixed(2)}');

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/report_${date.toIso8601String()}.csv');
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
}


final _nfIt = NumberFormat("#,##0.##", "it_IT");        // 0 → "0", 2.6 → "2,6", 77.82 → "77,82"
String fmtNum(num x, {int? fixed}) =>
    fixed != null ? _nfIt.format(num.parse(x.toStringAsFixed(fixed))) : _nfIt.format(x);

String fmtDistanzaM(num metri) {
  return fmtNum(metri, fixed: 1);
}