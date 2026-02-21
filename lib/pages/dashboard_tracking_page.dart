import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../lingua.dart';

class DashboardTrackingPage extends StatefulWidget {
  final bool trackingAttivo;
  final bool trackingInPausa;
  final int ascoltoSeconds;
  final int countdownLevel;
  final List<Map<String, dynamic>> livelli;
  final String utenteId;
  final String nomeId;
  final VoidCallback onToggleDashboard;
  final VoidCallback onOpenProfile;
  final ValueChanged<bool> onTrackingToggle;
  final VoidCallback onRefreshStats;

  const DashboardTrackingPage({
    super.key,
    required this.trackingAttivo,
    required this.trackingInPausa,
    required this.ascoltoSeconds,
    required this.countdownLevel,
    required this.livelli,
    required this.utenteId,
    required this.nomeId,
    required this.onToggleDashboard,
    required this.onOpenProfile,
    required this.onTrackingToggle,
    required this.onRefreshStats,
  });

  @override
  State<DashboardTrackingPage> createState() => _DashboardTrackingPageState();
}

class _DashboardTrackingPageState extends State<DashboardTrackingPage> {
  // Usa i dati dal widget, non variabili locali
  static const Color _moveBg = Color(0xFFF1F3F5);

  // Statistiche - verranno costruite dai dati di HomePage
  late Map<String, dynamic> stats;
  bool _statsInitialized = false;

  @override
  void initState() {
    super.initState();
    // Inizializza con mappa vuota, poi riempila
    stats = {};
    if (kDebugMode) {
      print(
          '[DEBUG DashboardTrackingPage.initState] Widget creato con livelli=${widget.livelli}');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_statsInitialized) {
      _buildStats();
      _statsInitialized = true;
    } else {
      setState(_buildStats);
    }
  }

  @override
  void didUpdateWidget(covariant DashboardTrackingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Controlla se i dati sono cambiati (confronto contenuto, non reference)
    final oldMinutes = oldWidget.livelli.map((e) => e['minuti']).toList();
    final newMinutes = widget.livelli.map((e) => e['minuti']).toList();

    if (kDebugMode) {
      print(
          '[DEBUG didUpdateWidget] oldMinutes=$oldMinutes, newMinutes=$newMinutes');
    }

    if (oldMinutes.toString() != newMinutes.toString()) {
      if (kDebugMode) {
        print('[DEBUG didUpdateWidget] Dati cambiati, aggiorno stats');
      }
      setState(_buildStats);
    }
  }

  int _levelMinutes(int idx) {
    if (idx < 0 || idx >= widget.livelli.length) return 0;
    final dynamic value = widget.livelli[idx]['minuti'];
    if (value is num) return value.toInt();
    return 0;
  }

  void _buildStats() {
    final fermoMin = _levelMinutes(0);
    final lentoMin = _levelMinutes(1);
    final veloceMin = _levelMinutes(2);
    final trackedMin = fermoMin + lentoMin + veloceMin;

    // Debug: verifica i dati ricevuti
    if (kDebugMode) {
      print(
          '[DEBUG DashboardTrackingPage] livelli=${widget.livelli}, fermoMin=$fermoMin, lentoMin=$lentoMin, veloceMin=$veloceMin');
    }

    final nonTracciatoMin = trackedMin >= 1440 ? 0 : (1440 - trackedMin);
    final totaleMin = trackedMin + nonTracciatoMin;

    double pct(int minuti) {
      if (totaleMin <= 0) return 0.0;
      final result = (minuti * 100.0) / totaleMin;
      return double.parse(result.toStringAsFixed(2));
    }

    stats = {
      'slow': {
        'minutes': fermoMin,
        'percentage': pct(fermoMin),
        'label': context.t.dash_fermo,
        'color': const Color(0xFF4CAF50)
      },
      'medium': {
        'minutes': lentoMin,
        'percentage': pct(lentoMin),
        'label': context.t.dash_lento,
        'color': const Color(0xFFFFC107)
      },
      'fast': {
        'minutes': veloceMin,
        'percentage': pct(veloceMin),
        'label': context.t.dash_veloce,
        'color': const Color(0xFFFF4444)
      },
      'notTracked': {
        'minutes': nonTracciatoMin,
        'percentage': pct(nonTracciatoMin),
        'label': context.t.dash_non_tracciato,
        'color': const Color(0xFF4A4A4A)
      },
    };
  }

  String _displayUserLabel() {
    final name = widget.nomeId.trim();
    final fallback = name.isNotEmpty ? name : 'Guest';
    final id = widget.utenteId.trim();
    return id.isNotEmpty ? '$fallback ($id)' : fallback;
  }

  String _formatElapsed(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

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

  double _totalPercentage() {
    final total = stats.values
        .map((v) => (v['percentage'] as double?) ?? 0.0)
        .fold<double>(0.0, (sum, p) => sum + p);
    return double.parse(total.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _moveBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.black54, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${context.t.welcomeUser(_displayUserLabel())}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== SEZIONE STATO TRACCIAMENTO =====
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusTab(
                          context.t.dash_registrazione,
                          widget.trackingAttivo,
                          () => widget.trackingAttivo ? null : () {},
                        ),
                        _buildStatusTab(
                          context.t.dash_spento,
                          !widget.trackingAttivo,
                          () => !widget.trackingAttivo ? null : () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ===== SEZIONE START/STOP =====
              _buildStartStopButton(),

              const SizedBox(height: 18),
              Divider(
                color: Colors.white.withValues(alpha: 0.22),
                height: 1,
              ),

              const SizedBox(height: 28),

              // ===== SEZIONE STATISTICHE OGGI =====
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Text(
                      context.t.dash_oggi,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: widget.onRefreshStats,
                      icon: const Icon(Icons.refresh, size: 20),
                      color: Colors.black54,
                      tooltip: context.t.dash_aggiorna,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Barra 24 ore visiva
              _build24hBar(),
              const SizedBox(height: 16),

              // Statistiche con cerchi colorati
              ..._buildStatsItems(context),

              // Totale
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Totale ${_totalPercentage().toStringAsFixed(2)}%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: _moveBg,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
          child: Row(
            children: [
              Expanded(
                child: _buildOutlineButton(context.t.dash_dettaglio, context),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOutlineButton(context.t.dash_profilo, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTab(String label, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black87 : Colors.black45,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                height: 3,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
          else
            const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildStartStopButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            widget.onTrackingToggle(!widget.trackingAttivo);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.trackingAttivo
                ? const Color(0xFFFF4444) // Rosso per STOP
                : const Color(0xFF4CAF50), // Verde per START
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 64,
              vertical: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          child: Text(
            widget.trackingAttivo ? 'STOP' : 'START',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        if (widget.trackingAttivo) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD2D9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  _formatElapsed(widget.ascoltoSeconds),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _build24hBar() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinuteOfDay = currentHour * 60 + now.minute;

    final fermoMin = _levelMinutes(0);
    final lentoMin = _levelMinutes(1);
    final veloceMin = _levelMinutes(2);
    final trackedMin = fermoMin + lentoMin + veloceMin;
    final nonTracciatoMin =
        currentMinuteOfDay > trackedMin ? (currentMinuteOfDay - trackedMin) : 0;

    final totalSoFar = fermoMin + lentoMin + veloceMin + nonTracciatoMin;

    double fraction(int minutes) {
      if (totalSoFar <= 0) return 0.0;
      return minutes / totalSoFar;
    }

    final segments = [
      {'color': const Color(0xFF4CAF50), 'fraction': fraction(fermoMin)},
      {'color': const Color(0xFFFFC107), 'fraction': fraction(lentoMin)},
      {'color': const Color(0xFFFF4444), 'fraction': fraction(veloceMin)},
      {'color': const Color(0xFF4A4A4A), 'fraction': fraction(nonTracciatoMin)},
    ];

    // Frazione barra riempita rispetto alle 24h
    final fillRatio = currentMinuteOfDay / 1440.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra container più grande con bordo
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD0D0D0), width: 1),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final filledWidth = constraints.maxWidth * fillRatio;
              final futureWidth = constraints.maxWidth - filledWidth;

              return Stack(
                children: [
                  // Parte riempita fino all'ora corrente (colorata)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: SizedBox(
                      width: filledWidth,
                      height: 20,
                      child: Row(
                        children: segments.map((seg) {
                          final w = filledWidth * (seg['fraction'] as double);
                          return Container(
                            width: w,
                            color: seg['color'] as Color,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Parte futura (da ora corrente a 24h) - bianco con strisce
                  if (futureWidth > 2)
                    Positioned(
                      left: filledWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(9),
                          bottomRight: Radius.circular(9),
                        ),
                        child: Container(
                          width: futureWidth,
                          height: 20,
                          color: Colors.white,
                          child: CustomPaint(
                            painter: _DiagonalStripesPainter(),
                          ),
                        ),
                      ),
                    ),
                  // Linea verticale indicatore ora corrente
                  if (fillRatio > 0.02 && fillRatio < 0.98)
                    Positioned(
                      left: filledWidth - 1,
                      child: Container(
                        width: 2,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        // Label ore
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0h',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currentHour}h',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '24h',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildStatsItems(BuildContext context) {
    if (stats.isEmpty) {
      return []; // Ritorna lista vuota se stats non è ancora caricata
    }
    return stats.entries.map((entry) {
      final data = entry.value;
      final minutes = data['minutes'] as int;
      final timeStr = _fmtMinutes(minutes);
      final pctStr = (data['percentage'] as double).toStringAsFixed(2);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            // Cerchio colorato
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: data['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            // Label, tempo e percentuale
            Expanded(
              child: Text(
                '${data['label']} $timeStr ($pctStr%)',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildOutlineButton(String label, BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (label == context.t.dash_dettaglio) {
          // Chiama il callback per togglare la visualizzazione
          widget.onToggleDashboard();
          return;
        }
        if (label == context.t.dash_profilo) {
          widget.onOpenProfile();
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: const BorderSide(
          color: Color(0xFF9AA0AA),
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// CustomPainter per strisce diagonali nella parte futura della barra
class _DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB0B0B0).withOpacity(0.7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const spacing = 5.0;

    // Strisce diagonali da in alto a sinistra verso in basso a destra
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
