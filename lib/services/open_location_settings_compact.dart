import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:android_intent_plus/android_intent.dart';

Future<void> openLocationSettingsCompat() async {
  try {
    if (Platform.isAndroid) {
      // Deep link alla pagina “Localizzazione”
      const intent = AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch();
    } else {
      // iOS: non esiste una pagina specifica; apri impostazioni app
      await AppSettings.openAppSettings();
    }
  } catch (_) {
    // Fallback estremo
    await AppSettings.openAppSettings();
  }
}