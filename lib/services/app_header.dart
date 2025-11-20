import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../lingua.dart';
import 'locale_controller.dart'; // <— importa
import '../services/app_icons.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final void Function(Locale?)? onChangeLocale; // <- NEW (popup lingua)

  const AppHeader({
    super.key,
    this.showBack = false,
    this.onChangeLocale,
  });

  @override
  Size get preferredSize => Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final title = context.t.appTitle;
    final subtitle = context.t.appSubTitle;
    final logoAsset = AppIcons.logo;

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Material(
      color: cs.surface,
      elevation: isLight ? 1 : 0, // ombra leggera solo in light
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            border: isLight
                ? null
                : Border(
                    // separatore sottile in dark
                    bottom: BorderSide(color: cs.outlineVariant, width: 0.6),
                  ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBack)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: cs.primary, size: 28),
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: context.t.botton_indietro,
                ),
              // Logo tondo con shadow solo in light
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.surface,
                  boxShadow: isLight
                      ? [
                          BoxShadow(
                            color: cs.primary.withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: ClipOval(
                  child: Image.asset(
                    logoAsset,
                    height: 72,
                    width: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Titoli
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Popup lingua (opzionale)
              if (onChangeLocale != null)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.language),
                  // Mostra la selezione attuale nel menu
                  initialValue: LocaleController.instance.locale == null
                      ? 'system'
                      : LocaleController.instance.locale!.languageCode,

                  onSelected: (v) {
                    if (v == 'system') {
                      onChangeLocale?.call(null); // lingua di sistema (auto)
                    } else {
                      onChangeLocale?.call(Locale(v)); // es. 'it','en',...
                    }
                  },

                  itemBuilder: (_) {
                    final lc = LocaleController.instance;
                    final isSystem = lc.locale == null;
                    final current = lc.locale?.languageCode;

                    return [
                      CheckedPopupMenuItem(
                        value: 'system',
                        checked: isSystem,
                        child: Text(context.t.lingua_sistema),
                      ),
                      ...AppLocalizations.supportedLocales.map(
                        (locale) => CheckedPopupMenuItem(
                          value: locale.languageCode,
                          checked: !isSystem && current == locale.languageCode,
                          child: Text(_labelFor(locale.languageCode)),
                        ),
                      ),
                    ];
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

String _labelFor(String code) {
  switch (code) {
    case 'it':
      return 'Italiano';
    case 'en':
      return 'English';
    case 'fr':
      return 'Français';
    case 'de':
      return 'Deutsch';
    case 'es':
      return 'Español';
    default:
      return code;
  }
}
