import 'package:fl_chart/fl_chart.dart';

class OraStat {
  final int ora;       // 0..23
  final int l0, l1, l2;
  OraStat(this.ora, this.l0, this.l1, this.l2);
}

List<FlSpot> buildTimelineSpots(List<OraStat> datiOrari) {
  final spots = <FlSpot>[];
  int? last;
  for (final e in datiOrari) {
    final livello = e.l0 > 0 ? 0 : (e.l1 > 0 ? 1 : (e.l2 > 0 ? 2 : 0));
    if (last != null && last != livello) {
      spots.add(FlSpot(e.ora.toDouble(), last.toDouble())); // step verticale
    }
    spots.add(FlSpot(e.ora.toDouble(), livello.toDouble()));
    last = livello;
  }
  return spots;
}