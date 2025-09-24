class ReportTotals {
  final DateTime start;
  final DateTime end;
  final int minL0;
  final int minL1;
  final int minL2;
  final double metri; // tot metri (usa km = metri/1000)
  final int passi;

  const ReportTotals({
    required this.start,
    required this.end,
    required this.minL0,
    required this.minL1,
    required this.minL2,
    required this.metri,
    required this.passi,
  });
}
