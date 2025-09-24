import 'package:flutter/material.dart';

/// Usa questa key nel MaterialApp
final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppBanner {
  static void show(
    String message, {
    Duration duration = const Duration(milliseconds: 900),
    IconData icon = Icons.info_outline,
    Color bg = Colors.black87,
    Color fg = Colors.white,
  }) {
    final messenger = rootMessengerKey.currentState;
    if (messenger == null) return;

    // Chiudi un eventuale banner precedente
    messenger.hideCurrentMaterialBanner();

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: bg,
        elevation: 0,
        contentTextStyle: TextStyle(color: fg),
        content: Row(
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // <<< OBBLIGATORIO: almeno una action
        actions: [
          IconButton(
            tooltip: 'Chiudi',
            icon: Icon(Icons.close, color: fg, size: 18),
            onPressed: messenger.hideCurrentMaterialBanner,
          ),
        ],
      ),
    );

    // Auto-hide dopo la durata
    Future.delayed(duration, () {
      // Evita errori se la route è cambiata
      if (rootMessengerKey.currentState == messenger) {
        messenger.hideCurrentMaterialBanner();
      }
    });
  }
}
