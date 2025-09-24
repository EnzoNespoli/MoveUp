import 'package:flutter/material.dart';
import 'package:move_app/db.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../lingua.dart';

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
          // Riga orizzontale con scritte e banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Info legali
              Expanded(
                child: Text(
                  context.t.footer_page_diritti,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  textAlign: TextAlign.left,
                ),
              ),
              // Banner o messaggio promozionale
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 239, 235),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.t.footer_page_banner,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
              ),
              // Info contatti
              Expanded(
                child: Text(
                  '$dt_email | $dt_telefono',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          // Versione app centrata
          if (appVersion.isNotEmpty)
            Text(
              '${context.t.footer_page_versione} $appVersion',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          SizedBox(height: 8),
          // Social
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook, color: Colors.blue[800]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.purple),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.alternate_email, color: Colors.lightBlue),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
