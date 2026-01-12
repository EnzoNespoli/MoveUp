import 'pages/home_page.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'services/locale_controller.dart';
import 'package:provider/provider.dart';
import 'services/purchase_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'theme.dart'; // buildThemeStandardWhite / buildThemePastelGreen / buildThemeDarkPink

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.load(); // lingua + tema custom
  await Hive.initFlutter();
  runApp(
    MultiProvider(
      providers: [
        Provider<PurchaseService>(
          create: (_) => PurchaseService()..init(),
          dispose: (_, s) => s.dispose(),
        ),
      ],
      child: const MoveApp(),
    ),
  );
}

class MoveApp extends StatefulWidget {
  const MoveApp({super.key});
  @override
  State<MoveApp> createState() => _MoveAppState();
}

class _MoveAppState extends State<MoveApp> {
  final lc = LocaleController.instance; // singleton

  @override
  void initState() {
    super.initState();
    lc.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    lc.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // Mappa la tua scelta custom ai temi effettivi
    final ThemeMode mode;
    final ThemeData lightTheme;
    final ThemeData darkTheme = buildThemePastelPink(); //  ROSA

    switch (lc.appTheme) {
      case AppTheme.systemWhite:
        // System = bianco standard (sempre light)
        mode = ThemeMode.light;
        lightTheme = buildThemeStandardWhite();
        break;
      case AppTheme.lightPastelGreen:
        // Light = verde pastello (sempre light)
        mode = ThemeMode.light;
        lightTheme = buildThemePastelGreen();
        break;
      case AppTheme.darkPink:
        // “dark” = rosa pastello (ma è un tema chiaro) → forziamo light
        mode = ThemeMode.light;
        // il lightTheme qui è irrilevante, ma MaterialApp lo richiede comunque
        lightTheme = buildThemePastelPink();
        break;
    }

    return MaterialApp(
      navigatorKey: appNavigatorKey,
      scaffoldMessengerKey: rootMessengerKey,
      title: 'MoveUP',

      // Lingua
      locale: lc.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (device, supported) {
        if (lc.locale != null) return lc.locale;
        if (device != null &&
            supported.any((l) => l.languageCode == device.languageCode)) {
          return device;
        }
        return supported.first;
      },

      debugShowCheckedModeBanner: false,

      // Tema: applica mapping custom
      themeMode: mode,
      theme: lightTheme,
      darkTheme: darkTheme,

      // Home + callback lingua
      home: HomePage(
        onChangeLocale: (Locale? l) {
          if (l == null) {
            lc.useSystem(); // “Lingua di sistema (auto)”
          } else {
            lc.useLang(l.languageCode); // es. 'it', 'en', ...
          }
        },
      ),
    );
  }
}
