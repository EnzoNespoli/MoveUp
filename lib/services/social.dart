import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../db.dart';

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});

  // METTI QUI I TUOI LINK REALI
  static const String? facebookUrl = null; //social_facebook;
  static const String? instagramUrl = null; //social_instagram;
  static const String? xUrl = null; //social_x;

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossibile aprire il link')),
      );
    }
  }

  Widget _btn({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String url,
    required String tooltip,
  }) {
    return IconButton(
      tooltip: tooltip,
      icon: FaIcon(icon, color: color),
      onPressed: () => _openUrl(context, url),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    if (facebookUrl != null) {
      buttons.add(_btn(
        context: context,
        icon: FontAwesomeIcons.facebook,
        color: const Color(0xFF1877F2),
        url: facebookUrl!,
        tooltip: 'Facebook',
      ));
    }

    if (instagramUrl != null) {
      buttons.add(_btn(
        context: context,
        icon: FontAwesomeIcons.instagram,
        color: const Color(0xFFE1306C),
        url: instagramUrl!,
        tooltip: 'Instagram',
      ));
    }

    if (xUrl != null) {
      buttons.add(_btn(
        context: context,
        icon: FontAwesomeIcons.xTwitter,
        color: Colors.black,
        url: xUrl!,
        tooltip: 'X',
      ));
    }

    // Se non c’è nessun social configurato, non mostrare niente
    if (buttons.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      ),
    );
  }
}
