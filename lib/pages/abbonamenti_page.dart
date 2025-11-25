import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/app_header.dart';
import '../services/app_footer.dart';
import '../db.dart'; // Importa la costante globale
import 'acquista_piano_page.dart';
import 'plan_feature_chips.dart';
import '../lingua.dart'; // Importa l'estensione XStrings

class AbbonamentiPage extends StatefulWidget {
  final String utenteId;
  final String nomeId;
  const AbbonamentiPage({
    super.key,
    required this.utenteId,
    required this.nomeId,
  });

  @override
  State<AbbonamentiPage> createState() => _AbbonamentiPageState();
}

class _AbbonamentiPageState extends State<AbbonamentiPage> {
  final _storage = const FlutterSecureStorage();
  String? _jwtToken;
  List<Map<String, dynamic>> piani = [];
  bool loading = true;

  // Aggiungi questa variabile (puoi valorizzarla come preferisci, qui è solo esempio)
  String? pianoAttivoId; // <-- imposta l'ID del piano attivo dell'utente

  @override
  void initState() {
    super.initState();
    _getToken();
  }

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
    await caricaPiani(); // <-- aspetta che i piani siano caricati
    await caricaUtente(); // <-- poi carica l'utente e aggiorna pianoAttivoId
  }

  Map<String, String> _authHeaders() {
    return {
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  Future<void> caricaPiani() async {
    try {
      final res = await http.get(
        Uri.parse("$apiBaseUrl/piani_abbonamento.php"),
        headers: _authHeaders(),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> dati = json.decode(res.body);
        final List<dynamic> pianiList = dati['piani'];
        setState(() {
          piani = pianiList.map(
            (e) {
              // Decodifica funzioni_attive se è una stringa
              final funzioniAttiveMap = e['funzioni_attive'] is String
                  ? json.decode(e['funzioni_attive']) as Map<String, dynamic>
                  : (e['funzioni_attive'] ?? <String, dynamic>{});

              //print(funzioniAttiveMap.runtimeType);
              //print(funzioniAttiveMap);

              final funzioniAttiveList = funzioniAttiveMap.entries
                  .where((e) => e.value == true)
                  .map((e) => e.key)
                  .toList();

              return {
                'id': e['id'],
                'nome': e['nome'],
                'prezzo': '${e['prezzo_euro']} €',
                'durata': '${e['durata_giorni']} giorni',
                // Lista delle funzioni attive (solo nomi con valore true)
                'funzioni': funzioniAttiveList,
                // Mappa completa delle funzioni attive
                'funzioni_attive_map': funzioniAttiveMap,
                'google_product_id': e['google_product_id'],
                'google_base_plan_id': e['google_base_plan_id'],
              };
            },
          ).toList();
          loading = false;
        });
      } else if (res.statusCode == 401) {
        await _storage.delete(key: 'jwt_token');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.t.sessionExpired),
            ),
          );
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  //-----------------------------------------------------------
  // Quando carichi i dati utente (esempio semplificato)
  //-----------------------------------------------------------
  Future<void> caricaUtente() async {
    final res = await http.get(
      Uri.parse("$apiBaseUrl/utenti_read.php?utente_id=${widget.utenteId}"),
      headers: _authHeaders(),
    );

    if (res.statusCode == 200) {
      final j = json.decode(res.body) as Map<String, dynamic>;
      final utente = j['utente'] ?? j['data'];
      setState(() {
        pianoAttivoId = utente?['piano_attivo_id']?.toString();
      });
    }
  }

  //----------------------------------------------------------------
  //  BUILD
  //----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 380;
    final w = MediaQuery.of(context).size.width;
    final cols =
        (w / 360).floor().clamp(1, 3); // 1 col <360, 2 col <720, 3 col >=720
    final aspect = (cols == 1)
        ? 0.68 // tile più alta su schermi piccoli
        : (cols == 2)
            ? 0.82
            : 0.96;

    return Scaffold(
      appBar: const AppHeader(showBack: true),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          size: 22,
                          color: Colors.blue[700],
                        ),
                        SizedBox(width: 8),
                        Text(
                          context.t.subscriptions,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      context.t.welcomeUser(
                        widget.nomeId.isNotEmpty
                            ? widget.nomeId
                            : context.t.anonymousUser,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey[700],
                      ),
                    ),  
                    SizedBox(height: 20),
                    GridView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: piani.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            720, // 1 col <360px, 2 col >=360px, 3 col >=720px...
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isSmall
                            ? 0.85
                            : 1.00, // più basso = card più alte (niente overflow)
                      ),
                      itemBuilder: (context, index) {
                        final piano = piani[index];
                        final durata = piano['durata']?.toString() ?? '';
                        final isAttivo =
                            piano['id'].toString() == pianoAttivoId;
                        final isFreeOrStart =
                            piano['nome'] == 'Free' || piano['nome'] == 'Start';

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          color:
                              isAttivo ? Colors.lightGreen[100] : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isAttivo
                                ? const BorderSide(
                                    color: Colors.green, width: 2)
                                : BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(10), // un filo più aria
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // NON center
                              children: [
                                // titolo
                                Text(
                                  piano['nome'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isAttivo
                                        ? Colors.green[900]
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // prezzo + durata (solo se non Free/Start)
                                if (!isFreeOrStart) ...[
                                  Text(
                                    piano['prezzo'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueGrey[800]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${context.t.durata_abbonamento} $durata',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(height: 8),
                                ] else
                                  const SizedBox(height: 4),

                                // chips (usa già maxChips=3)
                                Expanded(
                                  child: FeatureList(
                                    items:
                                        (piano['funzioni'] ?? const <String>[]),
                                    max: 5, // massimo 8 chips
                                  ),
                                ),

                                const Spacer(), // spinge il bottone in basso

                                // stato attivo o CTA
                                if (isAttivo) ...[
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      context.t.thisIsYourPlan,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ] else if (!isFreeOrStart) ...[
                                  SizedBox(
                                    height: 28,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AcquistaPianoPage(
                                              utenteId: widget.utenteId,
                                              piano: piano,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(context.t.buy,
                                          style: const TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(
                                    height: 28,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: null,
                                      child: Text(context.t.active,
                                          style: const TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
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
              icon: const Icon(Icons.home),
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
}

class FeatureList extends StatelessWidget {
  const FeatureList({super.key, required this.items, this.max = 3});
  final List items;
  final int max;

  Map<String, String> _featLabels(BuildContext context) => {
        'tracking_live': context.t.feat_tracking_live,
        'report_basic': context.t.feat_report_basic,
        'report_advanced': context.t.feat_report_advanced,
        'places_routes': context.t.feat_places_routes,
        'export_gpx': context.t.feat_export_gpx,
        'export_csv': context.t.feat_export_csv,
        'notifications': context.t.feat_notifications,
        'backup_cloud': context.t.feat_backup_cloud,
        'rewards': context.t.feat_rewards,
        'priority_support': context.t.feat_priority_support,
        'no_ads': context.t.feat_no_ads,
      };

  @override
  Widget build(BuildContext context) {
    final labelsMap = _featLabels(context);

    final labels = items
        .where((k) => labelsMap.containsKey(k))
        .take(max)
        .map((k) => labelsMap[k] ?? k)
        .toList();

    final totalCount = items.where((k) => labelsMap.containsKey(k)).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...labels.map((text) => _FeatureRow(text: text)),
        if (totalCount > max)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 2),
            child: Text(
              'more...',
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.blueGrey,
              ),
            ),
          ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: t.colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 2, // <-- permette massimo 2 righe
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
