class DailyAnalysis {
  final String giorno;
  final int secGap;
  final int secFermoTot;
  final int secMov;
  final double percGap;
  final double percFermo;
  final double percMov;
  final int score;
  final String messaggio;
  final String stato; // "completo" | "parziale" | "vuoto"

  DailyAnalysis({
    required this.giorno,
    required this.secGap,
    required this.secFermoTot,
    required this.secMov,
    required this.percGap,
    required this.percFermo,
    required this.percMov,
    required this.score,
    required this.messaggio,
    required this.stato,
  });

  factory DailyAnalysis.fromJson(Map<String, dynamic> json) {
    final d = json['data'];

    
    return DailyAnalysis(
      giorno: d['giorno'],
      secGap: d['sec_gap'],
      secFermoTot: d['sec_fermo_totale'],
      secMov: d['sec_movimento_probabile'],
      percGap: (d['perc_gap'] as num).toDouble(),
      percFermo: (d['perc_fermo'] as num).toDouble(),
      percMov: (d['perc_mov'] as num).toDouble(),
      score: d['score'],
      messaggio: d['messaggio'],
      stato: (d['perc_gap'] as num).toDouble() > 25 ? 'parziale' : 'completo',
    );
  }
}
