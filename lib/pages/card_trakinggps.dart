import 'package:flutter/material.dart';
import '../lingua.dart';

class CardTrackingGps extends StatelessWidget {
  final bool trackingAttivo;
  final bool consensoTrackingGps;
  final int countdown;
  final int countdownLevel;
  final ValueChanged<bool> onTrackingChanged;
  final String ultimaPosizione;

  const CardTrackingGps({
    super.key,
    required this.trackingAttivo,
    required this.consensoTrackingGps,
    required this.countdown,
    required this.countdownLevel,
    required this.onTrackingChanged,
    required this.ultimaPosizione,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 247, 250, 251),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueGrey, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.t.gps_err12,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Switch.adaptive(
                  value: trackingAttivo,
                  onChanged: consensoTrackingGps
                      ? onTrackingChanged
                      : null, // 👈 disabilita se manca consenso
                ),
                const SizedBox(width: 8),
                Text(
                  trackingAttivo ? context.t.gps_err14 : context.t.gps_err15,
                ),
              ],
            ),
            const SizedBox(height: 8),
            //Text('${context.t.gps_err16} $countdown s : $countdownLevel s'),
            
            Text('${context.t.gps_err16} $countdown s'),
            const SizedBox(height: 8),
            Text(
              '${context.t.rep_day_mes02}: $ultimaPosizione',
              style: TextStyle(fontSize: 13, color: Colors.blue),
            ),
            if (!consensoTrackingGps) ...[
              const SizedBox(height: 6),
              Text(
                context.t.gps_err13, // “Consenso mancante …”
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
