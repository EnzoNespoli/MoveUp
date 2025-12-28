import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // ⬅️ NEW
import 'funzioni_attive_form.dart';
import '../services/app_footer.dart';
import '../services/app_header.dart';
import '../services/mod_esclusione_temporale.dart';
import 'esclusione_temporale_diag.dart';
import '../db.dart'; // Importa la costante globale
import '../lingua.dart';
import '../safe_state.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/locale_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpostazioniPage extends StatefulWidget {
  final String utenteId;
  final String nomeId;

  const ImpostazioniPage({
    super.key,
    required this.utenteId,
    required this.nomeId,
  });

  @override
  State<ImpostazioniPage> createState() => _ImpostazioniPageState();
}

class _ImpostazioniPageState extends State<ImpostazioniPage> with SafeState {
  Map<String, dynamic>? datiUtente;
  Map<String, dynamic>? impostazioniUtente;
  Map<String, dynamic>? pianoAbbonamento;

  // === Auth helpers ===
  static const _storage = FlutterSecureStorage();
  String? _jwtToken;

  bool _isOk(Map<String, dynamic> j) => j['ok'] == true || j['success'] == true;
  bool busy = false; // 👈 la variabile che usi nell'esempio

  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  final lc = LocaleController.instance;

  //-----------------------------------------------------------
  // Inizializza  lo stato
  //------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getTokenInz();
  }

  //------------------------------------------------------------------
  // Inizializza il token
  //------------------------------------------------------------------
  Future<void> _getTokenInz() async {
    _jwtToken = await _storage.read(key: 'jwt_token');
    if (_jwtToken == null || _jwtToken!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.session_expired),
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }
    _caricaDati();
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      };

  //----------------------------------------------------------------
  // Carica i dati dell'utente
  //----------------------------------------------------------------
  Future<void> _caricaDati() async {
    if (_jwtToken == null || _jwtToken!.isEmpty) {
      // TODO: porta al login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.session_expired)),
      );
      setState(() {
        datiUtente = {};
        impostazioniUtente = {};
        pianoAbbonamento = {};
      });
      return;
    }

    try {
      // === UTENTE ===
      final urlUtente = Uri.parse(
        "$apiBaseUrl/utenti_read.php?utente_id=${widget.utenteId}",
      );

      final rUser = await http.get(
        urlUtente,
        headers: _authHeaders(_jwtToken!),
      );

      if (rUser.statusCode == 401) {
        await _storage.delete(key: 'jwt_token');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.token_invalid)),
        );
        setState(() {
          datiUtente = {};
          impostazioniUtente = {};
          pianoAbbonamento = {};
        });
        return;
      }

      if (rUser.statusCode == 200) {
        final j = json.decode(rUser.body) as Map<String, dynamic>;
        final utente = j['utente'] ?? j['data'];
        if (_isOk(j) && utente != null) {
          setState(() {
            datiUtente = Map<String, dynamic>.from(utente);
          });
        } else {
          setState(() {
            datiUtente = {};
          });
        }
      } else {
        setState(() {
          datiUtente = {};
        });
      }

      // === CONSENSI / IMPOSTAZIONI ===
      final rCons = await http.get(
        Uri.parse('$apiBaseUrl/consensi_read.php?utente_id=${widget.utenteId}'),
        headers: _authHeaders(_jwtToken!),
      );
      // )

      if (rCons.statusCode == 200) {
        final j = json.decode(rCons.body) as Map<String, dynamic>;
        final impostazioni = j['impostazioni'];
        if (_isOk(j) && impostazioni is List && impostazioni.isNotEmpty) {
          setState(() {
            impostazioniUtente = Map<String, dynamic>.from(impostazioni[0]);
          });
        } else {
          setState(() {
            impostazioniUtente = {};
          });
        }
      } else if (rCons.statusCode == 401) {
        await _storage.delete(key: 'jwt_token');
        setState(() {
          impostazioniUtente = {};
        });
        return;
      } else {
        setState(() {
          impostazioniUtente = {};
        });
      }

      // === PIANO ABBONAMENTO ===
      final pianoId = (datiUtente ?? const {})['piano_attivo_id'];
      if (pianoId != null) {
        final urlPiano = Uri.parse(
          '$apiBaseUrl/piani_abbonamento_read.php?id=$pianoId',
        );
        final rPlan = await http.get(
          urlPiano,
          headers: _authHeaders(_jwtToken!),
        );

        if (rPlan.statusCode == 200) {
          final j = json.decode(rPlan.body) as Map<String, dynamic>;
          final piano = j['piano'] ?? j['data'];
          if (_isOk(j) && piano != null) {
            setState(() {
              pianoAbbonamento = Map<String, dynamic>.from(piano);
            });
          } else {
            setState(() {
              pianoAbbonamento = {};
            });
          }
        } else if (rPlan.statusCode == 401) {
          await _storage.delete(key: 'jwt_token');
          setState(() {
            pianoAbbonamento = {};
          });
          return;
        } else {
          setState(() {
            pianoAbbonamento = {};
          });
        }
      } else {
        setState(() {
          pianoAbbonamento = {};
        });
      }
    } catch (e) {
      setState(() {
        datiUtente = {};
        impostazioniUtente = {};
        pianoAbbonamento = {};
      });
    }
  }

  //-----------------------------------------------------------------
  // Costruzione UI
  //-----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final lc =
        LocaleController.instance; // prendo il singleton, niente listener qui
    final professioni = [
      'Student',
      'Employee',
      'Freelancer',
      'Unemployed',
      'Retired',
      'Other',
    ];

    final fasceEta = ['18-25', '26-35', '36-45', '46-60', '60+'];

    String? genere = datiUtente?['genere'];
    String? professione = datiUtente?['professione'];
    String? fasciaEta = datiUtente?['fascia_eta'];

    return Scaffold(
      appBar: const AppHeader(showBack: true), // Mostra la freccia indietro
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t.imposta_page_miei,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Card(
                child: ListTile(
                  title: Text(context.t.form_reg_nome),
                  subtitle: Text(datiUtente?['nome'] ?? ''),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(context.t.form_reg_mail),
                  subtitle: Text(datiUtente?['email'] ?? ''),
                ),
              ),
              Card(
                child: DropdownButtonFormField<String>(
                  initialValue: genere,
                  decoration:
                      InputDecoration(labelText: context.t.form_reg_genere),
                  items: [
                    DropdownMenuItem(value: 'M', child: Text('Male')),
                    DropdownMenuItem(value: 'F', child: Text('Female')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      genere = val;
                      datiUtente?['genere'] = val;
                    });
                  },
                ),
              ),
              Card(
                child: DropdownButtonFormField<String>(
                  initialValue: professione,
                  decoration: InputDecoration(
                      labelText: context.t.form_reg_professione),
                  items: professioni
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      professione = val;
                      datiUtente?['professione'] = val;
                    });
                  },
                ),
              ),

              Card(
                child: DropdownButtonFormField<String>(
                  initialValue: datiUtente?['country_code'],
                  decoration:
                      InputDecoration(labelText: context.t.form_reg_country),
                  items: [
                    DropdownMenuItem(value: 'IT', child: Text('Italy')),
                    DropdownMenuItem(value: 'FR', child: Text('France')),
                    DropdownMenuItem(value: 'DE', child: Text('Germany')),
                    DropdownMenuItem(value: 'ES', child: Text('Spain')),
                    DropdownMenuItem(
                        value: 'GB', child: Text('United Kingdom')),
                    DropdownMenuItem(value: 'US', child: Text('United States')),
                    DropdownMenuItem(value: 'CA', child: Text('Canada')),
                    DropdownMenuItem(value: 'UA', child: Text('Ukraine')),
                    DropdownMenuItem(value: 'EU', child: Text('Europe (EU)')),
                    DropdownMenuItem(value: 'ZZ', child: Text('Other')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      datiUtente?['country_code'] = val;
                    });
                  },
                ),
              ),

              Card(
                child: DropdownButtonFormField<String>(
                  initialValue: fasciaEta,
                  decoration:
                      InputDecoration(labelText: context.t.form_reg_eta),
                  items: fasceEta
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      fasciaEta = val;
                      datiUtente?['fascia_eta'] = val;
                    });
                  },
                ),
              ),

              // ...dopo la Card di ultimo accesso
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListenableBuilder(
                    listenable: lc, // riassegna la spunta quando cambia il tema
                    builder: (_, __) {
                      return Column(
                        children: [
                          RadioListTile<AppTheme>(
                            title: const Text('System (white)'),
                            value: AppTheme.systemWhite,
                            groupValue: lc.appTheme,
                            onChanged: (v) => lc.setAppTheme(v!),
                          ),
                          RadioListTile<AppTheme>(
                            title: const Text('Light (pastel celestine)'),
                            value: AppTheme.lightPastelGreen,
                            groupValue: lc.appTheme,
                            onChanged: (v) => lc.setAppTheme(v!),
                          ),
                          RadioListTile<AppTheme>(
                            title: const Text('Light (pastel pink)'),
                            value: AppTheme.darkPink,
                            groupValue: lc.appTheme,
                            onChanged: (v) => lc.setAppTheme(v!),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              //-----------------------------------------------------
              // ultima accesso
              //-----------------------------------------------------
              Card(
                child: ListTile(
                  title: Text(context.t.form_reg_ult_accesso),
                  subtitle: Text(datiUtente?['ultimo_accesso'] ?? ''),
                ),
              ),

              //-----------------------------------------------------
              // Consensi
              //-----------------------------------------------------
              const SizedBox(height: 20),
              Text(
                context.t.form_reg_consensi,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (impostazioniUtente == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                Card(
                  child: SwitchListTile(
                    title: Text(context.t.form_reg_gps),
                    value: (impostazioniUtente!['tracking_gps'] ?? 0) == 1,
                    onChanged: (val) {
                      setState(
                        () => impostazioniUtente!['tracking_gps'] = val ? 1 : 0,
                      );
                    },
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    title: Text(context.t.imposta_page_notifiche),
                    value: (impostazioniUtente!['notifiche_attive'] ?? 0) == 1,
                    onChanged: (val) {
                      setState(
                        () => impostazioniUtente!['notifiche_attive'] =
                            val ? 1 : 0,
                      );
                    },
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    title: Text(context.t.imposta_page_consenso),
                    value: (impostazioniUtente!['consenso_privacy'] ?? 0) == 1,
                    onChanged: (val) {
                      setState(
                        () => impostazioniUtente!['consenso_privacy'] =
                            val ? 1 : 0,
                      );
                    },
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    title: Text(context.t.imposta_page_marketing),
                    value:
                        (impostazioniUtente!['consenso_marketing'] ?? 0) == 1,
                    onChanged: (val) {
                      setState(
                        () => impostazioniUtente!['consenso_marketing'] =
                            val ? 1 : 0,
                      );
                    },
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    title: Text(context.t.imposta_page_premi),
                    value: (impostazioniUtente!['consenso_premi'] ?? 0) == 1,
                    onChanged: (val) {
                      setState(
                        () =>
                            impostazioniUtente!['consenso_premi'] = val ? 1 : 0,
                      );
                    },
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    title: Text(context.t.imposta_page_ai),
                    value: (impostazioniUtente!['consenso_ai'] ?? 0) == 1,
                    onChanged: (val) {
                      setState(
                        () => impostazioniUtente!['consenso_ai'] = val ? 1 : 0,
                      );
                    },
                  ),
                ),
                //-------------------
                // data consenso
                //-------------------
                Card(
                  child: ListTile(
                    title: Text(context.t.imposta_page_datac),
                    subtitle: Text(
                      impostazioniUtente!['data_consenso']?.toString() ?? '',
                    ),
                  ),
                ),
                //------------------------------------------------
                // esclusioni temporali
                //------------------------------------------------
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.t.escl_prog_01,
                          style: Theme.of(context).textTheme.titleMedium),
                      if (datiUtente!['piano_attivo_id'] < 3)
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(context.t.escl_prog_02),
                        )
                      else ...[
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: context.t.escl_prog_03,
                              onPressed: () async {
                                final nuova =
                                    await showDialog<EsclusioneTemporale>(
                                  context: context,
                                  builder: (ctx) => EsclusioneTemporaleDialog(
                                    utenteId:
                                        int.tryParse(widget.utenteId) ?? 0,
                                  ),
                                );
                                if (nuova != null) {
                                  final esclusioneDaSalvare = nuova.copyWith(
                                    utenteId:
                                        int.tryParse(widget.utenteId) ?? 0,
                                  );
                                  await salvaEsclusioneTemporale(
                                      esclusioneDaSalvare);
                                  setState(() {}); // ricarica la lista
                                }
                              },
                            ),
                          ],
                        ),
                        FutureBuilder<List<EsclusioneTemporale>>(
                          future: caricaEsclusioniTemporali(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              );
                            }
                            final esclusioni = snapshot.data!;
                            if (esclusioni.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(context.t.escl_prog_04),
                              );
                            }
                            return Column(
                              children: esclusioni
                                  .map((e) => ListTile(
                                        title: Text(e.nome),
                                        subtitle: Text(
                                            '${e.oraInizio} - ${e.oraFine}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Switch(
                                              value: e.attiva == 1,
                                              onChanged: (val) async {
                                                final aggiornata = e.copyWith(
                                                    attiva: val ? 1 : 0);
                                                await salvaEsclusioneTemporale(
                                                    aggiornata);
                                                setState(() {});
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              tooltip: 'Modifica',
                                              onPressed: () async {
                                                final modificata =
                                                    await showDialog<
                                                        EsclusioneTemporale>(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      EsclusioneTemporaleDialog(
                                                    esclusione: e,
                                                    utenteId: int.tryParse(
                                                            widget.utenteId) ??
                                                        0,
                                                  ),
                                                );
                                                if (modificata != null) {
                                                  await salvaEsclusioneTemporale(
                                                      modificata);
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                context.t.imposta_page_piani,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (pianoAbbonamento == null)
                const Center(child: CircularProgressIndicator())
              else ...[
                Card(
                  child: ListTile(
                    title: Text(pianoAbbonamento!['nome'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${context.t.imposta_page_importo} ${pianoAbbonamento!['prezzo_euro']} €'),
                        if (pianoAbbonamento!['durata_giorni'] !=
                            0) // <-- aggiungi questo if
                          Text(
                            '${context.t.imposta_page_durata} ${pianoAbbonamento!['durata_giorni']} giorni',
                          ),
                        Text(
                          '${context.t.imposta_page_cancella} ${pianoAbbonamento!['retention_giorni']} giorni',
                        ),
                        FunzioniAttiveForm(
                            funzioniAttive:
                                pianoAbbonamento!['funzioni_attive']),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // ...existing code...

              Card(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ExpansionTile(
                  title: Text(
                    context.t.cambio_password,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  children: [
                    const SizedBox(height: 12),
                    TextField(
                      controller: _oldPasswordCtrl,
                      decoration: InputDecoration(
                        labelText: context.t.password_attuale_label,
                        labelStyle: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.blueGrey.shade200, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 14),
                      ),
                      style: GoogleFonts.roboto(fontSize: 16),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newPasswordCtrl,
                      decoration: InputDecoration(
                        labelText: context.t.nuova_password_label,
                        labelStyle: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.blueGrey.shade200, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 14),
                      ),
                      style: GoogleFonts.roboto(fontSize: 16),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPasswordCtrl,
                      decoration: InputDecoration(
                        labelText: context.t.conferma_password_label,
                        labelStyle: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                              color: Colors.blueGrey.shade200, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 14),
                      ),
                      style: GoogleFonts.roboto(fontSize: 16),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.lock_reset),
                      label: Text(context.t.button_cambia_password),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      onPressed: () async {
                        final oldPassword = _oldPasswordCtrl.text;
                        final newPassword = _newPasswordCtrl.text;
                        final confirmPassword = _confirmPasswordCtrl.text;

                        final passwordRegExp =
                            RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');

                        if (oldPassword.isEmpty ||
                            newPassword.isEmpty ||
                            confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(context.t.compila_tutti_campi)),
                          );
                          return;
                        }
                        if (newPassword != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text(context.t.password_non_coincidono)),
                          );
                          return;
                        }
                        if (newPassword == oldPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    context.t.password_diversa_dalla_attuale)),
                          );
                          return;
                        }
                        if (!passwordRegExp.hasMatch(newPassword)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(context.t.password_controllo)),
                          );
                          return;
                        }

                        final url =
                            Uri.parse('$apiBaseUrl/change_password.php');
                        final res = await http.post(
                          url,
                          headers: _authHeaders(_jwtToken!),
                          body: json.encode({
                            'utente_id': widget.utenteId,
                            'old_password': oldPassword,
                            'new_password': newPassword,
                          }),
                        );
                        final data = json.decode(res.body);
                        if (data['ok'] == true || data['success'] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(context.t.password_cambiata)),
                          );
                          _oldPasswordCtrl.clear();
                          _newPasswordCtrl.clear();
                          _confirmPasswordCtrl.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(data['error'] ??
                                    context.t.password_errore)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              //-----------------------------------------------------
              // ... dentro la tua colonna/lista impostazioni:
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 1,
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Request account cancellation'),
                      subtitle: const Text(
                          'Removes profile, activities, locations, and linked subscriptions'),
                      onTap: () =>
                          _openUrl('https://mytrak.app/delete-account.html'),
                      // in alternativa: onLongPress: _emailSupport, per shortcut email
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy Policy'),
                      onTap: () => _openUrl('https://mytrak.app/privacy.html'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Terms of Service'),
                      onTap: () => _openUrl('https://mytrak.app/terms.html'),
                    ),
                    // opzionale: contatto diretto
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Support to mail'),
                      subtitle: const Text('support@mytrak.app'),
                      onTap: _emailSupport,
                    ),
                  ],
                ),
              ),
              //-----------------------------------------------------

              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(context.t.imposta_page_save),
                  onPressed: () async {
                    await _salvaDatiPersonali();
                    await _salvaImpostazioniUtente();

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.t.imposta_page_mess6)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
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
                foregroundColor: Colors.black87, // icona + testo
                backgroundColor:
                    Colors.grey[200], // sfondo bottone (se vuoi chiaro)
              ),
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

  //-----------------------------------------------------------------
  // Salva dati personali
  //-----------------------------------------------------------------
  Future<void> _salvaDatiPersonali() async {
    final url = Uri.parse('$apiBaseUrl/utenti_write.php');
    final body = {
      'id': datiUtente?['id']?.toString(),
      'email': datiUtente?['email'] ?? '',
      'nome': datiUtente?['nome'] ?? '',
      'genere': datiUtente?['genere'],
      'fascia_eta': datiUtente?['fascia_eta'],
      'professione': datiUtente?['professione'],
      'piano_attivo_id': datiUtente?['piano_attivo_id'],
      'country_code': datiUtente?['country_code'],
    };

    try {
      final response = await http.post(
        url,
        headers: _authHeaders(_jwtToken!),
        body: json.encode(body),
      );
      final data = json.decode(response.body);
      if (data is Map && (data['ok'] == true || data['success'] == true)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.imposta_page_mess1)),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${context.t.imposta_page_mess2} ${data['error'] ?? data['message'] ?? context.t.imposta_page_mess3}',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.imposta_page_mess4)));
    }
  }

  //----------------------------------------------------------------
  // Salva impostazioni utente
  //----------------------------------------------------------------
  Future<void> _salvaImpostazioniUtente() async {
    final url = Uri.parse('$apiBaseUrl/consensi_write.php');
    final body = {
      'utente_id': datiUtente?['id']?.toString(),
      'consenso_marketing': impostazioniUtente?['consenso_marketing'] ?? 0,
      'consenso_premi': impostazioniUtente?['consenso_premi'] ?? 0,
      'consenso_privacy': impostazioniUtente?['consenso_privacy'] ?? 0,
      'consenso_ai': impostazioniUtente?['consenso_ai'] ?? 0,
      'data_consenso': impostazioniUtente?['data_consenso'],
      'frequenza_tracking':
          impostazioniUtente?['frequenza_tracking_sec']?.toString(),
      'notifiche_attive': impostazioniUtente?['notifiche_attive'] ?? 0,
      'tracking_gps': impostazioniUtente?['tracking_gps'] ?? 0,
      'tracking_modalita': impostazioniUtente?['tracking_modalita'] ?? '',
    };

    try {
      final response = await http.post(
        url,
        headers: _authHeaders(_jwtToken!),
        body: json.encode(body),
      );
      final data = json.decode(response.body);
      if (data is Map && (data['ok'] == true || data['success'] == true)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.imposta_page_mess5)),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${context.t.imposta_page_mess2} ${data['error'] ?? data['message'] ?? context.t.imposta_page_mess3}',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.imposta_page_mess4)));
    }
  }

//-------------------------------------------------------------------
// Carica le esclusioni temporali
//-------------------------------------------------------------------
  Future<List<EsclusioneTemporale>> caricaEsclusioniTemporali() async {
    final url = Uri.parse(
        '$apiBaseUrl/esclusioni_temporali.php?utente_id=${widget.utenteId}');
    final res = await http.get(url, headers: _authHeaders(_jwtToken!));
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      if (j['ok'] == true && j['data'] is List) {
        return (j['data'] as List)
            .map((e) => EsclusioneTemporale.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  //--------------------------------------------------------------------
  // Salva esclusione temporale
  //--------------------------------------------------------------------
  Future<bool> salvaEsclusioneTemporale(EsclusioneTemporale esclusione) async {
    final url = Uri.parse('$apiBaseUrl/esclusioni_temporali_save.php');

    final res = await http.post(
      url,
      headers: _authHeaders(_jwtToken!),
      body: json.encode(esclusione.toJson()),
    );
    if (res.statusCode == 200) {
      final j = json.decode(res.body);
      return j['ok'] == true || j['success'] == true;
    }
    return false;
  }
}

//---------------------------------------------------------------------
// Apri URL esterno
//---------------------------------------------------------------------
Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // fallback silenzioso, oppure mostra uno SnackBar
  }
}

//---------------------------------------------------------------------
// Invia email al supporto
//---------------------------------------------------------------------
Future<void> _emailSupport() async {
  final uri = Uri(
    scheme: 'mailto',
    path: 'support@mytrak.app',
    queryParameters: {
      'subject': 'MoveUP – account cancellation request',
      'body':
          'Hi, I would like to delete my account.\nEmail: \nUser ID (if known): \nNote: ',
    },
  );
  await launchUrl(uri);
}
