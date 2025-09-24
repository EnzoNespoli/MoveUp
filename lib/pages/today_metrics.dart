class TodayMetrics {
  // secondi per livello
  final int secFermo;
  final int secLeggero;
  final int secVeloce;

  // distanza di oggi in metri (filtrata)
  final double distanceMeters;

  // percentuale di tempo non monitorato su finestra odierna [0..1]
  final double gapRatio;

  // obiettivo (minuti attivi) - opzionale
  final int? goalMinutes;

  // minuti attivi di ieri (per confronto) - opzionale
  final int? yesterdayActiveMinutes;

  // flag stati
  final bool hasAnyData;        // esistono dati oggi?
  final bool dayClosed;         // (dopo 21:30 o marcata conclusa)

  TodayMetrics({
    required this.secFermo,
    required this.secLeggero,
    required this.secVeloce,
    required this.distanceMeters,
    required this.gapRatio,
    required this.hasAnyData,
    required this.dayClosed,
    this.goalMinutes,
    this.yesterdayActiveMinutes,
  });

  int get activeMinutes =>
      ((secLeggero + secVeloce) / 60).round();

  int get sedentaryMinutes =>
      (secFermo / 60).round();

  double get distanceKm => distanceMeters / 1000.0;
}
