import 'package:flutter/material.dart';

import '../lingua.dart';
import 'locale_controller.dart'; // <— importa

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final Widget? banner; // appare sotto al sottotitolo, nel bottom dell’AppBar
  final void Function(Locale?)? onChangeLocale;

  const AppHeaderBar({
    this.showBack = false,
    this.banner,
    this.onChangeLocale,
    super.key,
  });

  // altezza: toolbar 64 + subtitle 28 + (banner 44 opzionale)
  @override
  Size get preferredSize =>
      Size.fromHeight(80 + 28 + (banner != null ? 44 : 0));

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final small = MediaQuery.of(context).size.width < 360;

    final logoAsset = 'assets/logo.png';

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return AppBar(
      leading: showBack ? const BackButton() : null,
      backgroundColor: t.colorScheme.surface,
      elevation: 0,
      toolbarHeight: 80,
      titleSpacing: 12,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surface,
              boxShadow: isLight
                  ? [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
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
          // Titolo e sottotitolo uno sotto l'altro
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.t.appTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: t.colorScheme.primary,
                  ),
                ),
                Text(
                  context.t.appSubTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: t.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _LangMenuButton(onChangeLocale: onChangeLocale),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize:
            Size.fromHeight((small ? 0 : 28) + (banner != null ? 44 : 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            if (banner != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: banner!,
              ),
          ],
        ),
      ),
    );
  }
}

class _LangMenuButton extends StatelessWidget {
  const _LangMenuButton({this.onChangeLocale});
  final void Function(Locale?)? onChangeLocale;

  String _labelFor(BuildContext context, String code) {
    switch (code) {
      case 'it':
        return 'Italiano';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lc = LocaleController.instance;
    final isSystem = lc.locale == null;
    final currentCode = lc.locale?.languageCode;

    return PopupMenuButton<String>(
      tooltip: 'Lingua',
      icon: const Icon(Icons.language),

      // evidenzia l’elemento selezionato
      initialValue: isSystem ? 'system' : currentCode,

      onSelected: (v) {
        if (v == 'system') {
          onChangeLocale?.call(null); // lingua di sistema (auto)
        } else {
          onChangeLocale?.call(Locale(v)); // manuale: it/en/fr/es/de
        }
      },

      itemBuilder: (_) => [
        CheckedPopupMenuItem(
          value: 'system',
          checked: isSystem,
          child: const Text('Lingua di sistema'),
        ),
        ...['it', 'en', 'fr', 'es', 'de'].map((code) => CheckedPopupMenuItem(
              value: code,
              checked: !isSystem && currentCode == code,
              child: Text(_labelFor(context, code)),
            )),
      ],
    );
  }
}
