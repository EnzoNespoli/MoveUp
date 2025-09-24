// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MoveUP';

  @override
  String get appSubTitle => 'Your movement assistant';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get anonymousUser => 'Guest';

  @override
  String get lingua_sistema => 'System language';

  @override
  String get priceFree => 'Free';

  @override
  String pricePerMonth(String price) {
    return '$price/month';
  }

  @override
  String durationDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# days',
      one: '# day',
    );
    return '$_temp0';
  }

  @override
  String get features => 'Features';

  @override
  String get buy => 'Buy';

  @override
  String get active => 'Active';

  @override
  String get thisIsYourPlan => 'This is your plan!';

  @override
  String get sessionExpired => 'Session expired. Please log in again.';

  @override
  String get durata_abbonamento => 'Subscription duration:';

  @override
  String get onb1 => 'Track and organize your movements in one place.';

  @override
  String get onb2 => 'See where your time goes: home, work, commutes.';

  @override
  String get onb3 => 'Automatic reports and trends: improve with data.';

  @override
  String get botton_salta => 'Skip';

  @override
  String get condizioni_uso => 'I have read and accepted the ';

  @override
  String get condizioni_uso2 => 'Terms of Use';

  @override
  String get privacy_policy => 'and the ';

  @override
  String get privacy_policy2 => 'Privacy Policy';

  @override
  String get botton_prosegui => 'Continue';

  @override
  String get botton_indietro => 'Back';

  @override
  String get botton_avanti => 'Next';

  @override
  String get errore_001 => 'Location permission denied';

  @override
  String get errore_002 => 'Location permission permanently denied';

  @override
  String get errore_003 => 'Error getting location:';

  @override
  String get errore_004 => 'Location service disabled on the device';

  @override
  String get user_err01 => 'User initialization error:';

  @override
  String get user_err02 => 'Invalid user';

  @override
  String get user_err03 => 'Last login updated for user';

  @override
  String get user_err04 => 'Last login update error';

  @override
  String get user_err05 => 'Login failed';

  @override
  String get user_err06 => 'Login';

  @override
  String get user_err07 => 'Register';

  @override
  String get gps_err01 => 'GPS tracking disabled: enable it in settings.';

  @override
  String get gps_err02 => 'Error saving location:';

  @override
  String get gps_err03 => 'GPS tracking off: location is not recorded.';

  @override
  String get gps_err04 => 'Location permission denied';

  @override
  String get gps_err05 => 'Location permission permanently denied';

  @override
  String get gps_err06 => 'Weak GPS signal, waiting for a better location...';

  @override
  String get gps_err07 => 'Error getting location:';

  @override
  String get gps_err08 => 'Position saved!';

  @override
  String get gps_err09 => 'Error saving location:';

  @override
  String get gps_err10 => 'DEBUG API read consents:';

  @override
  String get gps_err11 => 'DEBUG API GPS consent value:';

  @override
  String get gps_err12 => 'GPS Tracking:';

  @override
  String get gps_err13 => 'You must enable GPS tracking consent in settings.';

  @override
  String get gps_err14 => 'Tracking active';

  @override
  String get gps_err15 => 'Tracking disabled';

  @override
  String get gps_err16 => 'Next detection in';

  @override
  String get gps_err17 => 'GPS On';

  @override
  String get gps_err18 => 'GPS Off';

  @override
  String get gps_err19 => 'GPS Log';

  @override
  String get gps_err20 => 'No events recorded yet.';

  @override
  String get att_err01 => 'Activity recalculation error:';

  @override
  String get att_err02 => 'Unchanged from yesterday';

  @override
  String get att_err03 => 'Compared to yesterday';

  @override
  String get att_err04 => 'Expand to see details...';

  @override
  String get att_err05 => 'No sessions recorded';

  @override
  String get info_mes01 => 'Start:';

  @override
  String get info_mes02 => 'End:';

  @override
  String get info_mes03 => 'Duration:';

  @override
  String get info_mes04 => 'Distance:';

  @override
  String get info_mes05 => 'Source:';

  @override
  String get info_mes06 => 'Estimated steps:';

  @override
  String get info_mes07 => 'Daily summary';

  @override
  String get mov_inattivo => 'Inactive or stationary';

  @override
  String get mov_leggero => 'Light movement';

  @override
  String get mov_veloce => 'Fast movement';

  @override
  String get chart_mes01 => 'No charts available at this time.';

  @override
  String get chart_mes02 => 'Daily levels timeline';

  @override
  String get chart_mes03 => 'One-hour interval';

  @override
  String get chart_mes04 => 'Daily level distribution';

  @override
  String get chart_mes05 => 'One-hour interval';

  @override
  String get chart_mes06 => 'Unable to generate the image. Please try again.';

  @override
  String get chart_mes07 => 'My MoveUP Report for today';

  @override
  String get cahrt_mes08 => 'Sharing error:';

  @override
  String get chart_mes09 => 'MoveUP Report for today';

  @override
  String get um_metri => 'Meters:';

  @override
  String get um_passi => 'Steps:';

  @override
  String get um_km => 'Km:';

  @override
  String get form_reg_testa => 'Registration';

  @override
  String get form_reg_nome => 'Name';

  @override
  String get form_reg_mail => 'Email';

  @override
  String get form_reg_password => 'Password';

  @override
  String get form_reg_err01 => 'Enter your name';

  @override
  String get form_reg_err02 => 'Enter a valid email address';

  @override
  String get form_reg_err03 => 'Password must be at least 8 characters, include one uppercase letter and one number';

  @override
  String get form_reg_err04 => 'Registration successful! Check your email and you can log in.';

  @override
  String get form_reg_err05 => 'Registration failed';

  @override
  String get form_reg_genere => 'Gender';

  @override
  String get form_reg_maschio => 'Male';

  @override
  String get form_reg_femmina => 'Female';

  @override
  String get form_reg_professione => 'Profession';

  @override
  String get form_reg_eta => 'Age range';

  @override
  String get form_reg_ult_accesso => 'Last access';

  @override
  String get form_reg_consensi => 'Settings and consents';

  @override
  String get form_reg_gps => 'GPS Tracking';

  @override
  String get form_reg_err06 => 'Passwords do not match';

  @override
  String get form_reg_country => 'Country of residence';

  @override
  String get cambio_password => 'Change password';

  @override
  String get password_attuale_label => 'Current password';

  @override
  String get nuova_password_label => 'New password';

  @override
  String get conferma_password_label => 'Confirm new password';

  @override
  String get button_cambia_password => 'Change password';

  @override
  String get compila_tutti_campi => 'Please fill in all fields';

  @override
  String get password_non_coincidono => 'The new passwords do not match';

  @override
  String get password_diversa_dalla_attuale => 'The new password must be different from the current one';

  @override
  String get password_controllo => 'The password must be at least 8 characters long and include one uppercase letter and one number';

  @override
  String get password_cambiata => 'Password changed successfully!';

  @override
  String get password_errore => 'Password change error';

  @override
  String get password_dimenticata => 'Forgot your password?';

  @override
  String get reimposta_password => 'Reset password';

  @override
  String get inserisci_mail => 'Enter your email to receive the reset link.';

  @override
  String get inserisci_tua_mail => 'Enter your email';

  @override
  String get link_mail_password => 'If the email is registered, we\'ve sent you a link to reset your password.';

  @override
  String get invia_richiesta_label => 'Send request';

  @override
  String get condividi_button => 'Share';

  @override
  String get form_consensi_01 => 'Consents';

  @override
  String get form_consensi_02 => 'I consent to the processing of personal data (privacy)';

  @override
  String get form_consensi_03 => 'I consent to receive marketing communications';

  @override
  String get form_consensi_04 => 'I consent to participate in contests and rewards';

  @override
  String get form_consensi_05 => 'I consent to GPS tracking';

  @override
  String get form_consensi_06 => 'Confirm';

  @override
  String get form_consensi_er => 'Error saving consents..:';

  @override
  String get session_expired => 'Your session has expired. Please log in again.';

  @override
  String get token_invalid => 'Invalid token: please log in again.';

  @override
  String get payment_mes1 => 'Unlimited';

  @override
  String get payment_mes2 => 'Expired';

  @override
  String get payment_mes3 => '1 day left';

  @override
  String get payment_mes4 => 'days left';

  @override
  String get bottom_impostazioni => 'Settings';

  @override
  String get bottom_cronologia => 'History';

  @override
  String get bottom_profilo => 'Profile';

  @override
  String get bottom_abbonamenti => 'Subscriptions';

  @override
  String get bottom_err01 => 'Function available only for registered users!';

  @override
  String get bottom_err02 => 'Invalid user!';

  @override
  String get bottom_nome => 'Name';

  @override
  String get bottom_logout => 'Logout';

  @override
  String get map_mes_01 => 'Update location';

  @override
  String get rep_day_mes01 => 'Daily report';

  @override
  String get rep_day_mes02 => 'Last location';

  @override
  String get storico_01 => 'Choose how much history you want to keep. The rest grows with you.';

  @override
  String get storico_02 => 'Free (Anonymous)';

  @override
  String get storico_03 => 'Use the app without signing up. History only for the current day.\nFeatures: live tracking and daily summary.';

  @override
  String get storico_04 => 'Start (Registered)';

  @override
  String get storico_05 => 'Free account with 7-day history.\nFeatures: live and background tracking, cloud backup, sync across devices, notifications.';

  @override
  String get storico_06 => 'Basic — 30 days (Paid)';

  @override
  String get storico_07 => '30-day history.\nFeatures: advanced daily timeline, per-level metrics (still/slow/fast), repeated places and routes.';

  @override
  String get storico_08 => 'Plus — 180 days (Paid)';

  @override
  String get storico_09 => '6-month history.\nFeatures: everything in Basic + analysis of recurring routes/places with weekly/monthly summaries.';

  @override
  String get storico_10 => 'Pro — 365 days (Paid)';

  @override
  String get storico_11 => '1-year history.\nFeatures: advanced reports, detailed filters, priority support, no ads.';

  @override
  String get storico_12 => 'Privacy note:';

  @override
  String get storico_13 => 'You can change or withdraw consent at any time. Without consent to tracking we do not record locations.';

  @override
  String get storico_14 => '⏳ Loading data…';

  @override
  String get form_crono_01 => 'History';

  @override
  String get form_crono_02 => 'History of last 7 days';

  @override
  String get form_crono_03 => 'Welcome, ';

  @override
  String get form_crono_04 => 'Totals for last 7 days';

  @override
  String get form_crono_05 => 'No sessions recorded';

  @override
  String get form_crono_06 => 'Level';

  @override
  String get form_crono_07 => 'View details';

  @override
  String get form_crono_08 => 'Level details';

  @override
  String get form_crono_09 => 'Details for level';

  @override
  String get dashboard_piano => 'Plan:';

  @override
  String get imposta_page_studente => 'Student';

  @override
  String get imposta_page_impiegato => 'Employee';

  @override
  String get imposta_page_libero => 'Freelancer';

  @override
  String get imposta_page_disoccupato => 'Unemployed';

  @override
  String get imposta_page_pensionato => 'Retired';

  @override
  String get imposta_page_altro => 'Other';

  @override
  String get imposta_page_lista => 'Student,Employee,Freelancer,Unemployed,Retired,Other';

  @override
  String get imposta_page_miei => 'My personal data';

  @override
  String get imposta_page_notifiche => 'Active notifications';

  @override
  String get imposta_page_consenso => 'Privacy consent';

  @override
  String get imposta_page_marketing => 'Marketing consent';

  @override
  String get imposta_page_premi => 'Contest & rewards consent';

  @override
  String get imposta_page_datac => 'Consent date';

  @override
  String get imposta_page_frequenza => 'Tracking frequency (sec)';

  @override
  String get imposta_page_piani => 'Subscription plans';

  @override
  String get imposta_page_importo => 'Amount:';

  @override
  String get imposta_page_durata => 'Duration:';

  @override
  String get imposta_page_cancella => 'Data deletion: after ';

  @override
  String get imposta_page_funzioni => 'Active features';

  @override
  String get imposta_page_save => 'Save changes';

  @override
  String get imposta_page_mess1 => 'Personal data updated!';

  @override
  String get imposta_page_mess2 => 'Error: ';

  @override
  String get imposta_page_mess3 => 'Unable to update.';

  @override
  String get imposta_page_mess4 => 'Network error.';

  @override
  String get imposta_page_mess5 => 'Settings updated!';

  @override
  String get imposta_page_mess6 => 'Data saved!';

  @override
  String get footer_page_diritti => '© 2025 MoveUP - All rights reserved';

  @override
  String get footer_page_banner => 'Your Personal Move';

  @override
  String get footer_page_versione => 'App version:';

  @override
  String get header_page_banner => 'Your Personal Move';

  @override
  String get rep_day_export_locked => 'Sharing requires BASIC/PLUS/PRO';

  @override
  String get msg_abilitato_01 => 'Sign up to see today\'s distribution';

  @override
  String get msg_abilitato_02 => 'Timeline available with BASIC. Please sign up first.';

  @override
  String get crono_msg_01 => 'Sign up to view today\'s route.';

  @override
  String get crono_msg_02 => 'Your plan allows up to';

  @override
  String get crono_msg_03 => 'days of history.';

  @override
  String get crono_msg_04 => 'Route not available. Try again.';

  @override
  String get crono_msg_05 => 'Unknown error';

  @override
  String get card_percorso_1 => 'Select date';

  @override
  String get card_percorso_2 => 'Cancel';

  @override
  String get card_percorso_3 => 'OK';

  @override
  String get card_percorso_4 => 'Route for';

  @override
  String get card_percorso_5 => 'No movement on this date';

  @override
  String get feat_tracking_live => 'Live tracking';

  @override
  String get feat_report_basic => 'Daily report (basic)';

  @override
  String get feat_report_advanced => 'Advanced daily timeline';

  @override
  String get feat_places_routes => 'Places & repeated routes';

  @override
  String get feat_export_gpx => 'GPX export';

  @override
  String get feat_export_csv => 'CSV export';

  @override
  String get feat_notifications => 'Notifications';

  @override
  String get feat_backup_cloud => 'Cloud backup';

  @override
  String get feat_rewards => 'Rewards';

  @override
  String get feat_priority_support => 'Priority support';

  @override
  String get feat_no_ads => 'No ads';

  @override
  String get feat_history_days => 'Viewable history';

  @override
  String get days => 'days';

  @override
  String get feat_gps => 'Plan GPS parameters';

  @override
  String get feat_gps_sample_sec => 'Sampling (seconds)';

  @override
  String get feat_gps_min_distance_m => 'Minimum distance (meters)';

  @override
  String get feat_gps_upload_sec => 'Batch upload (seconds)';

  @override
  String get feat_gps_background => 'Background tracking';

  @override
  String get gps_accuracy_mode => 'Accuracy mode';

  @override
  String get feat_gps_max_acc_m => 'Maximum accuracy (meters)';

  @override
  String get feat_gps_accuracy_mode => 'Accuracy mode';

  @override
  String get accuracy_low => 'Low';

  @override
  String get accuracy_balanced => 'Balanced';

  @override
  String get accuracy_high => 'High';

  @override
  String get accuracy_best => 'Best';

  @override
  String get unit_seconds => 'seconds';

  @override
  String get unit_meters => 'meters';

  @override
  String gps_next_fix(Object s) {
    return 'Next fix in ${s}s';
  }

  @override
  String get escl_prog_01 => 'Scheduled exclusions';

  @override
  String get escl_prog_02 => 'Exclusions available on Basic and above';

  @override
  String get escl_prog_03 => 'Add exclusion';

  @override
  String get escl_prog_04 => 'No scheduled exclusions configured.';

  @override
  String get escl_prog_05 => 'Edit';

  @override
  String get escl_prog_06 => 'New exclusion';

  @override
  String get escl_prog_07 => 'Edit exclusion';

  @override
  String get escl_prog_08 => 'Start time';

  @override
  String get escl_prog_09 => 'End time';

  @override
  String get escl_prog_10 => 'Notes';

  @override
  String get escl_prog_11 => 'Active';

  @override
  String get escl_prog_12 => 'Active days:';

  @override
  String get escl_prog_13 => 'Cancel';

  @override
  String get escl_prog_14 => 'Save';

  @override
  String get verifica_mail_titolo => 'Verify your email';

  @override
  String get verifica_mail_testo1 => 'Check your inbox and click the verification link.';

  @override
  String get verifica_mail_testo2 => 'Once you\'ve verified, return to the login to sign in.';

  @override
  String get verifica_mail_testo3 => 'Once you\'ve verified, return to the login to sign in.';

  @override
  String get verifica_mail_testo4 => 'I\'ve verified, go to the dashboard';

  @override
  String get verifica_mail_erro1 => 'Email sent!';

  @override
  String get verifica_mail_erro2 => 'Failed to send the email.';

  @override
  String get verifica_mail_button => 'Resend email';

  @override
  String get acquisto_piano_conferma => 'Confirm purchase';

  @override
  String get acquisto_piano_info => 'Your information.';

  @override
  String get acquisto_piano_id => 'User ID:';

  @override
  String get acquisto_piano_nome => 'Name:';

  @override
  String get acquisto_piano_mail => 'Email:';

  @override
  String get acquisto_piano_durata => 'Duration:';

  @override
  String get acquisto_piano_pagamento => 'Proceed to payment';

  @override
  String get acquisto_piano_stripe => 'You will be redirected to Stripe...';

  @override
  String get acquisto_piano_nopaga => 'Payment not started:';

  @override
  String get acquisto_piano_attivo => 'Plan activated!';
}
