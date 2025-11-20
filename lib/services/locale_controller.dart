// lib/services/locale_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum LangMode { system, manual }
enum AppTheme { systemWhite, lightPastelGreen, darkPink } // <— NEW

class LocaleController extends ChangeNotifier {
  // Singleton
  static final LocaleController instance = LocaleController._();
  LocaleController._();

  // Storage chiavi (lingua)
  static const _kMode = 'lang_mode';
  static const _kCode = 'lang_code';

  // Storage chiavi (tema)
  static const _kTheme = 'app_theme'; // "systemWhite" | "lightPastelGreen" | "darkPink"

  final _storage = const FlutterSecureStorage();

  // ---- Lingua ----
  LangMode _mode = LangMode.system;
  Locale? _manualLocale; // se null e _mode=system → segue la lingua di sistema
  Locale? get locale => _mode == LangMode.system ? null : _manualLocale;

  // ---- Tema ----
  AppTheme _appTheme = AppTheme.systemWhite;
  AppTheme get appTheme => _appTheme;

  Future<void> load() async {
    // lingua
    final m = await _storage.read(key: _kMode);
    final c = await _storage.read(key: _kCode);
    if (m == 'manual' && c != null && c.isNotEmpty) {
      _mode = LangMode.manual;
      _manualLocale = Locale(c);
    } else {
      _mode = LangMode.system;
      _manualLocale = null;
    }

    // tema
    final t = await _storage.read(key: _kTheme) ?? 'systemWhite';
    _appTheme = switch (t) {
      'lightPastelGreen' => AppTheme.lightPastelGreen,
      'darkPink'         => AppTheme.darkPink,
      _                  => AppTheme.systemWhite,
    };

    notifyListeners();
  }





  // --- Lingua ---
  Future<void> useSystem() async {
    _mode = LangMode.system;
    _manualLocale = null;
    await _storage.write(key: _kMode, value: 'system');
    await _storage.delete(key: _kCode);
    notifyListeners();
  }

  Future<void> useLang(String code) async {
    _mode = LangMode.manual;
    _manualLocale = Locale(code);
    await _storage.write(key: _kMode, value: 'manual');
    await _storage.write(key: _kCode, value: code);
    notifyListeners();
  }

  // tema (custom)
  // Call per salvare la scelta
  Future<void> setAppTheme(AppTheme t) async {
    _appTheme = t;
    await _storage.write(
      key: _kTheme,
      value: switch (t) {
        AppTheme.systemWhite     => 'systemWhite',
        AppTheme.lightPastelGreen=> 'lightPastelGreen',
        AppTheme.darkPink  => 'darkPastelPink',
      },
    );
    notifyListeners();
  }

}
