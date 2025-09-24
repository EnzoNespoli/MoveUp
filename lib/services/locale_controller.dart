// lib/services/locale_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum LangMode { system, manual }

class LocaleController extends ChangeNotifier {
  // Singleton
  static final LocaleController instance = LocaleController._();
  LocaleController._();

  // Storage chiavi
  static const _kMode = 'lang_mode';
  static const _kCode = 'lang_code';

  final _storage = const FlutterSecureStorage();

  LangMode _mode = LangMode.system;
  Locale? _manualLocale; // se null e _mode=system → segue la lingua di sistema

  /// Ritorna `null` quando vuoi usare la lingua di sistema
  Locale? get locale => _mode == LangMode.system ? null : _manualLocale;

  Future<void> load() async {
    final m = await _storage.read(key: _kMode);
    final c = await _storage.read(key: _kCode);
    if (m == 'manual' && c != null && c.isNotEmpty) {
      _mode = LangMode.manual;
      _manualLocale = Locale(c);
    } else {
      _mode = LangMode.system;
      _manualLocale = null;
    }
    notifyListeners();
  }

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
}
