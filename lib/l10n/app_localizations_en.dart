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
  String get onb1 => 'Do you really know what your day is like?';

  @override
  String get onb1_body => '';

  @override
  String get onb2 => 'MoveUP listens. You live.';

  @override
  String get onb2_body => 'Let your time tell its story.';

  @override
  String get onb3 => 'It\'s your time.';

  @override
  String get onb3_body => 'Tonight you\'ll know how it went.';

  @override
  String get botton_salta => 'Skip';

  @override
  String get condizioni_uso => 'I have read and accepted the ';

  @override
  String get condizioni_uso2 => 'Terms of Use';

  @override
  String get privacy_policy => ' and the ';

  @override
  String get privacy_policy2 => 'Privacy Policy';

  @override
  String get botton_prosegui => 'Start now!';

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
  String get user_login_success => 'Login successful!';

  @override
  String get gps_err01 => 'Location recording is disabled: enable it in settings.';

  @override
  String get gps_err02 => 'Error saving location:';

  @override
  String get gps_err03 => 'Location recording is disabled: the location is not being recorded.';

  @override
  String get gps_err04 => 'Location permission denied';

  @override
  String get gps_err05 => 'Location permission denied permanently';

  @override
  String get gps_err06 => 'Weak GPS signal, wait for a better location fix';

  @override
  String get gps_err07 => 'Error getting location:';

  @override
  String get gps_err08 => 'Location saved!';

  @override
  String get gps_err09 => 'Error saving location:';

  @override
  String get gps_err10 => 'DEBUG API read consents:';

  @override
  String get gps_err11 => 'DEBUG API GPS consent value:';

  @override
  String get gps_err12 => 'Location recording ';

  @override
  String get gps_err13 => 'You must enable location recording in settings.';

  @override
  String get gps_err14 => 'Recording on standby';

  @override
  String get gps_err15 => 'Recording off';

  @override
  String get gps_err16 => 'Next update in';

  @override
  String get gps_err17 => 'GPS On';

  @override
  String get gps_err18 => 'GPS Off';

  @override
  String get gps_err19 => 'GPS logbook';

  @override
  String get gps_err20 => 'No events recorded yet.';

  @override
  String get gps_err21 => 'Paused';

  @override
  String get gps_err22 => 'Listening';

  @override
  String get gps_err23 => 'Start recording';

  @override
  String get gps_err24 => 'Resume recording';

  @override
  String get gps_err25 => 'Pause recording';

  @override
  String get gps_err26 => 'Resume recording';

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
  String get info_mes07 => 'Understand how you move';

  @override
  String get info_mes08 => 'Discover how you use your time';

  @override
  String get mov_inattivo => 'Pause / Stopped';

  @override
  String get mov_leggero => 'Slow movement';

  @override
  String get mov_veloce => 'Fast movement';

  @override
  String get chart_mes01 => 'No charts available at this time.';

  @override
  String get chart_mes02 => 'Activity by Hours';

  @override
  String get chart_mes03 => 'Two-hour interval';

  @override
  String get chart_mes04 => 'Daily level distribution';

  @override
  String get chart_mes05 => 'Two-hour interval';

  @override
  String get chart_mes06 => 'Unable to generate the image. Please try again.';

  @override
  String get chart_mes07 => 'My MoveUP Report for today';

  @override
  String get cahrt_mes08 => 'Sharing error:';

  @override
  String get chart_mes09 => 'MoveUP Report for today';

  @override
  String get chart_mes10 => 'Levels timeline (by lanes)';

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
  String get form_reg_gps => 'Location registration';

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
  String get condividi_button => '';

  @override
  String get form_consensi_01 => 'Privacy';

  @override
  String get form_consensi_02 => 'I accept the Privacy Policy';

  @override
  String get form_consensi_03 => 'I agree to receive marketing communications';

  @override
  String get form_consensi_04 => 'I agree to participate in contests and rewards';

  @override
  String get form_consensi_05 => 'I agree to the position registration';

  @override
  String get form_consensi_06 => 'Continue';

  @override
  String get form_consensi_er => 'Error while saving consents:';

  @override
  String get form_consensi_07 => 'To use MoveUP, you must accept the Privacy Policy.';

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
  String get bottom_cronologia => 'Activity';

  @override
  String get bottom_profilo => 'Profile';

  @override
  String get bottom_abbonamenti => 'Subscriptions';

  @override
  String get bottom_dashboard => 'Home';

  @override
  String get bottom_impostazioni_short => 'Set.';

  @override
  String get bottom_cronologia_short => 'Act.';

  @override
  String get bottom_profilo_short => 'Prof.';

  @override
  String get bottom_abbonamenti_short => 'Sub.';

  @override
  String get bottom_impostazioni_tt => 'Open settings and consents';

  @override
  String get bottom_cronologia_tt => 'View your recorded activity';

  @override
  String get bottom_profilo_tt => 'Sign up, log in or log out of your profile';

  @override
  String get bottom_abbonamenti_tt => 'Manage your MoveUP subscription';

  @override
  String get bottom_dashboard_tt => 'Return to Home';

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
  String get rep_day_chiedi_AI => 'Ask the AI to…';

  @override
  String get rep_day_button_01 => 'Explain the day';

  @override
  String get rep_day_button_02 => 'Tip for tomorrow';

  @override
  String get rep_day_button_03 => 'Why am I inactive?';

  @override
  String get rep_day_ai_loading => 'The AI is processing your request…';

  @override
  String get rep_day_ai_error => 'AI error: please try again later.';

  @override
  String get rep_day_ai_limit => 'You have reached the daily AI request limit.';

  @override
  String get rep_day_ai_response => 'AI response:';

  @override
  String get rep_day_ai_info => 'The AI response will appear here.';

  @override
  String get rep_day_ai_error_01 => 'No response available';

  @override
  String get rep_day_ai_error_02 => 'remaining';

  @override
  String get rep_day_ai_error_03 => 'I analysis not available for your plan.';

  @override
  String get rep_day_ai_error_04 => 'To use AI you must first enable consent in settings.';

  @override
  String get rep_day_ai_error_05 => 'AI function not available at this time.';

  @override
  String get rep_week_insight_empty => 'This week shows no recurring routes. Keep using MoveUP to discover your habits.';

  @override
  String rep_week_insight_01(Object count, Object days) {
    return 'You followed the same route on $count different days ($days). This indicates a possible movement habit.';
  }

  @override
  String rep_week_insight_02(Object count, Object days) {
    return 'A route repeated $count times ($days). It could be a forming routine.';
  }

  @override
  String get rep_week_insight_03 => 'MoveUP can analyze your weekly movement habits.';

  @override
  String get rep_week_insight_04 => 'What does this week reveal';

  @override
  String get rep_week_insight_05 => 'MoveUP thinks:';

  @override
  String get rep_week_insight_06 => 'MoveUP is analyzing...';

  @override
  String get rep_week_insight_07 => 'MoveUP’s insight will appear here.';

  @override
  String get storico_01 => 'Choose how much history you want to keep. The rest grows with you.';

  @override
  String get storico_02 => 'Free (Anonymous)';

  @override
  String get storico_03 => 'Use the app without signing up.\nYour location can also be collected in the background to calculate, in real time, distance traveled, time in movement and pause moments.\nData stays only on your device, is valid for the current day, and is deleted automatically every day.\nFeatures: live tracking and daily summary.';

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
  String get storico_13 => 'The app may collect your location in the background to calculate your trips, distance traveled and time in movement.\nYou can change or withdraw consent at any time.\nWithout tracking consent we do not store locations.\nIf you use the app in anonymous mode (no registration), data stays only on the device and is automatically deleted at the end of the day: we do not keep history of previous days and we do not link locations to a personal profile.';

  @override
  String get storico_14 => '⏳ Loading data…';

  @override
  String get form_crono_01 => 'Activity';

  @override
  String get form_crono_02 => 'Activity Summary';

  @override
  String get form_crono_03 => 'Welcome, ';

  @override
  String get form_crono_04 => 'Summary for last 7 days';

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
  String get form_crono_10 => 'Summary from 8 to 14 days';

  @override
  String get form_crono_11 => 'Weekly comparison';

  @override
  String get dashboard_piano => 'Plan:';

  @override
  String get dashboard_msg => 'Go to Profile and register.\nYou will have your typical week';

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
  String get imposta_page_frequenza => 'Detection rate (sec)';

  @override
  String get imposta_page_piani => 'Subscription plans';

  @override
  String get imposta_page_importo => 'Amount:';

  @override
  String get imposta_page_durata => 'Duration:';

  @override
  String get imposta_page_cancella => 'Data deletion: after ';

  @override
  String get imposta_page_funzioni => 'Active features:';

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
  String get imposta_page_ai => 'AI Consent';

  @override
  String get footer_page_diritti => '© 2025 MoveUP - All rights reserved';

  @override
  String get footer_page_banner => 'Your Personal Move';

  @override
  String get footer_page_versione => 'App version:';

  @override
  String get header_page_banner => 'Your Personal Move';

  @override
  String get rep_day_export_locked => 'Sharing requires START/BASIC/PLUS/PRO';

  @override
  String get rep_day_function_ai => 'Functions available with START/BASIC/PLUS/PRO';

  @override
  String get msg_abilitato_01 => 'Register your profile to see your data for today.';

  @override
  String get msg_abilitato_02 => 'Register your profile to see your data for today.';

  @override
  String get crono_msg_01 => 'Register your profile to see your data for today.';

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
  String get feat_tracking_live => 'Live location recording';

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
  String get feat_ai_enabled => 'AI enabled';

  @override
  String get feat_ai_daily_limit => 'AI daily limit';

  @override
  String get feat_ai_scope => 'AI scope';

  @override
  String get feat_ai => 'AI features';

  @override
  String get days => 'days';

  @override
  String get feat_gps => 'Plane Recording Parameters';

  @override
  String get feat_gps_sample_sec => 'Sampling (seconds)';

  @override
  String get feat_gps_min_distance_m => 'Minimum distance (meters)';

  @override
  String get feat_gps_upload_sec => 'Batch upload (seconds)';

  @override
  String get feat_gps_background => 'Background detection';

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
  String get acquisto_piano_google => 'You will be redirected to Google...';

  @override
  String get acquisto_piano_nopaga => 'Payment not started:';

  @override
  String get acquisto_piano_attivo => 'Plan activated!';

  @override
  String get card_settimana => 'Week';

  @override
  String get card_gio_today => 'Now';

  @override
  String get card_gio_lunedi => 'Monday';

  @override
  String get card_gio_martedi => 'Tuesday';

  @override
  String get card_gio_mercoledi => 'Wednesday';

  @override
  String get card_gio_giovedi => 'Thursday';

  @override
  String get card_gio_venerdi => 'Friday';

  @override
  String get card_gio_sabato => 'Saturday';

  @override
  String get card_gio_domenica => 'Sunday';

  @override
  String get today_title => 'Today';

  @override
  String get today_title_closed => 'Today — day finished';

  @override
  String get badge_partial => 'Partial data';

  @override
  String get kpi_active => 'Time in movement';

  @override
  String get kpi_km => 'Km';

  @override
  String get kpi_sedentary => 'Pauses / Stopped';

  @override
  String get no_data_msg => 'We don’t have any data for today yet.';

  @override
  String get check_location => 'Location permissions';

  @override
  String get check_battery => 'Battery saver';

  @override
  String get check_gps => 'GPS status';

  @override
  String get insight_quality => 'We’re missing data due to battery saver. Tap to fix.';

  @override
  String get insight_goal_hit => 'You reached your planned movement time today.';

  @override
  String insight_goal_missing(Object v1) {
    return 'You’re $v1 min away from the planned movement time.';
  }

  @override
  String insight_vs_yesterday(Object v2) {
    return 'Today you’re at $v2% compared to yesterday.';
  }

  @override
  String get fix_qualita_dati => 'Data quality';

  @override
  String get fix_message => 'Fix these points to avoid data loss.';

  @override
  String get fix_permessi => 'Location permissions (Always)';

  @override
  String get fix_permessi_sub => 'Grant “Always” location access';

  @override
  String get fix_gps_attivo => 'GPS on and High accuracy';

  @override
  String get fix_gps_attivo_sub => 'Open Location settings';

  @override
  String get fix_auto_start => 'Autostart / App protection';

  @override
  String get fix_auto_ricontrolla => 'Re-check';

  @override
  String get fix_battery => 'Disable battery optimization for MoveUP';

  @override
  String get fix_battery_sub => 'Allow “Ignore battery optimization”';

  @override
  String get fix_vendor_01 => 'MIUI: Security → Permissions → Auto-start + Battery saver.';

  @override
  String get fix_vendor_02 => 'EMUI: Settings → Battery → App launch (allow auto-launch & background).';

  @override
  String get fix_vendor_03 => 'ColorOS/Funtouch: Enable Auto-start and remove aggressive optimization.';

  @override
  String get fix_vendor_04 => 'OnePlus: Battery → Battery optimization → MoveUP → Don’t optimize.';

  @override
  String get fix_vendor_05 => 'Samsung: Device care → Battery → Sleeping apps: remove MoveUP.';

  @override
  String get fix_vendor_06 => 'Check the manufacturer’s Autostart and app protection.';

  @override
  String get fix_messag_01 => 'Go to Settings → Privacy & security → Location → MoveUP\nset “Always” and enable “Precise location”.\nAlso check Power saving: it may limit background activity.';

  @override
  String get fix_chiudi_button => 'Close';

  @override
  String get fix_riduci_button => 'Minimize';

  @override
  String get fix_espandi_button => 'Expand';

  @override
  String get dettagli => 'Technical details of the day';

  @override
  String get posizione => 'Your location';

  @override
  String get export_day => 'Export day data';

  @override
  String get date_parse_error => 'Date parse error';

  @override
  String get export_started => 'Export started...';

  @override
  String get download_start => 'Download started in browser';

  @override
  String get esportazione_file => 'Export:';

  @override
  String get errore_http => 'Download error: HTTP';

  @override
  String get errore_generico => 'Export error:';

  @override
  String get dedica_title => 'Dedicated to…';

  @override
  String get dedica_testo => 'My wife and Lova, who gave me the strength to get this far. 💚🐾';

  @override
  String get analisi_oggi => 'Recorded data';

  @override
  String get movimento => 'Movement';

  @override
  String get non_reg => 'Not registered';

  @override
  String get parziale => 'Partial';

  @override
  String get completo => 'Complete';

  @override
  String get dati_incompleti => 'Incomplete data: the phone did not record for about';

  @override
  String get ottima_attivita => 'Great activity today';

  @override
  String get buona_attivita => 'Good activity, you used part of your day well.';

  @override
  String get giorno_statico1 => 'Day quite static ';

  @override
  String get giorno_statico2 => 'still/pause';

  @override
  String get attivita_media => 'Average activity.';

  @override
  String get attivita_giorno => 'No activity recorded today.';

  @override
  String get notifiche_testa => 'MoveUP Notifications';

  @override
  String get notifiche_segnala => 'Mark all as read';

  @override
  String get notifiche_elimina_tutte => 'Delete all';

  @override
  String get notifiche_conferma => 'Confirm';

  @override
  String get notifiche_conferma_msg => 'Do you want to delete all notifications?';

  @override
  String get notifiche_annulla => 'Cancel';

  @override
  String get notifiche_elimina => 'Delete';

  @override
  String get notifiche_vuota => 'No notifications at the moment.';

  @override
  String get notifiche_segnalate => 'Marked as read';

  @override
  String get costi_impatto => 'Estimated impact';

  @override
  String get costi_calcolo => 'Calculation in progress...';

  @override
  String get costi_nessuno => 'No fast movements detected this week.';

  @override
  String get costi_spostamenti => 'Fast movements:';

  @override
  String get costi_stima => 'Estimate based on';

  @override
  String get costi_costo => 'Estimated cost:';

  @override
  String get costi_escluso => 'Tolls/parking excluded.';

  @override
  String get help_title => 'Help';

  @override
  String get help_subtitle => 'Frequently Asked Questions about MoveUP';

  @override
  String get help_q1_title => 'Is MoveUP still recording me?';

  @override
  String get help_q2_title => 'Does it work even if the app is closed or the phone is locked?';

  @override
  String get help_q3_title => 'Why do I need to allow location access \"Always\"?';

  @override
  String get help_q4_title => 'Does it consume a lot of battery?';

  @override
  String get help_q5_title => 'Why do I sometimes see \"WAITING\"?';

  @override
  String get help_q6_title => 'Does MoveUP record me even when I am not moving?';

  @override
  String get help_q7_title => 'Why do I see fewer data today compared to yesterday?';

  @override
  String get help_q8_title => 'Can I stop or pause location recording?';

  @override
  String get help_q9_title => 'Are my data private?';

  @override
  String get help_q10_title => 'What happens if I uninstall the app?';

  @override
  String get help_q1_body => 'Yes. If you see the status LIVE or Listening, MoveUP is tracking your movements even with the screen turned off.';

  @override
  String get help_q2_body => 'Yes. MoveUP can continue working even when the screen is off, if you have given consent to recording your location.';

  @override
  String get help_q3_body => 'To allow MoveUP to work correctly even when you are not actively using the app, for example with the screen turned off.';

  @override
  String get help_q4_body => 'MoveUP uses GPS intelligently. Battery consumption depends on how much you move, but it is optimized for daily use.';

  @override
  String get help_q5_body => 'WAITING means that MoveUP is active but is waiting for a new movement or a valid GPS signal.';

  @override
  String get help_q6_body => 'Yes. Periods of inactivity are also important to correctly analyze your day.';

  @override
  String get help_q7_body => 'This is normal. It depends on how much you moved, GPS signal quality, and any pauses in recording.';

  @override
  String get help_q8_body => 'Yes. You can pause or stop recording at any time from the main screen.';

  @override
  String get help_q9_body => 'Yes. Your movement data are personal and are used only for the app’s features.';

  @override
  String get help_q10_body => 'Recording stops immediately. You can reinstall MoveUP at any time.';

  @override
  String get dash_dettaglio => 'DETAILS';

  @override
  String get dash_profilo => 'PROFILE';

  @override
  String get dash_totale => 'Total';

  @override
  String get dash_aggiorna => 'Update data';

  @override
  String get dash_oggi => 'TODAY';

  @override
  String get dash_registrazione => 'RECORDING';

  @override
  String get dash_spento => 'OFF';

  @override
  String get dash_benvenuto => 'Welcome';

  @override
  String get dash_fermo => 'STILL';

  @override
  String get dash_lento => 'SLOW';

  @override
  String get dash_veloce => 'FAST';

  @override
  String get dash_non_tracciato => 'NOT TRACKED';
}
