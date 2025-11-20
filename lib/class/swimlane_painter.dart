import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../class/periodo.dart';
 
// ---------------------------------------------------------------------------
// SwimlanePainter: disegna la timeline dei livelli di attività
// ---------------------------------------------------------------------------
class SwimlanePainter extends CustomPainter {
  SwimlanePainter({
    required this.periods,
    required this.viewMinX,
    required this.viewMaxX,
    required this.tickInterval,
    required this.labelFor,
    required this.showNow,
    required this.nowX,
    required this.colL0,
    required this.colL1,
    required this.colL2,
    this.blockHeight = 14,
    this.fontSize = 11,
    this.leftPadding = 42,
  });

  final List<Periodo> periods;
  final double viewMinX, viewMaxX, tickInterval;
  final String Function(double) labelFor;
  final bool showNow;
  final double nowX;
  final Color colL0, colL1, colL2;

  final double blockHeight;
  final double fontSize;
  final double leftPadding;

  double _hOf(DateTime dt) => dt.hour + dt.minute / 60 + dt.second / 3600;

  @override
  void paint(Canvas canvas, Size size) {
    // area di disegno
    const rightPad = 10.0, topPad = 6.0, bottomPad = 28.0;
    final chart = Rect.fromLTWH(
      leftPadding,
      topPad,
      (size.width - leftPadding - rightPad).clamp(0.0, size.width),
      (size.height - topPad - bottomPad).clamp(0.0, size.height),
    );
    if (chart.width <= 0 || chart.height <= 0) return;

    // helpers --------------------------------------------------------------
    double _xOfHour(double h) {
      final t = ((h - viewMinX) / (viewMaxX - viewMinX)).clamp(0.0, 1.0);
      return chart.left + chart.width * t;
    }

    final laneH = chart.height / 3.0;
    final yL2 = chart.top + laneH * 0.5;
    final yL1 = chart.top + laneH * 1.5;
    final yL0 = chart.top + laneH * 2.5;
    final yOff = chart.bottom - 6;

    void drawText(Offset p, String s, {Color color = Colors.black54}) {
      final tp = TextPainter(
        text: TextSpan(
            text: s, style: TextStyle(fontSize: fontSize, color: color)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, p);
    }

    void drawYLabel(double cy, String s, Color c) {
      final tp = TextPainter(
        text: TextSpan(text: s, style: TextStyle(fontSize: fontSize, color: c)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPadding - 8 - tp.width, cy - tp.height / 2));
    }

    RRect block(double sx, double ex, double cy, Color col) {
      // Garantiamo almeno un “pelo” di ampiezza se sx≈ex
      final x1 = _xOfHour(sx);
      final x2 = math.max(_xOfHour(ex), _xOfHour(sx) + 1.5);
      return RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset((x1 + x2) / 2, cy),
          width: (x2 - x1),
          height: blockHeight,
        ),
        const Radius.circular(6),
      );
    }

    // sfondo corsie leggere
    final laneBgPaint = Paint()..color = Colors.black12.withOpacity(0.04);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(chart.center.dx, yL2),
              width: chart.width,
              height: laneH),
          const Radius.circular(4),
        ),
        laneBgPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(chart.center.dx, yL1),
              width: chart.width,
              height: laneH),
          const Radius.circular(4),
        ),
        laneBgPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(chart.center.dx, yL0),
              width: chart.width,
              height: laneH),
          const Radius.circular(4),
        ),
        laneBgPaint);

    // griglia verticale + etichette X
    final grid = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..strokeWidth = 1;

    final startTick = (viewMinX / tickInterval).ceil() * tickInterval;
    for (double h = startTick; h <= viewMaxX + 1e-6; h += tickInterval) {
      final x = _xOfHour(h);
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), grid);

      final s = labelFor(h);
      final tp = TextPainter(
        text: TextSpan(
            text: s,
            style: TextStyle(fontSize: fontSize, color: Colors.black54)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chart.bottom + 4));
    }

    // etichette Y
    drawYLabel(yL2, 'L2', const Color(0xFF1565C0));
    drawYLabel(yL1, 'L1', Colors.orange);
    drawYLabel(yL0, 'L0', Colors.blueGrey);
    drawYLabel(yOff, 'OFF', Colors.grey);

    // OFF baseline
    final offPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeCap = StrokeCap.round
      ..strokeWidth = blockHeight / 2.5;
    canvas.drawLine(
        Offset(chart.left, yOff), Offset(chart.right, yOff), offPaint);

    // blocchi livelli
    final pL2 = Paint()..color = colL2.withOpacity(.90);
    final pL1 = Paint()..color = colL1.withOpacity(.90);
    final pL0 = Paint()..color = colL0.withOpacity(.90);
    final pOff = Paint()..color = Colors.grey.withOpacity(.8);

    for (final p in periods) {
      final sx = _hOf(p.inizio);
      final ex = _hOf(p.fine);
      if (ex <= viewMinX || sx >= viewMaxX) continue; // completamente fuori
      final sxc = sx.clamp(viewMinX, viewMaxX);
      final exc = ex.clamp(viewMinX, viewMaxX);

      switch (p.livello) {
        case 2:
          canvas.drawRRect(block(sxc, exc, yL2, colL2), pL2);
          break;
        case 1:
          canvas.drawRRect(block(sxc, exc, yL1, colL1), pL1);
          break;
        case 0:
          canvas.drawRRect(block(sxc, exc, yL0, colL0), pL0);
          break;
        default:
          // se arriva un OFF esplicito
          canvas.drawRRect(block(sxc, exc, yOff, Colors.grey), pOff);
      }
    }

    // linea "adesso" (tratteggiata)
    if (showNow) {
      final x = _xOfHour(nowX);
      final dashPaint = Paint()
        ..color = Colors.blueGrey.withOpacity(.8)
        ..strokeWidth = 2;

      const dash = 6.0, gap = 4.0;
      double y = chart.top;
      while (y < chart.bottom) {
        final y2 = math.min(y + dash, chart.bottom);
        canvas.drawLine(Offset(x, y), Offset(x, y2), dashPaint);
        y += dash + gap;
      }
    }

    // bordo esterno del riquadro
    final border = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(chart, border);
  }

  @override
  bool shouldRepaint(covariant SwimlanePainter old) =>
      old.periods != periods ||
      old.viewMinX != viewMinX ||
      old.viewMaxX != viewMaxX ||
      old.tickInterval != tickInterval ||
      old.showNow != showNow ||
      old.nowX != nowX ||
      old.colL0 != colL0 ||
      old.colL1 != colL1 ||
      old.colL2 != colL2 ||
      old.blockHeight != blockHeight ||
      old.fontSize != fontSize ||
      old.leftPadding != leftPadding;
}
