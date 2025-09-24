import 'today_metrics.dart';

enum InsightType { quality, goalHit, goalMissing, vsYesterday, none }

class TodayInsight {
  final InsightType type;
  final String text;
  const TodayInsight(this.type, this.text);
}

class InsightRules {
  /// Soglie di prodotto
  final double gapCritical; // es. 0.20 (=20%)
  final int goalReminderHour; // es. 18
  InsightRules({
    this.gapCritical = 0.20,
    this.goalReminderHour = 18,
  });

  TodayInsight pick(TodayMetrics m, {required DateTime now, 
    required String Function(String key, Map<String, dynamic> vars) t}) {

    // 1) Qualità dati
    if (m.gapRatio >= gapCritical) {
      return TodayInsight(
        InsightType.quality,
        t('insight_quality', {}),
      );
    }

    // 2) Obiettivo (se impostato)
    if (m.goalMinutes != null) {
      final goal = m.goalMinutes!;
      if (m.activeMinutes >= goal) {
        return TodayInsight(
          InsightType.goalHit,
          t('insight_goal_hit', {}),
        );
      } else if (now.hour >= goalReminderHour) {
        final remain = (goal - m.activeMinutes).clamp(1, 9999);
        return TodayInsight(
          InsightType.goalMissing,
          t('insight_goal_missing', {'n': remain}),
        );
      }
    }

    // 3) Vs ieri (se disponibile e ieri completo)
    if (m.yesterdayActiveMinutes != null &&
        m.yesterdayActiveMinutes! > 0) {
      final y = m.yesterdayActiveMinutes!.toDouble();
      final deltaPct = y == 0 ? 0 : ((m.activeMinutes - y) / y) * 100.0;
      final sign = deltaPct >= 0 ? '+' : '';
      return TodayInsight(
        InsightType.vsYesterday,
        t('insight_vs_yesterday', {'pct': sign + deltaPct.toStringAsFixed(0)}),
      );
    }

    // fallback
    return TodayInsight(InsightType.none, '');
  }
}
