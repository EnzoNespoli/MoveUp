import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompareWeeksChart extends StatelessWidget {
  final List<int> weekA; // 7 valori minuti (lun..dom)
  final List<int> weekB; // 7 valori minuti (lun..dom)
  final String labelA;
  final String labelB;
  final double height;
  final Color colorA;
  final Color colorB;
  final void Function(int dayIndex)? onBarTap;

  const CompareWeeksChart({
    super.key,
    required this.weekA,
    required this.weekB,
    this.labelA = 'This week',
    this.labelB = 'Last week',
    this.height = 220,
    this.colorA = Colors.blue,
    this.colorB = Colors.orange,
    this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
    assert(weekA.length == 7 && weekB.length == 7);
    final maxVal = [
      ...weekA,
      ...weekB,
      10, // minimo scala
    ].fold<int>(0, (a, b) => a > b ? a : b);
    final yMax = (maxVal * 1.3).ceilToDouble().clamp(10.0, double.infinity);

    const labels = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

    return SizedBox(
      height: height,
      child: Column(
        children: [
          // legenda + totali (wrap/fit per evitare overflow)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                children: [
                  // legenda che va a capo se lo spazio è poco
                  Expanded(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _legendDot(colorA, labelA, fontSize: 12),
                        _legendDot(colorB, labelB, fontSize: 12),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // totale: limitato e ridimensionabile per non far esplodere la riga
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.38),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Tot: ${weekA.reduce((a,b)=>a+b)}m / ${weekB.reduce((a,b)=>a+b)}m',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: yMax,
                barGroups: List.generate(7, (i) {
                  final a = weekA[i].toDouble();
                  final b = weekB[i].toDouble();
                  return BarChartGroupData(
                    x: i,
                    barsSpace: 6,
                    barRods: [
                      BarChartRodData(toY: a, width: 6, color: colorA),
                      BarChartRodData(toY: b, width: 6, color: colorB),
                    ],
                  );
                }),
                groupsSpace: 12,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30, // meno spazio per le y
                      getTitlesWidget: (val, meta) {
                        return Text(val.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.black54));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, meta) {
                        final idx = v.toInt().clamp(0,6);
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(labels[idx], style: const TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final val = rod.toY.toInt();
                      final lbl = rodIndex == 0 ? labelA : labelB;
                      return BarTooltipItem('$lbl\n${val} min', const TextStyle(color: Colors.black, fontSize: 11));
                    },
                  ),
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions && response != null && response.spot != null) {
                      final day = response.spot!.touchedBarGroup.x;
                      if (onBarTap != null) onBarTap!(day);
                    }
                  },
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color c, String label, {double fontSize = 13}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 9, height: 9, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      // usa overflow/ellipsis se la label è troppo lunga
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160),
        child: Text(label, style: TextStyle(fontSize: fontSize), overflow: TextOverflow.ellipsis),
      ),
    ]);
  }
}