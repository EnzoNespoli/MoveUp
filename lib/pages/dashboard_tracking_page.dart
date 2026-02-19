import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class DashboardTrackingPage extends StatefulWidget {
  final bool trackingAttivo;
  final bool trackingInPausa;
  final int countdownLevel;
  final List<Map<String, dynamic>> livelli;
  final String utenteId;
  final VoidCallback onToggleDashboard;

  const DashboardTrackingPage({
    super.key,
    required this.trackingAttivo,
    required this.trackingInPausa,
    required this.countdownLevel,
    required this.livelli,
    required this.utenteId,
    required this.onToggleDashboard,
  });

  @override
  State<DashboardTrackingPage> createState() => _DashboardTrackingPageState();
}

class _DashboardTrackingPageState extends State<DashboardTrackingPage> {
  // Usa i dati dal widget, non variabili locali

  // Statistiche - verranno costruite dai dati di HomePage
  late Map<String, dynamic> stats;

  @override
  void initState() {
    super.initState();
    // Costruisci le statistiche dai dati reali
    _buildStats();
  }

  void _buildStats() {
    // Qui potrai usare i dati reali da widget.livelli
    // Per ora, manteniamo i valori demo
    stats = {
      'notTracked': {
        'percentage': 35,
        'label': 'NON TRACCIATO',
        'color': const Color(0xFF4A4A4A)
      },
      'slow': {
        'percentage': 40,
        'label': 'FERMO',
        'color': const Color(0xFF4CAF50)
      },
      'medium': {
        'percentage': 20,
        'label': 'LENTO',
        'color': const Color(0xFFFFC107)
      },
      'fast': {
        'percentage': 5,
        'label': 'VELOCE',
        'color': const Color(0xFFFF4444)
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A2332), // Sfondo scuro come nella foto
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2332),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('MOVEUP'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== SEZIONE STATO TRACCIAMENTO =====
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusTab(
                          'REGISTRA',
                          widget.trackingAttivo,
                          () => widget.trackingAttivo ? null : () {},
                        ),
                        _buildStatusTab(
                          'SPENTO',
                          !widget.trackingAttivo,
                          () => !widget.trackingAttivo ? null : () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ===== SEZIONE START/STOP =====
              _buildStartStopButton(),

              const SizedBox(height: 48),

              // ===== SEZIONE STATISTICHE OGGI =====
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'OGGI',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

              // Statistiche con cerchi colorati
              ..._buildStatsItems(context),

              // Totale
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Totale 100%',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

              const SizedBox(height: 24),

              // ===== SEZIONE PULSANTI INFERIORI =====
              Row(
                children: [
                  Expanded(
                    child: _buildOutlineButton('DETTAGLI', context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOutlineButton('ACCEDI', context),
                  ),
                ],
              ),

              const SizedBox(height: 24),
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
              color: isActive ? Colors.white : Colors.grey,
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
                  color: Colors.white,
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              // TODO: collegare al servizio di tracking GPS della HomePage
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
        ),
      ],
    );
  }

  List<Widget> _buildStatsItems(BuildContext context) {
    return stats.entries.map((entry) {
      final data = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
            // Label e percentuale
            Expanded(
              child: Text(
                '${data['label']} ${data['percentage']}%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
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
        if (label == 'DETTAGLI') {
          // Chiama il callback per togglare la visualizzazione
          widget.onToggleDashboard();
        }
        // ACCEDI non fa nulla per ora
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(
          color: Colors.white24,
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
