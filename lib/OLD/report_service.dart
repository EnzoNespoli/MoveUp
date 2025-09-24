import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move_app/OLD/report_totals.dart';

typedef HeadersBuilder = Map<String, String> Function();

class ReportService {
  final String apiBaseUrl;
  final String utenteId;         // o int, come ce l’hai tu
  final HeadersBuilder headers;  // es: () => _authHeaders()

  const ReportService({
    required this.apiBaseUrl,
    required this.utenteId,
    required this.headers,
  });

  // --- pubblico: totali ultimi 7 giorni (incluso oggi) ---
  Future<ReportTotals> getWeeklyTotals(DateTime today) async {
    final day = DateTime(today.year, today.month, today.day);
    final start = day.subtract(const Duration(days: 6));
    final end   = day;

    // richieste in parallelo per livelli 0,1,2
    final futures = List.generate(3, (liv) => _fetchSettimanaLivello(liv, day));
    final results = await Future.wait(futures);

    // results è una lista di mappe {minuti, metri, passi} per ciascun livello
    final minL0 = results[0]['minuti'] as int;
    final minL1 = results[1]['minuti'] as int;
    final minL2 = results[2]['minuti'] as int;

    final metri = (results[0]['metri'] as num).toDouble()
                + (results[1]['metri'] as num).toDouble()
                + (results[2]['metri'] as num).toDouble();

    final passi = (results[0]['passi'] as int)
                + (results[1]['passi'] as int)
                + (results[2]['passi'] as int);

    return ReportTotals(
      start: start, end: end,
      minL0: minL0, minL1: minL1, minL2: minL2,
      metri: metri, passi: passi,
    );
  }

  // --- privato: chiama /settimana_livello.php e aggrega i dettagli ---
  Future<Map<String, dynamic>> _fetchSettimanaLivello(int livello, DateTime day) async {
    final dataStr =
        "${day.year.toString().padLeft(4, '0')}"
        "${day.month.toString().padLeft(2, '0')}"
        "${day.day.toString().padLeft(2, '0')}";

    final url = Uri.parse(
      "$apiBaseUrl/settimana_livello.php?utente_id=$utenteId&livello=$livello&data=$dataStr",
    );

    final res = await http.get(url, headers: headers());

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final List dettagli = (body['dettagli'] as List?) ?? const [];

      // somma robusta: accetta chiavi diverse se servisse
      int minuti = 0;
      double metri = 0;
      int passi = 0;

      for (final r in dettagli) {
        final m  = _asInt(r['minuti']);
        final mt = _asDouble(r['metri']);
        final p  = _asInt(r['passi']);
        minuti += m;
        metri  += mt;
        passi  += p;
      }

      return {'minuti': minuti, 'metri': metri, 'passi': passi};
    }

    if (res.statusCode == 401) {
      // lascia gestire al chiamante/Widget (snack + redirect), qui ritorna zero per non rompere la UI
      return {'minuti': 0, 'metri': 0.0, 'passi': 0};
    }

    // fallback: nessun dato
    return {'minuti': 0, 'metri': 0.0, 'passi': 0};
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is num) return v.toInt();
    return 0;
    }
  double _asDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }
}
