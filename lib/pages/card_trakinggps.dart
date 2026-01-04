import 'package:flutter/material.dart';
import '../lingua.dart';

class CardTrackingGps extends StatelessWidget {
  final bool trackingAttivo;
  final bool trackingInPausa;
  final bool consensoTrackingGps;

  /// secondi rimanenti al prossimo rilevamento
  final int countdown;

  /// 0=ok, 1=info, 2=warning, 3=alert (colore countdown)
  final int countdownLevel;

  /// secondi di ascolto complessivi (timer visibile solo se attivo)
  final int ascoltoSeconds;

  final ValueChanged<bool> onTrackingChanged; // start (da spento)
  final VoidCallback? onPause;
  final VoidCallback? onStop;
  final VoidCallback? onPlay; // resume (da pausa)
  final String ultimaPosizione;
  final DateTime? lastGpsTsUtc; // ultimo fix valido (UTC)
  final int liveThresholdSec; // default 120

  const CardTrackingGps({
    super.key,
    required this.trackingAttivo,
    required this.trackingInPausa,
    required this.consensoTrackingGps,
    required this.countdown,
    required this.countdownLevel,
    required this.ascoltoSeconds,
    required this.onTrackingChanged,
    this.onPause,
    this.onStop,
    this.onPlay,
    required this.ultimaPosizione,
    required this.lastGpsTsUtc,
    this.liveThresholdSec = 120,
  });

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  bool _isLive(DateTime nowUtc) {
    if (!trackingAttivo || trackingInPausa) return false;
    if (lastGpsTsUtc == null) return false;
    final diff = nowUtc.difference(lastGpsTsUtc!).inSeconds;
    return diff >= 0 && diff <= liveThresholdSec;
  }

  String _lastSeenText(DateTime nowUtc) {
    if (lastGpsTsUtc == null) return ' ';
    final s = nowUtc.difference(lastGpsTsUtc!).inSeconds;
    if (s < 0) return ' ';
    if (s < 60) return '${s}s old';
    final m = s ~/ 60;
    if (m < 60) return '${m}m old';
    final h = m ~/ 60;
    return '${h}h old';
  }

  Color _countdownColor(BuildContext ctx) {
    switch (countdownLevel) {
      case 3:
        return Colors.red.shade600;
      case 2:
        return Colors.orange.shade700;
      case 1:
        return Colors.blueGrey.shade600;
      default:
        return Theme.of(ctx).textTheme.bodyMedium?.color ?? Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF7FAFB),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 360; // telefoni stretti
            final iconSize = narrow ? 44.0 : 50.0;

            Widget controls() {
              if (!trackingAttivo) {
                return IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      size: iconSize, color: Colors.green),
                  tooltip: context.t.gps_err23, // Avvia
                  onPressed: consensoTrackingGps
                      ? () => onTrackingChanged(true)
                      : null,
                );
              }
              if (trackingInPausa) {
                return IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      size: iconSize, color: Colors.green),
                  tooltip: context.t.gps_err24, // Riprendi
                  onPressed: onPlay,
                );
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.pause_circle_filled,
                        size: iconSize, color: Colors.orange),
                    tooltip: context.t.gps_err25, // Pausa
                    onPressed: onPause,
                  ),
                  IconButton(
                    icon: Icon(Icons.stop_circle,
                        size: iconSize, color: Colors.red),
                    tooltip: context.t.gps_err26, // Stop
                    onPressed: onStop,
                  ),
                ],
              );
            }

            final nowUtc = DateTime.now().toUtc();
            final live = _isLive(nowUtc);
            final lastSeen = _lastSeenText(nowUtc);
            Widget statusText() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      !trackingAttivo
                          ? context.t.gps_err15
                          : trackingInPausa
                              ? context.t.gps_err21
                              : context.t.gps_err22,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: !trackingAttivo
                            ? Colors.blueGrey[700]
                            : trackingInPausa
                                ? Colors.orange[700]
                                : Colors.green[700],
                      ),
                    ),
                    if (trackingAttivo && !trackingInPausa) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: live
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  color: live
                                      ? Colors.green.shade300
                                      : Colors.orange.shade300),
                            ),
                            child: Text(
                              live ? 'LIVE' : 'PENDING',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: live
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ' $lastSeen',
                            style: TextStyle(
                                fontSize: 11, color: Colors.blueGrey.shade600),
                          ),
                        ],
                      ),
                    ]
                  ],
                );

            Widget timerChip() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.timer_outlined,
                        size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Text(_fmt(ascoltoSeconds),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ]),
                );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titolo
                Text(context.t.gps_err12, // "Tracciamento GPS"
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // Riga controlli + stato + timer (responsiva)
                if (narrow)
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      controls(),
                      statusText(),
                      if (trackingAttivo && !trackingInPausa) timerChip(),
                    ],
                  )
                else
                  Row(
                    children: [
                      controls(),
                      const SizedBox(width: 12),
                      Expanded(child: statusText()),
                      if (trackingAttivo && !trackingInPausa) ...[
                        const SizedBox(width: 12),
                        timerChip(),
                      ],
                    ],
                  ),

                const SizedBox(height: 10),

                // Countdown (solo se attivo e non in pausa)
                if (trackingAttivo && !trackingInPausa) ...[
                  Text(
                    '${context.t.gps_err16} $countdown s',
                    style: TextStyle(
                        fontSize: 13, color: _countdownColor(context)),
                  ),
                  const SizedBox(height: 8),
                ],

                // Ultima posizione (tronca su 2 righe)
                Text(
                  '${context.t.rep_day_mes02}: $ultimaPosizione',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

                // Messaggio consenso disattivo
                if (!consensoTrackingGps) ...[
                  const SizedBox(height: 6),
                  Text(
                    context.t.gps_err13,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
