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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
  /// In en, this message translates to:
  /// **'MoveUP'**
  String get appTitle;

  /// No description provided for @appSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Your movement assistant'**
  String get appSubTitle;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeUser(String name);

  /// No description provided for @anonymousUser.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get anonymousUser;

  /// No description provided for @lingua_sistema.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get lingua_sistema;

  /// No description provided for @priceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get priceFree;

  /// No description provided for @pricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String pricePerMonth(String price);

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one {# day} other {# days}}'**
  String durationDays(int days);

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @thisIsYourPlan.
  ///
  /// In en, this message translates to:
  /// **'This is your plan!'**
  String get thisIsYourPlan;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @durata_abbonamento.
  ///
  /// In en, this message translates to:
  /// **'Subscription duration:'**
  String get durata_abbonamento;

  /// No description provided for @onb1.
  ///
  /// In en, this message translates to:
  /// **'Do you really know what your day is like?'**
  String get onb1;

  /// No description provided for @onb1_body.
  ///
  /// In en, this message translates to:
  /// **''**
  String get onb1_body;

  /// No description provided for @onb2.
  ///
  /// In en, this message translates to:
  /// **'MoveUP listens. You live.'**
  String get onb2;

  /// No description provided for @onb2_body.
  ///
  /// In en, this message translates to:
  /// **'Let your time tell its story.'**
  String get onb2_body;

  /// No description provided for @onb3.
  ///
  /// In en, this message translates to:
  /// **'It\'s your time.'**
  String get onb3;

  /// No description provided for @onb3_body.
  ///
  /// In en, this message translates to:
  /// **'Tonight you\'ll know how it went.'**
  String get onb3_body;

  /// No description provided for @botton_salta.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get botton_salta;

  /// No description provided for @condizioni_uso.
  ///
  /// In en, this message translates to:
  /// **'I have read and accepted the '**
  String get condizioni_uso;

  /// No description provided for @condizioni_uso2.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get condizioni_uso2;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **' and the '**
  String get privacy_policy;

  /// No description provided for @privacy_policy2.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy2;

  /// No description provided for @botton_prosegui.
  ///
  /// In en, this message translates to:
  /// **'Start now!'**
  String get botton_prosegui;

  /// No description provided for @botton_indietro.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get botton_indietro;

  /// No description provided for @botton_avanti.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get botton_avanti;

  /// No description provided for @errore_001.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get errore_001;

  /// No description provided for @errore_002.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied'**
  String get errore_002;

  /// No description provided for @errore_003.
  ///
  /// In en, this message translates to:
  /// **'Error getting location:'**
  String get errore_003;

  /// No description provided for @errore_004.
  ///
  /// In en, this message translates to:
  /// **'Location service disabled on the device'**
  String get errore_004;

  /// No description provided for @user_err01.
  ///
  /// In en, this message translates to:
  /// **'User initialization error:'**
  String get user_err01;

  /// No description provided for @user_err02.
  ///
  /// In en, this message translates to:
  /// **'Invalid user'**
  String get user_err02;

  /// No description provided for @user_err03.
  ///
  /// In en, this message translates to:
  /// **'Last login updated for user'**
  String get user_err03;

  /// No description provided for @user_err04.
  ///
  /// In en, this message translates to:
  /// **'Last login update error'**
  String get user_err04;

  /// No description provided for @user_err05.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get user_err05;

  /// No description provided for @user_err06.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get user_err06;

  /// No description provided for @user_err07.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get user_err07;

  /// No description provided for @user_login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get user_login_success;

  /// No description provided for @gps_err01.
  ///
  /// In en, this message translates to:
  /// **'Location recording is disabled: enable it in settings.'**
  String get gps_err01;

  /// No description provided for @gps_err02.
  ///
  /// In en, this message translates to:
  /// **'Error saving location:'**
  String get gps_err02;

  /// No description provided for @gps_err03.
  ///
  /// In en, this message translates to:
  /// **'Location recording is disabled: the location is not being recorded.'**
  String get gps_err03;

  /// No description provided for @gps_err04.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get gps_err04;

  /// No description provided for @gps_err05.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied permanently'**
  String get gps_err05;

  /// No description provided for @gps_err06.
  ///
  /// In en, this message translates to:
  /// **'Weak GPS signal, wait for a better location fix'**
  String get gps_err06;

  /// No description provided for @gps_err07.
  ///
  /// In en, this message translates to:
  /// **'Error getting location:'**
  String get gps_err07;

  /// No description provided for @gps_err08.
  ///
  /// In en, this message translates to:
  /// **'Location saved!'**
  String get gps_err08;

  /// No description provided for @gps_err09.
  ///
  /// In en, this message translates to:
  /// **'Error saving location:'**
  String get gps_err09;

  /// No description provided for @gps_err10.
  ///
  /// In en, this message translates to:
  /// **'DEBUG API read consents:'**
  String get gps_err10;

  /// No description provided for @gps_err11.
  ///
  /// In en, this message translates to:
  /// **'DEBUG API GPS consent value:'**
  String get gps_err11;

  /// No description provided for @gps_err12.
  ///
  /// In en, this message translates to:
  /// **'Location recording '**
  String get gps_err12;

  /// No description provided for @gps_err13.
  ///
  /// In en, this message translates to:
  /// **'You must enable location recording in settings.'**
  String get gps_err13;

  /// No description provided for @gps_err14.
  ///
  /// In en, this message translates to:
  /// **'Recording on standby'**
  String get gps_err14;

  /// No description provided for @gps_err15.
  ///
  /// In en, this message translates to:
  /// **'Recording off'**
  String get gps_err15;

  /// No description provided for @gps_err16.
  ///
  /// In en, this message translates to:
  /// **'Next update in'**
  String get gps_err16;

  /// No description provided for @gps_err17.
  ///
  /// In en, this message translates to:
  /// **'GPS On'**
  String get gps_err17;

  /// No description provided for @gps_err18.
  ///
  /// In en, this message translates to:
  /// **'GPS Off'**
  String get gps_err18;

  /// No description provided for @gps_err19.
  ///
  /// In en, this message translates to:
  /// **'GPS logbook'**
  String get gps_err19;

  /// No description provided for @gps_err20.
  ///
  /// In en, this message translates to:
  /// **'No events recorded yet.'**
  String get gps_err20;

  /// No description provided for @gps_err21.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get gps_err21;

  /// No description provided for @gps_err22.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get gps_err22;

  /// No description provided for @gps_err23.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get gps_err23;

  /// No description provided for @gps_err24.
  ///
  /// In en, this message translates to:
  /// **'Resume recording'**
  String get gps_err24;

  /// No description provided for @gps_err25.
  ///
  /// In en, this message translates to:
  /// **'Pause recording'**
  String get gps_err25;

  /// No description provided for @gps_err26.
  ///
  /// In en, this message translates to:
  /// **'Resume recording'**
  String get gps_err26;

  /// No description provided for @att_err01.
  ///
  /// In en, this message translates to:
  /// **'Activity recalculation error:'**
  String get att_err01;

  /// No description provided for @att_err02.
  ///
  /// In en, this message translates to:
  /// **'Unchanged from yesterday'**
  String get att_err02;

  /// No description provided for @att_err03.
  ///
  /// In en, this message translates to:
  /// **'Compared to yesterday'**
  String get att_err03;

  /// No description provided for @att_err04.
  ///
  /// In en, this message translates to:
  /// **'Expand to see details...'**
  String get att_err04;

  /// No description provided for @att_err05.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded'**
  String get att_err05;

  /// No description provided for @info_mes01.
  ///
  /// In en, this message translates to:
  /// **'Start:'**
  String get info_mes01;

  /// No description provided for @info_mes02.
  ///
  /// In en, this message translates to:
  /// **'End:'**
  String get info_mes02;

  /// No description provided for @info_mes03.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get info_mes03;

  /// No description provided for @info_mes04.
  ///
  /// In en, this message translates to:
  /// **'Distance:'**
  String get info_mes04;

  /// No description provided for @info_mes05.
  ///
  /// In en, this message translates to:
  /// **'Source:'**
  String get info_mes05;

  /// No description provided for @info_mes06.
  ///
  /// In en, this message translates to:
  /// **'Estimated steps:'**
  String get info_mes06;

  /// No description provided for @info_mes07.
  ///
  /// In en, this message translates to:
  /// **'Understand how you move'**
  String get info_mes07;

  /// No description provided for @info_mes08.
  ///
  /// In en, this message translates to:
  /// **'Discover how you use your time'**
  String get info_mes08;

  /// No description provided for @mov_inattivo.
  ///
  /// In en, this message translates to:
  /// **'Pause / Stopped'**
  String get mov_inattivo;

  /// No description provided for @mov_leggero.
  ///
  /// In en, this message translates to:
  /// **'Slow movement'**
  String get mov_leggero;

  /// No description provided for @mov_veloce.
  ///
  /// In en, this message translates to:
  /// **'Fast movement'**
  String get mov_veloce;

  /// No description provided for @chart_mes01.
  ///
  /// In en, this message translates to:
  /// **'No charts available at this time.'**
  String get chart_mes01;

  /// No description provided for @chart_mes02.
  ///
  /// In en, this message translates to:
  /// **'Activity by Hours'**
  String get chart_mes02;

  /// No description provided for @chart_mes03.
  ///
  /// In en, this message translates to:
  /// **'Two-hour interval'**
  String get chart_mes03;

  /// No description provided for @chart_mes04.
  ///
  /// In en, this message translates to:
  /// **'Daily level distribution'**
  String get chart_mes04;

  /// No description provided for @chart_mes05.
  ///
  /// In en, this message translates to:
  /// **'Two-hour interval'**
  String get chart_mes05;

  /// No description provided for @chart_mes06.
  ///
  /// In en, this message translates to:
  /// **'Unable to generate the image. Please try again.'**
  String get chart_mes06;

  /// No description provided for @chart_mes07.
  ///
  /// In en, this message translates to:
  /// **'My MoveUP Report for today'**
  String get chart_mes07;

  /// No description provided for @cahrt_mes08.
  ///
  /// In en, this message translates to:
  /// **'Sharing error:'**
  String get cahrt_mes08;

  /// No description provided for @chart_mes09.
  ///
  /// In en, this message translates to:
  /// **'MoveUP Report for today'**
  String get chart_mes09;

  /// No description provided for @chart_mes10.
  ///
  /// In en, this message translates to:
  /// **'Levels timeline (by lanes)'**
  String get chart_mes10;

  /// No description provided for @um_metri.
  ///
  /// In en, this message translates to:
  /// **'Meters:'**
  String get um_metri;

  /// No description provided for @um_passi.
  ///
  /// In en, this message translates to:
  /// **'Steps:'**
  String get um_passi;

  /// No description provided for @um_km.
  ///
  /// In en, this message translates to:
  /// **'Km:'**
  String get um_km;

  /// No description provided for @form_reg_testa.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get form_reg_testa;

  /// No description provided for @form_reg_nome.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get form_reg_nome;

  /// No description provided for @form_reg_mail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get form_reg_mail;

  /// No description provided for @form_reg_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get form_reg_password;

  /// No description provided for @form_reg_err01.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get form_reg_err01;

  /// No description provided for @form_reg_err02.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get form_reg_err02;

  /// No description provided for @form_reg_err03.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters, include one uppercase letter and one number'**
  String get form_reg_err03;

  /// No description provided for @form_reg_err04.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Check your email and you can log in.'**
  String get form_reg_err04;

  /// No description provided for @form_reg_err05.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get form_reg_err05;

  /// No description provided for @form_reg_genere.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get form_reg_genere;

  /// No description provided for @form_reg_maschio.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get form_reg_maschio;

  /// No description provided for @form_reg_femmina.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get form_reg_femmina;

  /// No description provided for @form_reg_professione.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get form_reg_professione;

  /// No description provided for @form_reg_eta.
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get form_reg_eta;

  /// No description provided for @form_reg_ult_accesso.
  ///
  /// In en, this message translates to:
  /// **'Last access'**
  String get form_reg_ult_accesso;

  /// No description provided for @form_reg_consensi.
  ///
  /// In en, this message translates to:
  /// **'Settings and consents'**
  String get form_reg_consensi;

  /// No description provided for @form_reg_gps.
  ///
  /// In en, this message translates to:
  /// **'Location registration'**
  String get form_reg_gps;

  /// No description provided for @form_reg_err06.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get form_reg_err06;

  /// No description provided for @form_reg_country.
  ///
  /// In en, this message translates to:
  /// **'Country of residence'**
  String get form_reg_country;

  /// No description provided for @cambio_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get cambio_password;

  /// No description provided for @password_attuale_label.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get password_attuale_label;

  /// No description provided for @nuova_password_label.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get nuova_password_label;

  /// No description provided for @conferma_password_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get conferma_password_label;

  /// No description provided for @button_cambia_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get button_cambia_password;

  /// No description provided for @compila_tutti_campi.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get compila_tutti_campi;

  /// No description provided for @password_non_coincidono.
  ///
  /// In en, this message translates to:
  /// **'The new passwords do not match'**
  String get password_non_coincidono;

  /// No description provided for @password_diversa_dalla_attuale.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the current one'**
  String get password_diversa_dalla_attuale;

  /// No description provided for @password_controllo.
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 8 characters long and include one uppercase letter and one number'**
  String get password_controllo;

  /// No description provided for @password_cambiata.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get password_cambiata;

  /// No description provided for @password_errore.
  ///
  /// In en, this message translates to:
  /// **'Password change error'**
  String get password_errore;

  /// No description provided for @password_dimenticata.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get password_dimenticata;

  /// No description provided for @reimposta_password.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reimposta_password;

  /// No description provided for @inserisci_mail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive the reset link.'**
  String get inserisci_mail;

  /// No description provided for @inserisci_tua_mail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get inserisci_tua_mail;

  /// No description provided for @link_mail_password.
  ///
  /// In en, this message translates to:
  /// **'If the email is registered, we\'ve sent you a link to reset your password.'**
  String get link_mail_password;

  /// No description provided for @invia_richiesta_label.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get invia_richiesta_label;

  /// No description provided for @condividi_button.
  ///
  /// In en, this message translates to:
  /// **''**
  String get condividi_button;

  /// No description provided for @form_consensi_01.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get form_consensi_01;

  /// No description provided for @form_consensi_02.
  ///
  /// In en, this message translates to:
  /// **'I accept the Privacy Policy'**
  String get form_consensi_02;

  /// No description provided for @form_consensi_03.
  ///
  /// In en, this message translates to:
  /// **'I agree to receive marketing communications'**
  String get form_consensi_03;

  /// No description provided for @form_consensi_04.
  ///
  /// In en, this message translates to:
  /// **'I agree to participate in contests and rewards'**
  String get form_consensi_04;

  /// No description provided for @form_consensi_05.
  ///
  /// In en, this message translates to:
  /// **'I agree to the position registration'**
  String get form_consensi_05;

  /// No description provided for @form_consensi_06.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get form_consensi_06;

  /// No description provided for @form_consensi_er.
  ///
  /// In en, this message translates to:
  /// **'Error while saving consents:'**
  String get form_consensi_er;

  /// No description provided for @form_consensi_07.
  ///
  /// In en, this message translates to:
  /// **'To use MoveUP, you must accept the Privacy Policy.'**
  String get form_consensi_07;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get session_expired;

  /// No description provided for @token_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid token: please log in again.'**
  String get token_invalid;

  /// No description provided for @payment_mes1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get payment_mes1;

  /// No description provided for @payment_mes2.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get payment_mes2;

  /// No description provided for @payment_mes3.
  ///
  /// In en, this message translates to:
  /// **'1 day left'**
  String get payment_mes3;

  /// No description provided for @payment_mes4.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get payment_mes4;

  /// No description provided for @bottom_impostazioni.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get bottom_impostazioni;

  /// No description provided for @bottom_cronologia.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get bottom_cronologia;

  /// No description provided for @bottom_profilo.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get bottom_profilo;

  /// No description provided for @bottom_abbonamenti.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get bottom_abbonamenti;

  /// No description provided for @bottom_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottom_dashboard;

  /// No description provided for @bottom_impostazioni_short.
  ///
  /// In en, this message translates to:
  /// **'Set.'**
  String get bottom_impostazioni_short;

  /// No description provided for @bottom_cronologia_short.
  ///
  /// In en, this message translates to:
  /// **'Act.'**
  String get bottom_cronologia_short;

  /// No description provided for @bottom_profilo_short.
  ///
  /// In en, this message translates to:
  /// **'Prof.'**
  String get bottom_profilo_short;

  /// No description provided for @bottom_abbonamenti_short.
  ///
  /// In en, this message translates to:
  /// **'Sub.'**
  String get bottom_abbonamenti_short;

  /// No description provided for @bottom_impostazioni_tt.
  ///
  /// In en, this message translates to:
  /// **'Open settings and consents'**
  String get bottom_impostazioni_tt;

  /// No description provided for @bottom_cronologia_tt.
  ///
  /// In en, this message translates to:
  /// **'View your recorded activity'**
  String get bottom_cronologia_tt;

  /// No description provided for @bottom_profilo_tt.
  ///
  /// In en, this message translates to:
  /// **'Sign up, log in or log out of your profile'**
  String get bottom_profilo_tt;

  /// No description provided for @bottom_abbonamenti_tt.
  ///
  /// In en, this message translates to:
  /// **'Manage your MoveUP subscription'**
  String get bottom_abbonamenti_tt;

  /// No description provided for @bottom_dashboard_tt.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get bottom_dashboard_tt;

  /// No description provided for @bottom_err01.
  ///
  /// In en, this message translates to:
  /// **'Function available only for registered users!'**
  String get bottom_err01;

  /// No description provided for @bottom_err02.
  ///
  /// In en, this message translates to:
  /// **'Invalid user!'**
  String get bottom_err02;

  /// No description provided for @bottom_nome.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get bottom_nome;

  /// No description provided for @bottom_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get bottom_logout;

  /// No description provided for @map_mes_01.
  ///
  /// In en, this message translates to:
  /// **'Update location'**
  String get map_mes_01;

  /// No description provided for @rep_day_mes01.
  ///
  /// In en, this message translates to:
  /// **'Daily report'**
  String get rep_day_mes01;

  /// No description provided for @rep_day_mes02.
  ///
  /// In en, this message translates to:
  /// **'Last location'**
  String get rep_day_mes02;

  /// No description provided for @rep_day_chiedi_AI.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI to…'**
  String get rep_day_chiedi_AI;

  /// No description provided for @rep_day_button_01.
  ///
  /// In en, this message translates to:
  /// **'Explain the day'**
  String get rep_day_button_01;

  /// No description provided for @rep_day_button_02.
  ///
  /// In en, this message translates to:
  /// **'Tip for tomorrow'**
  String get rep_day_button_02;

  /// No description provided for @rep_day_button_03.
  ///
  /// In en, this message translates to:
  /// **'Why am I inactive?'**
  String get rep_day_button_03;

  /// No description provided for @rep_day_ai_loading.
  ///
  /// In en, this message translates to:
  /// **'The AI is processing your request…'**
  String get rep_day_ai_loading;

  /// No description provided for @rep_day_ai_error.
  ///
  /// In en, this message translates to:
  /// **'AI error: please try again later.'**
  String get rep_day_ai_error;

  /// No description provided for @rep_day_ai_limit.
  ///
  /// In en, this message translates to:
  /// **'You have reached the daily AI request limit.'**
  String get rep_day_ai_limit;

  /// No description provided for @rep_day_ai_response.
  ///
  /// In en, this message translates to:
  /// **'AI response:'**
  String get rep_day_ai_response;

  /// No description provided for @rep_day_ai_info.
  ///
  /// In en, this message translates to:
  /// **'The AI response will appear here.'**
  String get rep_day_ai_info;

  /// No description provided for @rep_day_ai_error_01.
  ///
  /// In en, this message translates to:
  /// **'No response available'**
  String get rep_day_ai_error_01;

  /// No description provided for @rep_day_ai_error_02.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get rep_day_ai_error_02;

  /// No description provided for @rep_day_ai_error_03.
  ///
  /// In en, this message translates to:
  /// **'I analysis not available for your plan.'**
  String get rep_day_ai_error_03;

  /// No description provided for @rep_day_ai_error_04.
  ///
  /// In en, this message translates to:
  /// **'To use AI you must first enable consent in settings.'**
  String get rep_day_ai_error_04;

  /// No description provided for @rep_day_ai_error_05.
  ///
  /// In en, this message translates to:
  /// **'AI function not available at this time.'**
  String get rep_day_ai_error_05;

  /// No description provided for @rep_week_insight_empty.
  ///
  /// In en, this message translates to:
  /// **'This week shows no recurring routes. Keep using MoveUP to discover your habits.'**
  String get rep_week_insight_empty;

  /// No description provided for @rep_week_insight_01.
  ///
  /// In en, this message translates to:
  /// **'You followed the same route on {count} different days ({days}). This indicates a possible movement habit.'**
  String rep_week_insight_01(Object count, Object days);

  /// No description provided for @rep_week_insight_02.
  ///
  /// In en, this message translates to:
  /// **'A route repeated {count} times ({days}). It could be a forming routine.'**
  String rep_week_insight_02(Object count, Object days);

  /// No description provided for @rep_week_insight_03.
  ///
  /// In en, this message translates to:
  /// **'MoveUP can analyze your weekly movement habits.'**
  String get rep_week_insight_03;

  /// No description provided for @rep_week_insight_04.
  ///
  /// In en, this message translates to:
  /// **'What does this week reveal'**
  String get rep_week_insight_04;

  /// No description provided for @rep_week_insight_05.
  ///
  /// In en, this message translates to:
  /// **'MoveUP thinks:'**
  String get rep_week_insight_05;

  /// No description provided for @rep_week_insight_06.
  ///
  /// In en, this message translates to:
  /// **'MoveUP is analyzing...'**
  String get rep_week_insight_06;

  /// No description provided for @rep_week_insight_07.
  ///
  /// In en, this message translates to:
  /// **'MoveUP’s insight will appear here.'**
  String get rep_week_insight_07;

  /// No description provided for @storico_01.
  ///
  /// In en, this message translates to:
  /// **'Choose how much history you want to keep. The rest grows with you.'**
  String get storico_01;

  /// No description provided for @storico_02.
  ///
  /// In en, this message translates to:
  /// **'Free (Anonymous)'**
  String get storico_02;

  /// No description provided for @storico_03.
  ///
  /// In en, this message translates to:
  /// **'Use the app without signing up.\nYour location can also be collected in the background to calculate, in real time, distance traveled, time in movement and pause moments.\nData stays only on your device, is valid for the current day, and is deleted automatically every day.\nFeatures: live tracking and daily summary.'**
  String get storico_03;

  /// No description provided for @storico_04.
  ///
  /// In en, this message translates to:
  /// **'Start (Registered)'**
  String get storico_04;

  /// No description provided for @storico_05.
  ///
  /// In en, this message translates to:
  /// **'Free account with 7-day history.\nFeatures: live and background tracking, cloud backup, sync across devices, notifications.'**
  String get storico_05;

  /// No description provided for @storico_06.
  ///
  /// In en, this message translates to:
  /// **'Basic — 30 days (Paid)'**
  String get storico_06;

  /// No description provided for @storico_07.
  ///
  /// In en, this message translates to:
  /// **'30-day history.\nFeatures: advanced daily timeline, per-level metrics (still/slow/fast), repeated places and routes.'**
  String get storico_07;

  /// No description provided for @storico_08.
  ///
  /// In en, this message translates to:
  /// **'Plus — 180 days (Paid)'**
  String get storico_08;

  /// No description provided for @storico_09.
  ///
  /// In en, this message translates to:
  /// **'6-month history.\nFeatures: everything in Basic + analysis of recurring routes/places with weekly/monthly summaries.'**
  String get storico_09;

  /// No description provided for @storico_10.
  ///
  /// In en, this message translates to:
  /// **'Pro — 365 days (Paid)'**
  String get storico_10;

  /// No description provided for @storico_11.
  ///
  /// In en, this message translates to:
  /// **'1-year history.\nFeatures: advanced reports, detailed filters, priority support, no ads.'**
  String get storico_11;

  /// No description provided for @storico_12.
  ///
  /// In en, this message translates to:
  /// **'Privacy note:'**
  String get storico_12;

  /// No description provided for @storico_13.
  ///
  /// In en, this message translates to:
  /// **'The app may collect your location in the background to calculate your trips, distance traveled and time in movement.\nYou can change or withdraw consent at any time.\nWithout tracking consent we do not store locations.\nIf you use the app in anonymous mode (no registration), data stays only on the device and is automatically deleted at the end of the day: we do not keep history of previous days and we do not link locations to a personal profile.'**
  String get storico_13;

  /// No description provided for @storico_14.
  ///
  /// In en, this message translates to:
  /// **'⏳ Loading data…'**
  String get storico_14;

  /// No description provided for @form_crono_01.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get form_crono_01;

  /// No description provided for @form_crono_02.
  ///
  /// In en, this message translates to:
  /// **'Activity Summary'**
  String get form_crono_02;

  /// No description provided for @form_crono_03.
  ///
  /// In en, this message translates to:
  /// **'Welcome, '**
  String get form_crono_03;

  /// No description provided for @form_crono_04.
  ///
  /// In en, this message translates to:
  /// **'Summary for last 7 days'**
  String get form_crono_04;

  /// No description provided for @form_crono_05.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded'**
  String get form_crono_05;

  /// No description provided for @form_crono_06.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get form_crono_06;

  /// No description provided for @form_crono_07.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get form_crono_07;

  /// No description provided for @form_crono_08.
  ///
  /// In en, this message translates to:
  /// **'Level details'**
  String get form_crono_08;

  /// No description provided for @form_crono_09.
  ///
  /// In en, this message translates to:
  /// **'Details for level'**
  String get form_crono_09;

  /// No description provided for @form_crono_10.
  ///
  /// In en, this message translates to:
  /// **'Summary from 8 to 14 days'**
  String get form_crono_10;

  /// No description provided for @form_crono_11.
  ///
  /// In en, this message translates to:
  /// **'Weekly comparison'**
  String get form_crono_11;

  /// No description provided for @dashboard_piano.
  ///
  /// In en, this message translates to:
  /// **'Plan:'**
  String get dashboard_piano;

  /// No description provided for @dashboard_msg.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile and register.\nYou will have your typical week'**
  String get dashboard_msg;

  /// No description provided for @imposta_page_studente.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get imposta_page_studente;

  /// No description provided for @imposta_page_impiegato.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get imposta_page_impiegato;

  /// No description provided for @imposta_page_libero.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get imposta_page_libero;

  /// No description provided for @imposta_page_disoccupato.
  ///
  /// In en, this message translates to:
  /// **'Unemployed'**
  String get imposta_page_disoccupato;

  /// No description provided for @imposta_page_pensionato.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get imposta_page_pensionato;

  /// No description provided for @imposta_page_altro.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get imposta_page_altro;

  /// No description provided for @imposta_page_lista.
  ///
  /// In en, this message translates to:
  /// **'Student,Employee,Freelancer,Unemployed,Retired,Other'**
  String get imposta_page_lista;

  /// No description provided for @imposta_page_miei.
  ///
  /// In en, this message translates to:
  /// **'My personal data'**
  String get imposta_page_miei;

  /// No description provided for @imposta_page_notifiche.
  ///
  /// In en, this message translates to:
  /// **'Active notifications'**
  String get imposta_page_notifiche;

  /// No description provided for @imposta_page_consenso.
  ///
  /// In en, this message translates to:
  /// **'Privacy consent'**
  String get imposta_page_consenso;

  /// No description provided for @imposta_page_marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing consent'**
  String get imposta_page_marketing;

  /// No description provided for @imposta_page_premi.
  ///
  /// In en, this message translates to:
  /// **'Contest & rewards consent'**
  String get imposta_page_premi;

  /// No description provided for @imposta_page_datac.
  ///
  /// In en, this message translates to:
  /// **'Consent date'**
  String get imposta_page_datac;

  /// No description provided for @imposta_page_frequenza.
  ///
  /// In en, this message translates to:
  /// **'Detection rate (sec)'**
  String get imposta_page_frequenza;

  /// No description provided for @imposta_page_piani.
  ///
  /// In en, this message translates to:
  /// **'Subscription plans'**
  String get imposta_page_piani;

  /// No description provided for @imposta_page_importo.
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get imposta_page_importo;

  /// No description provided for @imposta_page_durata.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get imposta_page_durata;

  /// No description provided for @imposta_page_cancella.
  ///
  /// In en, this message translates to:
  /// **'Data deletion: after '**
  String get imposta_page_cancella;

  /// No description provided for @imposta_page_funzioni.
  ///
  /// In en, this message translates to:
  /// **'Active features:'**
  String get imposta_page_funzioni;

  /// No description provided for @imposta_page_save.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get imposta_page_save;

  /// No description provided for @imposta_page_mess1.
  ///
  /// In en, this message translates to:
  /// **'Personal data updated!'**
  String get imposta_page_mess1;

  /// No description provided for @imposta_page_mess2.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get imposta_page_mess2;

  /// No description provided for @imposta_page_mess3.
  ///
  /// In en, this message translates to:
  /// **'Unable to update.'**
  String get imposta_page_mess3;

  /// No description provided for @imposta_page_mess4.
  ///
  /// In en, this message translates to:
  /// **'Network error.'**
  String get imposta_page_mess4;

  /// No description provided for @imposta_page_mess5.
  ///
  /// In en, this message translates to:
  /// **'Settings updated!'**
  String get imposta_page_mess5;

  /// No description provided for @imposta_page_mess6.
  ///
  /// In en, this message translates to:
  /// **'Data saved!'**
  String get imposta_page_mess6;

  /// No description provided for @imposta_page_ai.
  ///
  /// In en, this message translates to:
  /// **'AI Consent'**
  String get imposta_page_ai;

  /// No description provided for @footer_page_diritti.
  ///
  /// In en, this message translates to:
  /// **'© 2025 MoveUP - All rights reserved'**
  String get footer_page_diritti;

  /// No description provided for @footer_page_banner.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Move'**
  String get footer_page_banner;

  /// No description provided for @footer_page_versione.
  ///
  /// In en, this message translates to:
  /// **'App version:'**
  String get footer_page_versione;

  /// No description provided for @header_page_banner.
  ///
  /// In en, this message translates to:
  /// **'Your Personal Move'**
  String get header_page_banner;

  /// No description provided for @rep_day_export_locked.
  ///
  /// In en, this message translates to:
  /// **'Sharing requires START/BASIC/PLUS/PRO'**
  String get rep_day_export_locked;

  /// No description provided for @rep_day_function_ai.
  ///
  /// In en, this message translates to:
  /// **'Functions available with START/BASIC/PLUS/PRO'**
  String get rep_day_function_ai;

  /// No description provided for @msg_abilitato_01.
  ///
  /// In en, this message translates to:
  /// **'Register your profile to see your data for today.'**
  String get msg_abilitato_01;

  /// No description provided for @msg_abilitato_02.
  ///
  /// In en, this message translates to:
  /// **'Register your profile to see your data for today.'**
  String get msg_abilitato_02;

  /// No description provided for @crono_msg_01.
  ///
  /// In en, this message translates to:
  /// **'Register your profile to see your data for today.'**
  String get crono_msg_01;

  /// No description provided for @crono_msg_02.
  ///
  /// In en, this message translates to:
  /// **'Your plan allows up to'**
  String get crono_msg_02;

  /// No description provided for @crono_msg_03.
  ///
  /// In en, this message translates to:
  /// **'days of history.'**
  String get crono_msg_03;

  /// No description provided for @crono_msg_04.
  ///
  /// In en, this message translates to:
  /// **'Route not available. Try again.'**
  String get crono_msg_04;

  /// No description provided for @crono_msg_05.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get crono_msg_05;

  /// No description provided for @card_percorso_1.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get card_percorso_1;

  /// No description provided for @card_percorso_2.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get card_percorso_2;

  /// No description provided for @card_percorso_3.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get card_percorso_3;

  /// No description provided for @card_percorso_4.
  ///
  /// In en, this message translates to:
  /// **'Route for'**
  String get card_percorso_4;

  /// No description provided for @card_percorso_5.
  ///
  /// In en, this message translates to:
  /// **'No movement on this date'**
  String get card_percorso_5;

  /// No description provided for @feat_tracking_live.
  ///
  /// In en, this message translates to:
  /// **'Live location recording'**
  String get feat_tracking_live;

  /// No description provided for @feat_report_basic.
  ///
  /// In en, this message translates to:
  /// **'Daily report (basic)'**
  String get feat_report_basic;

  /// No description provided for @feat_report_advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced daily timeline'**
  String get feat_report_advanced;

  /// No description provided for @feat_places_routes.
  ///
  /// In en, this message translates to:
  /// **'Places & repeated routes'**
  String get feat_places_routes;

  /// No description provided for @feat_export_gpx.
  ///
  /// In en, this message translates to:
  /// **'GPX export'**
  String get feat_export_gpx;

  /// No description provided for @feat_export_csv.
  ///
  /// In en, this message translates to:
  /// **'CSV export'**
  String get feat_export_csv;

  /// No description provided for @feat_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get feat_notifications;

  /// No description provided for @feat_backup_cloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup'**
  String get feat_backup_cloud;

  /// No description provided for @feat_rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get feat_rewards;

  /// No description provided for @feat_priority_support.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get feat_priority_support;

  /// No description provided for @feat_no_ads.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get feat_no_ads;

  /// No description provided for @feat_history_days.
  ///
  /// In en, this message translates to:
  /// **'Viewable history'**
  String get feat_history_days;

  /// No description provided for @feat_ai_enabled.
  ///
  /// In en, this message translates to:
  /// **'AI enabled'**
  String get feat_ai_enabled;

  /// No description provided for @feat_ai_daily_limit.
  ///
  /// In en, this message translates to:
  /// **'AI daily limit'**
  String get feat_ai_daily_limit;

  /// No description provided for @feat_ai_scope.
  ///
  /// In en, this message translates to:
  /// **'AI scope'**
  String get feat_ai_scope;

  /// No description provided for @feat_ai.
  ///
  /// In en, this message translates to:
  /// **'AI features'**
  String get feat_ai;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @feat_gps.
  ///
  /// In en, this message translates to:
  /// **'Plane Recording Parameters'**
  String get feat_gps;

  /// No description provided for @feat_gps_sample_sec.
  ///
  /// In en, this message translates to:
  /// **'Sampling (seconds)'**
  String get feat_gps_sample_sec;

  /// No description provided for @feat_gps_min_distance_m.
  ///
  /// In en, this message translates to:
  /// **'Minimum distance (meters)'**
  String get feat_gps_min_distance_m;

  /// No description provided for @feat_gps_upload_sec.
  ///
  /// In en, this message translates to:
  /// **'Batch upload (seconds)'**
  String get feat_gps_upload_sec;

  /// No description provided for @feat_gps_background.
  ///
  /// In en, this message translates to:
  /// **'Background detection'**
  String get feat_gps_background;

  /// No description provided for @gps_accuracy_mode.
  ///
  /// In en, this message translates to:
  /// **'Accuracy mode'**
  String get gps_accuracy_mode;

  /// No description provided for @feat_gps_max_acc_m.
  ///
  /// In en, this message translates to:
  /// **'Maximum accuracy (meters)'**
  String get feat_gps_max_acc_m;

  /// No description provided for @feat_gps_accuracy_mode.
  ///
  /// In en, this message translates to:
  /// **'Accuracy mode'**
  String get feat_gps_accuracy_mode;

  /// No description provided for @accuracy_low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get accuracy_low;

  /// No description provided for @accuracy_balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get accuracy_balanced;

  /// No description provided for @accuracy_high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get accuracy_high;

  /// No description provided for @accuracy_best.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get accuracy_best;

  /// No description provided for @unit_seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get unit_seconds;

  /// No description provided for @unit_meters.
  ///
  /// In en, this message translates to:
  /// **'meters'**
  String get unit_meters;

  /// No description provided for @gps_next_fix.
  ///
  /// In en, this message translates to:
  /// **'Next fix in {s}s'**
  String gps_next_fix(Object s);

  /// No description provided for @escl_prog_01.
  ///
  /// In en, this message translates to:
  /// **'Scheduled exclusions'**
  String get escl_prog_01;

  /// No description provided for @escl_prog_02.
  ///
  /// In en, this message translates to:
  /// **'Exclusions available on Basic and above'**
  String get escl_prog_02;

  /// No description provided for @escl_prog_03.
  ///
  /// In en, this message translates to:
  /// **'Add exclusion'**
  String get escl_prog_03;

  /// No description provided for @escl_prog_04.
  ///
  /// In en, this message translates to:
  /// **'No scheduled exclusions configured.'**
  String get escl_prog_04;

  /// No description provided for @escl_prog_05.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get escl_prog_05;

  /// No description provided for @escl_prog_06.
  ///
  /// In en, this message translates to:
  /// **'New exclusion'**
  String get escl_prog_06;

  /// No description provided for @escl_prog_07.
  ///
  /// In en, this message translates to:
  /// **'Edit exclusion'**
  String get escl_prog_07;

  /// No description provided for @escl_prog_08.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get escl_prog_08;

  /// No description provided for @escl_prog_09.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get escl_prog_09;

  /// No description provided for @escl_prog_10.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get escl_prog_10;

  /// No description provided for @escl_prog_11.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get escl_prog_11;

  /// No description provided for @escl_prog_12.
  ///
  /// In en, this message translates to:
  /// **'Active days:'**
  String get escl_prog_12;

  /// No description provided for @escl_prog_13.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get escl_prog_13;

  /// No description provided for @escl_prog_14.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get escl_prog_14;

  /// No description provided for @verifica_mail_titolo.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifica_mail_titolo;

  /// No description provided for @verifica_mail_testo1.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox and click the verification link.'**
  String get verifica_mail_testo1;

  /// No description provided for @verifica_mail_testo2.
  ///
  /// In en, this message translates to:
  /// **'Once you\'ve verified, return to the login to sign in.'**
  String get verifica_mail_testo2;

  /// No description provided for @verifica_mail_testo3.
  ///
  /// In en, this message translates to:
  /// **'Once you\'ve verified, return to the login to sign in.'**
  String get verifica_mail_testo3;

  /// No description provided for @verifica_mail_testo4.
  ///
  /// In en, this message translates to:
  /// **'I\'ve verified, go to the dashboard'**
  String get verifica_mail_testo4;

  /// No description provided for @verifica_mail_erro1.
  ///
  /// In en, this message translates to:
  /// **'Email sent!'**
  String get verifica_mail_erro1;

  /// No description provided for @verifica_mail_erro2.
  ///
  /// In en, this message translates to:
  /// **'Failed to send the email.'**
  String get verifica_mail_erro2;

  /// No description provided for @verifica_mail_button.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get verifica_mail_button;

  /// No description provided for @acquisto_piano_conferma.
  ///
  /// In en, this message translates to:
  /// **'Confirm purchase'**
  String get acquisto_piano_conferma;

  /// No description provided for @acquisto_piano_info.
  ///
  /// In en, this message translates to:
  /// **'Your information.'**
  String get acquisto_piano_info;

  /// No description provided for @acquisto_piano_id.
  ///
  /// In en, this message translates to:
  /// **'User ID:'**
  String get acquisto_piano_id;

  /// No description provided for @acquisto_piano_nome.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get acquisto_piano_nome;

  /// No description provided for @acquisto_piano_mail.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get acquisto_piano_mail;

  /// No description provided for @acquisto_piano_durata.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get acquisto_piano_durata;

  /// No description provided for @acquisto_piano_pagamento.
  ///
  /// In en, this message translates to:
  /// **'Proceed to payment'**
  String get acquisto_piano_pagamento;

  /// No description provided for @acquisto_piano_stripe.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to Stripe...'**
  String get acquisto_piano_stripe;

  /// No description provided for @acquisto_piano_google.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to Google...'**
  String get acquisto_piano_google;

  /// No description provided for @acquisto_piano_nopaga.
  ///
  /// In en, this message translates to:
  /// **'Payment not started:'**
  String get acquisto_piano_nopaga;

  /// No description provided for @acquisto_piano_attivo.
  ///
  /// In en, this message translates to:
  /// **'Plan activated!'**
  String get acquisto_piano_attivo;

  /// No description provided for @card_settimana.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get card_settimana;

  /// No description provided for @card_gio_today.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get card_gio_today;

  /// No description provided for @card_gio_lunedi.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get card_gio_lunedi;

  /// No description provided for @card_gio_martedi.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get card_gio_martedi;

  /// No description provided for @card_gio_mercoledi.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get card_gio_mercoledi;

  /// No description provided for @card_gio_giovedi.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get card_gio_giovedi;

  /// No description provided for @card_gio_venerdi.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get card_gio_venerdi;

  /// No description provided for @card_gio_sabato.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get card_gio_sabato;

  /// No description provided for @card_gio_domenica.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get card_gio_domenica;

  /// No description provided for @today_title.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today_title;

  /// No description provided for @today_title_closed.
  ///
  /// In en, this message translates to:
  /// **'Today — day finished'**
  String get today_title_closed;

  /// No description provided for @badge_partial.
  ///
  /// In en, this message translates to:
  /// **'Partial data'**
  String get badge_partial;

  /// No description provided for @kpi_active.
  ///
  /// In en, this message translates to:
  /// **'Time in movement'**
  String get kpi_active;

  /// No description provided for @kpi_km.
  ///
  /// In en, this message translates to:
  /// **'Km'**
  String get kpi_km;

  /// No description provided for @kpi_sedentary.
  ///
  /// In en, this message translates to:
  /// **'Pauses / Stopped'**
  String get kpi_sedentary;

  /// No description provided for @no_data_msg.
  ///
  /// In en, this message translates to:
  /// **'We don’t have any data for today yet.'**
  String get no_data_msg;

  /// No description provided for @check_location.
  ///
  /// In en, this message translates to:
  /// **'Location permissions'**
  String get check_location;

  /// No description provided for @check_battery.
  ///
  /// In en, this message translates to:
  /// **'Battery saver'**
  String get check_battery;

  /// No description provided for @check_gps.
  ///
  /// In en, this message translates to:
  /// **'GPS status'**
  String get check_gps;

  /// No description provided for @insight_quality.
  ///
  /// In en, this message translates to:
  /// **'We’re missing data due to battery saver. Tap to fix.'**
  String get insight_quality;

  /// No description provided for @insight_goal_hit.
  ///
  /// In en, this message translates to:
  /// **'You reached your planned movement time today.'**
  String get insight_goal_hit;

  /// No description provided for @insight_goal_missing.
  ///
  /// In en, this message translates to:
  /// **'You’re {v1} min away from the planned movement time.'**
  String insight_goal_missing(Object v1);

  /// No description provided for @insight_vs_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Today you’re at {v2}% compared to yesterday.'**
  String insight_vs_yesterday(Object v2);

  /// No description provided for @fix_qualita_dati.
  ///
  /// In en, this message translates to:
  /// **'Data quality'**
  String get fix_qualita_dati;

  /// No description provided for @fix_message.
  ///
  /// In en, this message translates to:
  /// **'Fix these points to avoid data loss.'**
  String get fix_message;

  /// No description provided for @fix_permessi.
  ///
  /// In en, this message translates to:
  /// **'Location permissions (Always)'**
  String get fix_permessi;

  /// No description provided for @fix_permessi_sub.
  ///
  /// In en, this message translates to:
  /// **'Grant “Always” location access'**
  String get fix_permessi_sub;

  /// No description provided for @fix_gps_attivo.
  ///
  /// In en, this message translates to:
  /// **'GPS on and High accuracy'**
  String get fix_gps_attivo;

  /// No description provided for @fix_gps_attivo_sub.
  ///
  /// In en, this message translates to:
  /// **'Open Location settings'**
  String get fix_gps_attivo_sub;

  /// No description provided for @fix_auto_start.
  ///
  /// In en, this message translates to:
  /// **'Autostart / App protection'**
  String get fix_auto_start;

  /// No description provided for @fix_auto_ricontrolla.
  ///
  /// In en, this message translates to:
  /// **'Re-check'**
  String get fix_auto_ricontrolla;

  /// No description provided for @fix_battery.
  ///
  /// In en, this message translates to:
  /// **'Disable battery optimization for MoveUP'**
  String get fix_battery;

  /// No description provided for @fix_battery_sub.
  ///
  /// In en, this message translates to:
  /// **'Allow “Ignore battery optimization”'**
  String get fix_battery_sub;

  /// No description provided for @fix_vendor_01.
  ///
  /// In en, this message translates to:
  /// **'MIUI: Security → Permissions → Auto-start + Battery saver.'**
  String get fix_vendor_01;

  /// No description provided for @fix_vendor_02.
  ///
  /// In en, this message translates to:
  /// **'EMUI: Settings → Battery → App launch (allow auto-launch & background).'**
  String get fix_vendor_02;

  /// No description provided for @fix_vendor_03.
  ///
  /// In en, this message translates to:
  /// **'ColorOS/Funtouch: Enable Auto-start and remove aggressive optimization.'**
  String get fix_vendor_03;

  /// No description provided for @fix_vendor_04.
  ///
  /// In en, this message translates to:
  /// **'OnePlus: Battery → Battery optimization → MoveUP → Don’t optimize.'**
  String get fix_vendor_04;

  /// No description provided for @fix_vendor_05.
  ///
  /// In en, this message translates to:
  /// **'Samsung: Device care → Battery → Sleeping apps: remove MoveUP.'**
  String get fix_vendor_05;

  /// No description provided for @fix_vendor_06.
  ///
  /// In en, this message translates to:
  /// **'Check the manufacturer’s Autostart and app protection.'**
  String get fix_vendor_06;

  /// No description provided for @fix_messag_01.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings → Privacy & security → Location → MoveUP\nset “Always” and enable “Precise location”.\nAlso check Power saving: it may limit background activity.'**
  String get fix_messag_01;

  /// No description provided for @fix_chiudi_button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get fix_chiudi_button;

  /// No description provided for @fix_riduci_button.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get fix_riduci_button;

  /// No description provided for @fix_espandi_button.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get fix_espandi_button;

  /// No description provided for @dettagli.
  ///
  /// In en, this message translates to:
  /// **'Technical details of the day'**
  String get dettagli;

  /// No description provided for @posizione.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get posizione;

  /// No description provided for @export_day.
  ///
  /// In en, this message translates to:
  /// **'Export day data'**
  String get export_day;

  /// No description provided for @date_parse_error.
  ///
  /// In en, this message translates to:
  /// **'Date parse error'**
  String get date_parse_error;

  /// No description provided for @export_started.
  ///
  /// In en, this message translates to:
  /// **'Export started...'**
  String get export_started;

  /// No description provided for @download_start.
  ///
  /// In en, this message translates to:
  /// **'Download started in browser'**
  String get download_start;

  /// No description provided for @esportazione_file.
  ///
  /// In en, this message translates to:
  /// **'Export:'**
  String get esportazione_file;

  /// No description provided for @errore_http.
  ///
  /// In en, this message translates to:
  /// **'Download error: HTTP'**
  String get errore_http;

  /// No description provided for @errore_generico.
  ///
  /// In en, this message translates to:
  /// **'Export error:'**
  String get errore_generico;

  /// No description provided for @dedica_title.
  ///
  /// In en, this message translates to:
  /// **'Dedicated to…'**
  String get dedica_title;

  /// No description provided for @dedica_testo.
  ///
  /// In en, this message translates to:
  /// **'My wife and Lova, who gave me the strength to get this far. 💚🐾'**
  String get dedica_testo;

  /// No description provided for @analisi_oggi.
  ///
  /// In en, this message translates to:
  /// **'Analysis of today'**
  String get analisi_oggi;

  /// No description provided for @movimento.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get movimento;

  /// No description provided for @non_reg.
  ///
  /// In en, this message translates to:
  /// **'Not registered'**
  String get non_reg;

  /// No description provided for @parziale.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get parziale;

  /// No description provided for @completo.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completo;

  /// No description provided for @dati_incompleti.
  ///
  /// In en, this message translates to:
  /// **'Incomplete data: the phone did not record for about'**
  String get dati_incompleti;

  /// No description provided for @ottima_attivita.
  ///
  /// In en, this message translates to:
  /// **'Great activity today'**
  String get ottima_attivita;

  /// No description provided for @buona_attivita.
  ///
  /// In en, this message translates to:
  /// **'Good activity, you used part of your day well.'**
  String get buona_attivita;

  /// No description provided for @giorno_statico1.
  ///
  /// In en, this message translates to:
  /// **'Day quite static '**
  String get giorno_statico1;

  /// No description provided for @giorno_statico2.
  ///
  /// In en, this message translates to:
  /// **'still/pause'**
  String get giorno_statico2;

  /// No description provided for @attivita_media.
  ///
  /// In en, this message translates to:
  /// **'Average activity.'**
  String get attivita_media;

  /// No description provided for @attivita_giorno.
  ///
  /// In en, this message translates to:
  /// **'No activity recorded today.'**
  String get attivita_giorno;

  /// No description provided for @notifiche_testa.
  ///
  /// In en, this message translates to:
  /// **'MoveUP Notifications'**
  String get notifiche_testa;

  /// No description provided for @notifiche_segnala.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notifiche_segnala;

  /// No description provided for @notifiche_elimina_tutte.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get notifiche_elimina_tutte;

  /// No description provided for @notifiche_conferma.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get notifiche_conferma;

  /// No description provided for @notifiche_conferma_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete all notifications?'**
  String get notifiche_conferma_msg;

  /// No description provided for @notifiche_annulla.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get notifiche_annulla;

  /// No description provided for @notifiche_elimina.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notifiche_elimina;

  /// No description provided for @notifiche_vuota.
  ///
  /// In en, this message translates to:
  /// **'No notifications at the moment.'**
  String get notifiche_vuota;

  /// No description provided for @notifiche_segnalate.
  ///
  /// In en, this message translates to:
  /// **'Marked as read'**
  String get notifiche_segnalate;

  /// No description provided for @costi_impatto.
  ///
  /// In en, this message translates to:
  /// **'Estimated impact'**
  String get costi_impatto;

  /// No description provided for @costi_calcolo.
  ///
  /// In en, this message translates to:
  /// **'Calculation in progress...'**
  String get costi_calcolo;

  /// No description provided for @costi_nessuno.
  ///
  /// In en, this message translates to:
  /// **'No fast movements detected this week.'**
  String get costi_nessuno;

  /// No description provided for @costi_spostamenti.
  ///
  /// In en, this message translates to:
  /// **'Fast movements:'**
  String get costi_spostamenti;

  /// No description provided for @costi_stima.
  ///
  /// In en, this message translates to:
  /// **'Estimate based on'**
  String get costi_stima;

  /// No description provided for @costi_costo.
  ///
  /// In en, this message translates to:
  /// **'Estimated cost:'**
  String get costi_costo;

  /// No description provided for @costi_escluso.
  ///
  /// In en, this message translates to:
  /// **'Tolls/parking excluded.'**
  String get costi_escluso;

  /// No description provided for @help_title.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help_title;

  /// No description provided for @help_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions about MoveUP'**
  String get help_subtitle;

  /// No description provided for @help_q1_title.
  ///
  /// In en, this message translates to:
  /// **'Is MoveUP still recording me?'**
  String get help_q1_title;

  /// No description provided for @help_q2_title.
  ///
  /// In en, this message translates to:
  /// **'Does it work even if the app is closed or the phone is locked?'**
  String get help_q2_title;

  /// No description provided for @help_q3_title.
  ///
  /// In en, this message translates to:
  /// **'Why do I need to allow location access \"Always\"?'**
  String get help_q3_title;

  /// No description provided for @help_q4_title.
  ///
  /// In en, this message translates to:
  /// **'Does it consume a lot of battery?'**
  String get help_q4_title;

  /// No description provided for @help_q5_title.
  ///
  /// In en, this message translates to:
  /// **'Why do I sometimes see \"WAITING\"?'**
  String get help_q5_title;

  /// No description provided for @help_q6_title.
  ///
  /// In en, this message translates to:
  /// **'Does MoveUP record me even when I am not moving?'**
  String get help_q6_title;

  /// No description provided for @help_q7_title.
  ///
  /// In en, this message translates to:
  /// **'Why do I see fewer data today compared to yesterday?'**
  String get help_q7_title;

  /// No description provided for @help_q8_title.
  ///
  /// In en, this message translates to:
  /// **'Can I stop or pause location recording?'**
  String get help_q8_title;

  /// No description provided for @help_q9_title.
  ///
  /// In en, this message translates to:
  /// **'Are my data private?'**
  String get help_q9_title;

  /// No description provided for @help_q10_title.
  ///
  /// In en, this message translates to:
  /// **'What happens if I uninstall the app?'**
  String get help_q10_title;

  /// No description provided for @help_q1_body.
  ///
  /// In en, this message translates to:
  /// **'Yes. If you see the status LIVE or Listening, MoveUP is tracking your movements even with the screen turned off.'**
  String get help_q1_body;

  /// No description provided for @help_q2_body.
  ///
  /// In en, this message translates to:
  /// **'Yes. MoveUP can continue working even when the screen is off, if you have given consent to recording your location.'**
  String get help_q2_body;

  /// No description provided for @help_q3_body.
  ///
  /// In en, this message translates to:
  /// **'To allow MoveUP to work correctly even when you are not actively using the app, for example with the screen turned off.'**
  String get help_q3_body;

  /// No description provided for @help_q4_body.
  ///
  /// In en, this message translates to:
  /// **'MoveUP uses GPS intelligently. Battery consumption depends on how much you move, but it is optimized for daily use.'**
  String get help_q4_body;

  /// No description provided for @help_q5_body.
  ///
  /// In en, this message translates to:
  /// **'WAITING means that MoveUP is active but is waiting for a new movement or a valid GPS signal.'**
  String get help_q5_body;

  /// No description provided for @help_q6_body.
  ///
  /// In en, this message translates to:
  /// **'Yes. Periods of inactivity are also important to correctly analyze your day.'**
  String get help_q6_body;

  /// No description provided for @help_q7_body.
  ///
  /// In en, this message translates to:
  /// **'This is normal. It depends on how much you moved, GPS signal quality, and any pauses in recording.'**
  String get help_q7_body;

  /// No description provided for @help_q8_body.
  ///
  /// In en, this message translates to:
  /// **'Yes. You can pause or stop recording at any time from the main screen.'**
  String get help_q8_body;

  /// No description provided for @help_q9_body.
  ///
  /// In en, this message translates to:
  /// **'Yes. Your movement data are personal and are used only for the app’s features.'**
  String get help_q9_body;

  /// No description provided for @help_q10_body.
  ///
  /// In en, this message translates to:
  /// **'Recording stops immediately. You can reinstall MoveUP at any time.'**
  String get help_q10_body;

  /// No description provided for @dash_dettaglio.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get dash_dettaglio;

  /// No description provided for @dash_profilo.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get dash_profilo;

  /// No description provided for @dash_totale.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get dash_totale;

  /// No description provided for @dash_aggiorna.
  ///
  /// In en, this message translates to:
  /// **'Update data'**
  String get dash_aggiorna;

  /// No description provided for @dash_oggi.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get dash_oggi;

  /// No description provided for @dash_registrazione.
  ///
  /// In en, this message translates to:
  /// **'RECORDING'**
  String get dash_registrazione;

  /// No description provided for @dash_spento.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get dash_spento;

  /// No description provided for @dash_benvenuto.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get dash_benvenuto;

  /// No description provided for @dash_fermo.
  ///
  /// In en, this message translates to:
  /// **'STILL'**
  String get dash_fermo;

  /// No description provided for @dash_lento.
  ///
  /// In en, this message translates to:
  /// **'SLOW'**
  String get dash_lento;

  /// No description provided for @dash_veloce.
  ///
  /// In en, this message translates to:
  /// **'FAST'**
  String get dash_veloce;

  /// No description provided for @dash_non_tracciato.
  ///
  /// In en, this message translates to:
  /// **'NOT TRACKED'**
  String get dash_non_tracciato;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
