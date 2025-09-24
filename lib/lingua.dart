// lib/lingua.dart
import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

extension XStrings on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this)!;
}
