import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../db.dart'; // Importa la costante globale

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// solo se ti serve apiBaseUrl

class UserService {
  static Future<String> inizializzaUtente() async {
    final prefs = await SharedPreferences.getInstance();
    String? idUserGenerico = prefs.getString("idUserGenerico");
    String? idUserLogin = prefs.getString("idUserLogin");

    if (idUserGenerico == null || idUserGenerico.trim().isEmpty) {
      try {
        final res = await http.get(Uri.parse("$apiBaseUrl/crea_utente.php"));
        final data = json.decode(res.body);
        if (data['success'] == true && data['utente_id'] != null) {
          idUserGenerico = data['utente_id'].toString();
          await prefs.setString("idUserGenerico", idUserGenerico);
        }
      } catch (e) {
        //print('Errore chiamata API: $e');
        await scriviLog('Errore chiamata API: $e');
      }
    }
    return idUserLogin ?? idUserGenerico ?? '';
  }

  static Future<void> eseguiLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("idUserLogin");
  }

  static Future<void> scriviLog(String messaggio) async {
    if (kIsWeb) {
      // Su web: stampa solo su console (o usa localStorage se vuoi)
      print('[WEB LOG] $messaggio');
      return;
    }
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/log_api.txt');
    final now = DateTime.now().toIso8601String();
    await file.writeAsString("[$now] $messaggio\n", mode: FileMode.append);
  }
}
