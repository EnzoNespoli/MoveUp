import 'package:flutter/material.dart';
import '../lingua.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class CardReportGiornaliero extends StatelessWidget {
  final Map<String, dynamic> riepilogo0;
  final Map<String, dynamic> riepilogo1;
  final Map<String, dynamic> riepilogo2;
  final String ultimaPosizione;
  final Map<String, dynamic> features; // dall’API /utenti_livello
  final int historyDaysMax; // limits.history_days_max (o features['history_days'])
  final bool isAnonymous; // user.is_anonymous
  final String planName; // livello.nome (es. "Free"/"Plus")
  final DateTime date; // data mostrata (oggi)

  CardReportGiornaliero({
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
    final advancedEnabled = isAnonymous && !isAnonymous 
    && !isOverLimit && canAdvanced && (canExportCsv || canExportGpx);

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
                    context.t.rep_day_mes01,
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
            const SizedBox(height: 12),

            // Corpo come prima
            Text(
              '🛌 ${context.t.mov_inattivo} ${riepilogo0['durata']}',
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              '🚶 ${context.t.mov_leggero} ${riepilogo1['durata']}  '
              '${context.t.um_metri} ${riepilogo1['metri']}  '
              '${context.t.um_passi} ${riepilogo1['passi']}',
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              '🚗 ${context.t.mov_veloce} ${riepilogo2['durata']}  '
              '${context.t.um_km} ${riepilogo2['km'].toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            const Divider(),
            Text(
              '${context.t.rep_day_mes02}: $ultimaPosizione',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),

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
                  r0: riepilogo0,
                  r1: riepilogo1,
                  r2: riepilogo2,
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
    csv.writeln('Tipo,Durata,Metri,Passi,KM');
    csv.writeln('Inattivo,${riepilogo0['durata']},,,');
    csv.writeln(
        'Leggero,${riepilogo1['durata']},${riepilogo1['metri']},${riepilogo1['passi']},');
    csv.writeln(
        'Veloce,${riepilogo2['durata']},,,${riepilogo2['km'].toStringAsFixed(2)}');

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
                      style: const TextStyle(
                          fontSize: 24, color: Colors.white70)),
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
                  '🚗 Veloce • ${r2['durata']}   Km: ${ (r2['km'] as num).toStringAsFixed(2) }',
                  style: const TextStyle(fontSize: 36, height: 1.3)),
              const Spacer(),
              // Ultima posizione
              Text('Ultima posizione: $ultimaPosizione',
                  style:
                      const TextStyle(fontSize: 26, color: Colors.white70)),
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
