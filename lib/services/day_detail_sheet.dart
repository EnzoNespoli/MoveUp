import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../lingua.dart';

/// Minimal interface dei dati giornalieri che ci servono nel foglio.
/// Adatta i nomi se la tua TodayMetrics differisce.
class TodaySnapshot {
  final int activeMinutes; // min attivi oggi
  final double metersToday; // metri oggi
  final int sedentaryMinutes; // min seduto oggi
  final int? yesterdayActiveMinutes; // min attivi ieri (per info)
  TodaySnapshot({
    required this.activeMinutes,
    required this.metersToday,
    required this.sedentaryMinutes,
    this.yesterdayActiveMinutes,
  });
}

final _hmFmt = DateFormat.Hm();

/// Apri il bottom sheet “Dettaglio giorno”.
/// - [segmentsByLevel] è opzionale: se ce l’hai in memoria (0/1/2 -> lista segmenti),
///   lo mostriamo subito; altrimenti il foglio mostra solo i KPI.
Future<void> openDayDetailSheet(
  BuildContext context, {
  required TodaySnapshot snapshot,
  Map<int, List<Map<String, dynamic>>>? segmentsByLevel,
  String? title, // es. "Oggi" o "29/09/2025"
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _DayDetailSheet(
      snapshot: snapshot,
      segmentsByLevel: segmentsByLevel,
      title: title ?? context.t.today_title,
    ),
  );
}

/* ----------------------------- IMPLEMENTAZIONE ---------------------------- */

class _DayDetailSheet extends StatelessWidget {
  const _DayDetailSheet({
    required this.snapshot,
    required this.title,
    this.segmentsByLevel,
  });

  final TodaySnapshot snapshot;
  final String title;
  final Map<int, List<Map<String, dynamic>>>? segmentsByLevel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titolo
            Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                if (snapshot.yesterdayActiveMinutes != null)
                  Text(
                    'ieri: ${snapshot.yesterdayActiveMinutes} min',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // KPI: Min attivi • Km • Seduto
            _KpiRow(snapshot: snapshot),

            const SizedBox(height: 12),

            // Lista segmenti per livello (se forniti)
            if (segmentsByLevel != null && segmentsByLevel!.isNotEmpty)
              Flexible(child: _SegmentsList(segmentsByLevel: segmentsByLevel!))
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  context.t.card_percorso_5,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            const SizedBox(height: 12),

            // CTA opzionale per mappa (stub)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  // TODO: apri mappa (pagina o sheet) quando pronta
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.map),
                label: Text(context.t.botton_indietro),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* --------------------------------- WIDGETS -------------------------------- */

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.snapshot});
  final TodaySnapshot snapshot;

  String _fmtDist(double meters) {
    if (meters >= 1000) {
      final km = meters / 1000.0;
      return km >= 5
          ? '${km.toStringAsFixed(0)} km'
          : '${km.toStringAsFixed(1)} km';
    }
    return '${meters.round()} m';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    return Row(
      children: [
        Expanded(
            child: _KpiTile(
          label: context.t.kpi_active,
          value: '${snapshot.activeMinutes}',
          icon: Icons.directions_walk,
          bg: cs.surfaceContainerHigh,
        )),
        const SizedBox(width: 8),
        Expanded(
            child: _KpiTile(
          label: 'Km',
          value: _fmtDist(snapshot.metersToday),
          icon: Icons.route,
          bg: cs.surfaceContainerHigh,
        )),
        const SizedBox(width: 8),
        Expanded(
            child: _KpiTile(
          label: context.t.mov_inattivo,
          value: '${snapshot.sedentaryMinutes} min',
          icon: Icons.event_seat,
          bg: cs.surfaceContainerHigh,
        )),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.bg,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: t.textTheme.labelMedium?.copyWith(
                    color: t.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value,
                    style: t.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentsList extends StatelessWidget {
  const _SegmentsList({required this.segmentsByLevel});
  final Map<int, List<Map<String, dynamic>>> segmentsByLevel;

  String _hhmm(String ts) {
    // Atteso "YYYY-MM-DD HH:MM:SS"
    // Sicuro: prendi solo HH:MM
    if (ts.length >= 16) return ts.substring(11, 16);
    return ts;
  }

  String _fmtSec(dynamic v) {
    final s = (v is int) ? v : int.tryParse('$v') ?? 0;
    final m = s ~/ 60;
    final rem = s % 60;
    if (s < 60) return '${s}s';
    if (m < 60) return rem == 0 ? '${m}m' : '${m}m ${rem}s';
    final h = m ~/ 60;
    final mm = m % 60;
    return mm == 0 ? '${h}h' : '${h}h ${mm}m';
  }

  String _fmtDist(dynamic v) {
    final m = (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0.0;
    if (m >= 1000) {
      final km = m / 1000.0;
      return km >= 5
          ? '${km.toStringAsFixed(0)} km'
          : '${km.toStringAsFixed(1)} km';
    }
    return '${m.round()} m';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;

    final levels = <int>[0, 1, 2]
        .where((l) => (segmentsByLevel[l] ?? []).isNotEmpty)
        .toList();
    if (levels.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(context.t.card_percorso_5, style: t.textTheme.bodyMedium),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: levels.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final l = levels[idx];
        final label = l == 0
            ? context.t.mov_inattivo
            : (l == 1 ? context.t.mov_leggero : context.t.mov_veloce);
        final items = segmentsByLevel[l]!;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cs.surfaceContainerHighest,
          ),
          child: ExpansionTile(
            title: Text(label,
                style: t.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            children: items.map((s) {
              final startStr = (s['data_ora_inizio']) as String;
              final endStr = (s['data_ora_fine']) as String;

              final a = _hhmmFromServer(startStr);
              final b = _hhmmFromServer(endStr);

              final dur = _fmtSec(s['durata_sec']);
              final dist = _fmtDist(s['distanza_metri']);

              // Se fermo (l==0), non mostriamo dist porque è solo rumore GPS
              final subtitle = l == 0
                  ? '$a–$b  •  $dur' // Solo orario e durata
                  : '$a–$b  •  $dur  •  $dist'; // Orario, durata E distanza

              return ListTile(
                dense: true,
                title: Text(subtitle),
                //subtitle: Text('${s['fonte'] ?? ''}'),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _hhmmFromServer(String s) {
    // Se ha già offset/Z, DateTime.parse lo capisce e dt.isUtc==true → toLocal()
    // Se è naïvo (YYYY-MM-DD HH:MM:SS), lo consideriamo in UTC e lo convertiamo a locale.
    final hasOffset = RegExp(r'(Z|[+\-]\d{2}:\d{2})$').hasMatch(s);
    final iso = s.contains('T') ? s : s.replaceFirst(' ', 'T');
    final parsed = DateTime.parse(hasOffset ? iso : (iso + 'Z'));
    return _hmFmt.format(parsed.toLocal());
  }
}
