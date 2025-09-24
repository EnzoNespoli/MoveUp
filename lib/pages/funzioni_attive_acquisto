import 'dart:convert';
import 'package:flutter/material.dart';
import '../lingua.dart';

class FunzioniAttiveForm extends StatelessWidget {
  const FunzioniAttiveForm({super.key, required this.funzioniAttive});

  final dynamic funzioniAttive; // può essere Map, String JSON o List

  // Etichette tradotte per i booleani
  Map<String, String> _featLabels(BuildContext context) => {
        'tracking_live': context.t.feat_tracking_live,
        'report_basic': context.t.feat_report_basic,
        'report_advanced': context.t.feat_report_advanced,
        'places_routes': context.t.feat_places_routes,
        'export_gpx': context.t.feat_export_gpx,
        'export_csv': context.t.feat_export_csv,
        'notifications': context.t.feat_notifications,
        'backup_cloud': context.t.feat_backup_cloud,
        'rewards': context.t.feat_rewards,
        'priority_support': context.t.feat_priority_support,
        'no_ads': context.t.feat_no_ads,
      };

  // parser sicuro (gestisce Map, String e List)
  Map<String, dynamic> _toMap(dynamic x) {
    if (x == null) return {};
    if (x is Map) return Map<String, dynamic>.from(x);
    if (x is String) {
      try {
        return _toMap(jsonDecode(x));
      } catch (_) {
        return {};
      }
    }
    if (x is List) {
      return {for (final k in x) k.toString(): true};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final f = _toMap(funzioniAttive);
    final labels = _featLabels(context);

    // campi speciali
    final historyDays = f['history_days'];
    final gpsSample = f['gps_sample_sec'];
    final gpsMinDist = f['gps_min_distance_m'];
    final gpsUpload = f['gps_upload_sec'];
    final gpsBackground = f['gps_background'];

    // lista booleani “classici”
    final featureKeys = labels.keys.where((k) => f.containsKey(k)).toList();

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
              _kvTile(
                icon: Icons.history,
                title: context.t.feat_history_days,
                value: '$historyDays ${context.t.days}',
              ),

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

            if (gpsSample != null ||
                gpsMinDist != null ||
                gpsUpload != null ||
                gpsBackground != null) ...[
              const Divider(height: 16),
              Row(
                children: [
                  const Icon(Icons.gps_fixed, color: Colors.blueGrey),
                  const SizedBox(width: 6),
                  Text(
                    context.t.feat_gps,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              if (gpsSample != null)
                _kvTile(
                  icon: Icons.timer_outlined,
                  title: context.t.feat_gps_sample_sec,
                  value: '$gpsSample ${context.t.unit_seconds}',
                ),
              if (gpsMinDist != null)
                _kvTile(
                  icon: Icons.straighten,
                  title: context.t.feat_gps_min_distance_m,
                  value: '$gpsMinDist ${context.t.unit_meters}',
                ),
              if (gpsUpload != null)
                _kvTile(
                  icon: Icons.cloud_upload_outlined,
                  title: context.t.feat_gps_upload_sec,
                  value: '$gpsUpload ${context.t.unit_seconds}',
                ),
              if (gpsBackground != null)
                ListTile(
                  dense: true,
                  leading: Icon(
                    gpsBackground == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: gpsBackground == true ? Colors.green : Colors.grey,
                  ),
                  title: Text(context.t.feat_gps_background),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _kvTile(
      {required IconData icon,
      required String title,
      required String value}) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      trailing:
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
