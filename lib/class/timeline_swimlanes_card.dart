import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

import '../class/periodo.dart';
import 'swimlane_painter.dart';
import '../lingua.dart';

//--------------------------------------------------------------
// Widget per visualizzare la timeline a corsie
//---------------------------------------------------------------
class TimelineSwimlanesCard extends StatefulWidget {
  
  final List<Periodo> periodi;
  const TimelineSwimlanesCard({super.key, required this.periodi});

  @override
  State<TimelineSwimlanesCard> createState() => _TimelineSwimlanesCardState();
}

class _TimelineSwimlanesCardState extends State<TimelineSwimlanesCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    double _hOf(DateTime dt) => dt.hour + dt.minute / 60 + dt.second / 3600;

    const colL2 = Color(0xFF1565C0);
    final colL1 = Colors.orange;
    final colL0 = Colors.blueGrey;

    int totalL0 = 0, totalL1 = 0, totalL2 = 0;
    for (final p in widget.periodi) {
      final s = p.fine.difference(p.inizio).inSeconds;
      if (p.livello == 0) totalL0 += s;
      if (p.livello == 1) totalL1 += s;
      if (p.livello == 2) totalL2 += s;
    }

    final seg = [...widget.periodi]
      ..sort((a, b) => a.inizio.compareTo(b.inizio));

    double viewMinX = 0, viewMaxX = 24;
    if (seg.isNotEmpty) {
      final minS = seg
          .map((p) => _hOf(p.inizio))
          .fold<double>(24.0, (a, b) => a < b ? a : b);
      final maxE = seg
          .map((p) => _hOf(p.fine))
          .fold<double>(0.0, (a, b) => a > b ? a : b);
      const pad = 0.75;
      viewMinX = (minS - pad).clamp(0.0, 24.0);
      viewMaxX = (maxE + pad).clamp(viewMinX + 0.5, 24.0);
    }
    final span = viewMaxX - viewMinX;
    if (span <= 0) {
      viewMinX = 0;
      viewMaxX = 24;
    }
    final double xInterval = span <= 3 ? 0.5 : (span <= 6 ? 1 : 2);

    String _labelFor(double v) {
      if (xInterval < 1) {
        final hh = v.floor();
        var mm = ((v - hh) * 60).round();
        var H = hh;
        if (mm == 60) {
          H = hh + 1;
          mm = 0;
        }
        return mm == 0 ? '$H' : '$H:${mm.toString().padLeft(2, '0')}';
      }
      return v.toStringAsFixed(0);
    }

    final bool isToday = seg.isEmpty
        ? true
        : DateUtils.isSameDay(DateTime.now(), seg.first.inizio);
    final nowX = _hOf(DateTime.now());
    final showNow = isToday && nowX >= viewMinX && nowX <= viewMaxX;

    final key = GlobalKey();
    Future<void> _share() async {
      try {
        await WidgetsBinding.instance.endOfFrame;
        final ro = key.currentContext?.findRenderObject();
        final boundary = ro is RenderRepaintBoundary ? ro : null;
        if (boundary == null) return;
        var tries = 0;
        while (boundary.debugNeedsPaint && tries++ < 5) {
          await Future.delayed(const Duration(milliseconds: 40));
        }
        final dpr = ui.window.devicePixelRatio;
        final img =
            await boundary.toImage(pixelRatio: (dpr * 2).clamp(2.0, 4.0));
        final bd = await img.toByteData(format: ui.ImageByteFormat.png);
        if (bd == null) return;
        final dir = await getTemporaryDirectory();
        final f = File(
            '${dir.path}/move_timeline_swim_${DateTime.now().millisecondsSinceEpoch}.png');
        await f.writeAsBytes(bd.buffer.asUint8List(), flush: true);
        await Share.shareXFiles([XFile(f.path)], text: context.t.chart_mes07);
      } catch (_) {}
    }

    Widget chip(String label, int secs, Color color) {
      final m = (secs / 60).round();
      Color darken(Color c, [double a = .3]) {
        final h = HSLColor.fromColor(c);
        return h.withLightness((h.lightness - a).clamp(0.0, 1.0)).toColor();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(.35)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label ${m}m', style: TextStyle(color: darken(color))),
        ]),
      );
    }

    final baseH = 190.0;
    final height = expanded ? baseH + 110 : baseH;
    final blockH = expanded ? 18.0 : 14.0;
    final fontSz = expanded ? 12.0 : 11.0;
    final leftPad = expanded ? 56.0 : 42.0;

    return RepaintBoundary(
      key: key,
      child: Card(
        color: Colors.blueGrey[50],
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.blueGrey, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(context.t.chart_mes10,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700])),
              ),
              IconButton(
                tooltip: expanded ? context.t.fix_riduci_button : context.t.fix_espandi_button,
                icon: Icon(expanded ? Icons.fullscreen_exit : Icons.fullscreen),
                onPressed: () => setState(() => expanded = !expanded),
              ),
              const SizedBox(width: 4),
              ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: Text(context.t.condividi_button),
                onPressed: _share,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white),
              ),
            ]),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: height,
              width: double.infinity,
              child: CustomPaint(
                painter: SwimlanePainter(
                  periods: seg,
                  viewMinX: viewMinX,
                  viewMaxX: viewMaxX,
                  tickInterval: xInterval,
                  labelFor: _labelFor,
                  showNow: showNow,
                  nowX: nowX,
                  colL0: colL0,
                  colL1: colL1,
                  colL2: colL2,
                  blockHeight: blockH,
                  fontSize: fontSz,
                  leftPadding: leftPad,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              chip('L2', totalL2, colL2),
              chip('L1', totalL1, colL1),
              chip('L0', totalL0, colL0),
            ]),
            const SizedBox(height: 8),
            Text(context.t.chart_mes03,
                style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          ]),
        ),
      ),
    );
  }
}
