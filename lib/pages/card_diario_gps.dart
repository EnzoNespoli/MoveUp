// card_diario_gps.dart
import 'package:flutter/material.dart';
import 'gps_log.dart';
import 'package:intl/intl.dart'; // aggiungi intl ^0.19.x a pubspec
import '../lingua.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class CardDiarioGps extends StatelessWidget {
  const CardDiarioGps({super.key});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('HH:mm:ss');

    IconData _icon(GpsLogStatus s) {
      switch (s) {
        case GpsLogStatus.queued:
          return Icons.schedule;
        case GpsLogStatus.flushed:
          return Icons.cloud_upload;
        case GpsLogStatus.saved:
          return Icons.check_circle;
        case GpsLogStatus.error:
          return Icons.error_outline;
        case GpsLogStatus.info:
          return Icons.info_outline;
      }
    }

    Color _color(BuildContext ctx, GpsLogStatus s) {
      switch (s) {
        case GpsLogStatus.queued:
          return Colors.blueGrey;
        case GpsLogStatus.flushed:
          return Colors.blue;
        case GpsLogStatus.saved:
          return Colors.green;
        case GpsLogStatus.error:
          return Colors.red;
        case GpsLogStatus.info:
          return Colors.orange;
      }
    }

    String _title(GpsLogEntry e) {
      if (e.lat != null && e.lon != null) {
        final acc = e.accM != null ? '±${e.accM!.toStringAsFixed(0)}m' : '';
        return '${e.lat!.toStringAsFixed(5)}, ${e.lon!.toStringAsFixed(5)} $acc';
      }
      return e.msg;
    }

    String _subtitle(GpsLogEntry e, DateFormat f) {
      final t = f.format(e.ts);
      if (e.status == GpsLogStatus.error) return '[$t] ${e.msg}';
      final alt = e.altM != null ? 'alt ${e.altM!.toStringAsFixed(0)}m' : '';
      return '[$t] ${e.msg}${alt.isNotEmpty ? ' · $alt' : ''}';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueGrey, width: 1),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Text(context.t.gps_err19),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Copy log',
              icon: const Icon(Icons.copy),
              onPressed: () async {
                final text =
                    GpsLog.instance.exportText(maxLines: 2000); // metti limite
                await Clipboard.setData(ClipboardData(text: text));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Log copiato negli appunti')),
                  );
                }
              },
            ),
            IconButton(
              tooltip: 'Share log',
              icon: const Icon(Icons.ios_share),
              onPressed: () async {
                final text = GpsLog.instance.exportText(maxLines: 3000);

                final dir = await getTemporaryDirectory();
                final ts = DateTime.now()
                    .toUtc()
                    .toIso8601String()
                    .replaceAll(':', '-');
                final file = File('${dir.path}/moveup_gpslog_$ts.txt');
                await file.writeAsString(text, flush: true);

                await Share.shareXFiles(
                  [XFile(file.path)],
                  text: 'MoveUP GPS log (UTC)',
                );
              },
            ),
            IconButton(
              tooltip: 'Clear log',
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => GpsLog.instance.clear(),
            ),
          ],
        ),
        children: [
          // altezza fissa per scrollare dentro la card
          SizedBox(
            height: 240,
            child: StreamBuilder<List<GpsLogEntry>>(
              stream: GpsLog.instance.stream,
              initialData: GpsLog.instance.current,
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <GpsLogEntry>[];
                if (items.isEmpty) {
                  return Center(
                    child: Text(context.t.gps_err20),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final e = items[i];
                    return ListTile(
                      dense: true,
                      leading:
                          Icon(_icon(e.status), color: _color(ctx, e.status)),
                      title: Text(
                        _title(e),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _color(ctx, e.status),
                        ),
                      ),
                      subtitle: Text(_subtitle(e, df)),
                      onLongPress: () {
                        // copia coordinata rapida
                        final text = '${e.lat},${e.lon}';
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(content: Text('Copy : $text')),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
