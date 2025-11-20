import 'dart:convert';
import 'package:http/http.dart' as http;
import '../class/daily_analysis.dart';

Future<DailyAnalysis> fetchDailyAnalysis({
  required int utenteId,
  required String baseUrl, // es: https://mytrak.app/move/api
  String? data, // opzionale, se null prende oggi
  String? token, // se il tuo PHP usa Bearer
}) async {
  final uri = Uri.parse(
    '$baseUrl/analisi_giorno.php?utente_id=$utenteId${data != null ? '&data=$data' : ''}',
  );

  final headers = <String, String>{
    'Accept': 'application/json',
  };

  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }

    
  final resp = await http.get(uri, headers: headers);
  
  if (resp.statusCode != 200) {
    throw Exception('Error server: ${resp.statusCode}');
  }

  final Map<String, dynamic> body = json.decode(resp.body);

  if (body['success'] != true) {
    throw Exception('API response with error: ${body['error'] ?? 'not specified'}');
  }

  return DailyAnalysis.fromJson(body);
}
