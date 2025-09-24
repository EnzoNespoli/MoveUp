// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'MoveUP';

  @override
  String get appSubTitle => 'Ton assistant de mouvement';

  @override
  String get subscriptions => 'Abonnements';

  @override
  String welcomeUser(String name) {
    return 'Bienvenue, $name !';
  }

  @override
  String get anonymousUser => 'Utilisateur Anonyme';

  @override
  String get lingua_sistema => 'Langue système';

  @override
  String get priceFree => 'Gratuit';

  @override
  String pricePerMonth(String price) {
    return '$price/mois';
  }

  @override
  String durationDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# jours',
      one: '# jour',
    );
    return '$_temp0';
  }

  @override
  String get features => 'Fonctions';

  @override
  String get buy => 'Acheter';

  @override
  String get active => 'Actif';

  @override
  String get thisIsYourPlan => 'Ceci est ton plan !';

  @override
  String get sessionExpired => 'Session expirée. Connecte-toi de nouveau.';

  @override
  String get durata_abbonamento => 'Durée :';

  @override
  String get onb1 => 'Suis et organise tes déplacements en un seul endroit.';

  @override
  String get onb2 => 'Vois où va ton temps : maison, travail, trajets.';

  @override
  String get onb3 => 'Rapports et tendances automatiques : progresse grâce aux données.';

  @override
  String get botton_salta => 'Passer';

  @override
  String get condizioni_uso => 'J’ai lu et j’accepte les ';

  @override
  String get condizioni_uso2 => 'Conditions d’utilisation';

  @override
  String get privacy_policy => 'et la ';

  @override
  String get privacy_policy2 => 'Politique de Confidentialité';

  @override
  String get botton_prosegui => 'Continuer';

  @override
  String get botton_indietro => 'Retour';

  @override
  String get botton_avanti => 'Suivant';

  @override
  String get errore_001 => 'Permission de localisation refusée';

  @override
  String get errore_002 => 'Permission de localisation refusée définitivement';

  @override
  String get errore_003 => 'Erreur lors de l’obtention de la localisation :';

  @override
  String get errore_004 => 'Service de localisation désactivé sur l’appareil';

  @override
  String get user_err01 => 'Erreur d’initialisation de l’utilisateur :';

  @override
  String get user_err02 => 'Utilisateur incorrect';

  @override
  String get user_err03 => 'Dernière connexion mise à jour pour l’utilisateur';

  @override
  String get user_err04 => 'Erreur mise à jour dernière connexion';

  @override
  String get user_err05 => 'Échec de connexion';

  @override
  String get user_err06 => 'Connexion';

  @override
  String get user_err07 => 'S’inscrire';

  @override
  String get gps_err01 => 'Suivi GPS désactivé : active-le dans les paramètres.';

  @override
  String get gps_err02 => 'Erreur d’enregistrement de la localisation :';

  @override
  String get gps_err03 => 'Suivi GPS désactivé : la localisation n’est pas enregistrée.';

  @override
  String get gps_err04 => 'Permission de localisation refusée';

  @override
  String get gps_err05 => 'Permission de localisation refusée définitivement';

  @override
  String get gps_err06 => 'Signal GPS faible, attends une meilleure position';

  @override
  String get gps_err07 => 'Erreur lors de l’obtention de la localisation :';

  @override
  String get gps_err08 => 'Localisation enregistrée !';

  @override
  String get gps_err09 => 'Erreur d’enregistrement de la localisation :';

  @override
  String get gps_err10 => 'DEBUG API lecture consentements :';

  @override
  String get gps_err11 => 'DEBUG API valeur consentement GPS :';

  @override
  String get gps_err12 => 'Suivi GPS ';

  @override
  String get gps_err13 => 'Tu dois activer le consentement au suivi GPS dans les paramètres';

  @override
  String get gps_err14 => 'Suivi en écoute';

  @override
  String get gps_err15 => 'Suivi désactivé';

  @override
  String get gps_err16 => 'Prochaine détection dans';

  @override
  String get gps_err17 => 'GPS Actif';

  @override
  String get gps_err18 => 'GPS Inactif';

  @override
  String get gps_err19 => 'Journal de bord GPS';

  @override
  String get gps_err20 => 'Aucun événement enregistré.';

  @override
  String get att_err01 => 'Erreur de recalcul d’activité :';

  @override
  String get att_err02 => 'inchangé par rapport à hier';

  @override
  String get att_err03 => 'par rapport à hier';

  @override
  String get att_err04 => 'Développe pour voir les détails...';

  @override
  String get att_err05 => 'Aucune session enregistrée';

  @override
  String get info_mes01 => 'Début :';

  @override
  String get info_mes02 => 'Fin :';

  @override
  String get info_mes03 => 'Durée :';

  @override
  String get info_mes04 => 'Distance :';

  @override
  String get info_mes05 => 'Source :';

  @override
  String get info_mes06 => 'Pas estimés :';

  @override
  String get info_mes07 => 'Comprends comment tu te déplaces,\naméliore-toi chaque jour.';

  @override
  String get mov_inattivo => 'Inactif ou arrêté';

  @override
  String get mov_leggero => 'Mouvement léger';

  @override
  String get mov_veloce => 'Mouvement rapide';

  @override
  String get chart_mes01 => 'Aucun graphique disponible pour le moment.';

  @override
  String get chart_mes02 => 'Chronologie des niveaux quotidiens';

  @override
  String get chart_mes03 => 'Intervalle une heure';

  @override
  String get chart_mes04 => 'Distribution des niveaux quotidiens';

  @override
  String get chart_mes05 => 'Intervalle une heure';

  @override
  String get chart_mes06 => 'Impossible de générer l’image. Veuillez réessayer.';

  @override
  String get chart_mes07 => 'Mon rapport MoveUP d’aujourd’hui';

  @override
  String get cahrt_mes08 => 'Erreur de partage :';

  @override
  String get chart_mes09 => 'Rapport MoveUP d’aujourd’hui';

  @override
  String get um_metri => 'Mètres :';

  @override
  String get um_passi => 'Pas :';

  @override
  String get um_km => 'Km :';

  @override
  String get form_reg_testa => 'Inscription';

  @override
  String get form_reg_nome => 'Nom';

  @override
  String get form_reg_mail => 'E-mail';

  @override
  String get form_reg_password => 'Mot de passe';

  @override
  String get form_reg_err01 => 'Saisis le nom';

  @override
  String get form_reg_err02 => 'Saisis un e-mail valide';

  @override
  String get form_reg_err03 => 'Le mot de passe doit contenir au moins 8 caractères, une majuscule et un chiffre';

  @override
  String get form_reg_err04 => 'Inscription réussie ! Vérifie ton e-mail et tu peux te connecter.';

  @override
  String get form_reg_err05 => 'Échec de l’inscription';

  @override
  String get form_reg_genere => 'Genre';

  @override
  String get form_reg_maschio => 'Homme';

  @override
  String get form_reg_femmina => 'Femme';

  @override
  String get form_reg_professione => 'Profession';

  @override
  String get form_reg_eta => 'Tranche d’âge';

  @override
  String get form_reg_ult_accesso => 'Dernière connexion';

  @override
  String get form_reg_consensi => 'Paramètres et consentements';

  @override
  String get form_reg_gps => 'Suivi GPS';

  @override
  String get form_reg_err06 => 'Les mots de passe ne correspondent pas';

  @override
  String get form_reg_country => 'Pays de résidence';

  @override
  String get cambio_password => 'Changer le mot de passe';

  @override
  String get password_attuale_label => 'Mot de passe actuel';

  @override
  String get nuova_password_label => 'Nouveau mot de passe';

  @override
  String get conferma_password_label => 'Confirmer le nouveau mot de passe';

  @override
  String get button_cambia_password => 'Changer le mot de passe';

  @override
  String get compila_tutti_campi => 'Veuillez remplir tous les champs';

  @override
  String get password_non_coincidono => 'Les nouveaux mots de passe ne correspondent pas';

  @override
  String get password_diversa_dalla_attuale => 'Le nouveau mot de passe doit être différent de l’actuel';

  @override
  String get password_controllo => 'Le mot de passe doit comporter au moins 8 caractères et inclure une lettre majuscule et un chiffre';

  @override
  String get password_cambiata => 'Mot de passe modifié avec succès !';

  @override
  String get password_errore => 'Erreur lors du changement de mot de passe';

  @override
  String get password_dimenticata => 'Mot de passe oublié ?';

  @override
  String get reimposta_password => 'Réinitialiser le mot de passe';

  @override
  String get inserisci_mail => 'Saisissez votre e-mail pour recevoir le lien de réinitialisation.';

  @override
  String get inserisci_tua_mail => 'Saisissez votre e-mail';

  @override
  String get link_mail_password => 'Si l’e-mail est enregistré, nous vous avons envoyé un lien pour réinitialiser votre mot de passe.';

  @override
  String get invia_richiesta_label => 'Envoyer la demande';

  @override
  String get condividi_button => 'Partager';

  @override
  String get form_consensi_01 => 'Consentements';

  @override
  String get form_consensi_02 => 'J’accepte le traitement des données (confidentialité)';

  @override
  String get form_consensi_03 => 'J’accepte de recevoir des communications marketing';

  @override
  String get form_consensi_04 => 'J’accepte de participer aux prix et concours';

  @override
  String get form_consensi_05 => 'J’accepte le suivi GPS';

  @override
  String get form_consensi_06 => 'Confirmer';

  @override
  String get form_consensi_er => 'Erreur d’enregistrement des consentements .. :';

  @override
  String get session_expired => 'Session expirée. Connecte-toi de nouveau.';

  @override
  String get token_invalid => 'Jeton non valide : reconnecte-toi.';

  @override
  String get payment_mes1 => 'Illimité';

  @override
  String get payment_mes2 => 'Expiré';

  @override
  String get payment_mes3 => '1 j rest.';

  @override
  String get payment_mes4 => 'j rest.';

  @override
  String get bottom_impostazioni => 'Paramètres';

  @override
  String get bottom_cronologia => 'Activité';

  @override
  String get bottom_profilo => 'Profil';

  @override
  String get bottom_abbonamenti => 'Abonnements';

  @override
  String get bottom_err01 => 'Fonction disponible uniquement pour les utilisateurs inscrits !';

  @override
  String get bottom_err02 => 'Utilisateur INCORRECT !';

  @override
  String get bottom_nome => 'Nom';

  @override
  String get bottom_logout => 'Déconnexion';

  @override
  String get map_mes_01 => 'Mettre à jour la position';

  @override
  String get rep_day_mes01 => 'Rapport Quotidien';

  @override
  String get rep_day_mes02 => 'Dernière position';

  @override
  String get storico_01 => 'Choisissez la durée d’historique à conserver. Le reste grandit avec vous.';

  @override
  String get storico_02 => 'Free (Anonyme)';

  @override
  String get storico_03 => 'Utilisez l’app sans vous inscrire. Historique uniquement pour la journée en cours.\nFonctions : suivi en direct et récapitulatif quotidien.';

  @override
  String get storico_04 => 'Start (Enregistré)';

  @override
  String get storico_05 => 'Compte gratuit avec 7 jours d’historique.\nFonctions : suivi en direct et en arrière-plan, sauvegarde cloud, synchronisation multi-appareils, notifications.';

  @override
  String get storico_06 => 'Basic — 30 jours (Payant)';

  @override
  String get storico_07 => 'Historique de 30 jours.\nFonctions : chronologie quotidienne avancée, métriques par niveau (immobile/lent/rapide), lieux et itinéraires récurrents.';

  @override
  String get storico_08 => 'Plus — 180 jours (Payant)';

  @override
  String get storico_09 => 'Historique de 6 mois.\nFonctions : tout ce qui est dans Basic + analyse des trajets/lieux récurrents avec récapitulatifs hebdomadaires/mensuels.';

  @override
  String get storico_10 => 'Pro — 365 jours (Payant)';

  @override
  String get storico_11 => 'Historique d’un an.\nFonctions : rapports avancés, filtres détaillés, support prioritaire, sans publicité.';

  @override
  String get storico_12 => 'Note de confidentialité :';

  @override
  String get storico_13 => 'Vous pouvez modifier ou retirer votre consentement à tout moment. Sans consentement au suivi, nous n’enregistrons pas de positions.';

  @override
  String get storico_14 => '⏳ Chargement des données…';

  @override
  String get form_crono_01 => 'Activité';

  @override
  String get form_crono_02 => 'Résumé d’activité';

  @override
  String get form_crono_03 => 'Bienvenue, ';

  @override
  String get form_crono_04 => 'Totaux des 7 derniers jours';

  @override
  String get form_crono_05 => 'Aucune session enregistrée';

  @override
  String get form_crono_06 => 'Niveau';

  @override
  String get form_crono_07 => 'Voir détails';

  @override
  String get form_crono_08 => 'Détails Niveau';

  @override
  String get form_crono_09 => 'Détails pour le Niveau';

  @override
  String get dashboard_piano => 'Plan :';

  @override
  String get dashboard_msg => 'Crée un compte (gratuit) pour enregistrer vos données et déverrouiller le partage.';

  @override
  String get imposta_page_studente => 'Étudiant';

  @override
  String get imposta_page_impiegato => 'Employé';

  @override
  String get imposta_page_libero => 'Travailleur';

  @override
  String get imposta_page_disoccupato => 'Chômeur';

  @override
  String get imposta_page_pensionato => 'Retraité';

  @override
  String get imposta_page_altro => 'Autre';

  @override
  String get imposta_page_lista => 'Étudiant,Employé,Travailleur,Chômeur,Retraité,Autre';

  @override
  String get imposta_page_miei => 'Mes données personnelles';

  @override
  String get imposta_page_notifiche => 'Notifications actives';

  @override
  String get imposta_page_consenso => 'Consentement confidentialité';

  @override
  String get imposta_page_marketing => 'Consentement marketing';

  @override
  String get imposta_page_premi => 'Consentement récompenses';

  @override
  String get imposta_page_datac => 'Date consentement';

  @override
  String get imposta_page_frequenza => 'Fréquence de suivi (sec)';

  @override
  String get imposta_page_piani => 'Plans d’abonnement';

  @override
  String get imposta_page_importo => 'Montant :';

  @override
  String get imposta_page_durata => 'Durée :';

  @override
  String get imposta_page_cancella => 'Suppression des données : après ';

  @override
  String get imposta_page_funzioni => 'Fonctionnalités actives';

  @override
  String get imposta_page_save => 'Enregistrer les modifications';

  @override
  String get imposta_page_mess1 => 'Données personnelles mises à jour !';

  @override
  String get imposta_page_mess2 => 'Erreur : ';

  @override
  String get imposta_page_mess3 => 'Impossible de mettre à jour.';

  @override
  String get imposta_page_mess4 => 'Erreur réseau.';

  @override
  String get imposta_page_mess5 => 'Paramètres mis à jour !';

  @override
  String get imposta_page_mess6 => 'Données enregistrées !';

  @override
  String get footer_page_diritti => '© 2025 MoveUP - Tous droits réservés';

  @override
  String get footer_page_banner => 'Your Personal Move';

  @override
  String get footer_page_versione => 'Version app :';

  @override
  String get header_page_banner => 'Your Personal Move';

  @override
  String get rep_day_export_locked => 'Le partage nécessite BASIC/PLUS/PRO';

  @override
  String get msg_abilitato_01 => 'Inscrivez-vous pour voir la répartition d’aujourd’hui';

  @override
  String get msg_abilitato_02 => 'Chronologie disponible avec BASIC. Inscrivez-vous d’abord.';

  @override
  String get crono_msg_01 => 'Inscrivez-vous pour voir le parcours du jour.';

  @override
  String get crono_msg_02 => 'Votre offre permet jusqu’à';

  @override
  String get crono_msg_03 => 'jours d’historique.';

  @override
  String get crono_msg_04 => 'Parcours indisponible. Réessayez.';

  @override
  String get crono_msg_05 => 'Erreur inconnue';

  @override
  String get card_percorso_1 => 'Sélectionner une date';

  @override
  String get card_percorso_2 => 'Annuler';

  @override
  String get card_percorso_3 => 'OK';

  @override
  String get card_percorso_4 => 'Parcours du';

  @override
  String get card_percorso_5 => 'Aucun déplacement à cette date';

  @override
  String get feat_tracking_live => 'Suivi en direct';

  @override
  String get feat_report_basic => 'Rapport quotidien (de base)';

  @override
  String get feat_report_advanced => 'Chronologie quotidienne avancée';

  @override
  String get feat_places_routes => 'Lieux et trajets répétés';

  @override
  String get feat_export_gpx => 'Export GPX';

  @override
  String get feat_export_csv => 'Export CSV';

  @override
  String get feat_notifications => 'Notifications';

  @override
  String get feat_backup_cloud => 'Sauvegarde cloud';

  @override
  String get feat_rewards => 'Récompenses';

  @override
  String get feat_priority_support => 'Support prioritaire';

  @override
  String get feat_no_ads => 'Sans publicité';

  @override
  String get feat_history_days => 'Historique disponible';

  @override
  String get days => 'jours';

  @override
  String get feat_gps => 'Paramètres GPS du forfait';

  @override
  String get feat_gps_sample_sec => 'Échantillonnage (secondes)';

  @override
  String get feat_gps_min_distance_m => 'Distance minimale (mètres)';

  @override
  String get feat_gps_upload_sec => 'Envoi en lot (secondes)';

  @override
  String get feat_gps_background => 'Suivi en arrière-plan';

  @override
  String get gps_accuracy_mode => 'Mode de précision';

  @override
  String get feat_gps_max_acc_m => 'Précision maximale (mètres)';

  @override
  String get feat_gps_accuracy_mode => 'Mode de précision';

  @override
  String get accuracy_low => 'Faible';

  @override
  String get accuracy_balanced => 'Équilibré';

  @override
  String get accuracy_high => 'Élevé';

  @override
  String get accuracy_best => 'Optimal';

  @override
  String get unit_seconds => 'secondes';

  @override
  String get unit_meters => 'mètres';

  @override
  String gps_next_fix(Object s) {
    return 'Prochaine mesure dans ${s}s';
  }

  @override
  String get escl_prog_01 => 'Exclusions programmées';

  @override
  String get escl_prog_02 => 'Exclusions disponibles à partir du niveau Basic';

  @override
  String get escl_prog_03 => 'Ajouter une exclusion';

  @override
  String get escl_prog_04 => 'Aucune exclusion programmée n’est configurée.';

  @override
  String get escl_prog_05 => 'Modifier';

  @override
  String get escl_prog_06 => 'Nouvelle exclusion';

  @override
  String get escl_prog_07 => 'Modifier l’exclusion';

  @override
  String get escl_prog_08 => 'Heure de début';

  @override
  String get escl_prog_09 => 'Heure de fin';

  @override
  String get escl_prog_10 => 'Notes';

  @override
  String get escl_prog_11 => 'Activée';

  @override
  String get escl_prog_12 => 'Jours actifs :';

  @override
  String get escl_prog_13 => 'Annuler';

  @override
  String get escl_prog_14 => 'Enregistrer';

  @override
  String get verifica_mail_titolo => 'Vérifiez votre adresse e-mail';

  @override
  String get verifica_mail_testo1 => 'Consultez votre boîte de réception et cliquez sur le lien de vérification.';

  @override
  String get verifica_mail_testo2 => 'Une fois vérifié, revenez à la page de connexion pour vous connecter.';

  @override
  String get verifica_mail_testo3 => 'Une fois vérifié, revenez à la page de connexion pour vous connecter.';

  @override
  String get verifica_mail_testo4 => 'J’ai vérifié, aller au tableau de bord';

  @override
  String get verifica_mail_erro1 => 'E-mail envoyé !';

  @override
  String get verifica_mail_erro2 => 'Erreur lors de l’envoi de l’e-mail.';

  @override
  String get verifica_mail_button => 'Renvoyer l’e-mail';

  @override
  String get acquisto_piano_conferma => 'Confirmer l’achat';

  @override
  String get acquisto_piano_info => 'Vos informations.';

  @override
  String get acquisto_piano_id => 'ID utilisateur :';

  @override
  String get acquisto_piano_nome => 'Nom :';

  @override
  String get acquisto_piano_mail => 'Adresse e-mail :';

  @override
  String get acquisto_piano_durata => 'Durée :';

  @override
  String get acquisto_piano_pagamento => 'Procéder au paiement';

  @override
  String get acquisto_piano_stripe => 'Vous serez redirigé vers Stripe...';

  @override
  String get acquisto_piano_nopaga => 'Paiement non démarré :';

  @override
  String get acquisto_piano_attivo => 'Abonnement activé !';

  @override
  String get card_settimana => 'Semaine';

  @override
  String get card_gio_today => 'Maintenant';

  @override
  String get card_gio_lunedi => 'Lundi';

  @override
  String get card_gio_martedi => 'Mardi';

  @override
  String get card_gio_mercoledi => 'Mercredi';

  @override
  String get card_gio_giovedi => 'Jeudi';

  @override
  String get card_gio_venerdi => 'Vendredi';

  @override
  String get card_gio_sabato => 'Samedi';

  @override
  String get card_gio_domenica => 'Dimanche';

  @override
  String get today_title => 'Aujourd’hui';

  @override
  String get today_title_closed => 'Aujourd’hui — journée terminée';

  @override
  String get badge_partial => 'Données partielles';

  @override
  String get kpi_active => 'Min actives';

  @override
  String get kpi_km => 'Km';

  @override
  String get kpi_sedentary => 'Assis';

  @override
  String get no_data_msg => 'Nous n’avons pas encore de données pour aujourd’hui.';

  @override
  String get check_location => 'Autorisations de localisation';

  @override
  String get check_battery => 'Économie d’énergie';

  @override
  String get check_gps => 'Statut GPS';

  @override
  String get insight_quality => 'Nous perdons des données à cause de l’économiseur de batterie. Touchez pour corriger.';

  @override
  String get insight_goal_hit => 'Objectif atteint 🎯 Bravo !';

  @override
  String insight_goal_missing(Object v1) {
    return 'Il vous manque $v1 min pour l’objectif.';
  }

  @override
  String insight_vs_yesterday(Object v2) {
    return 'Aujourd’hui vous êtes à $v2% par rapport à hier.';
  }

  @override
  String get fix_qualita_dati => 'Qualité des données';

  @override
  String get fix_message => 'Corrigez ces points pour éviter des pertes de données.';

  @override
  String get fix_permessi => 'Autorisations de localisation (Toujours)';

  @override
  String get fix_permessi_sub => 'Accordez l’accès “Toujours” à la localisation';

  @override
  String get fix_gps_attivo => 'GPS activé et Haute précision';

  @override
  String get fix_gps_attivo_sub => 'Ouvrir les paramètres de Localisation';

  @override
  String get fix_auto_start => 'Démarrage auto / Protection des apps';

  @override
  String get fix_auto_ricontrolla => 'Vérifier à nouveau';

  @override
  String get fix_battery => 'Désactiver l’économiseur de batterie pour MoveUP';

  @override
  String get fix_battery_sub => 'Autoriser “Ignorer l’optimisation de la batterie”';

  @override
  String get fix_vendor_01 => 'MIUI : Sécurité → Autorisations → Démarrage auto + Économie d’énergie.';

  @override
  String get fix_vendor_02 => 'EMUI : Paramètres → Batterie → Lancement d’apps (autoriser démarrage et arrière-plan).';

  @override
  String get fix_vendor_03 => 'ColorOS/Funtouch : Activer le démarrage auto et désactiver l’optimisation agressive.';

  @override
  String get fix_vendor_04 => 'OnePlus : Batterie → Optimisation de la batterie → MoveUP → Ne pas optimiser.';

  @override
  String get fix_vendor_05 => 'Samsung : Entretien de l’appareil → Batterie → Apps en veille : retirer MoveUP.';

  @override
  String get fix_vendor_06 => 'Vérifiez le Démarrage auto et la protection des apps du fabricant.';

  @override
  String get fix_messag_01 => 'Allez dans Paramètres → Confidentialité et sécurité → Localisation → MoveUP\nréglez sur “Toujours” et activez “Position précise”.\nVérifiez aussi l’Économie d’énergie : elle peut limiter l’arrière-plan.';

  @override
  String get fix_chiudi_button => 'Fermer';
}
