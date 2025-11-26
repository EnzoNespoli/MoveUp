import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../services/app_header.dart';
import '../services/app_footer.dart';
import '../db.dart'; // Importa la costante globale
import '../lingua.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'funzioni_attive_form.dart';
import '../services/purchase_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kIsWeb;
import 'package:provider/provider.dart';

class AcquistaPianoPage extends StatefulWidget {
  final String utenteId;
  final Map<String, dynamic> piano;

  const AcquistaPianoPage({
    super.key,
    required this.utenteId,
    required this.piano,
  });

  @override
  State<AcquistaPianoPage> createState() => _AcquistaPianoPageState();
}

class _AcquistaPianoPageState extends State<AcquistaPianoPage> {
  final _storage = const FlutterSecureStorage();
  Map<String, dynamic>? datiUtente;
  bool loading = true;
  String? _jwtToken;
  String? _pendingSessionId; // <- per riprendere alla ripresa app

  @override
  void initState() {
    super.initState();
    _getToken().then((_) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  //-----------------------------------------------------------------------------
  // Gestisce i cambiamenti nello stato dell'app
  //-----------------------------------------------------------------------------
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingSessionId != null) {
      _pollForActivation(_pendingSessionId!); // riprova quando torni in app
    }
  }

  //-----------------------------------------------------------------------------
  // Ottiene il token JWT
  //-----------------------------------------------------------------------------
  Future<void> _getToken() async {
    _jwtToken = await _storage.read(key: 'jwt_token');
    if (_jwtToken == null || _jwtToken!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.sessionExpired),
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }

    await caricaUtente(); // <-- poi carica l'utente e aggiorna pianoAttivoId
  }

  //-----------------------------------------------------------------------------
  // Restituisce le intestazioni di autorizzazione
  //-----------------------------------------------------------------------------
  Map<String, String> _authHeaders() {
    return {
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  //-----------------------------------------------------------------------------
  // Carica i dati dell'utente
  //-----------------------------------------------------------------------------
  Future<void> caricaUtente() async {
    final res = await http.get(
      Uri.parse("$apiBaseUrl/utenti_read.php?utente_id=${widget.utenteId}"),
      headers: _authHeaders(),
    );
    if (res.statusCode == 200) {
      final j = json.decode(res.body) as Map<String, dynamic>;
      final utente = j['utente'] ?? j['data'];
      setState(() {
        datiUtente = utente;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  //-----------------------------------------------------------------------------
  // Inizia il processo di checkout
  //-----------------------------------------------------------------------------
  Future<void> _iniziaCheckout() async {
    if (datiUtente == null) return;

    final res = await http.post(
      Uri.parse("$apiBaseUrl/checkout.php"),
      headers: _authHeaders(),
      body: json.encode({'utente_id': widget.utenteId, 'piano': widget.piano}),
    );

    if (res.statusCode == 200) {
      final j = json.decode(res.body) as Map<String, dynamic>;
      if (j['success']) {
        // Checkout avvenuto con successo
        Navigator.of(context).pushReplacementNamed('/success');
      } else {
        // Errore nel checkout
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(j['message'])));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.imposta_page_mess4)));
    }
  }

  //-----------------------------------------------------------------------------
  // Costruzione dell'interfaccia utente
  //-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //debugPrint('AcquistaPianoPage build piano: ${widget.piano}');
    final platform = _platformName();
    return Scaffold(
      appBar: const AppHeader(showBack: true),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          color: Colors.amber[800],
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          context.t.acquisto_piano_conferma,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    // INFORMAZIONI CLIENTE
                    Card(
                      color: Colors.yellow[100],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.orange, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.orange[800],
                              size: 32,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.t.acquisto_piano_info,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${context.t.acquisto_piano_id} ${widget.utenteId}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  if (datiUtente != null) ...[
                                    if (datiUtente!['nome'] != null)
                                      Text(
                                        '${context.t.acquisto_piano_nome} ${datiUtente!['nome']}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    if (datiUtente!['email'] != null)
                                      Text(
                                        '${context.t.acquisto_piano_mail} ${datiUtente!['email']}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // RIQUADRO PIANO
                    Card(
                      color: Colors.blueGrey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blueGrey, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.piano['nome'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.piano['prezzo'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${context.t.acquisto_piano_durata} ${widget.piano['durata']}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            FunzioniAttiveForm(
                                funzioniAttive:
                                    widget.piano!['funzioni'] ?? {}),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.payment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        label: Text(
                          context.t.acquisto_piano_pagamento +
                              '( ' +
                              platform +
                              ':' +
                              widget.piano['google_product_id'] +
                              ':' +
                              widget.piano['google_base_plan_id'] +
                              ')',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          if (Platform.isAndroid) {
                            final svc = context.read<PurchaseService>();
                            await svc.buySubscription(
                              productId: widget.piano['google_product_id']
                                  as String, // "move.premium"
                              basePlanId: widget.piano['google_base_plan_id']
                                  as String?, // "month"
                              // offerId: widget.piano['google_offer_id'] as String?,       // es. "trial7d" (se vuoi forzare l’offerta)
                              accountId: widget.utenteId.toString(),
                            );
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(context.t.acquisto_piano_google)),
                            );
                          } else {
                            _checkout(widget
                                .piano['id']); // Stripe (web / iOS per ora)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(context.t.acquisto_piano_stripe)),
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    AppFooter(), // <-- ora scorre con la pagina
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

      // BOTTONE fisso in basso
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,   // icona + testo
          backgroundColor: Colors.grey[200], // sfondo bottone (se vuoi chiaro)
        ),
              icon: const Icon(Icons.navigate_before),
              label: Text(context.t.bottom_dashboard),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------------
  // Inizia il processo di checkout
  //-----------------------------------------------------------------------------
  Future<void> _checkout(int pianoId) async {
    try {
      final uri = Uri.parse('$apiBaseUrl/checkout_session.php');
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_jwtToken',
        },
        body: jsonEncode({'utente_id': widget.utenteId, 'piano_id': pianoId}),
      );

      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['ok'] != true || data['url'] == null) {
        throw Exception(data['error'] ?? 'Risposta non valida');
      }

      final url = Uri.parse(data['url'] as String);
      final sessionId =
          data['session_id'] as String; // <— QUI PRENDI IL SESSION_ID
      _pendingSessionId = sessionId; // memorizza

      // Apre Stripe Checkout (SafariView/CustomTabs).
      final ok = await launchUrl(url, mode: LaunchMode.externalApplication);

      // Avvia il polling di attivazione (parte anche se l’utente non esce dal browser subito)
      _pollForActivation(sessionId); // <— FINALIZZA QUI

      if (!ok) {
        // fallback in-app
        await launchUrl(url, mode: LaunchMode.inAppBrowserView);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(content: Text('${context.t.acquisto_piano_nopaga} $e')));
    }
  }

  //-----------------------------------------------------------------------------
  // Polling: chiama l’endpoint che attiva/controlla l’abbonamento dalla sessione
  //-----------------------------------------------------------------------------
  Future<void> _pollForActivation(String sessionId) async {
    final deadline = DateTime.now().add(const Duration(minutes: 2));
    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(seconds: 3));
      final ok = await _finalizza(sessionId);
      if (ok) {
        _pendingSessionId = null;
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
            SnackBar(content: Text(context.t.acquisto_piano_attivo)));
        // qui puoi navigare/aggiornare UI
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
    }
    // se scade il timeout, lascio _pendingSessionId per riprovare al resume
  }

  //----------------------------------------------------------------------------
  // Chiama la tua API server per attivare/validare la sessione e scrivere su DB
  //----------------------------------------------------------------------------
  Future<bool> _finalizza(String sessionId) async {
    final uri = Uri.parse(
      '$apiBaseUrl/activate_from_session.php?session_id=$sessionId',
    );
    final res = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_jwtToken'},
    );
    if (res.statusCode != 200) return false;
    final js = jsonDecode(res.body) as Map<String, dynamic>;
    return js['ok'] == true && (js['status'] == 'active');
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }
}
