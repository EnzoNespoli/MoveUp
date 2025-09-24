// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MoveUP';

  @override
  String get appSubTitle => 'Tu asistente de movimiento';

  @override
  String get subscriptions => 'Suscripciones';

  @override
  String welcomeUser(String name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get anonymousUser => 'Usuario Anónimo';

  @override
  String get lingua_sistema => 'Idioma del sistema';

  @override
  String get priceFree => 'Gratis';

  @override
  String pricePerMonth(String price) {
    return '$price/mes';
  }

  @override
  String durationDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '# días',
      one: '# día',
    );
    return '$_temp0';
  }

  @override
  String get features => 'Funciones';

  @override
  String get buy => 'Comprar';

  @override
  String get active => 'Activo';

  @override
  String get thisIsYourPlan => '¡Este es tu plan!';

  @override
  String get sessionExpired => 'Sesión expirada. Inicia sesión de nuevo.';

  @override
  String get durata_abbonamento => 'Duración:';

  @override
  String get onb1 => 'Registra y organiza tus movimientos en un solo lugar.';

  @override
  String get onb2 => 'Mira adónde va tu tiempo: casa, trabajo, desplazamientos.';

  @override
  String get onb3 => 'Informes y tendencias automáticos: mejora con datos.';

  @override
  String get botton_salta => 'Saltar';

  @override
  String get condizioni_uso => 'He leído y acepto las ';

  @override
  String get condizioni_uso2 => 'Condiciones de uso';

  @override
  String get privacy_policy => 'y la ';

  @override
  String get privacy_policy2 => 'Política de Privacidad';

  @override
  String get botton_prosegui => 'Continuar';

  @override
  String get botton_indietro => 'Atrás';

  @override
  String get botton_avanti => 'Siguiente';

  @override
  String get errore_001 => 'Permiso de ubicación denegado';

  @override
  String get errore_002 => 'Permiso de ubicación denegado permanentemente';

  @override
  String get errore_003 => 'Error al obtener ubicación:';

  @override
  String get errore_004 => 'Servicio de ubicación deshabilitado en el dispositivo';

  @override
  String get user_err01 => 'Error al inicializar usuario:';

  @override
  String get user_err02 => 'Usuario incorrecto';

  @override
  String get user_err03 => 'Último acceso actualizado para el usuario';

  @override
  String get user_err04 => 'Error al actualizar último acceso';

  @override
  String get user_err05 => 'Inicio de sesión fallido';

  @override
  String get user_err06 => 'Iniciar sesión';

  @override
  String get user_err07 => 'Registrarse';

  @override
  String get gps_err01 => 'Seguimiento GPS desactivado: actívalo en la configuración.';

  @override
  String get gps_err02 => 'Error al guardar ubicación:';

  @override
  String get gps_err03 => 'Seguimiento GPS desactivado: la ubicación no se está registrando.';

  @override
  String get gps_err04 => 'Permiso de ubicación denegado';

  @override
  String get gps_err05 => 'Permiso de ubicación denegado permanentemente';

  @override
  String get gps_err06 => 'Señal GPS débil, espera una mejor ubicación';

  @override
  String get gps_err07 => 'Error al obtener ubicación:';

  @override
  String get gps_err08 => '¡Ubicación guardada!';

  @override
  String get gps_err09 => 'Error al guardar ubicación:';

  @override
  String get gps_err10 => 'DEBUG API leer consentimientos:';

  @override
  String get gps_err11 => 'DEBUG API valor consentimiento GPS:';

  @override
  String get gps_err12 => 'Seguimiento GPS:';

  @override
  String get gps_err13 => 'Debes activar el consentimiento de seguimiento GPS en la configuración';

  @override
  String get gps_err14 => 'Seguimiento en escucha';

  @override
  String get gps_err15 => 'Seguimiento desactivado';

  @override
  String get gps_err16 => 'Próxima detección en';

  @override
  String get gps_err17 => 'GPS Activo';

  @override
  String get gps_err18 => 'GPS Inactivo';

  @override
  String get gps_err19 => 'Diario de bordo GPS';

  @override
  String get gps_err20 => 'Ningún evento aún registrado.';

  @override
  String get att_err01 => 'Error en el recálculo de actividad:';

  @override
  String get att_err02 => 'sin cambios respecto a ayer';

  @override
  String get att_err03 => 'en comparación con ayer';

  @override
  String get att_err04 => 'Expande para ver los detalles...';

  @override
  String get att_err05 => 'Ninguna sesión registrada';

  @override
  String get info_mes01 => 'Inicio:';

  @override
  String get info_mes02 => 'Fin:';

  @override
  String get info_mes03 => 'Duración:';

  @override
  String get info_mes04 => 'Distancia:';

  @override
  String get info_mes05 => 'Fuente:';

  @override
  String get info_mes06 => 'Pasos estimados:';

  @override
  String get info_mes07 => 'Resumen diario';

  @override
  String get mov_inattivo => 'Inactivo o parado';

  @override
  String get mov_leggero => 'Movimiento ligero';

  @override
  String get mov_veloce => 'Movimiento rápido';

  @override
  String get chart_mes01 => 'No hay gráficos disponibles por el momento.';

  @override
  String get chart_mes02 => 'Cronología de niveles diarios';

  @override
  String get chart_mes03 => 'Intervalo una hora';

  @override
  String get chart_mes04 => 'Distribución de niveles diarios';

  @override
  String get chart_mes05 => 'Intervalo una hora';

  @override
  String get chart_mes06 => 'No se pudo generar la imagen. Inténtalo de nuevo.';

  @override
  String get chart_mes07 => 'Mi informe MoveUP de hoy';

  @override
  String get cahrt_mes08 => 'Error al compartir:';

  @override
  String get chart_mes09 => 'Informe MoveUP de hoy';

  @override
  String get um_metri => 'Metros:';

  @override
  String get um_passi => 'Pasos:';

  @override
  String get um_km => 'Km:';

  @override
  String get form_reg_testa => 'Registro';

  @override
  String get form_reg_nome => 'Nombre';

  @override
  String get form_reg_mail => 'Correo electrónico';

  @override
  String get form_reg_password => 'Contraseña';

  @override
  String get form_reg_err01 => 'Introduce el nombre';

  @override
  String get form_reg_err02 => 'Introduce un correo válido';

  @override
  String get form_reg_err03 => 'La contraseña debe tener al menos 8 caracteres, una mayúscula y un número';

  @override
  String get form_reg_err04 => '¡Registro exitoso! Verifica tu correo y podrás iniciar sesión.';

  @override
  String get form_reg_err05 => 'Registro fallido';

  @override
  String get form_reg_genere => 'Género';

  @override
  String get form_reg_maschio => 'Hombre';

  @override
  String get form_reg_femmina => 'Mujer';

  @override
  String get form_reg_professione => 'Profesión';

  @override
  String get form_reg_eta => 'Rango de edad';

  @override
  String get form_reg_ult_accesso => 'Último acceso';

  @override
  String get form_reg_consensi => 'Configuraciones y consentimientos';

  @override
  String get form_reg_gps => 'Seguimiento GPS';

  @override
  String get form_reg_err06 => 'Las contraseñas no coinciden';

  @override
  String get form_reg_country => 'País de residencia';

  @override
  String get cambio_password => 'Cambio de contraseña';

  @override
  String get password_attuale_label => 'Contraseña actual';

  @override
  String get nuova_password_label => 'Nueva contraseña';

  @override
  String get conferma_password_label => 'Confirmar nueva contraseña';

  @override
  String get button_cambia_password => 'Cambiar contraseña';

  @override
  String get compila_tutti_campi => 'Completa todos los campos';

  @override
  String get password_non_coincidono => 'Las nuevas contraseñas no coinciden';

  @override
  String get password_diversa_dalla_attuale => 'La nueva contraseña debe ser diferente de la actual';

  @override
  String get password_controllo => 'La contraseña debe tener al menos 8 caracteres e incluir una letra mayúscula y un número';

  @override
  String get password_cambiata => '¡Contraseña cambiada con éxito!';

  @override
  String get password_errore => 'Error al cambiar la contraseña';

  @override
  String get password_dimenticata => '¿Has olvidado la contraseña?';

  @override
  String get reimposta_password => 'Restablecer contraseña';

  @override
  String get inserisci_mail => 'Introduce tu correo electrónico para recibir el enlace de restablecimiento.';

  @override
  String get inserisci_tua_mail => 'Introduce tu correo electrónico';

  @override
  String get link_mail_password => 'Si el correo está registrado, te hemos enviado un enlace para restablecer la contraseña.';

  @override
  String get invia_richiesta_label => 'Enviar solicitud';

  @override
  String get condividi_button => 'Compartir';

  @override
  String get form_consensi_01 => 'Consentimientos';

  @override
  String get form_consensi_02 => 'Consiento el tratamiento de datos (privacidad)';

  @override
  String get form_consensi_03 => 'Consiento recibir comunicaciones de marketing';

  @override
  String get form_consensi_04 => 'Consiento participar en premios y concursos';

  @override
  String get form_consensi_05 => 'Consiento el seguimiento GPS';

  @override
  String get form_consensi_06 => 'Confirmar';

  @override
  String get form_consensi_er => 'Error al guardar consentimientos .. :';

  @override
  String get session_expired => 'Sesión expirada. Inicia sesión de nuevo.';

  @override
  String get token_invalid => 'Token no válido: vuelve a iniciar sesión.';

  @override
  String get payment_mes1 => 'Ilimitado';

  @override
  String get payment_mes2 => 'Expirado';

  @override
  String get payment_mes3 => '1 día rest.';

  @override
  String get payment_mes4 => 'días rest.';

  @override
  String get bottom_impostazioni => 'Configuración';

  @override
  String get bottom_cronologia => 'Historial';

  @override
  String get bottom_profilo => 'Perfil';

  @override
  String get bottom_abbonamenti => 'Suscripciones';

  @override
  String get bottom_err01 => '¡Función disponible solo para usuarios registrados!';

  @override
  String get bottom_err02 => '¡Usuario INCORRECTO!';

  @override
  String get bottom_nome => 'Nombre';

  @override
  String get bottom_logout => 'Cerrar sesión';

  @override
  String get map_mes_01 => 'Actualizar ubicación';

  @override
  String get rep_day_mes01 => 'Informe Diario';

  @override
  String get rep_day_mes02 => 'Última ubicación';

  @override
  String get storico_01 => 'Elige cuánto historial quieres conservar. El resto crece contigo.';

  @override
  String get storico_02 => 'Free (Anónimo)';

  @override
  String get storico_03 => 'Usa la app sin registrarte. Historial solo del día en curso.\nFunciones: seguimiento en vivo y resumen diario.';

  @override
  String get storico_04 => 'Start (Registrado)';

  @override
  String get storico_05 => 'Cuenta gratuita con historial de 7 días.\nFunciones: seguimiento en vivo y en segundo plano, copia de seguridad en la nube, sincronización en varios dispositivos, notificaciones.';

  @override
  String get storico_06 => 'Basic — 30 días (De pago)';

  @override
  String get storico_07 => 'Historial de 30 días.\nFunciones: cronología diaria avanzada, métricas por nivel (quieto/lento/rápido), lugares y rutas repetidas.';

  @override
  String get storico_08 => 'Plus — 180 días (De pago)';

  @override
  String get storico_09 => 'Historial de 6 meses.\nFunciones: todo lo de Basic + análisis de rutas/lugares recurrentes con resúmenes semanales/mensuales.';

  @override
  String get storico_10 => 'Pro — 365 días (De pago)';

  @override
  String get storico_11 => 'Historial de 1 año.\nFunciones: informes avanzados, filtros detallados, soporte prioritario, sin publicidad.';

  @override
  String get storico_12 => 'Nota de privacidad:';

  @override
  String get storico_13 => 'Puedes cambiar o retirar tu consentimiento en cualquier momento. Sin consentimiento para el seguimiento no registramos posiciones.';

  @override
  String get storico_14 => '⏳ Cargando datos…';

  @override
  String get form_crono_01 => 'Historial';

  @override
  String get form_crono_02 => 'Historial últimos 7 días';

  @override
  String get form_crono_03 => 'Bienvenido, ';

  @override
  String get form_crono_04 => 'Totales últimos 7 días';

  @override
  String get form_crono_05 => 'Ninguna sesión registrada';

  @override
  String get form_crono_06 => 'Nivel';

  @override
  String get form_crono_07 => 'Ver detalles';

  @override
  String get form_crono_08 => 'Detalles Nivel';

  @override
  String get form_crono_09 => 'Detalles para el Nivel';

  @override
  String get dashboard_piano => 'Plan:';

  @override
  String get imposta_page_studente => 'Estudiante';

  @override
  String get imposta_page_impiegato => 'Empleado';

  @override
  String get imposta_page_libero => 'Profesional';

  @override
  String get imposta_page_disoccupato => 'Desempleado';

  @override
  String get imposta_page_pensionato => 'Jubilado';

  @override
  String get imposta_page_altro => 'Otro';

  @override
  String get imposta_page_lista => 'Estudiante,Empleado,Profesional,Desempleado,Jubilado,Otro';

  @override
  String get imposta_page_miei => 'Mis datos personales';

  @override
  String get imposta_page_notifiche => 'Notificaciones activas';

  @override
  String get imposta_page_consenso => 'Consentimiento de privacidad';

  @override
  String get imposta_page_marketing => 'Consentimiento de marketing';

  @override
  String get imposta_page_premi => 'Consentimiento de premios';

  @override
  String get imposta_page_datac => 'Fecha consentimiento';

  @override
  String get imposta_page_frequenza => 'Frecuencia de seguimiento (seg)';

  @override
  String get imposta_page_piani => 'Planes de suscripción';

  @override
  String get imposta_page_importo => 'Importe:';

  @override
  String get imposta_page_durata => 'Duración:';

  @override
  String get imposta_page_cancella => 'Eliminación de datos: después de ';

  @override
  String get imposta_page_funzioni => 'Funzioni attive';

  @override
  String get imposta_page_save => 'Guardar cambios';

  @override
  String get imposta_page_mess1 => '¡Datos personales actualizados!';

  @override
  String get imposta_page_mess2 => 'Error: ';

  @override
  String get imposta_page_mess3 => 'No se pudo actualizar.';

  @override
  String get imposta_page_mess4 => 'Error de red.';

  @override
  String get imposta_page_mess5 => '¡Configuraciones actualizadas!';

  @override
  String get imposta_page_mess6 => '¡Datos guardados!';

  @override
  String get footer_page_diritti => '© 2025 MoveUP - Todos los derechos reservados';

  @override
  String get footer_page_banner => 'Your Personal Move';

  @override
  String get footer_page_versione => 'Versión app:';

  @override
  String get header_page_banner => 'Your Personal Move';

  @override
  String get rep_day_export_locked => 'Compartir requiere BASIC/PLUS/PRO';

  @override
  String get msg_abilitato_01 => 'Regístrate para ver la distribución de hoy';

  @override
  String get msg_abilitato_02 => 'Cronología disponible con BASIC. Regístrate primero.';

  @override
  String get crono_msg_01 => 'Regístrate para ver el recorrido de hoy.';

  @override
  String get crono_msg_02 => 'Tu plan permite hasta';

  @override
  String get crono_msg_03 => 'días de historial.';

  @override
  String get crono_msg_04 => 'Recorrido no disponible. Inténtalo de nuevo.';

  @override
  String get crono_msg_05 => 'Error desconocido';

  @override
  String get card_percorso_1 => 'Selecciona fecha';

  @override
  String get card_percorso_2 => 'Cancelar';

  @override
  String get card_percorso_3 => 'OK';

  @override
  String get card_percorso_4 => 'Recorrido del';

  @override
  String get card_percorso_5 => 'No hay movimiento en esta fecha';

  @override
  String get feat_tracking_live => 'Tracking live';

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
  String get feat_gps => 'Parámetros GPS del plan';

  @override
  String get feat_gps_sample_sec => 'Muestreo (segundos)';

  @override
  String get feat_gps_min_distance_m => 'Distancia mínima (metros)';

  @override
  String get feat_gps_upload_sec => 'Carga por lotes (segundos)';

  @override
  String get feat_gps_background => 'Seguimiento en segundo plano';

  @override
  String get gps_accuracy_mode => 'Modo de precisión';

  @override
  String get feat_gps_max_acc_m => 'Precisión máxima (metros)';

  @override
  String get feat_gps_accuracy_mode => 'Modo de precisión';

  @override
  String get accuracy_low => 'Baja';

  @override
  String get accuracy_balanced => 'Equilibrada';

  @override
  String get accuracy_high => 'Alta';

  @override
  String get accuracy_best => 'Máxima';

  @override
  String get unit_seconds => 'segundos';

  @override
  String get unit_meters => 'metros';

  @override
  String gps_next_fix(Object s) {
    return 'Próxima lectura en ${s}s';
  }

  @override
  String get escl_prog_01 => 'Exclusiones programadas';

  @override
  String get escl_prog_02 => 'Exclusiones disponibles solo a partir del plan Basic';

  @override
  String get escl_prog_03 => 'Añadir exclusión';

  @override
  String get escl_prog_04 => 'No hay exclusiones programadas configuradas.';

  @override
  String get escl_prog_05 => 'Editar';

  @override
  String get escl_prog_06 => 'Nueva exclusión';

  @override
  String get escl_prog_07 => 'Editar exclusión';

  @override
  String get escl_prog_08 => 'Hora de inicio';

  @override
  String get escl_prog_09 => 'Hora de fin';

  @override
  String get escl_prog_10 => 'Notas';

  @override
  String get escl_prog_11 => 'Activa';

  @override
  String get escl_prog_12 => 'Días activos:';

  @override
  String get escl_prog_13 => 'Cancelar';

  @override
  String get escl_prog_14 => 'Guardar';

  @override
  String get verifica_mail_titolo => 'Verifica tu correo electrónico';

  @override
  String get verifica_mail_testo1 => 'Revisa tu bandeja de entrada y haz clic en el enlace de verificación.';

  @override
  String get verifica_mail_testo2 => 'Cuando hayas verificado, vuelve a la página de inicio de sesión para acceder.';

  @override
  String get verifica_mail_testo3 => 'Cuando hayas verificado, vuelve a la página de inicio de sesión para acceder.';

  @override
  String get verifica_mail_testo4 => 'He verificado, volver al panel';

  @override
  String get verifica_mail_erro1 => '¡Correo enviado!';

  @override
  String get verifica_mail_erro2 => 'Error al enviar el correo.';

  @override
  String get verifica_mail_button => 'Reenviar correo';

  @override
  String get acquisto_piano_conferma => 'Confirmar compra';

  @override
  String get acquisto_piano_info => 'Tu información.';

  @override
  String get acquisto_piano_id => 'ID de usuario:';

  @override
  String get acquisto_piano_nome => 'Nombre:';

  @override
  String get acquisto_piano_mail => 'Correo electrónico:';

  @override
  String get acquisto_piano_durata => 'Duración:';

  @override
  String get acquisto_piano_pagamento => 'Proceder al pago';

  @override
  String get acquisto_piano_stripe => 'Serás redirigido a Stripe...';

  @override
  String get acquisto_piano_nopaga => 'Pago no iniciado:';

  @override
  String get acquisto_piano_attivo => '¡Plan activado!';
}
