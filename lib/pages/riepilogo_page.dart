import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/app_header_bar.dart';

class RiepilogoPage extends StatelessWidget {
  final String utenteId;
  final String nomeId;
  final Map<int, List<dynamic>> datiLivelli;

  const RiepilogoPage({
    super.key,
    required this.utenteId,
    required this.nomeId,
    required this.datiLivelli,
  });

  @override
  Widget build(BuildContext context) {
    // Esempio: mostra un grafico a barre per il livello 1 (Movimento Leggero)
    final dati = datiLivelli[1] ?? [];
    return Scaffold(
      appBar: const AppHeaderBar(showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: [
              for (int i = 0; i < dati.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: (dati[i]['distanza_metri'] ?? 0).toDouble(),
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < dati.length) {
                      return Text(
                        dati[value.toInt()]['data_ora_inizio']?.substring(
                              5,
                              10,
                            ) ??
                            '',
                        style: TextStyle(fontSize: 10),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
