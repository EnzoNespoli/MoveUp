import 'package:flutter/services.dart';

class NativeTimezone {
  static const _ch = MethodChannel('flutter_native_timezone');

  static Future<String> getLocalTimezone() async {
    try {
      final tz = await _ch.invokeMethod<String>('getLocalTimezone');
      return tz ?? 'UTC';
    } catch (_) {
      return 'UTC';
    }
  }
}
