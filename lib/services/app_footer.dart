import 'package:flutter/material.dart';
import 'package:move_app/db.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../lingua.dart';
import '../services/social.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Linea divisoria
          Divider(thickness: 1, color: Colors.grey[300]),
          // 2. Banner promozionale
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 240, 239, 235),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              context.t.footer_page_banner,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
          ),
          // 3. Info legali + contatti
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.t.footer_page_diritti,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  '$dt_email | $dt_telefono',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          // 4. Versione app centrata
          if (appVersion.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                '${context.t.footer_page_versione} $appVersion',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          // 5. Social in fondo
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: const SocialRow(),
          ),
        ],
      ),
    );
  }
}
