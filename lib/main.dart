import 'pages/home_page.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'services/locale_controller.dart'; // <-- usa davvero il controller

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.load(); // carica mode + eventuale lingua salvata
  runApp(const MoveApp());
}

class MoveApp extends StatefulWidget {
  const MoveApp({super.key});
  @override
  State<MoveApp> createState() => _MoveAppState();
}

class _MoveAppState extends State<MoveApp> {
  final lc = LocaleController.instance; // singleton, notifyListeners() → rebuild

  @override
  void initState() {
    super.initState();
    lc.addListener(_onLocaleChange);
  }

  @override
  void dispose() {
    lc.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() => setState(() {}); // ricostruisce MaterialApp quando cambia lingua

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      scaffoldMessengerKey: rootMessengerKey,
      title: 'MoveUP',

      // 🔤 Punto chiave:
      // - se lc.mode == system → locale = null → segue la lingua del telefono
      // - se manuale → usa lc.locale
      locale: lc.locale,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Se la lingua di sistema non è tra le supported, cade sulla prima (es. it)
      localeResolutionCallback: (device, supported) {
        if (lc.locale != null) return lc.locale;
        if (device != null && supported.any((l) => l.languageCode == device.languageCode)) {
          return device;
        }
        return supported.first;
      },

      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0), brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0), brightness: Brightness.dark),
      ),

      // Passa le azioni al resto dell’app, ma fai chiamare il controller
      home: HomePage(
        onChangeLocale: (Locale? l) {
          if (l == null) {
            lc.useSystem();          // “Lingua di sistema (auto)”
          } else {
            lc.useLang(l.languageCode); // es. 'it', 'en', ...
          }
        },
      ),
    );
  }
}
