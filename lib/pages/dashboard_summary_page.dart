import 'dart:async';
import 'package:flutter/material.dart';
import '../services/app_header.dart';
import '../services/app_footer.dart';
import '../lingua.dart';

class DashboardSummaryPage extends StatefulWidget {
  final List<Map<String, dynamic>> livelli;
  final Map<int, List<dynamic>> datiLivelliSett;
  final String homeMessage;
  final bool provaScaduta;
  final bool utenteTemporaneo;
  final VoidCallback onToggleDashboard;
  final VoidCallback onOpenSubscriptions;

  const DashboardSummaryPage({
    super.key,
    required this.livelli,
    required this.datiLivelliSett,
    required this.homeMessage,
    required this.provaScaduta,
    required this.utenteTemporaneo,
    required this.onToggleDashboard,
    required this.onOpenSubscriptions,
  });

  @override
  State<DashboardSummaryPage> createState() => _DashboardSummaryPageState();
}

class _DashboardSummaryPageState extends State<DashboardSummaryPage> {
  static const Color _moveBg = Color(0xFFF1F3F5);

  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DashboardSummaryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  //-----------------------------------------------------------------
  // Helpers per dati e formattazione
  //-----------------------------------------------------------------
  int _levelMinutes(int idx) {
    if (idx < 0 || idx >= widget.livelli.length) return 0;
    final dynamic value = widget.livelli[idx]['minuti'];
    if (value is num) return value.toInt();
    return 0;
  }

  //-----------------------------------------------------------------
  // Restituisce i km per il livello specificato, o 0.0 se non disponibile
  //-----------------------------------------------------------------
  double _levelKm(int idx) {
    if (idx < 0 || idx >= widget.livelli.length) return 0.0;
    final dynamic value = widget.livelli[idx]['km'];
    if (value is num) return value.toDouble();
    return 0.0;
  }

  //---------------------------------------------------------------------
  // Formatta un numero di minuti in una stringa leggibile (es. "1h 20min")
  //---------------------------------------------------------------------
  String _fmtMinutes(int minutes) {
    if (minutes <= 0) return '0 min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) return '${h}h ${m}min';
    return '${m} min';
  }

  //---------------------------------------------------------------------
  // Calcola la somma dei secondi per un dato livello negli ultimi 7 giorni
  //---------------------------------------------------------------------
  int _sumWeekSeconds(int livello) {
    final list = widget.datiLivelliSett[livello] as List? ?? [];
    int total = 0;

    for (final item in list) {
      final sec = item['durata_sec'];
      if (sec is num) total += sec.toInt();
    }

    return total;
  }

  //---------------------------------------------------------------------
  // Calcola la somma dei metri per un dato livello negli ultimi 7 giorni
  //---------------------------------------------------------------------
  double _sumWeekMeters(int livello) {
    final list = widget.datiLivelliSett[livello] as List? ?? [];
    double total = 0;

    for (final item in list) {
      final metri = item['distanza_metri'];
      if (metri is num) total += metri.toDouble();
    }

    return total;
  }

  //---------------------------------------------------------------------
  // Formatta un numero di secondi in una stringa leggibile (es. "
  // 1h 20min")
  //---------------------------------------------------------------------
  String _fmtSeconds(int seconds) {
    if (seconds <= 0) return '0 min';
    final minutes = (seconds / 60).round();
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) return '${h}h ${m}min';
    return '${m} min';
  }

  //-------------------------------------------------------------------------
  // Costruisce la card per il log GPS
  //-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final bool provaScaduta = widget.provaScaduta;
    debugPrint('DashboardSummaryPage build - provaScaduta: $provaScaduta');

    final String primaryLabel = widget.utenteTemporaneo
        ? context.t.dash_accedi
        : (provaScaduta ? context.t.dash_acquista_piano : context.t.dash_home);

    final fermoMin = _levelMinutes(0);
    final lentoMin = _levelMinutes(1);
    final veloceMin = _levelMinutes(2);

    final movimentoMin = lentoMin + veloceMin;
    final kmTotali = _levelKm(2);

    final weekFermoSec = _sumWeekSeconds(0);
    final weekLentoSec = _sumWeekSeconds(1);
    final weekVeloceSec = _sumWeekSeconds(2);

    final weekLentoM = _sumWeekMeters(1);
    final weekVeloceM = _sumWeekMeters(2);

    return Scaffold(
      backgroundColor: _moveBg,
      appBar: const AppHeader(showBack: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionCard(
                    title: context.t.dash_oggi,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildMiniStat(
                            icon: Icons.schedule,
                            label: context.t.dash_tempo_movimento,
                            value: _fmtMinutes(movimentoMin),
                          ),
                        ),
                        Expanded(
                          child: _buildMiniStat(
                            icon: Icons.straighten,
                            label: 'Km',
                            value: '${kmTotali.toStringAsFixed(1)} km',
                          ),
                        ),
                        Expanded(
                          child: _buildMiniStat(
                            icon: Icons.event_seat,
                            label: context.t.dash_fermo,
                            value: _fmtMinutes(fermoMin),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildSectionCard(
                    title: context.t.dash_riepilogo,
                    child: Column(
                      children: [
                        _buildSummaryLine(
                          icon: '🛏️',
                          label: context.t.dash_fermo,
                          time: _fmtSeconds(weekFermoSec),
                          extra: '',
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryLine(
                          icon: '🚶',
                          label: context.t.dash_movimento_lento,
                          time: _fmtSeconds(weekLentoSec),
                          extra: '${weekLentoM.toStringAsFixed(0)} m',
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryLine(
                          icon: '🚗',
                          label: context.t.dash_spostamento_veloce,
                          time: _fmtSeconds(weekVeloceSec),
                          extra:
                              '${(weekVeloceM / 1000).toStringAsFixed(1)} km',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                if (!widget.utenteTemporaneo) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (provaScaduta) {
                          // TODO: qui in futuro apriremo la pagina acquisto piano
                          widget.onOpenSubscriptions();
                        } else {
                          widget.onToggleDashboard();
                          Navigator.of(context).pop();
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
                        provaScaduta
                            ? context.t.dash_acquista_piano
                            : context.t.dash_home,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                      context.t.dash_indietro,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppFooter(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Helpers per costruire i widget
  //-------------------------------------------------------------------------
  Widget _buildSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFB8C2CC),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Helpers per costruire i widget
  //-------------------------------------------------------------------------
  Widget _buildMiniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF476391)),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  //-------------------------------------------------------------------------
  // Helper per costruire la riga di riepilogo nei 7 giorni
  //-------------------------------------------------------------------------
  Widget _buildSummaryLine({
    required String icon,
    required String label,
    required String time,
    required String extra,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (extra.isNotEmpty) ...[
          const SizedBox(width: 14),
          Text(
            extra,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
