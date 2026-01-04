import 'dart:convert';
import 'package:flutter/material.dart';
import '../lingua.dart';

/// Passa qui il JSON del piano: es. pianoAbbonamento['funzioni_attive']
class FunzioniAttiveForm extends StatelessWidget {
  const FunzioniAttiveForm({super.key, required this.funzioniAttive});

  final dynamic funzioniAttive; // può essere Map o String JSON

  Map<String, String> _featLabels(BuildContext context) => {
        'tracking_live': context.t.feat_tracking_live,
        'report_basic': context.t.feat_report_basic,
        'report_advanced': context.t.feat_report_advanced,
        'places_routes': context.t.feat_places_routes,
        //'export_gpx': context.t.feat_export_gpx,
        //'export_csv': context.t.feat_export_csv,
        'notifications': context.t.feat_notifications,
        'backup_cloud': context.t.feat_backup_cloud,
        //'rewards': context.t.feat_rewards,
        'priority_support': context.t.feat_priority_support,
        'no_ads': context.t.feat_no_ads,
        'ai_enabled': context.t.feat_ai_enabled,
        'ai_daily_limit': context.t.feat_ai_daily_limit,
        'ai_scope': context.t.feat_ai_scope,
      };

  Map<String, dynamic> _toMap(dynamic x) {
    if (x == null) return {};
    if (x is Map) return Map<String, dynamic>.from(x);

    if (x is String) {
      try {
        final decoded = jsonDecode(x);
        return _toMap(decoded);
      } catch (_) {
        return {};
      }
    }

    if (x is List) {
      // ['rewards','no_ads'] -> {'rewards': true, 'no_ads': true}
      return {for (final k in x) k.toString(): true};
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> f = _toMap(funzioniAttive);

    // 2) Etichette "umane"
    final labels = _featLabels(context);

    final historyDays = f['history_days'];
    final featureKeys = [
      'tracking_live',
      'report_basic',
      'report_advanced',
      'places_routes',
      //'export_gpx',
      //'export_csv',
      'notifications',
      'backup_cloud',
      //'rewards',
      'priority_support',
      'no_ads',
    ].where((k) => f.containsKey(k)).toList();

    // Parametri GPS presenti?
    final hasGps = f.containsKey('gps_accuracy_mode') ||
        f.containsKey('gps_max_acc_m') ||
        f.containsKey('gps_sample_sec') ||
        f.containsKey('gps_min_distance_m') ||
        f.containsKey('gps_upload_sec') ||
        f.containsKey('gps_background');

    // Parametri AI presenti?
    final hasAi = f.containsKey('ai_enabled') ||
        f.containsKey('ai_daily_limit') ||
        f.containsKey('ai_scope');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.imposta_page_funzioni,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            if (historyDays != null)
              ListTile(
                dense: true,
                leading: const Icon(Icons.history),
                title: Text(context.t.feat_history_days),
                trailing: Text('$historyDays ${context.t.days}'),
              ),

            // Feature boolean classiche
            ...featureKeys.map((k) {
              final enabled = f[k] == true;
              return ListTile(
                dense: true,
                leading: Icon(
                  enabled ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: enabled ? Colors.green : Colors.grey,
                ),
                title: Text(labels[k] ?? k),
              );
            }),

            // Sezione GPS
            if (hasGps) ...[
              const Divider(height: 16),
              Row(
                children: [
                  const Icon(Icons.gps_fixed, color: Colors.blueGrey),
                  const SizedBox(width: 6),
                  Text(
                    context.t.feat_gps, // "Parametri GPS del piano"
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (f['gps_sample_sec'] != null)
                _kvTile(
                  icon: Icons.timer_outlined,
                  title: context
                      .t.feat_gps_sample_sec, // "Campionamento (secondi)"
                  value:
                      '${f['gps_sample_sec']} ${context.t.unit_seconds}', // "60 secondi"
                ),
              if (f['gps_accuracy_mode'] != null)
                _kvTile(
                  icon: Icons.timer_outlined,
                  title: context.t
                      .feat_gps_accuracy_mode, // "Massima accuratezza (metri)"
                  value: '${f['gps_accuracy_mode']} ', // "20 metri"
                ),
              if (f['gps_max_acc_m'] != null)
                _kvTile(
                  icon: Icons.timer_outlined,
                  title: context
                      .t.feat_gps_max_acc_m, // "Massima accuratezza (metri)"
                  value:
                      '${f['gps_max_acc_m']} ${context.t.unit_meters}', // "20 metri"
                ),
              if (f['gps_min_distance_m'] != null)
                _kvTile(
                  icon: Icons.straighten,
                  title: context
                      .t.feat_gps_min_distance_m, // "Distanza minima (metri)"
                  value:
                      '${f['gps_min_distance_m']} ${context.t.unit_meters}', // "20 metri"
                ),
              if (f['gps_upload_sec'] != null)
                _kvTile(
                  icon: Icons.cloud_upload_outlined,
                  title: context
                      .t.feat_gps_upload_sec, // "Invio in batch (secondi)"
                  value:
                      '${f['gps_upload_sec']} ${context.t.unit_seconds}', // "180 secondi"
                ),
              if (f['gps_background'] != null)
                ListTile(
                  dense: true,
                  leading: Icon(
                    f['gps_background'] == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: f['gps_background'] == true
                        ? Colors.green
                        : Colors.grey,
                  ),
                  title: Text(context
                      .t.feat_gps_background), // "Tracking in background"
                ),
            ],

            // Sezione AI
            if (hasAi) ...[
              const Divider(height: 16),
              Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.deepPurple),
                  const SizedBox(width: 6),
                  Text(
                    context.t.feat_ai, // "Funzioni AI"
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (f['ai_enabled'] != null)
                ListTile(
                  dense: true,
                  leading: Icon(
                    f['ai_enabled'] == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: f['ai_enabled'] == true ? Colors.green : Colors.grey,
                  ),
                  title: Text(labels['ai_enabled'] ?? 'AI Enabled'),
                ),
              if (f['ai_daily_limit'] != null)
                _kvTile(
                  icon: Icons.query_stats,
                  title: labels['ai_daily_limit'] ?? 'Daily AI Queries',
                  value: '${f['ai_daily_limit']}',
                ),
              if (f['ai_scope'] != null)
                _kvTile(
                  icon: Icons.analytics_outlined,
                  title: labels['ai_scope'] ?? 'AI Scope',
                  value: '${f['ai_scope']}',
                ),
            ],
          ],
        ),
      ),
    );
  }

  // helper per righe chiave:valore
  Widget _kvTile(
      {required IconData icon, required String title, required String value}) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      trailing:
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
