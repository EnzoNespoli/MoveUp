//-------------------------------------------------------------
// Classe per i periodi di attività
//-------------------------------------------------------------
class Periodo {
  final DateTime inizio, fine;
  final int livello;
  Periodo(this.inizio, this.fine, this.livello);
  factory Periodo.fromJson(Map<String, dynamic> j) => Periodo(
        DateTime.parse(j['inizio']).toLocal(),
        DateTime.parse(j['fine']).toLocal(),
        j['livello'].toInt(),
      );
}