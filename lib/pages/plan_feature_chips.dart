// plan_feature_chips.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../lingua.dart';

/// Riga di chip con le prime N funzioni **attive** del piano.
/// Accetta sia Map che String JSON (campo "funzioni_attive").
class PlanFeatureChips extends StatelessWidget {
  const PlanFeatureChips({
    super.key,
    required this.funzioniAttive,
    this.maxChips = 3,
  });

  final dynamic funzioniAttive; // Map<String,bool> oppure String JSON
  final int maxChips;

  @override
  Widget build(BuildContext context) {
    final feats = _parse(funzioniAttive);

    final attive = feats.entries
        .where((e) => e.value == true && e.key != 'history_days')
        .map((e) => _label(context, e.key))
        .where((s) => s.isNotEmpty)
        .toList();

    if (attive.isEmpty) return const SizedBox.shrink();

    final shown = attive.take(maxChips).toList();
    final rest = attive.length - shown.length;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final l in shown)
          Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            labelPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            backgroundColor: Colors.blueGrey.shade50,
            side: BorderSide(color: Colors.blueGrey.shade100),
            label: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(l),
            ]),
          ),
        if (rest > 0)
          Chip(
            label: Text(
              '+$rest',
              style: TextStyle(
                fontSize: 10, // più piccolo
                fontWeight: FontWeight.w400,
              ),
               overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: Colors.grey.shade100,
            side: BorderSide(color: Colors.grey.shade300),
          ),
      ],
    );
  }

  // ---- helpers ----

  static Map<String, dynamic> _parse(dynamic v) {
    if (v is Map) return Map<String, dynamic>.from(v);
    if (v is String && v.trim().isNotEmpty) {
      try {
        return Map<String, dynamic>.from(jsonDecode(v));
      } catch (_) {}
    }
    return const {};
  }

  /// Etichette localizzate tramite context.t.*
  static String _label(BuildContext ctx, String k) {
    try {
      // Adatta i nomi delle chiavi qui sotto alle tue stringhe di localizzazione
      switch (k) {
        case 'tracking_live':
          return ctx.t.feat_tracking_live;
        case 'report_basic':
          return ctx.t.feat_report_basic;
        case 'report_advanced':
          return ctx.t.feat_report_advanced;
        case 'places_routes':
          return ctx.t.feat_places_routes;
        case 'export_gpx':
          return ctx.t.feat_export_gpx;
        case 'export_csv':
          return ctx.t.feat_export_csv;
        case 'notifications':
          return ctx.t.feat_notifications;
        case 'backup_cloud':
          return ctx.t.feat_backup_cloud;
        case 'rewards':
          return ctx.t.feat_rewards;
        case 'priority_support':
          return ctx.t.feat_priority_support;
        case 'no_ads':
          return ctx.t.feat_no_ads;
        default:
          return k; // fallback sicuro
      }
    } catch (_) {
      return k; // fallback se context.t non ha la chiave
    }
  }
}
