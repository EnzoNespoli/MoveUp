// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'MoveUP';

  @override
  String get appSubTitle => 'Il tuo assistente di movimento';

  @override
  String get subscriptions => 'Abbonamenti';

  @override
  String welcomeUser(String name) {
    return 'Benvenuto, $name!';
  }

  @override
  String get anonymousUser => 'Utente Anonimo';

  @override
  String get lingua_sistema => 'Lingua di sistema';

  @override
  String get priceFree => 'Gratis';

  @override
  String pricePerMonth(String price) {
    return '$price/mese';
  }

  @override
  String durationDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# giorni',
      one: '# giorno',
    );
    return '$_temp0';
  }

  @override
  String get features => 'Funzioni';

  @override
  String get buy => 'Acquista';

  @override
  String get active => 'Attivo';

  @override
  String get thisIsYourPlan => 'Questo è il tuo piano!';

  @override
  String get sessionExpired => 'Sessione scaduta. Effettua di nuovo il login.';

  @override
  String get durata_abbonamento => 'Durata:';

  @override
  String get onb1 => 'Cosa fa MoveUP?';

  @override
  String get onb1_body => 'MoveUP ti mostra quanto del tuo tempo sei fermo, ti stai muovendo lentamente o veloce.\nSarà una scoperta!';

  @override
  String get onb2 => 'Come funziona';

  @override
  String get onb2_body => '• Avvia il tracciamento\n• Muoviti 10 minuti\n• Apri il riepilogo serale\n• Condividilo con chi vuoi';

  @override
  String get onb3 => 'Pronti a iniziare?';

  @override
  String get onb3_body => 'Accetta le condizioni e attiva il tracciamento.\nRegistrati GRATIS.\nAvrai la settimana sotto controllo.';

  @override
  String get botton_salta => 'Salta';

  @override
  String get condizioni_uso => 'Ho letto e accettato le ';

  @override
  String get condizioni_uso2 => 'Condizioni d\'uso';

  @override
  String get privacy_policy => ' e la ';

  @override
  String get privacy_policy2 => 'Privacy Policy';

  @override
  String get botton_prosegui => 'Inizia adesso!';

  @override
  String get botton_indietro => 'Indietro';

  @override
  String get botton_avanti => 'Avanti';

  @override
  String get errore_001 => 'Permesso posizione negato';

  @override
  String get errore_002 => 'Permesso posizione negato per sempre';

  @override
  String get errore_003 => 'Errore ottenimento posizione:';

  @override
  String get errore_004 => 'Location service disabilitato sul dispositivo';

  @override
  String get user_err01 => 'Errore inizializza utente:';

  @override
  String get user_err02 => 'Utente errato';

  @override
  String get user_err03 => 'Ultimo accesso aggiornato per utente';

  @override
  String get user_err04 => 'Errore aggiornamento ultimo accesso';

  @override
  String get user_err05 => 'Login fallito';

  @override
  String get user_err06 => 'Login';

  @override
  String get user_err07 => 'Registrati';

  @override
  String get user_login_success => 'Login avvenuto con successo!';

  @override
  String get gps_err01 => 'Tracciamento GPS disattivato: attivalo nelle impostazioni.';

  @override
  String get gps_err02 => 'Errore salvataggio posizione:';

  @override
  String get gps_err03 => 'Tracciamento GPS disattivato: la posizione non viene registrata.';

  @override
  String get gps_err04 => 'Permesso posizione negato';

  @override
  String get gps_err05 => 'Permesso posizione negato per sempre';

  @override
  String get gps_err06 => 'Segnale GPS debole, attendi una posizione migliore';

  @override
  String get gps_err07 => 'Errore ottenimento posizione:';

  @override
  String get gps_err08 => 'Posizione salvata!';

  @override
  String get gps_err09 => 'Errore salvataggio posizione:';

  @override
  String get gps_err10 => 'DEBUG API leggi consensi:';

  @override
  String get gps_err11 => 'DEBUG API valore consenso GPS:';

  @override
  String get gps_err12 => 'Tracciamento GPS ';

  @override
  String get gps_err13 => 'Devi attivare il consenso al tracciamento GPS nelle impostazioni';

  @override
  String get gps_err14 => 'Tracciamento in ascolto';

  @override
  String get gps_err15 => 'Tracciamento spento';

  @override
  String get gps_err16 => 'Prossima rilevazione tra';

  @override
  String get gps_err17 => 'GPS Attivo';

  @override
  String get gps_err18 => 'GPS Disattivo';

  @override
  String get gps_err19 => 'Diario di bordo GPS';

  @override
  String get gps_err20 => 'Nessun evento ancora registrato.';

  @override
  String get gps_err21 => 'In pausa';

  @override
  String get gps_err22 => 'In ascolto';

  @override
  String get gps_err23 => 'Avvia tracciamento';

  @override
  String get gps_err24 => 'Riprendi tracciamento';

  @override
  String get gps_err25 => 'Pausa tracciamento';

  @override
  String get gps_err26 => 'Riprendi tracciamento';

  @override
  String get att_err01 => 'Errore ricalcolo attività:';

  @override
  String get att_err02 => 'invariato rispetto a ieri';

  @override
  String get att_err03 => 'rispetto a ieri';

  @override
  String get att_err04 => 'Espandi per vedere i dettagli...';

  @override
  String get att_err05 => 'Nessuna sessione registrata';

  @override
  String get info_mes01 => 'Inizio:';

  @override
  String get info_mes02 => 'Fine:';

  @override
  String get info_mes03 => 'Durata:';

  @override
  String get info_mes04 => 'Distanza:';

  @override
  String get info_mes05 => 'Fonte:';

  @override
  String get info_mes06 => 'Passi stimati:';

  @override
  String get info_mes07 => 'Capisci come ti muovi';

  @override
  String get info_mes08 => 'Scopri come impieghi il tuo tempo';

  @override
  String get mov_inattivo => 'Fermo / Pausa';

  @override
  String get mov_leggero => 'Movimento lento';

  @override
  String get mov_veloce => 'Spostamento veloce';

  @override
  String get chart_mes01 => 'Nessun grafico disponibile al momento.';

  @override
  String get chart_mes02 => 'Timeline Livelli Giornaliero';

  @override
  String get chart_mes03 => 'Intervallo un ora';

  @override
  String get chart_mes04 => 'Distribuzione Livelli Giornaliero';

  @override
  String get chart_mes05 => 'Intervallo un ora';

  @override
  String get chart_mes06 => 'Impossibile generare l’immagine. Riprova.';

  @override
  String get chart_mes07 => 'Il mio Report MoveUP di oggi';

  @override
  String get cahrt_mes08 => 'Errore condivisione:';

  @override
  String get chart_mes09 => 'Report MoveUP di oggi';

  @override
  String get chart_mes10 => 'Timeline Livelli (a corsie)';

  @override
  String get um_metri => 'Metri:';

  @override
  String get um_passi => 'Passi:';

  @override
  String get um_km => 'Km:';

  @override
  String get form_reg_testa => 'Registrazione';

  @override
  String get form_reg_nome => 'Nome';

  @override
  String get form_reg_mail => 'Email';

  @override
  String get form_reg_password => 'Password';

  @override
  String get form_reg_err01 => 'Inserisci il nome';

  @override
  String get form_reg_err02 => 'Inserisci una email valida';

  @override
  String get form_reg_err03 => 'La password deve avere almeno 8 caratteri, una maiuscola e un numero';

  @override
  String get form_reg_err04 => 'Registrazione avvenuta! Verifica la tua mail e puoi fare login.';

  @override
  String get form_reg_err05 => 'Registrazione fallita';

  @override
  String get form_reg_genere => 'Genere';

  @override
  String get form_reg_maschio => 'Maschio';

  @override
  String get form_reg_femmina => 'Femmina';

  @override
  String get form_reg_professione => 'Professione';

  @override
  String get form_reg_eta => 'Fascia di età';

  @override
  String get form_reg_ult_accesso => 'Ultimo accesso';

  @override
  String get form_reg_consensi => 'Impostazioni e consensi';

  @override
  String get form_reg_gps => 'Tracciamento GPS';

  @override
  String get form_reg_err06 => 'Le password non coincidono';

  @override
  String get form_reg_country => 'Nazione di residenza';

  @override
  String get cambio_password => 'Cambio password';

  @override
  String get password_attuale_label => 'Password attuale';

  @override
  String get nuova_password_label => 'Nuova password';

  @override
  String get conferma_password_label => 'Conferma nuova password';

  @override
  String get button_cambia_password => 'Cambia password';

  @override
  String get compila_tutti_campi => 'Compila tutti i campi';

  @override
  String get password_non_coincidono => 'Le nuove password non coincidono';

  @override
  String get password_diversa_dalla_attuale => 'La nuova password deve essere diversa da quella attuale';

  @override
  String get password_controllo => 'La password deve avere almeno 8 caratteri, includere una lettera maiuscola e un numero';

  @override
  String get password_cambiata => 'Password cambiata con successo!';

  @override
  String get password_errore => 'Errore nel cambio password';

  @override
  String get password_dimenticata => 'Hai dimenticato la password?';

  @override
  String get reimposta_password => 'Reimposta password';

  @override
  String get inserisci_mail => 'Inserisci la tua email per ricevere il link di reimpostazione.';

  @override
  String get inserisci_tua_mail => 'Inserisci la tua email';

  @override
  String get link_mail_password => 'Se l’email è registrata, ti abbiamo inviato un link per reimpostare la password.';

  @override
  String get invia_richiesta_label => 'Invia richiesta';

  @override
  String get condividi_button => '';

  @override
  String get form_consensi_01 => 'Consensi';

  @override
  String get form_consensi_02 => 'Acconsento al trattamento dei dati (privacy)';

  @override
  String get form_consensi_03 => 'Acconsento a ricevere comunicazioni marketing';

  @override
  String get form_consensi_04 => 'Acconsento a partecipare a premi e concorsi';

  @override
  String get form_consensi_05 => 'Acconsento al tracciamento GPS';

  @override
  String get form_consensi_06 => 'Conferma';

  @override
  String get form_consensi_er => 'Errore salvataggio consensi .. :';

  @override
  String get session_expired => 'Sessione scaduta. Effettua di nuovo il login.';

  @override
  String get token_invalid => 'Token non valido: riesegui il login.';

  @override
  String get payment_mes1 => 'Illimitato';

  @override
  String get payment_mes2 => 'Scaduto';

  @override
  String get payment_mes3 => '1 gg rim.';

  @override
  String get payment_mes4 => 'gg rim.';

  @override
  String get bottom_impostazioni => 'Impostazioni';

  @override
  String get bottom_cronologia => 'Attività';

  @override
  String get bottom_profilo => 'Profilo';

  @override
  String get bottom_abbonamenti => 'Abbonamenti';

  @override
  String get bottom_dashboard => 'Home';

  @override
  String get bottom_impostazioni_short => 'Imp.';

  @override
  String get bottom_cronologia_short => 'Att.';

  @override
  String get bottom_profilo_short => 'Prof.';

  @override
  String get bottom_abbonamenti_short => 'Abb.';

  @override
  String get bottom_err01 => 'Funzione disponibile solo per utenti registrati!';

  @override
  String get bottom_err02 => 'Utente ERRATO!';

  @override
  String get bottom_nome => 'Nome';

  @override
  String get bottom_logout => 'Logout';

  @override
  String get map_mes_01 => 'Aggiorna posizione';

  @override
  String get rep_day_mes01 => 'Report Giornaliero';

  @override
  String get rep_day_mes02 => 'Ultima posizione';

  @override
  String get storico_01 => 'Scegli quanto storico vuoi tenere. Il resto cresce con te.';

  @override
  String get storico_02 => 'Free (Anonimo)';

  @override
  String get storico_03 => 'Usa l’app senza registrarti.\nLa posizione può essere rilevata anche in background per calcolare in tempo reale distanza percorsa, tempo in movimento e momenti di sosta.\nI dati restano solo sul tuo dispositivo, valgono solo per la giornata in corso e vengono cancellati automaticamente ogni giorno.\nFunzioni: tracking live e riepilogo del giorno.';

  @override
  String get storico_04 => 'Start (Registrato)';

  @override
  String get storico_05 => 'Account gratuito con storico 7 giorni.\nFunzioni: tracking live e in background, backup cloud, sincronizzazione su più dispositivi, notifiche.';

  @override
  String get storico_06 => 'Basic — 30 giorni (Pagamento)';

  @override
  String get storico_07 => 'Storico di 30 giorni.\nFunzioni: timeline giornaliera avanzata, metriche per livello (fermo/lento/veloce), luoghi e percorsi ripetuti.';

  @override
  String get storico_08 => 'Plus — 180 giorni (Pagamento)';

  @override
  String get storico_09 => 'Storico di 6 mesi.\nFunzioni: tutto di Basic + analisi dei percorsi/luoghi ricorrenti con riepiloghi settimanali/mensili.';

  @override
  String get storico_10 => 'Pro — 365 giorni (Pagamento)';

  @override
  String get storico_11 => 'Storico di 1 anno.\nFunzioni: report avanzati, filtri dettagliati, supporto prioritario, niente pubblicità.';

  @override
  String get storico_12 => 'Nota privacy:';

  @override
  String get storico_13 => 'L’app rileva la tua posizione anche in background per calcolare i tuoi spostamenti, la distanza percorsa e il tempo in movimento.\nPuoi cambiare o revocare i consensi in qualsiasi momento.\nSenza consenso al tracking non registriamo posizioni.\nSe usi l’app in modalità anonima (senza registrazione) i dati restano solo sul dispositivo e vengono eliminati automaticamente alla fine della giornata: non teniamo storico dei giorni precedenti e non associamo le posizioni a un profilo personale.';

  @override
  String get storico_14 => '⏳ Caricamento dati…';

  @override
  String get form_crono_01 => 'Attività';

  @override
  String get form_crono_02 => 'Riepilogo attività';

  @override
  String get form_crono_03 => 'Benvenuto, ';

  @override
  String get form_crono_04 => 'Riepilogo ultimi 7 giorni';

  @override
  String get form_crono_05 => 'Nessuna sessione registrata';

  @override
  String get form_crono_06 => 'Livello';

  @override
  String get form_crono_07 => 'Visualizza dettagli';

  @override
  String get form_crono_08 => 'Dettagli Livello';

  @override
  String get form_crono_09 => 'Dettagli per il Livello';

  @override
  String get form_crono_10 => 'Riepilogo da 8 a 14 giorni';

  @override
  String get form_crono_11 => 'Confronto settimanale';

  @override
  String get dashboard_piano => 'Piano:';

  @override
  String get dashboard_msg => 'Vai su Profilo e registrati.\nAvrai la tua settimana tipo';

  @override
  String get imposta_page_studente => 'Studente';

  @override
  String get imposta_page_impiegato => 'Impiegato';

  @override
  String get imposta_page_libero => 'Professionista';

  @override
  String get imposta_page_disoccupato => 'Disoccupato';

  @override
  String get imposta_page_pensionato => 'Pensionato';

  @override
  String get imposta_page_altro => 'Altro';

  @override
  String get imposta_page_lista => 'Studente,Impiegato,Professionista,Disoccupato,Pensionato,Altro';

  @override
  String get imposta_page_miei => 'I miei dati personali';

  @override
  String get imposta_page_notifiche => 'Notifiche attive';

  @override
  String get imposta_page_consenso => 'Consenso privacy';

  @override
  String get imposta_page_marketing => 'Consenso marketing';

  @override
  String get imposta_page_premi => 'Consenso premi';

  @override
  String get imposta_page_datac => 'Data consenso';

  @override
  String get imposta_page_frequenza => 'Frequenza tracciamento (sec)';

  @override
  String get imposta_page_piani => 'Piani abbonamento';

  @override
  String get imposta_page_importo => 'Importo:';

  @override
  String get imposta_page_durata => 'Durata:';

  @override
  String get imposta_page_cancella => 'Cancellazione dati: dopo ';

  @override
  String get imposta_page_funzioni => 'Funzioni attive:';

  @override
  String get imposta_page_save => 'Salva modifiche';

  @override
  String get imposta_page_mess1 => 'Dati personali aggiornati!';

  @override
  String get imposta_page_mess2 => 'Errore: ';

  @override
  String get imposta_page_mess3 => 'Impossibile aggiornare.';

  @override
  String get imposta_page_mess4 => 'Errore di rete.';

  @override
  String get imposta_page_mess5 => 'Impostazioni aggiornate! ';

  @override
  String get imposta_page_mess6 => 'Dati salvati!';

  @override
  String get footer_page_diritti => '© 2025 MoveUP - Tutti i diritti riservati';

  @override
  String get footer_page_banner => 'Your Personal Move';

  @override
  String get footer_page_versione => 'Versione app:';

  @override
  String get header_page_banner => 'Your Personal Move';

  @override
  String get rep_day_export_locked => 'La condivisione richiede START/BASIC/PLUS/PRO';

  @override
  String get msg_abilitato_01 => 'Registrati per vedere la distribuzione di oggi';

  @override
  String get msg_abilitato_02 => 'Timeline disponibile con BASIC. Prima registrati.';

  @override
  String get crono_msg_01 => 'Registrati per vedere il percorso del giorno.';

  @override
  String get crono_msg_02 => 'Il tuo piano consente fino a';

  @override
  String get crono_msg_03 => 'giorni di storico.';

  @override
  String get crono_msg_04 => 'Percorso non disponibile. Riprova.';

  @override
  String get crono_msg_05 => 'Errore sconosciuto';

  @override
  String get card_percorso_1 => 'Seleziona data';

  @override
  String get card_percorso_2 => 'Annulla';

  @override
  String get card_percorso_3 => 'Ok';

  @override
  String get card_percorso_4 => 'Percorso del';

  @override
  String get card_percorso_5 => 'Nessun movimento in questa data';

  @override
  String get feat_tracking_live => 'Tracciamento live';

  @override
  String get feat_report_basic => 'Report giornaliero (base)';

  @override
  String get feat_report_advanced => 'Timeline giornaliera avanzata';

  @override
  String get feat_places_routes => 'Luoghi e percorsi ripetuti';

  @override
  String get feat_export_gpx => 'Esportazione GPX';

  @override
  String get feat_export_csv => 'Esportazione CSV';

  @override
  String get feat_notifications => 'Notifiche';

  @override
  String get feat_backup_cloud => 'Backup cloud';

  @override
  String get feat_rewards => 'Premi';

  @override
  String get feat_priority_support => 'Supporto prioritario';

  @override
  String get feat_no_ads => 'Senza banner pubblicitari';

  @override
  String get feat_history_days => 'Storico consultabile';

  @override
  String get days => 'giorni';

  @override
  String get feat_gps => 'Parametri GPS del piano';

  @override
  String get feat_gps_sample_sec => 'Campionamento (secondi)';

  @override
  String get feat_gps_min_distance_m => 'Distanza minima (metri)';

  @override
  String get feat_gps_upload_sec => 'Invio in batch (secondi)';

  @override
  String get feat_gps_background => 'Tracciamento in background';

  @override
  String get gps_accuracy_mode => 'Modalità precisione';

  @override
  String get feat_gps_max_acc_m => 'Massima accuratezza (metri)';

  @override
  String get feat_gps_accuracy_mode => 'Modalità precisione';

  @override
  String get accuracy_low => 'Bassa';

  @override
  String get accuracy_balanced => 'Bilanciata';

  @override
  String get accuracy_high => 'Alta';

  @override
  String get accuracy_best => 'Massima';

  @override
  String get unit_seconds => 'secondi';

  @override
  String get unit_meters => 'metri';

  @override
  String gps_next_fix(Object s) {
    return 'Prossima rilevazione tra ${s}s';
  }

  @override
  String get escl_prog_01 => 'Esclusioni programmate';

  @override
  String get escl_prog_02 => 'Esclusioni disponibili solo da Livello Basic';

  @override
  String get escl_prog_03 => 'Aggiungi esclusione';

  @override
  String get escl_prog_04 => 'Nessuna esclusione programmata impostata.';

  @override
  String get escl_prog_05 => 'Modifica';

  @override
  String get escl_prog_06 => 'Nuova esclusione';

  @override
  String get escl_prog_07 => 'Modifica esclusione';

  @override
  String get escl_prog_08 => 'Ora inizio';

  @override
  String get escl_prog_09 => 'Ora fine';

  @override
  String get escl_prog_10 => 'Note';

  @override
  String get escl_prog_11 => 'Attiva';

  @override
  String get escl_prog_12 => 'Giorni attivi:';

  @override
  String get escl_prog_13 => 'Annulla';

  @override
  String get escl_prog_14 => 'Salva';

  @override
  String get verifica_mail_titolo => 'Verifica la tua email';

  @override
  String get verifica_mail_testo1 => 'Controlla la posta e clicca sul link di verifica.';

  @override
  String get verifica_mail_testo2 => 'Quando hai verificato, torna al login per accedere.';

  @override
  String get verifica_mail_testo3 => 'Quando hai verificato, torna al login per accedere.';

  @override
  String get verifica_mail_testo4 => 'Ho verificato, torna alla dashboard';

  @override
  String get verifica_mail_erro1 => 'Email inviata!';

  @override
  String get verifica_mail_erro2 => 'Errore invio email.';

  @override
  String get verifica_mail_button => 'Reinvia email';

  @override
  String get acquisto_piano_conferma => 'Conferma acquisto';

  @override
  String get acquisto_piano_info => 'Le tue informazioni.';

  @override
  String get acquisto_piano_id => 'ID utente:';

  @override
  String get acquisto_piano_nome => 'Nome:';

  @override
  String get acquisto_piano_mail => 'Email:';

  @override
  String get acquisto_piano_durata => 'Durata:';

  @override
  String get acquisto_piano_pagamento => 'Procedi con pagamento';

  @override
  String get acquisto_piano_stripe => 'Verrai indirizzato su Stripe...';

  @override
  String get acquisto_piano_google => 'Verrai indirizzato su Google...';

  @override
  String get acquisto_piano_nopaga => 'Pagamento non avviato:';

  @override
  String get acquisto_piano_attivo => 'Piano attivato!';

  @override
  String get card_settimana => 'Settimana';

  @override
  String get card_gio_today => 'Adesso';

  @override
  String get card_gio_lunedi => 'Lunedì';

  @override
  String get card_gio_martedi => 'Martedì';

  @override
  String get card_gio_mercoledi => 'Mercoledì';

  @override
  String get card_gio_giovedi => 'Giovedì';

  @override
  String get card_gio_venerdi => 'Venerdì';

  @override
  String get card_gio_sabato => 'Sabato';

  @override
  String get card_gio_domenica => 'Domenica';

  @override
  String get today_title => 'Oggi';

  @override
  String get today_title_closed => 'Oggi — giornata conclusa';

  @override
  String get badge_partial => 'Dati parziali';

  @override
  String get kpi_active => 'Tempo in movimento';

  @override
  String get kpi_km => 'Km';

  @override
  String get kpi_sedentary => 'Pause / Fermo';

  @override
  String get no_data_msg => 'Non abbiamo ancora dati per oggi.';

  @override
  String get check_location => 'Permessi posizione';

  @override
  String get check_battery => 'Risparmio batteria';

  @override
  String get check_gps => 'Stato GPS';

  @override
  String get insight_quality => 'Stiamo perdendo dati per il risparmio batteria. Tocca per sistemare.';

  @override
  String get insight_goal_hit => 'Hai raggiunto il tempo di movimento previsto oggi.';

  @override
  String insight_goal_missing(Object v1) {
    return 'Ti mancano $v1 min per il tempo di movimento previsto.';
  }

  @override
  String insight_vs_yesterday(Object v2) {
    return 'Oggi sei al $v2% rispetto a ieri.';
  }

  @override
  String get fix_qualita_dati => 'Qualità dati';

  @override
  String get fix_message => 'Sistema questi punti per evitare perdite di dati.';

  @override
  String get fix_permessi => 'Permessi posizione (Sempre)';

  @override
  String get fix_permessi_sub => 'Concedi “Sempre” alla posizione';

  @override
  String get fix_gps_attivo => 'GPS attivo e Alta precisione';

  @override
  String get fix_gps_attivo_sub => 'Apri impostazioni Localizzazione';

  @override
  String get fix_auto_start => 'Autostart / Protezione app';

  @override
  String get fix_auto_ricontrolla => 'Ricontrolla';

  @override
  String get fix_battery => 'Disattiva risparmio batteria per MoveUP';

  @override
  String get fix_battery_sub => 'Consenti “Ignora ottimizzazione batteria”';

  @override
  String get fix_vendor_01 => 'MIUI: Sicurezza → Autorizzazioni → Avvio automatico + Risparmio batteria.';

  @override
  String get fix_vendor_02 => 'EMUI: Impostazioni → Batteria → Avvio app (consenti avvio & background).';

  @override
  String get fix_vendor_03 => 'ColorOS/Funtouch: Abilita Avvio automatico e rimuovi ottimizzazione aggressiva.';

  @override
  String get fix_vendor_04 => 'OnePlus: Batteria → Ottimizzazione batteria → MoveUP → Non ottimizzare.';

  @override
  String get fix_vendor_05 => 'Samsung: Cura dispositivo → Batteria → App in sospensione: rimuovi MoveUP.';

  @override
  String get fix_vendor_06 => 'Controlla Autostart e protezione app del produttore.';

  @override
  String get fix_messag_01 => 'Vai in Impostazioni → Privacy e sicurezza → Localizzazione → MoveUP\nimposta “Sempre” e attiva “Posizione precisa”.\nControlla anche Risparmio energia: potrebbe ridurre le attività in background.';

  @override
  String get fix_chiudi_button => 'Chiudi';

  @override
  String get fix_riduci_button => 'Riduci';

  @override
  String get fix_espandi_button => 'Espandi';

  @override
  String get dettagli => 'Dettagli tecnici del giorno';

  @override
  String get posizione => 'La tua posizione';

  @override
  String get export_day => 'Esporta dati del giorno';

  @override
  String get date_parse_error => 'Errore lettura data';

  @override
  String get export_started => 'Esportazione avviata...';

  @override
  String get download_start => 'Download avviato nel browser';

  @override
  String get esportazione_file => 'Esportazione:';

  @override
  String get errore_http => 'Errore download: HTTP';

  @override
  String get errore_generico => 'Errore esportazione:';

  @override
  String get dedica_title => 'Dedicato a…';

  @override
  String get dedica_testo => 'Mia moglie e Lova, che mi hanno dato la forza di arrivare fino a qui. 💚🐾';

  @override
  String get analisi_oggi => 'Analisi di oggi';

  @override
  String get movimento => 'Movimento';

  @override
  String get non_reg => 'Non registrato';

  @override
  String get parziale => 'Parziale';

  @override
  String get completo => 'Completo';

  @override
  String get dati_incompleti => 'Dati incompleti: il telefono non ha registrato per circa';

  @override
  String get ottima_attivita => 'Ottima attività oggi';

  @override
  String get buona_attivita => 'Buona attività, una parte della giornata l\'hai usata bene.';

  @override
  String get giorno_statico1 => 'Giornata piuttosto statica ';

  @override
  String get giorno_statico2 => 'fermo/pausa';

  @override
  String get attivita_media => 'Attività nella media.';

  @override
  String get attivita_giorno => 'Nessuna attività registrata oggi.';
}
