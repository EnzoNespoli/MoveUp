import 'package:flutter/material.dart';

// ===== Standard bianco (light "pulito")
ThemeData buildThemeStandardWhite() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1565C0),
    brightness: Brightness.light,
  );
  return ThemeData(useMaterial3: true, colorScheme: scheme);
}

// ===== Light verde pastello
const _gPrimary = Color(0xFF2E7D32);   // green 800
const _gBg      = Color(0xFFE7F4EA);   // pastel background
const _gSurf    = Color(0xFFF3FAF4);   // surface

ThemeData buildThemePastelGreen() {
  final scheme = ColorScheme.fromSeed(
    seedColor: _gPrimary,
    brightness: Brightness.light,
  ).copyWith(background: _gBg, surface: _gSurf);

  final base = ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: _gBg);
  return base.copyWith(
    cardTheme: base.cardTheme.copyWith(
      color: _gSurf,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      filled: true, fillColor: _gSurf,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _gPrimary),
      ),
    ),
  );
}


// PALETTE — Rosa pastello elegante
const Color kPPPrimary = Color(0xFFE35A9A); // rosa vivo per accenti
const Color kPPBg      = Color(0xFFFFF4F8); // sfondo latte-rosa
const Color kPPSurf    = Color(0xFFFFEAF2); // superfici (card, sheet)

ThemeData buildThemePastelPink() {
  // NOTA: Brightness.light → testi scuri di default (niente bianco!)
  final scheme = ColorScheme.fromSeed(
    seedColor: kPPPrimary,
    brightness: Brightness.light,
  ).copyWith(
    primary: kPPPrimary,
    onPrimary: Colors.white,
    background: kPPBg,
    surface: kPPSurf,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: kPPBg,
  );

  return base.copyWith(
    // AppBar chiara con testo scuro
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: kPPBg,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
    // Card/pannelli
    cardTheme: base.cardTheme.copyWith(
      color: kPPSurf,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withOpacity(0.06)),
      ),
    ),
    // Campi input
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      filled: true,
      fillColor: kPPSurf,
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.60)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: kPPPrimary),
      ),
    ),
    // Bottom nav
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      backgroundColor: kPPSurf,
      selectedItemColor: kPPPrimary,
      unselectedItemColor: Colors.black54,
      elevation: 8,
    ),
    // Divisori
    dividerColor: Colors.black12,

    // IMPORTANTISSIMO: NON forziamo textTheme a bianco!
    // (quindi niente .apply(bodyColor: Colors.white, ...))
  );
}