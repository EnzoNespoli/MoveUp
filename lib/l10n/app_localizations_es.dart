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
  String get onb1 => '¿Sabes realmente cómo es tu día?';

  @override
  String get onb1_body => '';

  @override
  String get onb2 => 'MoveUP escucha. Tú vives.';

  @override
  String get onb2_body => 'Deja que tu tiempo se cuente.';

  @override
  String get onb3 => 'Es tu tiempo.';

  @override
  String get onb3_body => 'Esta noche sabrás cómo fue.';

  @override
  String get botton_salta => 'Saltar';

  @override
  String get condizioni_uso => 'He leído y acepto las ';

  @override
  String get condizioni_uso2 => 'Condiciones de uso';

  @override
  String get privacy_policy => ' y la ';

  @override
  String get privacy_policy2 => 'Política de Privacidad';

  @override
  String get botton_prosegui => '¡Comenzar ahora!';

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
  String get user_login_success => '¡Inicio de sesión exitoso!';

  @override
  String get gps_err01 => 'El registro de ubicación está desactivado: actívalo en ajustes.';

  @override
  String get gps_err02 => 'Error al guardar la ubicación:';

  @override
  String get gps_err03 => 'El registro de ubicación está desactivado: la ubicación no se registra.';

  @override
  String get gps_err04 => 'Permiso de ubicación denegado';

  @override
  String get gps_err05 => 'Permiso de ubicación denegado permanentemente';

  @override
  String get gps_err06 => 'Señal GPS débil, espera una mejor ubicación';

  @override
  String get gps_err07 => 'Error al obtener la ubicación:';

  @override
  String get gps_err08 => '¡Ubicación guardada!';

  @override
  String get gps_err09 => 'Error al guardar la ubicación:';

  @override
  String get gps_err10 => 'DEBUG API leer consentimientos:';

  @override
  String get gps_err11 => 'DEBUG API valor de consentimiento GPS:';

  @override
  String get gps_err12 => 'Registro de ubicación ';

  @override
  String get gps_err13 => 'Debes activar el registro de ubicación en ajustes.';

  @override
  String get gps_err14 => 'Registro en espera';

  @override
  String get gps_err15 => 'Registro desactivado';

  @override
  String get gps_err16 => 'Próxima actualización en';

  @override
  String get gps_err17 => 'GPS Activado';

  @override
  String get gps_err18 => 'GPS Desactivado';

  @override
  String get gps_err19 => 'Registro GPS';

  @override
  String get gps_err20 => 'Aún no hay eventos registrados.';

  @override
  String get gps_err21 => 'En pausa';

  @override
  String get gps_err22 => 'En escucha';

  @override
  String get gps_err23 => 'Iniciar registro';

  @override
  String get gps_err24 => 'Reanudar registro';

  @override
  String get gps_err25 => 'Pausar registro';

  @override
  String get gps_err26 => 'Reanudar registro';

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
  String get info_mes07 => 'Entiende cómo te mueves';

  @override
  String get info_mes08 => 'Descubre cómo empleas tu tiempo';

  @override
  String get mov_inattivo => 'En pausa / Parado';

  @override
  String get mov_leggero => 'Movimiento lento';

  @override
  String get mov_veloce => 'Desplazamiento rápido';

  @override
  String get chart_mes01 => 'No hay gráficos disponibles por el momento.';

  @override
  String get chart_mes02 => 'Actividad por horas';

  @override
  String get chart_mes03 => 'Intervalo dos horas';

  @override
  String get chart_mes04 => 'Distribución de niveles diarios';

  @override
  String get chart_mes05 => 'Intervalo dos horas';

  @override
  String get chart_mes06 => 'No se pudo generar la imagen. Inténtalo de nuevo.';

  @override
  String get chart_mes07 => 'Mi informe MoveUP de hoy';

  @override
  String get cahrt_mes08 => 'Error al compartir:';

  @override
  String get chart_mes09 => 'Informe MoveUP de hoy';

  @override
  String get chart_mes10 => 'Línea temporal de niveles (por carriles)';

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
  String get form_reg_gps => 'Registro de ubicación';

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
  String get condividi_button => '';

  @override
  String get form_consensi_01 => 'Privacidad';

  @override
  String get form_consensi_02 => 'Acepto la Política de Privacidad';

  @override
  String get form_consensi_03 => 'Acepto recibir comunicaciones de marketing';

  @override
  String get form_consensi_04 => 'Acepto participar en concursos y premios';

  @override
  String get form_consensi_05 => 'Acepto el registro de ubicación';

  @override
  String get form_consensi_06 => 'Continuar';

  @override
  String get form_consensi_er => 'Error al guardar los consentimientos:';

  @override
  String get form_consensi_07 => 'Para usar MoveUP debes aceptar la Política de Privacidad.';

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
  String get bottom_cronologia => 'Actividad';

  @override
  String get bottom_profilo => 'Perfil';

  @override
  String get bottom_abbonamenti => 'Suscripciones';

  @override
  String get bottom_dashboard => 'Inicio';

  @override
  String get bottom_impostazioni_short => 'Conf.';

  @override
  String get bottom_cronologia_short => 'Act.';

  @override
  String get bottom_profilo_short => 'Perf.';

  @override
  String get bottom_abbonamenti_short => 'Susc.';

  @override
  String get bottom_impostazioni_tt => 'Abre la configuración y los consentimientos';

  @override
  String get bottom_cronologia_tt => 'Consulta tu actividad registrada';

  @override
  String get bottom_profilo_tt => 'Regístrate, inicia sesión o cierra sesión en tu perfil';

  @override
  String get bottom_abbonamenti_tt => 'Gestiona tu suscripción a MoveUP';

  @override
  String get bottom_dashboard_tt => 'Volver a Inicio';

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
  String get rep_day_chiedi_AI => 'Pedir a la IA que…';

  @override
  String get rep_day_button_01 => 'Explicar el día';

  @override
  String get rep_day_button_02 => 'Consejo para mañana';

  @override
  String get rep_day_button_03 => '¿Por qué estoy inactivo?';

  @override
  String get rep_day_ai_loading => 'La IA está procesando tu solicitud…';

  @override
  String get rep_day_ai_error => 'Error de IA: inténtalo de nuevo más tarde.';

  @override
  String get rep_day_ai_limit => 'Has alcanzado el límite diario de solicitudes de IA.';

  @override
  String get rep_day_ai_response => 'Respuesta IA:';

  @override
  String get rep_day_ai_info => 'Aquí aparecerá la respuesta de la IA.';

  @override
  String get rep_day_ai_error_01 => 'Ninguna respuesta disponible';

  @override
  String get rep_day_ai_error_02 => 'restan';

  @override
  String get rep_day_ai_error_03 => 'Análisis de IA no disponible para tu plan.';

  @override
  String get rep_day_ai_error_04 => 'Para usar la IA primero debes activar el consentimiento en la configuración.';

  @override
  String get rep_day_ai_error_05 => 'Función de IA no disponible en este momento.';

  @override
  String get rep_week_insight_empty => 'Esta semana no emergen rutas recurrentes. Sigue usando MoveUP para identificar tus hábitos.';

  @override
  String rep_week_insight_01(Object count, Object days) {
    return 'Has seguido la misma ruta en $count días diferentes ($days). Esto indica un posible hábito de desplazamiento.';
  }

  @override
  String rep_week_insight_02(Object count, Object days) {
    return 'Una ruta se ha repetido $count veces ($days). Podría tratarse de una rutina en formación.';
  }

  @override
  String get rep_week_insight_03 => 'MoveUP puede analizar tus hábitos de desplazamiento semanalmente.';

  @override
  String get rep_week_insight_04 => 'Qué revela esta semana';

  @override
  String get rep_week_insight_05 => 'MoveUP piensa:';

  @override
  String get rep_week_insight_06 => 'MoveUP está analizando...';

  @override
  String get rep_week_insight_07 => 'Aquí aparecerá el análisis de MoveUP.';

  @override
  String get storico_01 => 'Elige cuánto historial quieres conservar. El resto crece contigo.';

  @override
  String get storico_02 => 'Free (Anónimo)';

  @override
  String get storico_03 => 'Usa la aplicación sin registrarte.\nMoveUP puede detectar tu posición para registrar el tiempo en movimiento, la distancia recorrida y los momentos de pausa.\nLos datos permanecen solo en tu dispositivo y se eliminan automáticamente después de 10 días.\nFunciones: registro de posición y resumen diario.\nNota: la sección HOME no está disponible en este modo.';

  @override
  String get storico_04 => 'Start (Registrado)';

  @override
  String get storico_05 => 'Cuenta gratuita con prueba completa de 30 días.\nFunciones: registro de posición en tiempo real y en segundo plano, copia de seguridad en la nube, sincronización entre dispositivos y notificaciones.\nDespués de 30 días la cuenta permanece activa pero el historial vuelve a 10 días.\nNota: la sección HOME no está disponible sin un plan activo.';

  @override
  String get storico_06 => 'Basic — 30 días (Pago)';

  @override
  String get storico_07 => 'Historial de 30 días.\nFunciones: línea temporal diaria completa, métricas por nivel (parado/lento/rápido), lugares y rutas recurrentes.\nAcceso completo a la sección HOME.';

  @override
  String get storico_08 => 'Plus — 180 días (Pago)';

  @override
  String get storico_09 => 'Historial de 6 meses.\nFunciones: todo lo incluido en Basic más análisis de rutas y lugares recurrentes con resúmenes semanales y mensuales.\nAcceso completo a la sección HOME.';

  @override
  String get storico_10 => 'Pro — 365 días (Pago)';

  @override
  String get storico_11 => 'Historial de 1 año.\nFunciones: informes avanzados, filtros detallados y acceso completo a la sección HOME.';

  @override
  String get storico_12 => 'Nota de privacidad:';

  @override
  String get storico_13 => 'MoveUP puede detectar tu posición también en segundo plano para registrar tus desplazamientos, la distancia recorrida y el tiempo en movimiento.\nPuedes modificar o revocar los permisos en cualquier momento.\nSin permiso de ubicación la aplicación no registra datos.\nSi usas la aplicación en modo anónimo, los datos permanecen solo en el dispositivo y se eliminan automáticamente cuando finaliza el período disponible.';

  @override
  String get storico_14 => '⏳ Cargando datos…';

  @override
  String get form_crono_01 => 'Actividad';

  @override
  String get form_crono_02 => 'Resumen de actividad';

  @override
  String get form_crono_03 => 'Bienvenido, ';

  @override
  String get form_crono_04 => 'Resumen últimos 7 días';

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
  String get form_crono_10 => 'Resumen de 8 a 14 días';

  @override
  String get form_crono_11 => 'Comparación semanal';

  @override
  String get dashboard_piano => 'Plan:';

  @override
  String get dashboard_msg => 'Ve a Perfil y regístrate.\nTendrás tu semana tipo';

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
  String get imposta_page_frequenza => 'Tasa de detección (seg)';

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
  String get imposta_page_ai => 'Consentimiento IA';

  @override
  String get footer_page_diritti => '© 2025 MoveUP - Todos los derechos reservados';

  @override
  String get footer_page_banner => 'Your Personal Move';

  @override
  String get footer_page_versione => 'Versión app:';

  @override
  String get header_page_banner => 'Your Personal Move';

  @override
  String get rep_day_export_locked => 'Compartir requiere START/BASIC/PLUS/PRO';

  @override
  String get rep_day_function_ai => 'Funciones disponibles con START/BASIC/PLUS/PRO';

  @override
  String get msg_abilitato_01 => 'Registra tu perfil para ver tus datos de hoy.';

  @override
  String get msg_abilitato_02 => 'Registra tu perfil para ver tus datos de hoy.';

  @override
  String get crono_msg_01 => 'Registra tu perfil para ver tus datos de hoy.';

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
  String get feat_tracking_live => 'Registro de ubicación en vivo';

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
  String get feat_ai_enabled => 'AI habilitada';

  @override
  String get feat_ai_daily_limit => 'ímite diario de AI';

  @override
  String get feat_ai_scope => 'Ámbito de AI';

  @override
  String get feat_ai => 'Funciones AI';

  @override
  String get days => 'giorni';

  @override
  String get feat_gps => 'Parámetros de grabación del plan';

  @override
  String get feat_gps_sample_sec => 'Muestreo (segundos)';

  @override
  String get feat_gps_min_distance_m => 'Distancia mínima (metros)';

  @override
  String get feat_gps_upload_sec => 'Carga por lotes (segundos)';

  @override
  String get feat_gps_background => 'Detección en segundo plano';

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
  String get acquisto_piano_google => 'Serás redirigido a Google...';

  @override
  String get acquisto_piano_nopaga => 'Pago no iniciado:';

  @override
  String get acquisto_piano_attivo => '¡Plan activado!';

  @override
  String get card_settimana => 'Semana';

  @override
  String get card_gio_today => 'Ahora';

  @override
  String get card_gio_lunedi => 'Lunes';

  @override
  String get card_gio_martedi => 'Martes';

  @override
  String get card_gio_mercoledi => 'Miércoles';

  @override
  String get card_gio_giovedi => 'Jueves';

  @override
  String get card_gio_venerdi => 'Viernes';

  @override
  String get card_gio_sabato => 'Sábado';

  @override
  String get card_gio_domenica => 'Domingo';

  @override
  String get today_title => 'Hoy';

  @override
  String get today_title_closed => 'Hoy — jornada terminada';

  @override
  String get badge_partial => 'Datos parciales';

  @override
  String get kpi_active => 'Tiempo en movimiento';

  @override
  String get kpi_km => 'Km';

  @override
  String get kpi_sedentary => 'Pausas / En pausa';

  @override
  String get no_data_msg => 'Aún no tenemos datos para hoy.';

  @override
  String get check_location => 'Permisos de ubicación';

  @override
  String get check_battery => 'Ahorro de batería';

  @override
  String get check_gps => 'Estado del GPS';

  @override
  String get insight_quality => 'Estamos perdiendo datos por el ahorro de batería. Toca para corregirlo.';

  @override
  String get insight_goal_hit => '¡Objetivo logrado 🎯! ¡Buen trabajo!';

  @override
  String insight_goal_missing(Object v1) {
    return 'Te faltan $v1 min para el objetivo.';
  }

  @override
  String insight_vs_yesterday(Object v2) {
    return 'Hoy estás al $v2% respecto a ayer.';
  }

  @override
  String get fix_qualita_dati => 'Calidad de datos';

  @override
  String get fix_message => 'Corrige estos puntos para evitar pérdida de datos.';

  @override
  String get fix_permessi => 'Permisos de ubicación (Siempre)';

  @override
  String get fix_permessi_sub => 'Concede acceso de ubicación “Siempre”';

  @override
  String get fix_gps_attivo => 'GPS activo y Alta precisión';

  @override
  String get fix_gps_attivo_sub => 'Abrir ajustes de Ubicación';

  @override
  String get fix_auto_start => 'Inicio automático / Protección de apps';

  @override
  String get fix_auto_ricontrolla => 'Volver a comprobar';

  @override
  String get fix_battery => 'Desactiva el ahorro de batería para MoveUP';

  @override
  String get fix_battery_sub => 'Permitir “Ignorar optimización de batería”';

  @override
  String get fix_vendor_01 => 'MIUI: Seguridad → Permisos → Inicio automático + Ahorro de batería.';

  @override
  String get fix_vendor_02 => 'EMUI: Ajustes → Batería → Inicio de apps (permitir inicio y ejecución en segundo plano).';

  @override
  String get fix_vendor_03 => 'ColorOS/Funtouch: Habilita Inicio automático y quita la optimización agresiva.';

  @override
  String get fix_vendor_04 => 'OnePlus: Batería → Optimización de batería → MoveUP → No optimizar.';

  @override
  String get fix_vendor_05 => 'Samsung: Cuidado del dispositivo → Batería → Apps en suspensión: elimina MoveUP.';

  @override
  String get fix_vendor_06 => 'Revisa el Inicio automático y la protección de apps del fabricante.';

  @override
  String get fix_messag_01 => 'Ve a Ajustes → Privacidad y seguridad → Ubicación → MoveUP\nestablece “Siempre” y activa “Ubicación precisa”.\nRevisa también Ahorro de energía: podría limitar la actividad en segundo plano.';

  @override
  String get fix_chiudi_button => 'Cerrar';

  @override
  String get fix_riduci_button => 'Reducir';

  @override
  String get fix_espandi_button => 'Expandir';

  @override
  String get dettagli => 'Detalles técnicos del día';

  @override
  String get posizione => 'Tu ubicación';

  @override
  String get export_day => 'Exportar datos del día';

  @override
  String get date_parse_error => 'Error al leer la fecha';

  @override
  String get export_started => 'Exportación iniciada...';

  @override
  String get download_start => 'Descarga iniciada en el navegador';

  @override
  String get esportazione_file => 'Exportación:';

  @override
  String get errore_http => 'Error de descarga: HTTP';

  @override
  String get errore_generico => 'Error de exportación:';

  @override
  String get dedica_title => 'Dedicado a…';

  @override
  String get dedica_testo => 'Mi esposa y Lova, que me dieron la fuerza para llegar hasta aquí. 💚🐾';

  @override
  String get analisi_oggi => 'Datos registrados';

  @override
  String get movimento => 'Movimiento';

  @override
  String get non_reg => 'No registrado';

  @override
  String get parziale => 'Parcial';

  @override
  String get completo => 'Completo';

  @override
  String get dati_incompleti => 'Datos incompletos: el teléfono no ha registrado durante aproximadamente';

  @override
  String get ottima_attivita => 'Muy buena actividad hoy';

  @override
  String get buona_attivita => 'Buena actividad, has aprovechado bien parte del día.';

  @override
  String get giorno_statico1 => 'Jornada bastante estática ';

  @override
  String get giorno_statico2 => 'parado/pausa';

  @override
  String get attivita_media => 'Actividad media.';

  @override
  String get attivita_giorno => 'Ninguna actividad registrada hoy.';

  @override
  String get notifiche_testa => 'Notificaciones MoveUP';

  @override
  String get notifiche_segnala => 'Marcar todo como leído';

  @override
  String get notifiche_elimina_tutte => 'Eliminar todo';

  @override
  String get notifiche_conferma => 'Confirmar';

  @override
  String get notifiche_conferma_msg => '¿Quieres eliminar todas las notificaciones?';

  @override
  String get notifiche_annulla => 'Cancelar';

  @override
  String get notifiche_elimina => 'Eliminar';

  @override
  String get notifiche_vuota => 'No hay notificaciones en este momento.';

  @override
  String get notifiche_segnalate => 'Marcadas como leídas';

  @override
  String get costi_impatto => 'Impacto estimado';

  @override
  String get costi_calcolo => 'Cálculo en curso...';

  @override
  String get costi_nessuno => 'No se detectaron desplazamientos rápidos esta semana.';

  @override
  String get costi_spostamenti => 'Desplazamientos rápidos:';

  @override
  String get costi_stima => 'Estimación basada en';

  @override
  String get costi_costo => 'Costo estimado:';

  @override
  String get costi_escluso => 'Peajes/aparcamiento excluidos.';

  @override
  String get help_title => 'Help';

  @override
  String get help_subtitle => 'Preguntas frecuentes sobre MoveUP';

  @override
  String get help_q1_title => '¿MoveUP está registrando mis movimientos ahora?';

  @override
  String get help_q2_title => '¿MoveUP funciona si la app está cerrada o el teléfono bloqueado?';

  @override
  String get help_q3_title => '¿Por qué debo permitir la ubicación \"Siempre\"?';

  @override
  String get help_q4_title => '¿MoveUP consume mucha batería?';

  @override
  String get help_q5_title => '¿Por qué a veces veo \"EN ESPERA\"?';

  @override
  String get help_q6_title => '¿MoveUP registra también cuando estoy quieto?';

  @override
  String get help_q7_title => '¿Por qué hoy veo menos datos que otros días?';

  @override
  String get help_q8_title => '¿Puedo detener o pausar el registro?';

  @override
  String get help_q9_title => '¿Mis datos son privados?';

  @override
  String get help_q10_title => '¿Qué pasa si desinstalo MoveUP?';

  @override
  String get help_q1_body => 'Si ves el estado LIVE o En escucha, MoveUP está monitoreando tu movimiento incluso con la pantalla apagada.';

  @override
  String get help_q2_body => 'Sí. MoveUP puede seguir registrando movimientos incluso cuando la aplicación no está abierta, si has autorizado la ubicación.';

  @override
  String get help_q3_body => 'El permiso \"Siempre\" permite que MoveUP funcione correctamente incluso cuando no estás usando activamente la aplicación.';

  @override
  String get help_q4_body => 'MoveUP utiliza el GPS solo cuando es necesario y de forma optimizada. El consumo depende principalmente de cuánto te muevas durante el día.';

  @override
  String get help_q5_body => '\"EN ESPERA\" significa que MoveUP está activo pero todavía no ha detectado un nuevo movimiento o está esperando una señal GPS estable.';

  @override
  String get help_q6_body => 'Sí. Los periodos de inactividad también se registran para entender mejor cómo evoluciona tu día.';

  @override
  String get help_q7_body => 'Es normal. Los datos dependen de tu movimiento real durante el día y de la calidad de la señal GPS.';

  @override
  String get help_q8_body => 'Sí. Puedes detener o pausar el registro en cualquier momento desde la pantalla principal.';

  @override
  String get help_q9_body => 'Sí. Tus datos de movimiento son personales y se utilizan únicamente para las funciones de la aplicación.';

  @override
  String get help_q10_body => 'Si desinstalas MoveUP, el registro se detiene inmediatamente. Puedes reinstalar la app en cualquier momento.';

  @override
  String get dash_dettaglio => 'DETALLES';

  @override
  String get dash_profilo => 'PERFIL';

  @override
  String get dash_totale => 'Total';

  @override
  String get dash_aggiorna => 'Actualizar datos';

  @override
  String get dash_oggi => 'Hoy';

  @override
  String get dash_registrazione => 'Descubre cómo ha sido tu día.';

  @override
  String get dash_spento => 'MoveUP está en funcionamiento.';

  @override
  String get dash_benvenuto => 'Bienvenido';

  @override
  String get dash_fermo => 'DETENIDO';

  @override
  String get dash_lento => 'LENTO';

  @override
  String get dash_veloce => 'RÁPIDO';

  @override
  String get dash_non_tracciato => 'NO REGISTRADO';

  @override
  String get dash_prova_attiva => 'Prueba activa';

  @override
  String get dash_move_pronto => 'MoveUP está listo';

  @override
  String get dash_prova_terminata => 'Prueba finalizada • Regístrate para continuar';

  @override
  String get dash_prova_terminata2 => 'Prueba finalizada • Compra para continuar';

  @override
  String get dash_modalita_ospite => 'Modo invitado • 1 día restante';

  @override
  String get dash_modalita => 'Modo invitado •';

  @override
  String get dash_giorni_rimasti => 'días restantes';

  @override
  String get dash_prova_completa => 'Prueba completa • 1 día restante';

  @override
  String get dash_prova => 'Prueba completa •';

  @override
  String get dash_fine => 'DETENER';

  @override
  String get dash_inizia => 'INICIAR';

  @override
  String get dash_accedi => 'ACCEDER';

  @override
  String get dash_acquista_piano => 'COMPRAR PLAN';

  @override
  String get dash_home => 'INICIO';

  @override
  String get dash_tempo_movimento => 'Tiempo en movimiento';

  @override
  String get dash_pausa_fermo => 'Pausa / Detenido';

  @override
  String get dash_riepilogo => 'Resumen últimos 7 días';

  @override
  String get dash_movimento_lento => 'Movimiento lento';

  @override
  String get dash_spostamento_veloce => 'Desplazamiento rápido';

  @override
  String get dash_indietro => 'ATRÁS';

  @override
  String get feat_gps_moving_every_sec => 'Intervalle en mouvement (secondes)';

  @override
  String get feat_gps_stationary_every_sec => 'Intervalle immobile (secondes)';

  @override
  String get feat_gps_ios_distance_filter_m => 'Filtre de distance iOS (mètres)';

  @override
  String get feat_gps_acc_hard_reject_m => 'Rejet précis (mètres)';
}
