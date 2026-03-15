import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../lingua.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossibile aprire $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <_HelpItem>[
      _HelpItem(context.t.help_q1_title, context.t.help_q1_body),
      _HelpItem(context.t.help_q2_title, context.t.help_q2_body),
      _HelpItem(context.t.help_q3_title, context.t.help_q3_body),
      _HelpItem(context.t.help_q4_title, context.t.help_q4_body),
      _HelpItem(context.t.help_q5_title, context.t.help_q5_body),
      _HelpItem(context.t.help_q6_title, context.t.help_q6_body),
      _HelpItem(context.t.help_q7_title, context.t.help_q7_body),
      _HelpItem(context.t.help_q8_title, context.t.help_q8_body),
      _HelpItem(context.t.help_q9_title, context.t.help_q9_body),
      _HelpItem(context.t.help_q10_title, context.t.help_q10_body),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.help_title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            context.t.help_subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ...items.map(
            (it) => Card(
              child: ExpansionTile(
                title: Text(
                  it.q,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(it.a),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  onTap: () => _openUrl('https://mytrak.app/privacy.html'),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  onTap: () => _openUrl('https://mytrak.app/terms.html'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HelpItem {
  final String q;
  final String a;
  _HelpItem(this.q, this.a);
}
