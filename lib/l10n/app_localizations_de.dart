// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'MoveUP';

  @override
  String get appSubTitle => 'Dein Bewegungsassistent';

  @override
  String get subscriptions => 'Abonnements';

  @override
  String welcomeUser(String name) {
    return 'Willkommen, $name!';
  }

  @override
  String get anonymousUser => 'Anonymer Benutzer';

  @override
  String get lingua_sistema => 'Systemsprache';

  @override
  String get priceFree => 'Kostenlos';

  @override
  String pricePerMonth(String price) {
    return '$price/Monat';
  }

  @override
  String durationDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# Tage',
      one: '# Tag',
    );
    return '$_temp0';
  }

  @override
  String get features => 'Funktionen';

  @override
  String get buy => 'Kaufen';

  @override
  String get active => 'Aktiv';

  @override
  String get thisIsYourPlan => 'Das ist dein Plan!';

  @override
  String get sessionExpired => 'Sitzung abgelaufen. Bitte erneut einloggen.';

  @override
  String get durata_abbonamento => 'Dauer:';

  @override
  String get onb1 => 'Erfasse und organisiere deine Bewegungen an einem Ort.';

  @override
  String get onb2 => 'Sieh, wohin deine Zeit geht: zu Hause, Arbeit, Pendelstrecken.';

  @override
  String get onb3 => 'Automatische Berichte und Trends: verbessere dich mit Daten.';

  @override
  String get botton_salta => 'Überspringen';

  @override
  String get condizioni_uso => 'Ich habe die ';

  @override
  String get condizioni_uso2 => 'Nutzungsbedingungen';

  @override
  String get privacy_policy => 'und die ';

  @override
  String get privacy_policy2 => 'Datenschutzrichtlinie akzeptiert';

  @override
  String get botton_prosegui => 'Weiter';

  @override
  String get botton_indietro => 'Zurück';

  @override
  String get botton_avanti => 'Weiter';

  @override
  String get errore_001 => 'Standorterlaubnis verweigert';

  @override
  String get errore_002 => 'Standorterlaubnis dauerhaft verweigert';

  @override
  String get errore_003 => 'Fehler beim Abrufen des Standorts:';

  @override
  String get errore_004 => 'Standortdienst auf dem Gerät deaktiviert';

  @override
  String get user_err01 => 'Fehler beim Initialisieren des Benutzers:';

  @override
  String get user_err02 => 'Falscher Benutzer';

  @override
  String get user_err03 => 'Letzter Zugriff für Benutzer aktualisiert';

  @override
  String get user_err04 => 'Fehler beim Aktualisieren des letzten Zugriffs';

  @override
  String get user_err05 => 'Login fehlgeschlagen';

  @override
  String get user_err06 => 'Login';

  @override
  String get user_err07 => 'Registrieren';

  @override
  String get gps_err01 => 'GPS-Tracking deaktiviert: Bitte in den Einstellungen aktivieren.';

  @override
  String get gps_err02 => 'Fehler beim Speichern des Standorts:';

  @override
  String get gps_err03 => 'GPS-Tracking deaktiviert: Standort wird nicht aufgezeichnet.';

  @override
  String get gps_err04 => 'Standorterlaubnis verweigert';

  @override
  String get gps_err05 => 'Standorterlaubnis dauerhaft verweigert';

  @override
  String get gps_err06 => 'GPS-Signal schwach, bitte auf bessere Position warten';

  @override
  String get gps_err07 => 'Fehler beim Abrufen des Standorts:';

  @override
  String get gps_err08 => 'Standort gespeichert!';

  @override
  String get gps_err09 => 'Fehler beim Speichern des Standorts:';

  @override
  String get gps_err10 => 'DEBUG API Lese Einwilligungen:';

  @override
  String get gps_err11 => 'DEBUG API Wert GPS-Einwilligung:';

  @override
  String get gps_err12 => 'GPS-Tracking:';

  @override
  String get gps_err13 => 'Du musst die GPS-Tracking-Einwilligung in den Einstellungen aktivieren';

  @override
  String get gps_err14 => 'Tracking aktiv';

  @override
  String get gps_err15 => 'Tracking deaktiviert';

  @override
  String get gps_err16 => 'Nächste Erfassung in';

  @override
  String get gps_err17 => 'GPS Aktiv';

  @override
  String get gps_err18 => 'GPS Inaktiv';

  @override
  String get gps_err19 => 'GPS-Logbuch';

  @override
  String get gps_err20 => 'Noch keine Veranstaltungen registriert.';

  @override
  String get att_err01 => 'Fehler bei Aktivitätsneuberechnung:';

  @override
  String get att_err02 => 'unverändert gegenüber gestern';

  @override
  String get att_err03 => 'im Vergleich zu gestern';

  @override
  String get att_err04 => 'Erweitern, um Details zu sehen...';

  @override
  String get att_err05 => 'Keine Sitzung aufgezeichnet';

  @override
  String get info_mes01 => 'Beginn:';

  @override
  String get info_mes02 => 'Ende:';

  @override
  String get info_mes03 => 'Dauer:';

  @override
  String get info_mes04 => 'Distanz:';

  @override
  String get info_mes05 => 'Quelle:';

  @override
  String get info_mes06 => 'Geschätzte Schritte:';

  @override
  String get info_mes07 => 'Tagesübersicht';

  @override
  String get mov_inattivo => 'Inaktiv oder stillstehend';

  @override
  String get mov_leggero => 'Leichte Bewegung';

  @override
  String get mov_veloce => 'Schnelle Bewegung';

  @override
  String get chart_mes01 => 'Momentan kein Diagramm verfügbar.';

  @override
  String get chart_mes02 => 'Tägliche Level-Timeline';

  @override
  String get chart_mes03 => 'Intervall eine Stunde';

  @override
  String get chart_mes04 => 'Tägliche Level-Verteilung';

  @override
  String get chart_mes05 => 'Intervall eine Stunde';

  @override
  String get chart_mes06 => 'Das Bild konnte nicht erstellt werden. Bitte erneut versuchen.';

  @override
  String get chart_mes07 => 'Mein heutiger MoveUP-Bericht';

  @override
  String get cahrt_mes08 => 'Fehler beim Teilen:';

  @override
  String get chart_mes09 => 'MoveUP-Bericht für heute';

  @override
  String get um_metri => 'Meter:';

  @override
  String get um_passi => 'Schritte:';

  @override
  String get um_km => 'Km:';

  @override
  String get form_reg_testa => 'Registrierung';

  @override
  String get form_reg_nome => 'Name';

  @override
  String get form_reg_mail => 'E-Mail';

  @override
  String get form_reg_password => 'Passwort';

  @override
  String get form_reg_err01 => 'Bitte Name eingeben';

  @override
  String get form_reg_err02 => 'Bitte gültige E-Mail eingeben';

  @override
  String get form_reg_err03 => 'Das Passwort muss mindestens 8 Zeichen, einen Großbuchstaben und eine Zahl enthalten';

  @override
  String get form_reg_err04 => 'Registrierung erfolgreich! Überprüfe deine E-Mails und du kannst dich anmelden.';

  @override
  String get form_reg_err05 => 'Registrierung fehlgeschlagen';

  @override
  String get form_reg_genere => 'Geschlecht';

  @override
  String get form_reg_maschio => 'Männlich';

  @override
  String get form_reg_femmina => 'Weiblich';

  @override
  String get form_reg_professione => 'Beruf';

  @override
  String get form_reg_eta => 'Altersgruppe';

  @override
  String get form_reg_ult_accesso => 'Letzter Zugriff';

  @override
  String get form_reg_consensi => 'Einstellungen und Einwilligungen';

  @override
  String get form_reg_gps => 'GPS-Tracking';

  @override
  String get form_reg_err06 => 'Die Passwörter stimmen nicht überein';

  @override
  String get form_reg_country => 'Aufenthaltsland';

  @override
  String get cambio_password => 'Passwort ändern';

  @override
  String get password_attuale_label => 'Aktuelles Passwort';

  @override
  String get nuova_password_label => 'Neues Passwort';

  @override
  String get conferma_password_label => 'Neues Passwort bestätigen';

  @override
  String get button_cambia_password => 'Passwort ändern';

  @override
  String get compila_tutti_campi => 'Bitte fülle alle Felder aus';

  @override
  String get password_non_coincidono => 'Die neuen Passwörter stimmen nicht überein';

  @override
  String get password_diversa_dalla_attuale => 'Das neue Passwort muss sich vom aktuellen unterscheiden';

  @override
  String get password_controllo => 'Das Passwort muss mindestens 8 Zeichen lang sein und einen Großbuchstaben sowie eine Ziffer enthalten';

  @override
  String get password_cambiata => 'Passwort erfolgreich geändert!';

  @override
  String get password_errore => 'Fehler beim Ändern des Passworts';

  @override
  String get password_dimenticata => 'Passwort vergessen?';

  @override
  String get reimposta_password => 'Passwort zurücksetzen';

  @override
  String get inserisci_mail => 'Gib deine E-Mail-Adresse ein, um den Link zum Zurücksetzen zu erhalten.';

  @override
  String get inserisci_tua_mail => 'E-Mail-Adresse eingeben';

  @override
  String get link_mail_password => 'Wenn die E-Mail registriert ist, haben wir dir einen Link zum Zurücksetzen gesendet.';

  @override
  String get invia_richiesta_label => 'Anfrage senden';

  @override
  String get condividi_button => 'Teilen';

  @override
  String get form_consensi_01 => 'Einwilligungen';

  @override
  String get form_consensi_02 => 'Ich stimme der Datenverarbeitung (Datenschutz) zu';

  @override
  String get form_consensi_03 => 'Ich stimme dem Erhalt von Marketing-Mitteilungen zu';

  @override
  String get form_consensi_04 => 'Ich stimme der Teilnahme an Preisen und Wettbewerben zu';

  @override
  String get form_consensi_05 => 'Ich stimme dem GPS-Tracking zu';

  @override
  String get form_consensi_06 => 'Bestätigen';

  @override
  String get form_consensi_er => 'Fehler beim Speichern der Einwilligungen .. :';

  @override
  String get session_expired => 'Sitzung abgelaufen. Bitte erneut einloggen.';

  @override
  String get token_invalid => 'Ungültiger Token: Bitte erneut einloggen.';

  @override
  String get payment_mes1 => 'Unbegrenzt';

  @override
  String get payment_mes2 => 'Abgelaufen';

  @override
  String get payment_mes3 => '1 Tag übrig';

  @override
  String get payment_mes4 => 'Tage übrig';

  @override
  String get bottom_impostazioni => 'Einstellungen';

  @override
  String get bottom_cronologia => 'Chronik';

  @override
  String get bottom_profilo => 'Profil';

  @override
  String get bottom_abbonamenti => 'Abonnements';

  @override
  String get bottom_err01 => 'Funktion nur für registrierte Benutzer verfügbar!';

  @override
  String get bottom_err02 => 'FALSCHER Benutzer!';

  @override
  String get bottom_nome => 'Name';

  @override
  String get bottom_logout => 'Abmelden';

  @override
  String get map_mes_01 => 'Position aktualisieren';

  @override
  String get rep_day_mes01 => 'Tagesbericht';

  @override
  String get rep_day_mes02 => 'Letzte Position';

  @override
  String get storico_01 => 'Wähle, wie viel Verlauf du behalten möchtest. Der Rest wächst mit dir.';

  @override
  String get storico_02 => 'Free (Anonym)';

  @override
  String get storico_03 => 'App ohne Registrierung nutzen. Verlauf nur für den aktuellen Tag.\nFunktionen: Live-Tracking und Tagesübersicht.';

  @override
  String get storico_04 => 'Start (Registriert)';

  @override
  String get storico_05 => 'Kostenloses Konto mit 7-Tage-Verlauf.\nFunktionen: Live- und Hintergrund-Tracking, Cloud-Backup, Synchronisierung über mehrere Geräte, Benachrichtigungen.';

  @override
  String get storico_06 => 'Basic — 30 Tage (Kostenpflichtig)';

  @override
  String get storico_07 => '30-Tage-Verlauf.\nFunktionen: erweiterte Tageschronik, Metriken pro Niveau (still/langsam/schnell), wiederkehrende Orte und Routen.';

  @override
  String get storico_08 => 'Plus — 180 Tage (Kostenpflichtig)';

  @override
  String get storico_09 => '6-Monats-Verlauf.\nFunktionen: alles aus Basic + Analyse wiederkehrender Routen/Orte mit Wochen-/Monatsübersichten.';

  @override
  String get storico_10 => 'Pro — 365 Tage (Kostenpflichtig)';

  @override
  String get storico_11 => '1-Jahres-Verlauf.\nFunktionen: erweiterte Berichte, detaillierte Filter, priorisierter Support, keine Werbung.';

  @override
  String get storico_12 => 'Hinweis zum Datenschutz:';

  @override
  String get storico_13 => 'Du kannst deine Einwilligung jederzeit ändern oder widerrufen. Ohne Einwilligung zum Tracking speichern wir keine Positionen.';

  @override
  String get storico_14 => '⏳ Daten werden geladen…';

  @override
  String get form_crono_01 => 'Chronik';

  @override
  String get form_crono_02 => 'Chronik der letzten 7 Tage';

  @override
  String get form_crono_03 => 'Willkommen, ';

  @override
  String get form_crono_04 => 'Summen der letzten 7 Tage';

  @override
  String get form_crono_05 => 'Keine Sitzung aufgezeichnet';

  @override
  String get form_crono_06 => 'Level';

  @override
  String get form_crono_07 => 'Details anzeigen';

  @override
  String get form_crono_08 => 'Level-Details';

  @override
  String get form_crono_09 => 'Details für Level';

  @override
  String get dashboard_piano => 'Plan:';

  @override
  String get imposta_page_studente => 'Student';

  @override
  String get imposta_page_impiegato => 'Angestellter';

  @override
  String get imposta_page_libero => 'Selbstständig';

  @override
  String get imposta_page_disoccupato => 'Arbeitslos';

  @override
  String get imposta_page_pensionato => 'Rentner';

  @override
  String get imposta_page_altro => 'Andere';

  @override
  String get imposta_page_lista => 'Student,Angestellter,Selbstständig,Arbeitslos,Rentner,Andere';

  @override
  String get imposta_page_miei => 'Meine persönlichen Daten';

  @override
  String get imposta_page_notifiche => 'Aktive Benachrichtigungen';

  @override
  String get imposta_page_consenso => 'Datenschutzeinwilligung';

  @override
  String get imposta_page_marketing => 'Marketing-Einwilligung';

  @override
  String get imposta_page_premi => 'Gewinnspiel-Einwilligung';

  @override
  String get imposta_page_datac => 'Einwilligungsdatum';

  @override
  String get imposta_page_frequenza => 'Tracking-Frequenz (Sek.)';

  @override
  String get imposta_page_piani => 'Abonnementpläne';

  @override
  String get imposta_page_importo => 'Betrag:';

  @override
  String get imposta_page_durata => 'Dauer:';

  @override
  String get imposta_page_cancella => 'Datenlöschung: nach ';

  @override
  String get imposta_page_funzioni => 'Aktive Funktionen';

  @override
  String get imposta_page_save => 'Änderungen speichern';

  @override
  String get imposta_page_mess1 => 'Persönliche Daten aktualisiert!';

  @override
  String get imposta_page_mess2 => 'Fehler: ';

  @override
  String get imposta_page_mess3 => 'Aktualisierung nicht möglich.';

  @override
  String get imposta_page_mess4 => 'Netzwerkfehler.';

  @override
  String get imposta_page_mess5 => 'Einstellungen aktualisiert!';

  @override
  String get imposta_page_mess6 => 'Daten gespeichert!';

  @override
  String get footer_page_diritti => '© 2025 MoveUP - Alle Rechte vorbehalten';

  @override
  String get footer_page_banner => 'Your Personal Move';

  @override
  String get footer_page_versione => 'App-Version:';

  @override
  String get header_page_banner => 'Your Personal Move';

  @override
  String get rep_day_export_locked => 'Teilen erfordert BASIC/PLUS/PRO';

  @override
  String get msg_abilitato_01 => 'Registriere dich, um die heutige Verteilung zu sehen';

  @override
  String get msg_abilitato_02 => 'Zeitleiste mit BASIC verfügbar. Registriere dich zuerst.';

  @override
  String get crono_msg_01 => 'Registriere dich, um die Route des Tages zu sehen.';

  @override
  String get crono_msg_02 => 'Dein Tarif erlaubt bis zu';

  @override
  String get crono_msg_03 => 'Tage Verlauf.';

  @override
  String get crono_msg_04 => 'Route nicht verfügbar. Bitte versuche es erneut.';

  @override
  String get crono_msg_05 => 'Unbekannter Fehler';

  @override
  String get card_percorso_1 => 'Datum auswählen';

  @override
  String get card_percorso_2 => 'Abbrechen';

  @override
  String get card_percorso_3 => 'OK';

  @override
  String get card_percorso_4 => 'Strecke vom';

  @override
  String get card_percorso_5 => 'Keine Bewegung an diesem Tag';

  @override
  String get feat_tracking_live => 'Live-Tracking';

  @override
  String get feat_report_basic => 'Tagesbericht (Basis)';

  @override
  String get feat_report_advanced => 'Erweiterte Tages-Timeline';

  @override
  String get feat_places_routes => 'Wiederholte Orte und Routen';

  @override
  String get feat_export_gpx => 'GPX-Export';

  @override
  String get feat_export_csv => 'CSV-Export';

  @override
  String get feat_notifications => 'Benachrichtigungen';

  @override
  String get feat_backup_cloud => 'Cloud-Backup';

  @override
  String get feat_rewards => 'Prämien';

  @override
  String get feat_priority_support => 'Priorisierter Support';

  @override
  String get feat_no_ads => 'Keine Werbung';

  @override
  String get feat_history_days => 'Verfügbare Historie';

  @override
  String get days => 'Tage';

  @override
  String get feat_gps => 'GPS-Parameter des Tarifs';

  @override
  String get feat_gps_sample_sec => 'Abtastrate (Sekunden)';

  @override
  String get feat_gps_min_distance_m => 'Mindestentfernung (Meter)';

  @override
  String get feat_gps_upload_sec => 'Batch-Upload (Sekunden)';

  @override
  String get feat_gps_background => 'Hintergrund-Tracking';

  @override
  String get gps_accuracy_mode => 'Genauigkeitsmodus';

  @override
  String get feat_gps_max_acc_m => 'Maximale Genauigkeit (Meter)';

  @override
  String get feat_gps_accuracy_mode => 'Genauigkeitsmodus';

  @override
  String get accuracy_low => 'Niedrig';

  @override
  String get accuracy_balanced => 'Ausgewogen';

  @override
  String get accuracy_high => 'Hoch';

  @override
  String get accuracy_best => 'Maximal';

  @override
  String get unit_seconds => 'Sekunden';

  @override
  String get unit_meters => 'Meter';

  @override
  String gps_next_fix(Object s) {
    return 'Nächster Fix in ${s}s';
  }

  @override
  String get escl_prog_01 => 'Geplante Ausschlüsse';

  @override
  String get escl_prog_02 => 'Ausschlüsse nur ab Tarif Basic verfügbar';

  @override
  String get escl_prog_03 => 'Ausschluss hinzufügen';

  @override
  String get escl_prog_04 => 'Keine geplanten Ausschlüsse eingerichtet.';

  @override
  String get escl_prog_05 => 'Bearbeiten';

  @override
  String get escl_prog_06 => 'Neuer Ausschluss';

  @override
  String get escl_prog_07 => 'Ausschluss bearbeiten';

  @override
  String get escl_prog_08 => 'Startzeit';

  @override
  String get escl_prog_09 => 'Endzeit';

  @override
  String get escl_prog_10 => 'Notizen';

  @override
  String get escl_prog_11 => 'Aktiv';

  @override
  String get escl_prog_12 => 'Aktive Tage:';

  @override
  String get escl_prog_13 => 'Abbrechen';

  @override
  String get escl_prog_14 => 'Speichern';

  @override
  String get verifica_mail_titolo => 'Verifiziere deine E-Mail';

  @override
  String get verifica_mail_testo1 => 'Überprüfe deine E-Mails und klicke auf den Verifizierungslink.';

  @override
  String get verifica_mail_testo2 => 'Wenn du verifiziert hast, gehe zurück zur Anmeldung, um dich anzumelden.';

  @override
  String get verifica_mail_testo3 => 'Wenn du verifiziert hast, gehe zurück zur Anmeldung, um dich anzumelden.';

  @override
  String get verifica_mail_testo4 => 'Ich habe verifiziert, gehe zurück zum Dashboard.';

  @override
  String get verifica_mail_erro1 => '-Mail gesendet!';

  @override
  String get verifica_mail_erro2 => 'Fehler beim Senden der E-Mail.';

  @override
  String get verifica_mail_button => 'E-Mail erneut senden';

  @override
  String get acquisto_piano_conferma => 'Kauf bestätigen';

  @override
  String get acquisto_piano_info => 'Ihre Informationen.';

  @override
  String get acquisto_piano_id => 'Benutzer-ID:';

  @override
  String get acquisto_piano_nome => 'Name:';

  @override
  String get acquisto_piano_mail => 'E-Mail:';

  @override
  String get acquisto_piano_durata => 'Dauer:';

  @override
  String get acquisto_piano_pagamento => 'Zur Zahlung fortfahren';

  @override
  String get acquisto_piano_stripe => 'Sie werden zu Stripe weitergeleitet...';

  @override
  String get acquisto_piano_nopaga => 'Zahlung nicht gestartet:';

  @override
  String get acquisto_piano_attivo => 'Abo aktiviert!';
}
