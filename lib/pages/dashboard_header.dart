import 'package:flutter/material.dart';
import '../lingua.dart';
import '../class/daily_analysis.dart'; // importa il modello

class DashboardHeader extends StatelessWidget {
  final bool consensoTrackingGps;
  final String nomeId;
  final String utenteId;
  final String livelloUtente;
  final int giorniRimanenti;
  final String Function(int?, String) labelGiorni;
  final Color Function(int?, String) coloreGiorni;
  final Widget chipGiorni;
  final Function(BuildContext) mostraLoginDialog;
  final DailyAnalysis? dailyAnalysis;
  final List<Map<String, dynamic>> livelli;

  const DashboardHeader({
    Key? key,
    required this.consensoTrackingGps,
    required this.nomeId,
    required this.utenteId,
    required this.livelloUtente,
    required this.giorniRimanenti,
    required this.labelGiorni,
    required this.coloreGiorni,
    required this.chipGiorni,
    required this.mostraLoginDialog,
    this.dailyAnalysis,
    required this.livelli,
  }) : super(key: key);

  String _fmtMinutes(int minutes) {
    if (minutes <= 0) return '--';

    final h = minutes ~/ 60;
    final m = minutes % 60;

    if (h > 0) {
      return '${h}h ${m}min';
    } else {
      return '${m}min';
    }
  }

  int _levelMinutes(int idx) {
    if (idx < 0 || idx >= livelli.length) return 0;
    final dynamic value = livelli[idx]['minuti'];
    if (value is num) return value.toInt();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // riga Dashboard + stato GPS
        LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 360;

            final gpsChip = FittedBox(
              // si rimpicciolisce se serve
              fit: BoxFit.scaleDown,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      consensoTrackingGps ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: consensoTrackingGps ? Colors.green : Colors.red,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle,
                        size: 12,
                        color:
                            consensoTrackingGps ? Colors.green : Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      consensoTrackingGps
                          ? context.t.gps_err17
                          : context.t.gps_err18,
                      style: TextStyle(
                        color: consensoTrackingGps
                            ? Colors.green[800]
                            : Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (narrow) {
              // CHIP A CAPO
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dashboard, size: 22, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.t.bottom_dashboard,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  gpsChip,
                ],
              );
            }

            // TUTTO IN RIGA
            return Row(
              children: [
                Icon(Icons.dashboard, size: 22, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.t.bottom_dashboard,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                gpsChip,
              ],
            );
          },
        ),

        const SizedBox(height: 12),

        // riga slogan
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.directions_walk, size: 22, color: Colors.blue[500]),
            const SizedBox(width: 2),
            Icon(Icons.trending_up, size: 18, color: Colors.blue[300]),
            const SizedBox(width: 8),

            // Testo a due righe
            // Testo a due righe
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // riga 1: resta su 1 riga con ellissi
                  Text(
                    context.t.info_mes07, // "Capisci come ti muovi"
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.orange[700],
                          height: 1.1,
                        ),
                  ),

                  const SizedBox(height: 2),

                  // riga 2: può andare a capo (2 righe max)
                  if (context.t.info_mes08.isNotEmpty)
                    Text(
                      context
                          .t.info_mes08, // "Scopri come impieghi il tuo tempo"
                      softWrap: true,
                      maxLines: 2, // ⬅️ qui la differenza
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.black54,
                                height: 1.15,
                              ),
                    ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // riga utente
        Row(
          children: [
            Icon(Icons.person, color: Colors.blue[700], size: 22),
            const SizedBox(width: 8),
            Expanded(
              // ⬅️ qui
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                  children: [
                    TextSpan(
                      text: '${context.t.form_crono_03} ', // "Benvenuto,"
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextSpan(
                        text:
                            nomeId.isNotEmpty ? nomeId : context.t.user_err02),
                    TextSpan(
                        text: ' ($utenteId) ',
                        style: const TextStyle(fontSize: 12)),
                    TextSpan(
                        text: '!', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (livelloUtente == 'Free')
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 30),
            child: InkWell(
              onTap: () {
                mostraLoginDialog(context);
              },
              borderRadius: BorderRadius.circular(6),
              child: Text(
                context.t
                    .dashboard_msg, // "Vai su Profilo e registrati. Avrai la tua settimana tipo"
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        const SizedBox(height: 8),

        // riga piano
        Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber[700]),
            const SizedBox(width: 8),
            Text(
              '${context.t.dashboard_piano} $livelloUtente',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            chipGiorni,
          ],
        ),

        // 👇 STATISTICHE GIORNALIERE DAI LIVELLI
        const SizedBox(height: 14),
        Builder(
          builder: (context) {
            final fermoMin = _levelMinutes(0);
            final lentoMin = _levelMinutes(1);
            final veloceMin = _levelMinutes(2);
            final movimentoMin = lentoMin + veloceMin;

            // Calcola tempo NON TRACCIATO (non il gap GPS!)
            final trackedMin = fermoMin + lentoMin + veloceMin;
            final nonTracciatoMin =
                trackedMin >= 1440 ? 0 : (1440 - trackedMin);

            // Calcola percentuale di completezza
            final percCompletezza = trackedMin > 0
                ? ((trackedMin / 1440) * 100).clamp(0, 100)
                : 0.0;
            final percNonTracciato = 100 - percCompletezza;

            final isIncomplete = percNonTracciato > 25;

            final oggi = DateTime.now();
            final giornoStr =
                "${oggi.year.toString().padLeft(4, '0')}-${oggi.month.toString().padLeft(2, '0')}-${oggi.day.toString().padLeft(2, '0')}";

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isIncomplete ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isIncomplete
                      ? Colors.red.shade200
                      : Colors.green.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t.analisi_oggi + " ($giornoStr)",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isIncomplete
                        ? '${context.t.dati_incompleti} ${percNonTracciato.toStringAsFixed(0)}%.'
                        : context.t.completo,
                    style: const TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          icon: "🛑",
                          label: context.t.mov_inattivo,
                          value: _fmtMinutes(fermoMin),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _MiniStat(
                          icon: "🚶",
                          label: context.t.movimento,
                          value: _fmtMinutes(movimentoMin),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _MiniStat(
                          icon: "📵",
                          label: context.t.non_reg,
                          value: _fmtMinutes(nonTracciatoMin),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.black54)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
