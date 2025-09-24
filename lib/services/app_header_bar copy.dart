import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../lingua.dart';

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final Widget? banner;
  final void Function(Locale?)? onChangeLocale; // <-- NEW

  const AppHeaderBar({
    this.showBack = false,
    this.banner,
    this.onChangeLocale, // <-- NEW
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showBack)
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Colors.blue[700], size: 32),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),

                  // Logo
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Titoli
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.appTitle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.t.appSubTitle,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400]),
                      ),
                    ],
                  ),

                  const Spacer(), // <-- spinge il menu a destra

                  // Popup lingua (opzionale se non passi il callback)
                  if (onChangeLocale != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.language),
                      onSelected: (v) {
                        if (v == 'system') {
                          onChangeLocale!(null); // lingua di sistema
                        } else {
                          onChangeLocale!(Locale(v));
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'system',
                          child: Text('Lingua di sistema'),
                        ),
                        ...AppLocalizations.supportedLocales.map(
                          (locale) => PopupMenuItem(
                            value: locale.languageCode,
                            child: Text(_labelFor(locale.languageCode)),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (banner != null) SizedBox(width: double.infinity, child: banner),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120 + (banner != null ? 48 : 0));
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
