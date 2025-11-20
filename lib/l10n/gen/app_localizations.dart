import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'MoveUP'**
  String get appTitle;

  /// No description provided for @appSubTitle.
  ///
  /// In it, this message translates to:
  /// **'Il tuo assistente di movimento'**
  String get appSubTitle;

  /// No description provided for @subscriptions.
  ///
  /// In it, this message translates to:
  /// **'Abbonamenti'**
  String get subscriptions;

  /// No description provided for @welcomeUser.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto, {name}!'**
  String welcomeUser(String name);

  /// No description provided for @anonymousUser.
  ///
  /// In it, this message translates to:
  /// **'Utente Anonimo'**
  String get anonymousUser;

  /// No description provided for @lingua_sistema.
  ///
  /// In it, this message translates to:
  /// **'Lingua di sistema'**
  String get lingua_sistema;

  /// No description provided for @priceFree.
  ///
  /// In it, this message translates to:
  /// **'Gratis'**
  String get priceFree;

  /// No description provided for @pricePerMonth.
  ///
  /// In it, this message translates to:
  /// **'{price}/mese'**
  String pricePerMonth(String price);

  /// No description provided for @durationDays.
  ///
  /// In it, this message translates to:
  /// **'{days, plural, one {# giorno} other {# giorni}}'**
  String durationDays(int days);

  /// No description provided for @features.
  ///
  /// In it, this message translates to:
  /// **'Funzioni'**
  String get features;

  /// No description provided for @buy.
  ///
  /// In it, this message translates to:
  /// **'Acquista'**
  String get buy;

  /// No description provided for @active.
  ///
  /// In it, this message translates to:
  /// **'Attivo'**
  String get active;

  /// No description provided for @thisIsYourPlan.
  ///
  /// In it, this message translates to:
  /// **'Questo è il tuo piano!'**
  String get thisIsYourPlan;

  /// No description provided for @sessionExpired.
  ///
  /// In it, this message translates to:
  /// **'Sessione scaduta. Effettua di nuovo il login.'**
  String get sessionExpired;

  /// No description provided for @durata_abbonamento.
  ///
  /// In it, this message translates to:
  /// **'Durata:'**
  String get durata_abbonamento;

  /// No description provided for @onb1.
  ///
  /// In it, this message translates to:
  /// **'Cosa fa MoveUP?'**
  String get onb1;

  /// No description provided for @onb1_body.
  ///
  /// In it, this message translates to:
  /// **'MoveUP ti mostra quanto del tuo tempo sei fermo, ti stai muovendo lentamente o veloce.\nSarà una scoperta!'**
  String get onb1_body;

  /// No description provided for @onb2.
  ///
  /// In it, this message translates to:
  /// **'Come funziona'**
  String get onb2;

  /// No description provided for @onb2_body.
  ///
  /// In it, this message translates to:
  /// **'1) Avvia il tracciamento •  \n2) Muoviti 10 minuti •  \n3) Apri il riepilogo serale • 4) Condividilo con chi vuoi •'**
  String get onb2_body;

  /// No description provided for @onb3.
  ///
  /// In it, this message translates to:
  /// **'Pronti a iniziare?'**
  String get onb3;

  /// No description provided for @onb3_body.
  ///
  /// In it, this message translates to:
  /// **'Accetta le condizioni e attiva il tracciamento.\nRegistrati GRATIS.\nAvrai la settimana sotto controllo.'**
  String get onb3_body;

  /// No description provided for @botton_salta.
  ///
  /// In it, this message translates to:
  /// **'Salta'**
  String get botton_salta;

  /// No description provided for @condizioni_uso.
  ///
  /// In it, this message translates to:
  /// **'Ho letto e accettato le '**
  String get condizioni_uso;

  /// No description provided for @condizioni_uso2.
  ///
  /// In it, this message translates to:
  /// **'Condizioni d\'uso'**
  String get condizioni_uso2;

  /// No description provided for @privacy_policy.
  ///
  /// In it, this message translates to:
  /// **'e le '**
  String get privacy_policy;

  /// No description provided for @privacy_policy2.
  ///
  /// In it, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy2;

  /// No description provided for @botton_prosegui.
  ///
  /// In it, this message translates to:
  /// **'Avvia tracciamento ora'**
  String get botton_prosegui;

  /// No description provided for @botton_indietro.
  ///
  /// In it, this message translates to:
  /// **'Indietro'**
  String get botton_indietro;

  /// No description provided for @botton_avanti.
  ///
  /// In it, this message translates to:
  /// **'Avanti'**
  String get botton_avanti;

  /// No description provided for @errore_001.
  ///
  /// In it, this message translates to:
  /// **'Permesso posizione negato'**
  String get errore_001;

  /// No description provided for @errore_002.
  ///
  /// In it, this message translates to:
  /// **'Permesso posizione negato per sempre'**
  String get errore_002;

  /// No description provided for @errore_003.
  ///
  /// In it, this message translates to:
  /// **'Errore ottenimento posizione:'**
  String get errore_003;

  /// No description provided for @errore_004.
  ///
  /// In it, this message translates to:
  /// **'Location service disabilitato sul dispositivo'**
  String get errore_004;

  /// No description provided for @user_err01.
  ///
  /// In it, this message translates to:
  /// **'Errore inizializza utente:'**
  String get user_err01;

  /// No description provided for @user_err02.
  ///
  /// In it, this message translates to:
  /// **'Utente errato'**
  String get user_err02;

  /// No description provided for @user_err03.
  ///
  /// In it, this message translates to:
  /// **'Ultimo accesso aggiornato per utente'**
  String get user_err03;

  /// No description provided for @user_err04.
  ///
  /// In it, this message translates to:
  /// **'Errore aggiornamento ultimo accesso'**
  String get user_err04;

  /// No description provided for @user_err05.
  ///
  /// In it, this message translates to:
  /// **'Login fallito'**
  String get user_err05;

  /// No description provided for @user_err06.
  ///
  /// In it, this message translates to:
  /// **'Login'**
  String get user_err06;

  /// No description provided for @user_err07.
  ///
  /// In it, this message translates to:
  /// **'Registrati'**
  String get user_err07;

  /// No description provided for @gps_err01.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento GPS disattivato: attivalo nelle impostazioni.'**
  String get gps_err01;

  /// No description provided for @gps_err02.
  ///
  /// In it, this message translates to:
  /// **'Errore salvataggio posizione:'**
  String get gps_err02;

  /// No description provided for @gps_err03.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento GPS disattivato: la posizione non viene registrata.'**
  String get gps_err03;

  /// No description provided for @gps_err04.
  ///
  /// In it, this message translates to:
  /// **'Permesso posizione negato'**
  String get gps_err04;

  /// No description provided for @gps_err05.
  ///
  /// In it, this message translates to:
  /// **'Permesso posizione negato per sempre'**
  String get gps_err05;

  /// No description provided for @gps_err06.
  ///
  /// In it, this message translates to:
  /// **'Segnale GPS debole, attendi una posizione migliore'**
  String get gps_err06;

  /// No description provided for @gps_err07.
  ///
  /// In it, this message translates to:
  /// **'Errore ottenimento posizione:'**
  String get gps_err07;

  /// No description provided for @gps_err08.
  ///
  /// In it, this message translates to:
  /// **'Posizione salvata!'**
  String get gps_err08;

  /// No description provided for @gps_err09.
  ///
  /// In it, this message translates to:
  /// **'Errore salvataggio posizione:'**
  String get gps_err09;

  /// No description provided for @gps_err10.
  ///
  /// In it, this message translates to:
  /// **'DEBUG API leggi consensi:'**
  String get gps_err10;

  /// No description provided for @gps_err11.
  ///
  /// In it, this message translates to:
  /// **'DEBUG API valore consenso GPS:'**
  String get gps_err11;

  /// No description provided for @gps_err12.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento GPS '**
  String get gps_err12;

  /// No description provided for @gps_err13.
  ///
  /// In it, this message translates to:
  /// **'Devi attivare il consenso al tracciamento GPS nelle impostazioni'**
  String get gps_err13;

  /// No description provided for @gps_err14.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento in ascolto'**
  String get gps_err14;

  /// No description provided for @gps_err15.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento spento'**
  String get gps_err15;

  /// No description provided for @gps_err16.
  ///
  /// In it, this message translates to:
  /// **'Prossima rilevazione tra'**
  String get gps_err16;

  /// No description provided for @gps_err17.
  ///
  /// In it, this message translates to:
  /// **'GPS Attivo'**
  String get gps_err17;

  /// No description provided for @gps_err18.
  ///
  /// In it, this message translates to:
  /// **'GPS Disattivo'**
  String get gps_err18;

  /// No description provided for @gps_err19.
  ///
  /// In it, this message translates to:
  /// **'Diario di bordo GPS'**
  String get gps_err19;

  /// No description provided for @gps_err20.
  ///
  /// In it, this message translates to:
  /// **'Nessun evento ancora registrato.'**
  String get gps_err20;

  /// No description provided for @gps_err21.
  ///
  /// In it, this message translates to:
  /// **'In pausa'**
  String get gps_err21;

  /// No description provided for @gps_err22.
  ///
  /// In it, this message translates to:
  /// **'In ascolto'**
  String get gps_err22;

  /// No description provided for @gps_err23.
  ///
  /// In it, this message translates to:
  /// **'Avvia tracciamento'**
  String get gps_err23;

  /// No description provided for @gps_err24.
  ///
  /// In it, this message translates to:
  /// **'Riprendi tracciamento'**
  String get gps_err24;

  /// No description provided for @gps_err25.
  ///
  /// In it, this message translates to:
  /// **'Pausa tracciamento'**
  String get gps_err25;

  /// No description provided for @gps_err26.
  ///
  /// In it, this message translates to:
  /// **'Riprendi tracciamento'**
  String get gps_err26;

  /// No description provided for @att_err01.
  ///
  /// In it, this message translates to:
  /// **'Errore ricalcolo attività:'**
  String get att_err01;

  /// No description provided for @att_err02.
  ///
  /// In it, this message translates to:
  /// **'invariato rispetto a ieri'**
  String get att_err02;

  /// No description provided for @att_err03.
  ///
  /// In it, this message translates to:
  /// **'rispetto a ieri'**
  String get att_err03;

  /// No description provided for @att_err04.
  ///
  /// In it, this message translates to:
  /// **'Espandi per vedere i dettagli...'**
  String get att_err04;

  /// No description provided for @att_err05.
  ///
  /// In it, this message translates to:
  /// **'Nessuna sessione registrata'**
  String get att_err05;

  /// No description provided for @info_mes01.
  ///
  /// In it, this message translates to:
  /// **'Inizio:'**
  String get info_mes01;

  /// No description provided for @info_mes02.
  ///
  /// In it, this message translates to:
  /// **'Fine:'**
  String get info_mes02;

  /// No description provided for @info_mes03.
  ///
  /// In it, this message translates to:
  /// **'Durata:'**
  String get info_mes03;

  /// No description provided for @info_mes04.
  ///
  /// In it, this message translates to:
  /// **'Distanza:'**
  String get info_mes04;

  /// No description provided for @info_mes05.
  ///
  /// In it, this message translates to:
  /// **'Fonte:'**
  String get info_mes05;

  /// No description provided for @info_mes06.
  ///
  /// In it, this message translates to:
  /// **'Passi stimati:'**
  String get info_mes06;

  /// No description provided for @info_mes07.
  ///
  /// In it, this message translates to:
  /// **'Capisci come ti muovi,\nScopri dove va il tuo tempo.'**
  String get info_mes07;

  /// No description provided for @mov_inattivo.
  ///
  /// In it, this message translates to:
  /// **'Fermo / Pausa'**
  String get mov_inattivo;

  /// No description provided for @mov_leggero.
  ///
  /// In it, this message translates to:
  /// **'Movimento lento'**
  String get mov_leggero;

  /// No description provided for @mov_veloce.
  ///
  /// In it, this message translates to:
  /// **'Spostamento veloce'**
  String get mov_veloce;

  /// No description provided for @chart_mes01.
  ///
  /// In it, this message translates to:
  /// **'Nessun grafico disponibile al momento.'**
  String get chart_mes01;

  /// No description provided for @chart_mes02.
  ///
  /// In it, this message translates to:
  /// **'Timeline Livelli Giornaliero'**
  String get chart_mes02;

  /// No description provided for @chart_mes03.
  ///
  /// In it, this message translates to:
  /// **'Intervallo un ora'**
  String get chart_mes03;

  /// No description provided for @chart_mes04.
  ///
  /// In it, this message translates to:
  /// **'Distribuzione Livelli Giornaliero'**
  String get chart_mes04;

  /// No description provided for @chart_mes05.
  ///
  /// In it, this message translates to:
  /// **'Intervallo un ora'**
  String get chart_mes05;

  /// No description provided for @chart_mes06.
  ///
  /// In it, this message translates to:
  /// **'Impossibile generare l’immagine. Riprova.'**
  String get chart_mes06;

  /// No description provided for @chart_mes07.
  ///
  /// In it, this message translates to:
  /// **'Il mio Report MoveUP di oggi'**
  String get chart_mes07;

  /// No description provided for @cahrt_mes08.
  ///
  /// In it, this message translates to:
  /// **'Errore condivisione:'**
  String get cahrt_mes08;

  /// No description provided for @chart_mes09.
  ///
  /// In it, this message translates to:
  /// **'Report MoveUP di oggi'**
  String get chart_mes09;

  /// No description provided for @chart_mes10.
  ///
  /// In it, this message translates to:
  /// **'Timeline Livelli (a corsie)'**
  String get chart_mes10;

  /// No description provided for @um_metri.
  ///
  /// In it, this message translates to:
  /// **'Metri:'**
  String get um_metri;

  /// No description provided for @um_passi.
  ///
  /// In it, this message translates to:
  /// **'Passi:'**
  String get um_passi;

  /// No description provided for @um_km.
  ///
  /// In it, this message translates to:
  /// **'Km:'**
  String get um_km;

  /// No description provided for @form_reg_testa.
  ///
  /// In it, this message translates to:
  /// **'Registrazione'**
  String get form_reg_testa;

  /// No description provided for @form_reg_nome.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get form_reg_nome;

  /// No description provided for @form_reg_mail.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get form_reg_mail;

  /// No description provided for @form_reg_password.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get form_reg_password;

  /// No description provided for @form_reg_err01.
  ///
  /// In it, this message translates to:
  /// **'Inserisci il nome'**
  String get form_reg_err01;

  /// No description provided for @form_reg_err02.
  ///
  /// In it, this message translates to:
  /// **'Inserisci una email valida'**
  String get form_reg_err02;

  /// No description provided for @form_reg_err03.
  ///
  /// In it, this message translates to:
  /// **'La password deve avere almeno 8 caratteri, una maiuscola e un numero'**
  String get form_reg_err03;

  /// No description provided for @form_reg_err04.
  ///
  /// In it, this message translates to:
  /// **'Registrazione avvenuta! Verifica la tua mail e puoi fare login.'**
  String get form_reg_err04;

  /// No description provided for @form_reg_err05.
  ///
  /// In it, this message translates to:
  /// **'Registrazione fallita'**
  String get form_reg_err05;

  /// No description provided for @form_reg_genere.
  ///
  /// In it, this message translates to:
  /// **'Genere'**
  String get form_reg_genere;

  /// No description provided for @form_reg_maschio.
  ///
  /// In it, this message translates to:
  /// **'Maschio'**
  String get form_reg_maschio;

  /// No description provided for @form_reg_femmina.
  ///
  /// In it, this message translates to:
  /// **'Femmina'**
  String get form_reg_femmina;

  /// No description provided for @form_reg_professione.
  ///
  /// In it, this message translates to:
  /// **'Professione'**
  String get form_reg_professione;

  /// No description provided for @form_reg_eta.
  ///
  /// In it, this message translates to:
  /// **'Fascia di età'**
  String get form_reg_eta;

  /// No description provided for @form_reg_ult_accesso.
  ///
  /// In it, this message translates to:
  /// **'Ultimo accesso'**
  String get form_reg_ult_accesso;

  /// No description provided for @form_reg_consensi.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni e consensi'**
  String get form_reg_consensi;

  /// No description provided for @form_reg_gps.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento GPS'**
  String get form_reg_gps;

  /// No description provided for @form_reg_err06.
  ///
  /// In it, this message translates to:
  /// **'Le password non coincidono'**
  String get form_reg_err06;

  /// No description provided for @form_reg_country.
  ///
  /// In it, this message translates to:
  /// **'Nazione di residenza'**
  String get form_reg_country;

  /// No description provided for @cambio_password.
  ///
  /// In it, this message translates to:
  /// **'Cambio password'**
  String get cambio_password;

  /// No description provided for @password_attuale_label.
  ///
  /// In it, this message translates to:
  /// **'Password attuale'**
  String get password_attuale_label;

  /// No description provided for @nuova_password_label.
  ///
  /// In it, this message translates to:
  /// **'Nuova password'**
  String get nuova_password_label;

  /// No description provided for @conferma_password_label.
  ///
  /// In it, this message translates to:
  /// **'Conferma nuova password'**
  String get conferma_password_label;

  /// No description provided for @button_cambia_password.
  ///
  /// In it, this message translates to:
  /// **'Cambia password'**
  String get button_cambia_password;

  /// No description provided for @compila_tutti_campi.
  ///
  /// In it, this message translates to:
  /// **'Compila tutti i campi'**
  String get compila_tutti_campi;

  /// No description provided for @password_non_coincidono.
  ///
  /// In it, this message translates to:
  /// **'Le nuove password non coincidono'**
  String get password_non_coincidono;

  /// No description provided for @password_diversa_dalla_attuale.
  ///
  /// In it, this message translates to:
  /// **'La nuova password deve essere diversa da quella attuale'**
  String get password_diversa_dalla_attuale;

  /// No description provided for @password_controllo.
  ///
  /// In it, this message translates to:
  /// **'La password deve avere almeno 8 caratteri, includere una lettera maiuscola e un numero'**
  String get password_controllo;

  /// No description provided for @password_cambiata.
  ///
  /// In it, this message translates to:
  /// **'Password cambiata con successo!'**
  String get password_cambiata;

  /// No description provided for @password_errore.
  ///
  /// In it, this message translates to:
  /// **'Errore nel cambio password'**
  String get password_errore;

  /// No description provided for @password_dimenticata.
  ///
  /// In it, this message translates to:
  /// **'Hai dimenticato la password?'**
  String get password_dimenticata;

  /// No description provided for @reimposta_password.
  ///
  /// In it, this message translates to:
  /// **'Reimposta password'**
  String get reimposta_password;

  /// No description provided for @inserisci_mail.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la tua email per ricevere il link di reimpostazione.'**
  String get inserisci_mail;

  /// No description provided for @inserisci_tua_mail.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la tua email'**
  String get inserisci_tua_mail;

  /// No description provided for @link_mail_password.
  ///
  /// In it, this message translates to:
  /// **'Se l’email è registrata, ti abbiamo inviato un link per reimpostare la password.'**
  String get link_mail_password;

  /// No description provided for @invia_richiesta_label.
  ///
  /// In it, this message translates to:
  /// **'Invia richiesta'**
  String get invia_richiesta_label;

  /// No description provided for @condividi_button.
  ///
  /// In it, this message translates to:
  /// **'Condividi'**
  String get condividi_button;

  /// No description provided for @form_consensi_01.
  ///
  /// In it, this message translates to:
  /// **'Consensi'**
  String get form_consensi_01;

  /// No description provided for @form_consensi_02.
  ///
  /// In it, this message translates to:
  /// **'Acconsento al trattamento dei dati (privacy)'**
  String get form_consensi_02;

  /// No description provided for @form_consensi_03.
  ///
  /// In it, this message translates to:
  /// **'Acconsento a ricevere comunicazioni marketing'**
  String get form_consensi_03;

  /// No description provided for @form_consensi_04.
  ///
  /// In it, this message translates to:
  /// **'Acconsento a partecipare a premi e concorsi'**
  String get form_consensi_04;

  /// No description provided for @form_consensi_05.
  ///
  /// In it, this message translates to:
  /// **'Acconsento al tracciamento GPS'**
  String get form_consensi_05;

  /// No description provided for @form_consensi_06.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get form_consensi_06;

  /// No description provided for @form_consensi_er.
  ///
  /// In it, this message translates to:
  /// **'Errore salvataggio consensi .. :'**
  String get form_consensi_er;

  /// No description provided for @session_expired.
  ///
  /// In it, this message translates to:
  /// **'Sessione scaduta. Effettua di nuovo il login.'**
  String get session_expired;

  /// No description provided for @token_invalid.
  ///
  /// In it, this message translates to:
  /// **'Token non valido: riesegui il login.'**
  String get token_invalid;

  /// No description provided for @payment_mes1.
  ///
  /// In it, this message translates to:
  /// **'Illimitato'**
  String get payment_mes1;

  /// No description provided for @payment_mes2.
  ///
  /// In it, this message translates to:
  /// **'Scaduto'**
  String get payment_mes2;

  /// No description provided for @payment_mes3.
  ///
  /// In it, this message translates to:
  /// **'1 gg rim.'**
  String get payment_mes3;

  /// No description provided for @payment_mes4.
  ///
  /// In it, this message translates to:
  /// **'gg rim.'**
  String get payment_mes4;

  /// No description provided for @bottom_impostazioni.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get bottom_impostazioni;

  /// No description provided for @bottom_cronologia.
  ///
  /// In it, this message translates to:
  /// **'Attività'**
  String get bottom_cronologia;

  /// No description provided for @bottom_profilo.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get bottom_profilo;

  /// No description provided for @bottom_abbonamenti.
  ///
  /// In it, this message translates to:
  /// **'Abbonamenti'**
  String get bottom_abbonamenti;

  /// No description provided for @bottom_err01.
  ///
  /// In it, this message translates to:
  /// **'Funzione disponibile solo per utenti registrati!'**
  String get bottom_err01;

  /// No description provided for @bottom_err02.
  ///
  /// In it, this message translates to:
  /// **'Utente ERRATO!'**
  String get bottom_err02;

  /// No description provided for @bottom_nome.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get bottom_nome;

  /// No description provided for @bottom_logout.
  ///
  /// In it, this message translates to:
  /// **'Logout'**
  String get bottom_logout;

  /// No description provided for @map_mes_01.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna posizione'**
  String get map_mes_01;

  /// No description provided for @rep_day_mes01.
  ///
  /// In it, this message translates to:
  /// **'Report Giornaliero'**
  String get rep_day_mes01;

  /// No description provided for @rep_day_mes02.
  ///
  /// In it, this message translates to:
  /// **'Ultima posizione'**
  String get rep_day_mes02;

  /// No description provided for @storico_01.
  ///
  /// In it, this message translates to:
  /// **'Scegli quanto storico vuoi tenere. Il resto cresce con te.'**
  String get storico_01;

  /// No description provided for @storico_02.
  ///
  /// In it, this message translates to:
  /// **'Free (Anonimo)'**
  String get storico_02;

  /// No description provided for @storico_03.
  ///
  /// In it, this message translates to:
  /// **'Usa l’app senza registrarti.\nLa posizione può essere rilevata anche in background per calcolare in tempo reale distanza percorsa, tempo in movimento e momenti di sosta.\nI dati restano solo sul tuo dispositivo, valgono solo per la giornata in corso e vengono cancellati automaticamente ogni giorno.\nFunzioni: tracking live e riepilogo del giorno.'**
  String get storico_03;

  /// No description provided for @storico_04.
  ///
  /// In it, this message translates to:
  /// **'Start (Registrato)'**
  String get storico_04;

  /// No description provided for @storico_05.
  ///
  /// In it, this message translates to:
  /// **'Account gratuito con storico 7 giorni.\nFunzioni: tracking live e in background, backup cloud, sincronizzazione su più dispositivi, notifiche.'**
  String get storico_05;

  /// No description provided for @storico_06.
  ///
  /// In it, this message translates to:
  /// **'Basic — 30 giorni (Pagamento)'**
  String get storico_06;

  /// No description provided for @storico_07.
  ///
  /// In it, this message translates to:
  /// **'Storico di 30 giorni.\nFunzioni: timeline giornaliera avanzata, metriche per livello (fermo/lento/veloce), luoghi e percorsi ripetuti.'**
  String get storico_07;

  /// No description provided for @storico_08.
  ///
  /// In it, this message translates to:
  /// **'Plus — 180 giorni (Pagamento)'**
  String get storico_08;

  /// No description provided for @storico_09.
  ///
  /// In it, this message translates to:
  /// **'Storico di 6 mesi.\nFunzioni: tutto di Basic + analisi dei percorsi/luoghi ricorrenti con riepiloghi settimanali/mensili.'**
  String get storico_09;

  /// No description provided for @storico_10.
  ///
  /// In it, this message translates to:
  /// **'Pro — 365 giorni (Pagamento)'**
  String get storico_10;

  /// No description provided for @storico_11.
  ///
  /// In it, this message translates to:
  /// **'Storico di 1 anno.\nFunzioni: report avanzati, filtri dettagliati, supporto prioritario, niente pubblicità.'**
  String get storico_11;

  /// No description provided for @storico_12.
  ///
  /// In it, this message translates to:
  /// **'Nota privacy:'**
  String get storico_12;

  /// No description provided for @storico_13.
  ///
  /// In it, this message translates to:
  /// **'L’app rileva la tua posizione anche in background per calcolare i tuoi spostamenti, la distanza percorsa e il tempo in movimento.\nPuoi cambiare o revocare i consensi in qualsiasi momento.\nSenza consenso al tracking non registriamo posizioni.\nSe usi l’app in modalità anonima (senza registrazione) i dati restano solo sul dispositivo e vengono eliminati automaticamente alla fine della giornata: non teniamo storico dei giorni precedenti e non associamo le posizioni a un profilo personale.'**
  String get storico_13;

  /// No description provided for @storico_14.
  ///
  /// In it, this message translates to:
  /// **'⏳ Caricamento dati…'**
  String get storico_14;

  /// No description provided for @form_crono_01.
  ///
  /// In it, this message translates to:
  /// **'Attività'**
  String get form_crono_01;

  /// No description provided for @form_crono_02.
  ///
  /// In it, this message translates to:
  /// **'Riepilogo attività'**
  String get form_crono_02;

  /// No description provided for @form_crono_03.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto, '**
  String get form_crono_03;

  /// No description provided for @form_crono_04.
  ///
  /// In it, this message translates to:
  /// **'Riepilogo ultimi 7 giorni'**
  String get form_crono_04;

  /// No description provided for @form_crono_05.
  ///
  /// In it, this message translates to:
  /// **'Nessuna sessione registrata'**
  String get form_crono_05;

  /// No description provided for @form_crono_06.
  ///
  /// In it, this message translates to:
  /// **'Livello'**
  String get form_crono_06;

  /// No description provided for @form_crono_07.
  ///
  /// In it, this message translates to:
  /// **'Visualizza dettagli'**
  String get form_crono_07;

  /// No description provided for @form_crono_08.
  ///
  /// In it, this message translates to:
  /// **'Dettagli Livello'**
  String get form_crono_08;

  /// No description provided for @form_crono_09.
  ///
  /// In it, this message translates to:
  /// **'Dettagli per il Livello'**
  String get form_crono_09;

  /// No description provided for @form_crono_10.
  ///
  /// In it, this message translates to:
  /// **'Riepilogo da 8 a 14 giorni'**
  String get form_crono_10;

  /// No description provided for @form_crono_11.
  ///
  /// In it, this message translates to:
  /// **'Confronto settimanale'**
  String get form_crono_11;

  /// No description provided for @dashboard_piano.
  ///
  /// In it, this message translates to:
  /// **'Piano:'**
  String get dashboard_piano;

  /// No description provided for @dashboard_msg.
  ///
  /// In it, this message translates to:
  /// **'Crea un account (gratis) per salvare i dati e sbloccare la condivisione.'**
  String get dashboard_msg;

  /// No description provided for @imposta_page_studente.
  ///
  /// In it, this message translates to:
  /// **'Studente'**
  String get imposta_page_studente;

  /// No description provided for @imposta_page_impiegato.
  ///
  /// In it, this message translates to:
  /// **'Impiegato'**
  String get imposta_page_impiegato;

  /// No description provided for @imposta_page_libero.
  ///
  /// In it, this message translates to:
  /// **'Professionista'**
  String get imposta_page_libero;

  /// No description provided for @imposta_page_disoccupato.
  ///
  /// In it, this message translates to:
  /// **'Disoccupato'**
  String get imposta_page_disoccupato;

  /// No description provided for @imposta_page_pensionato.
  ///
  /// In it, this message translates to:
  /// **'Pensionato'**
  String get imposta_page_pensionato;

  /// No description provided for @imposta_page_altro.
  ///
  /// In it, this message translates to:
  /// **'Altro'**
  String get imposta_page_altro;

  /// No description provided for @imposta_page_lista.
  ///
  /// In it, this message translates to:
  /// **'Studente,Impiegato,Professionista,Disoccupato,Pensionato,Altro'**
  String get imposta_page_lista;

  /// No description provided for @imposta_page_miei.
  ///
  /// In it, this message translates to:
  /// **'I miei dati personali'**
  String get imposta_page_miei;

  /// No description provided for @imposta_page_notifiche.
  ///
  /// In it, this message translates to:
  /// **'Notifiche attive'**
  String get imposta_page_notifiche;

  /// No description provided for @imposta_page_consenso.
  ///
  /// In it, this message translates to:
  /// **'Consenso privacy'**
  String get imposta_page_consenso;

  /// No description provided for @imposta_page_marketing.
  ///
  /// In it, this message translates to:
  /// **'Consenso marketing'**
  String get imposta_page_marketing;

  /// No description provided for @imposta_page_premi.
  ///
  /// In it, this message translates to:
  /// **'Consenso premi'**
  String get imposta_page_premi;

  /// No description provided for @imposta_page_datac.
  ///
  /// In it, this message translates to:
  /// **'Data consenso'**
  String get imposta_page_datac;

  /// No description provided for @imposta_page_frequenza.
  ///
  /// In it, this message translates to:
  /// **'Frequenza tracciamento (sec)'**
  String get imposta_page_frequenza;

  /// No description provided for @imposta_page_piani.
  ///
  /// In it, this message translates to:
  /// **'Piani abbonamento'**
  String get imposta_page_piani;

  /// No description provided for @imposta_page_importo.
  ///
  /// In it, this message translates to:
  /// **'Importo:'**
  String get imposta_page_importo;

  /// No description provided for @imposta_page_durata.
  ///
  /// In it, this message translates to:
  /// **'Durata:'**
  String get imposta_page_durata;

  /// No description provided for @imposta_page_cancella.
  ///
  /// In it, this message translates to:
  /// **'Cancellazione dati: dopo '**
  String get imposta_page_cancella;

  /// No description provided for @imposta_page_funzioni.
  ///
  /// In it, this message translates to:
  /// **'Funzioni attive:'**
  String get imposta_page_funzioni;

  /// No description provided for @imposta_page_save.
  ///
  /// In it, this message translates to:
  /// **'Salva modifiche'**
  String get imposta_page_save;

  /// No description provided for @imposta_page_mess1.
  ///
  /// In it, this message translates to:
  /// **'Dati personali aggiornati!'**
  String get imposta_page_mess1;

  /// No description provided for @imposta_page_mess2.
  ///
  /// In it, this message translates to:
  /// **'Errore: '**
  String get imposta_page_mess2;

  /// No description provided for @imposta_page_mess3.
  ///
  /// In it, this message translates to:
  /// **'Impossibile aggiornare.'**
  String get imposta_page_mess3;

  /// No description provided for @imposta_page_mess4.
  ///
  /// In it, this message translates to:
  /// **'Errore di rete.'**
  String get imposta_page_mess4;

  /// No description provided for @imposta_page_mess5.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni aggiornate! '**
  String get imposta_page_mess5;

  /// No description provided for @imposta_page_mess6.
  ///
  /// In it, this message translates to:
  /// **'Dati salvati!'**
  String get imposta_page_mess6;

  /// No description provided for @footer_page_diritti.
  ///
  /// In it, this message translates to:
  /// **'© 2025 MoveUP - Tutti i diritti riservati'**
  String get footer_page_diritti;

  /// No description provided for @footer_page_banner.
  ///
  /// In it, this message translates to:
  /// **'Your Personal Move'**
  String get footer_page_banner;

  /// No description provided for @footer_page_versione.
  ///
  /// In it, this message translates to:
  /// **'Versione app:'**
  String get footer_page_versione;

  /// No description provided for @header_page_banner.
  ///
  /// In it, this message translates to:
  /// **'Your Personal Move'**
  String get header_page_banner;

  /// No description provided for @rep_day_export_locked.
  ///
  /// In it, this message translates to:
  /// **'La condivisione richiede START/BASIC/PLUS/PRO'**
  String get rep_day_export_locked;

  /// No description provided for @msg_abilitato_01.
  ///
  /// In it, this message translates to:
  /// **'Registrati per vedere la distribuzione di oggi'**
  String get msg_abilitato_01;

  /// No description provided for @msg_abilitato_02.
  ///
  /// In it, this message translates to:
  /// **'Timeline disponibile con BASIC. Prima registrati.'**
  String get msg_abilitato_02;

  /// No description provided for @crono_msg_01.
  ///
  /// In it, this message translates to:
  /// **'Registrati per vedere il percorso del giorno.'**
  String get crono_msg_01;

  /// No description provided for @crono_msg_02.
  ///
  /// In it, this message translates to:
  /// **'Il tuo piano consente fino a'**
  String get crono_msg_02;

  /// No description provided for @crono_msg_03.
  ///
  /// In it, this message translates to:
  /// **'giorni di storico.'**
  String get crono_msg_03;

  /// No description provided for @crono_msg_04.
  ///
  /// In it, this message translates to:
  /// **'Percorso non disponibile. Riprova.'**
  String get crono_msg_04;

  /// No description provided for @crono_msg_05.
  ///
  /// In it, this message translates to:
  /// **'Errore sconosciuto'**
  String get crono_msg_05;

  /// No description provided for @card_percorso_1.
  ///
  /// In it, this message translates to:
  /// **'Seleziona data'**
  String get card_percorso_1;

  /// No description provided for @card_percorso_2.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get card_percorso_2;

  /// No description provided for @card_percorso_3.
  ///
  /// In it, this message translates to:
  /// **'Ok'**
  String get card_percorso_3;

  /// No description provided for @card_percorso_4.
  ///
  /// In it, this message translates to:
  /// **'Percorso del'**
  String get card_percorso_4;

  /// No description provided for @card_percorso_5.
  ///
  /// In it, this message translates to:
  /// **'Nessun movimento in questa data'**
  String get card_percorso_5;

  /// No description provided for @feat_tracking_live.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento live'**
  String get feat_tracking_live;

  /// No description provided for @feat_report_basic.
  ///
  /// In it, this message translates to:
  /// **'Report giornaliero (base)'**
  String get feat_report_basic;

  /// No description provided for @feat_report_advanced.
  ///
  /// In it, this message translates to:
  /// **'Timeline giornaliera avanzata'**
  String get feat_report_advanced;

  /// No description provided for @feat_places_routes.
  ///
  /// In it, this message translates to:
  /// **'Luoghi e percorsi ripetuti'**
  String get feat_places_routes;

  /// No description provided for @feat_export_gpx.
  ///
  /// In it, this message translates to:
  /// **'Esportazione GPX'**
  String get feat_export_gpx;

  /// No description provided for @feat_export_csv.
  ///
  /// In it, this message translates to:
  /// **'Esportazione CSV'**
  String get feat_export_csv;

  /// No description provided for @feat_notifications.
  ///
  /// In it, this message translates to:
  /// **'Notifiche'**
  String get feat_notifications;

  /// No description provided for @feat_backup_cloud.
  ///
  /// In it, this message translates to:
  /// **'Backup cloud'**
  String get feat_backup_cloud;

  /// No description provided for @feat_rewards.
  ///
  /// In it, this message translates to:
  /// **'Premi'**
  String get feat_rewards;

  /// No description provided for @feat_priority_support.
  ///
  /// In it, this message translates to:
  /// **'Supporto prioritario'**
  String get feat_priority_support;

  /// No description provided for @feat_no_ads.
  ///
  /// In it, this message translates to:
  /// **'Senza banner pubblicitari'**
  String get feat_no_ads;

  /// No description provided for @feat_history_days.
  ///
  /// In it, this message translates to:
  /// **'Storico consultabile'**
  String get feat_history_days;

  /// No description provided for @days.
  ///
  /// In it, this message translates to:
  /// **'giorni'**
  String get days;

  /// No description provided for @feat_gps.
  ///
  /// In it, this message translates to:
  /// **'Parametri GPS del piano'**
  String get feat_gps;

  /// No description provided for @feat_gps_sample_sec.
  ///
  /// In it, this message translates to:
  /// **'Campionamento (secondi)'**
  String get feat_gps_sample_sec;

  /// No description provided for @feat_gps_min_distance_m.
  ///
  /// In it, this message translates to:
  /// **'Distanza minima (metri)'**
  String get feat_gps_min_distance_m;

  /// No description provided for @feat_gps_upload_sec.
  ///
  /// In it, this message translates to:
  /// **'Invio in batch (secondi)'**
  String get feat_gps_upload_sec;

  /// No description provided for @feat_gps_background.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento in background'**
  String get feat_gps_background;

  /// No description provided for @feat_gps_max_acc_m.
  ///
  /// In it, this message translates to:
  /// **'Massima accuratezza (metri)'**
  String get feat_gps_max_acc_m;

  /// No description provided for @feat_gps_accuracy_mode.
  ///
  /// In it, this message translates to:
  /// **'Modalità precisione'**
  String get feat_gps_accuracy_mode;

  /// No description provided for @gps_accuracy_mode.
  ///
  /// In it, this message translates to:
  /// **'Modalità precisione'**
  String get gps_accuracy_mode;

  /// No description provided for @accuracy_low.
  ///
  /// In it, this message translates to:
  /// **'Bassa'**
  String get accuracy_low;

  /// No description provided for @accuracy_balanced.
  ///
  /// In it, this message translates to:
  /// **'Bilanciata'**
  String get accuracy_balanced;

  /// No description provided for @accuracy_high.
  ///
  /// In it, this message translates to:
  /// **'Alta'**
  String get accuracy_high;

  /// No description provided for @accuracy_best.
  ///
  /// In it, this message translates to:
  /// **'Massima'**
  String get accuracy_best;

  /// No description provided for @unit_seconds.
  ///
  /// In it, this message translates to:
  /// **'secondi'**
  String get unit_seconds;

  /// No description provided for @unit_meters.
  ///
  /// In it, this message translates to:
  /// **'metri'**
  String get unit_meters;

  /// No description provided for @gps_next_fix.
  ///
  /// In it, this message translates to:
  /// **'Prossima rilevazione tra {s}s'**
  String gps_next_fix(Object s);

  /// No description provided for @escl_prog_01.
  ///
  /// In it, this message translates to:
  /// **'Esclusioni programmate'**
  String get escl_prog_01;

  /// No description provided for @escl_prog_02.
  ///
  /// In it, this message translates to:
  /// **'Esclusioni disponibili solo da Livello Basic'**
  String get escl_prog_02;

  /// No description provided for @escl_prog_03.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi esclusione'**
  String get escl_prog_03;

  /// No description provided for @escl_prog_04.
  ///
  /// In it, this message translates to:
  /// **'Nessuna esclusione programmata impostata.'**
  String get escl_prog_04;

  /// No description provided for @escl_prog_05.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get escl_prog_05;

  /// No description provided for @escl_prog_06.
  ///
  /// In it, this message translates to:
  /// **'Nuova esclusione'**
  String get escl_prog_06;

  /// No description provided for @escl_prog_07.
  ///
  /// In it, this message translates to:
  /// **'Modifica esclusione'**
  String get escl_prog_07;

  /// No description provided for @escl_prog_08.
  ///
  /// In it, this message translates to:
  /// **'Ora inizio'**
  String get escl_prog_08;

  /// No description provided for @escl_prog_09.
  ///
  /// In it, this message translates to:
  /// **'Ora fine'**
  String get escl_prog_09;

  /// No description provided for @escl_prog_10.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get escl_prog_10;

  /// No description provided for @escl_prog_11.
  ///
  /// In it, this message translates to:
  /// **'Attiva'**
  String get escl_prog_11;

  /// No description provided for @escl_prog_12.
  ///
  /// In it, this message translates to:
  /// **'Giorni attivi:'**
  String get escl_prog_12;

  /// No description provided for @escl_prog_13.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get escl_prog_13;

  /// No description provided for @escl_prog_14.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get escl_prog_14;

  /// No description provided for @verifica_mail_titolo.
  ///
  /// In it, this message translates to:
  /// **'Verifica la tua email'**
  String get verifica_mail_titolo;

  /// No description provided for @verifica_mail_testo1.
  ///
  /// In it, this message translates to:
  /// **'Controlla la posta e clicca sul link di verifica.'**
  String get verifica_mail_testo1;

  /// No description provided for @verifica_mail_testo2.
  ///
  /// In it, this message translates to:
  /// **'Quando hai verificato, torna al login per accedere.'**
  String get verifica_mail_testo2;

  /// No description provided for @verifica_mail_testo3.
  ///
  /// In it, this message translates to:
  /// **'Quando hai verificato, torna al login per accedere.'**
  String get verifica_mail_testo3;

  /// No description provided for @verifica_mail_testo4.
  ///
  /// In it, this message translates to:
  /// **'Ho verificato, torna alla dashboard'**
  String get verifica_mail_testo4;

  /// No description provided for @verifica_mail_erro1.
  ///
  /// In it, this message translates to:
  /// **'Email inviata!'**
  String get verifica_mail_erro1;

  /// No description provided for @verifica_mail_erro2.
  ///
  /// In it, this message translates to:
  /// **'Errore invio email.'**
  String get verifica_mail_erro2;

  /// No description provided for @verifica_mail_button.
  ///
  /// In it, this message translates to:
  /// **'Reinvia email'**
  String get verifica_mail_button;

  /// No description provided for @acquisto_piano_conferma.
  ///
  /// In it, this message translates to:
  /// **'Conferma acquisto'**
  String get acquisto_piano_conferma;

  /// No description provided for @acquisto_piano_info.
  ///
  /// In it, this message translates to:
  /// **'Le tue informazioni.'**
  String get acquisto_piano_info;

  /// No description provided for @acquisto_piano_id.
  ///
  /// In it, this message translates to:
  /// **'ID utente:'**
  String get acquisto_piano_id;

  /// No description provided for @acquisto_piano_nome.
  ///
  /// In it, this message translates to:
  /// **'Nome:'**
  String get acquisto_piano_nome;

  /// No description provided for @acquisto_piano_mail.
  ///
  /// In it, this message translates to:
  /// **'Email:'**
  String get acquisto_piano_mail;

  /// No description provided for @acquisto_piano_durata.
  ///
  /// In it, this message translates to:
  /// **'Durata:'**
  String get acquisto_piano_durata;

  /// No description provided for @acquisto_piano_pagamento.
  ///
  /// In it, this message translates to:
  /// **'Procedi con pagamento'**
  String get acquisto_piano_pagamento;

  /// No description provided for @acquisto_piano_stripe.
  ///
  /// In it, this message translates to:
  /// **'Verrai indirizzato su Stripe...'**
  String get acquisto_piano_stripe;

  /// No description provided for @acquisto_piano_google.
  ///
  /// In it, this message translates to:
  /// **'Verrai indirizzato su Google...'**
  String get acquisto_piano_google;

  /// No description provided for @acquisto_piano_nopaga.
  ///
  /// In it, this message translates to:
  /// **'Pagamento non avviato:'**
  String get acquisto_piano_nopaga;

  /// No description provided for @acquisto_piano_attivo.
  ///
  /// In it, this message translates to:
  /// **'Piano attivato!'**
  String get acquisto_piano_attivo;

  /// No description provided for @card_gio_today.
  ///
  /// In it, this message translates to:
  /// **'Adesso'**
  String get card_gio_today;

  /// No description provided for @card_settimana.
  ///
  /// In it, this message translates to:
  /// **'Settimana'**
  String get card_settimana;

  /// No description provided for @card_gio_lunedi.
  ///
  /// In it, this message translates to:
  /// **'Lunedì'**
  String get card_gio_lunedi;

  /// No description provided for @card_gio_martedi.
  ///
  /// In it, this message translates to:
  /// **'Martedì'**
  String get card_gio_martedi;

  /// No description provided for @card_gio_mercoledi.
  ///
  /// In it, this message translates to:
  /// **'Mercoledì'**
  String get card_gio_mercoledi;

  /// No description provided for @card_gio_giovedi.
  ///
  /// In it, this message translates to:
  /// **'Giovedì'**
  String get card_gio_giovedi;

  /// No description provided for @card_gio_venerdi.
  ///
  /// In it, this message translates to:
  /// **'Venerdì'**
  String get card_gio_venerdi;

  /// No description provided for @card_gio_sabato.
  ///
  /// In it, this message translates to:
  /// **'Sabato'**
  String get card_gio_sabato;

  /// No description provided for @card_gio_domenica.
  ///
  /// In it, this message translates to:
  /// **'Domenica'**
  String get card_gio_domenica;

  /// No description provided for @today_title.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get today_title;

  /// No description provided for @today_title_closed.
  ///
  /// In it, this message translates to:
  /// **'Oggi — giornata conclusa'**
  String get today_title_closed;

  /// No description provided for @badge_partial.
  ///
  /// In it, this message translates to:
  /// **'Dati parziali'**
  String get badge_partial;

  /// No description provided for @kpi_active.
  ///
  /// In it, this message translates to:
  /// **'Tempo in movimento'**
  String get kpi_active;

  /// No description provided for @kpi_km.
  ///
  /// In it, this message translates to:
  /// **'Km'**
  String get kpi_km;

  /// No description provided for @kpi_sedentary.
  ///
  /// In it, this message translates to:
  /// **'Pause / Fermo'**
  String get kpi_sedentary;

  /// No description provided for @no_data_msg.
  ///
  /// In it, this message translates to:
  /// **'Non abbiamo ancora dati per oggi.'**
  String get no_data_msg;

  /// No description provided for @check_location.
  ///
  /// In it, this message translates to:
  /// **'Permessi posizione'**
  String get check_location;

  /// No description provided for @check_battery.
  ///
  /// In it, this message translates to:
  /// **'Risparmio batteria'**
  String get check_battery;

  /// No description provided for @check_gps.
  ///
  /// In it, this message translates to:
  /// **'Stato GPS'**
  String get check_gps;

  /// No description provided for @insight_quality.
  ///
  /// In it, this message translates to:
  /// **'Stiamo perdendo dati per il risparmio batteria. Tocca per sistemare.'**
  String get insight_quality;

  /// No description provided for @insight_goal_hit.
  ///
  /// In it, this message translates to:
  /// **'Hai raggiunto il tempo di movimento previsto oggi.'**
  String get insight_goal_hit;

  /// No description provided for @insight_goal_missing.
  ///
  /// In it, this message translates to:
  /// **'Ti mancano {v1} min per il tempo di movimento previsto.'**
  String insight_goal_missing(Object v1);

  /// No description provided for @insight_vs_yesterday.
  ///
  /// In it, this message translates to:
  /// **'Oggi sei al {v2}% rispetto a ieri.'**
  String insight_vs_yesterday(Object v2);

  /// No description provided for @fix_qualita_dati.
  ///
  /// In it, this message translates to:
  /// **'Qualità dati'**
  String get fix_qualita_dati;

  /// No description provided for @fix_message.
  ///
  /// In it, this message translates to:
  /// **'Sistema questi punti per evitare perdite di dati.'**
  String get fix_message;

  /// No description provided for @fix_permessi.
  ///
  /// In it, this message translates to:
  /// **'Permessi posizione (Sempre)'**
  String get fix_permessi;

  /// No description provided for @fix_permessi_sub.
  ///
  /// In it, this message translates to:
  /// **'Concedi “Sempre” alla posizione'**
  String get fix_permessi_sub;

  /// No description provided for @fix_gps_attivo.
  ///
  /// In it, this message translates to:
  /// **'GPS attivo e Alta precisione'**
  String get fix_gps_attivo;

  /// No description provided for @fix_gps_attivo_sub.
  ///
  /// In it, this message translates to:
  /// **'Apri impostazioni Localizzazione'**
  String get fix_gps_attivo_sub;

  /// No description provided for @fix_auto_start.
  ///
  /// In it, this message translates to:
  /// **'Autostart / Protezione app'**
  String get fix_auto_start;

  /// No description provided for @fix_auto_ricontrolla.
  ///
  /// In it, this message translates to:
  /// **'Ricontrolla'**
  String get fix_auto_ricontrolla;

  /// No description provided for @fix_battery.
  ///
  /// In it, this message translates to:
  /// **'Disattiva risparmio batteria per MoveUP'**
  String get fix_battery;

  /// No description provided for @fix_battery_sub.
  ///
  /// In it, this message translates to:
  /// **'Consenti “Ignora ottimizzazione batteria”'**
  String get fix_battery_sub;

  /// No description provided for @fix_vendor_01.
  ///
  /// In it, this message translates to:
  /// **'MIUI: Sicurezza → Autorizzazioni → Avvio automatico + Risparmio batteria.'**
  String get fix_vendor_01;

  /// No description provided for @fix_vendor_02.
  ///
  /// In it, this message translates to:
  /// **'EMUI: Impostazioni → Batteria → Avvio app (consenti avvio & background).'**
  String get fix_vendor_02;

  /// No description provided for @fix_vendor_03.
  ///
  /// In it, this message translates to:
  /// **'ColorOS/Funtouch: Abilita Avvio automatico e rimuovi ottimizzazione aggressiva.'**
  String get fix_vendor_03;

  /// No description provided for @fix_vendor_04.
  ///
  /// In it, this message translates to:
  /// **'OnePlus: Batteria → Ottimizzazione batteria → MoveUP → Non ottimizzare.'**
  String get fix_vendor_04;

  /// No description provided for @fix_vendor_05.
  ///
  /// In it, this message translates to:
  /// **'Samsung: Cura dispositivo → Batteria → App in sospensione: rimuovi MoveUP.'**
  String get fix_vendor_05;

  /// No description provided for @fix_vendor_06.
  ///
  /// In it, this message translates to:
  /// **'Controlla Autostart e protezione app del produttore.'**
  String get fix_vendor_06;

  /// No description provided for @fix_messag_01.
  ///
  /// In it, this message translates to:
  /// **'Vai in Impostazioni → Privacy e sicurezza → Localizzazione → MoveUP\nimposta “Sempre” e attiva “Posizione precisa”.\nControlla anche Risparmio energia: potrebbe ridurre le attività in background.'**
  String get fix_messag_01;

  /// No description provided for @fix_chiudi_button.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get fix_chiudi_button;

  /// No description provided for @fix_riduci_button.
  ///
  /// In it, this message translates to:
  /// **'Riduci'**
  String get fix_riduci_button;

  /// No description provided for @fix_espandi_button.
  ///
  /// In it, this message translates to:
  /// **'Espandi'**
  String get fix_espandi_button;

  /// No description provided for @dettagli.
  ///
  /// In it, this message translates to:
  /// **'Dettagli tecnici del giorno'**
  String get dettagli;

  /// No description provided for @posizione.
  ///
  /// In it, this message translates to:
  /// **'La tua posizione'**
  String get posizione;

  /// No description provided for @export_day.
  ///
  /// In it, this message translates to:
  /// **'Esporta dati del giorno'**
  String get export_day;

  /// No description provided for @date_parse_error.
  ///
  /// In it, this message translates to:
  /// **'Errore lettura data'**
  String get date_parse_error;

  /// No description provided for @export_started.
  ///
  /// In it, this message translates to:
  /// **'Esportazione avviata...'**
  String get export_started;

  /// No description provided for @download_start.
  ///
  /// In it, this message translates to:
  /// **'Download avviato nel browser'**
  String get download_start;

  /// No description provided for @esportazione_file.
  ///
  /// In it, this message translates to:
  /// **'Esportazione:'**
  String get esportazione_file;

  /// No description provided for @errore_http.
  ///
  /// In it, this message translates to:
  /// **'Errore download: HTTP'**
  String get errore_http;

  /// No description provided for @errore_generico.
  ///
  /// In it, this message translates to:
  /// **'Errore esportazione:'**
  String get errore_generico;

  /// No description provided for @dedica_title.
  ///
  /// In it, this message translates to:
  /// **'Dedicato a…'**
  String get dedica_title;

  /// No description provided for @dedica_testo.
  ///
  /// In it, this message translates to:
  /// **'Mia moglie e Lova, che mi hanno dato la forza di arrivare fino a qui. 💚🐾'**
  String get dedica_testo;

  /// No description provided for @analisi_oggi.
  ///
  /// In it, this message translates to:
  /// **'Analisi di oggi'**
  String get analisi_oggi;

  /// No description provided for @movimento.
  ///
  /// In it, this message translates to:
  /// **'Movimento'**
  String get movimento;

  /// No description provided for @non_reg.
  ///
  /// In it, this message translates to:
  /// **'Non registrato'**
  String get non_reg;

  /// No description provided for @parziale.
  ///
  /// In it, this message translates to:
  /// **'Parziale'**
  String get parziale;

  /// No description provided for @completo.
  ///
  /// In it, this message translates to:
  /// **'Completo'**
  String get completo;

  /// No description provided for @dati_incompleti.
  ///
  /// In it, this message translates to:
  /// **'Dati incompleti: il telefono non ha registrato per circa'**
  String get dati_incompleti;

  /// No description provided for @ottima_attivita.
  ///
  /// In it, this message translates to:
  /// **'Ottima attività oggi'**
  String get ottima_attivita;

  /// No description provided for @buona_attivita.
  ///
  /// In it, this message translates to:
  /// **'Buona attività, una parte della giornata l\'hai usata bene.'**
  String get buona_attivita;

  /// No description provided for @giorno_statico1.
  ///
  /// In it, this message translates to:
  /// **'Giornata piuttosto statica '**
  String get giorno_statico1;

  /// No description provided for @giorno_statico2.
  ///
  /// In it, this message translates to:
  /// **'fermo/pausa'**
  String get giorno_statico2;

  /// No description provided for @attivita_media.
  ///
  /// In it, this message translates to:
  /// **'Attività nella media.'**
  String get attivita_media;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
