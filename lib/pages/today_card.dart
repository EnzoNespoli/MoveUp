import 'package:flutter/material.dart';
import 'today_metrics.dart';
import 'today_insight.dart';

class TodayCard extends StatelessWidget {
  final TodayMetrics metrics;
  final InsightRules rules;
  final DateTime now;

  // callback opzionali
  final VoidCallback? onTap;
  final VoidCallback? onTapQualityFix;

  // i18n adapter: riceve key e variabili → ritorna stringa localizzata
  final String Function(String key, Map<String, dynamic> vars) t;

  const TodayCard({
    super.key,
    required this.metrics,
    required this.rules,
    required this.now,
    required this.t,
    this.onTap,
    this.onTapQualityFix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Stati
    final hasData = metrics.hasAnyData;
    final partial = metrics.gapRatio >= rules.gapCritical;
    final closed = metrics.dayClosed;

    // Insight
    final insight = rules.pick(metrics, now: now, t: t);

    // UI helpers
    Widget kpi(String label, String value, IconData icon) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    String fmtKm(double meters) {
      if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
      return '${(meters/1000).toStringAsFixed(1)} km';
    }
    String fmtSedentary(int mins) {
      final h = mins ~/ 60, m = mins % 60;
      return h > 0 ? '${h} h ${m} min' : '${m} min';
    }

    // Nessun dato → stato esplicativo
    if (!hasData) {
      return _CardShell(
        cs: cs,
        title: t('today_title', {}),
        badge: null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('no_data_msg', {}),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _ChecklistChip(label: t('check_location', {}), icon: Icons.location_on),
                _ChecklistChip(label: t('check_battery', {}),  icon: Icons.battery_saver),
                _ChecklistChip(label: t('check_gps', {}),      icon: Icons.gps_fixed),
              ],
            ),
          ],
        ),
      );
    }

    // Card normale/partiale/chiusa
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: _CardShell(
        cs: cs,
        title: closed ? t('today_title_closed', {}) : t('today_title', {}),
        badge: partial ? t('badge_partial', {}) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kpi(t('kpi_active', {}), '${metrics.activeMinutes} min', Icons.access_time),
                const SizedBox(width: 12),
                kpi(t('kpi_km', {}), fmtKm(metrics.distanceMeters), Icons.straighten),
                const SizedBox(width: 12),
                kpi(t('kpi_sedentary', {}), fmtSedentary(metrics.sedentaryMinutes), Icons.event_seat),
              ],
            ),
            const SizedBox(height: 10),

            // Insight
            if (insight.type != InsightType.none)
              _InsightBanner(
                text: insight.text,
                type: insight.type,
                onTapQualityFix: onTapQualityFix,
              ),
          ],
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final ColorScheme cs;
  final String title;
  final String? badge;
  final Widget child;

  const _CardShell({
    required this.cs,
    required this.title,
    required this.child,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChecklistChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ChecklistChip({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: cs.primary),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}

class _InsightBanner extends StatelessWidget {
  final String text;
  final InsightType type;
  final VoidCallback? onTapQualityFix;

  const _InsightBanner({
    required this.text,
    required this.type,
    this.onTapQualityFix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Color bg;
    Color fg;
    VoidCallback? onTap;

    switch (type) {
      case InsightType.quality:
        bg = Colors.amber.withOpacity(0.18);
        fg = Colors.amber[900]!;
        onTap = onTapQualityFix;
        break;
      case InsightType.goalHit:
        bg = Colors.green.withOpacity(0.18);
        fg = Colors.green[900]!;
        break;
      case InsightType.goalMissing:
        bg = Colors.orange.withOpacity(0.18);
        fg = Colors.orange[900]!;
        break;
      case InsightType.vsYesterday:
        bg = cs.primaryContainer.withOpacity(0.25);
        fg = cs.onPrimaryContainer;
        break;
      case InsightType.none:
        bg = cs.surfaceVariant;
        fg = cs.onSurfaceVariant;
        break;
    }

    final content = Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: fg,
        fontWeight: FontWeight.w600,
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }
}
