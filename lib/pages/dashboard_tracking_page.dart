import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dashboard_summary_page.dart';
import '../lingua.dart';
import '../models/home_message_status.dart';

class DashboardTrackingPage extends StatefulWidget {
  final bool trackingAttivo;
  final bool trackingInPausa;
  final int ascoltoSeconds;
  final int countdownLevel;
  final List<Map<String, dynamic>> livelli;
  final String utenteId;
  final String nomeId;
  final bool utenteTemporaneo;
  final String homeMessage;
  final HomeMessageStatus homeStatus;
  final int remainingDays;
  final bool provaScaduta;
  final VoidCallback onToggleDashboard;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSubscriptions;
  final ValueChanged<bool> onTrackingToggle;
  final VoidCallback onRefreshStats;
  final Map<int, List<dynamic>> datiLivelliSett;

  const DashboardTrackingPage({
    super.key,
    required this.trackingAttivo,
    required this.trackingInPausa,
    required this.ascoltoSeconds,
    required this.countdownLevel,
    required this.livelli,
    required this.utenteId,
    required this.nomeId,
    required this.utenteTemporaneo,
    required this.homeMessage,
    required this.homeStatus,
    required this.remainingDays,
    required this.provaScaduta,
    required this.onToggleDashboard,
    required this.onOpenProfile,
    required this.onOpenSubscriptions,
    required this.onTrackingToggle,
    required this.onRefreshStats,
    required this.datiLivelliSett,
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
  bool _provaScaduta = false;

  // Timer leggero per aggiornamento periodico (ogni 5 minuti)
  // Evita di appesantire il sistema con chiamate troppo frequenti
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    // Inizializza con mappa vuota, poi riempila
    stats = {};

    _provaScaduta = widget.provaScaduta;

    // Timer leggero: aggiorna i livelli ogni 5 minuti (300 secondi)
    // Non appesantisce il sistema e tiene i dati ragionevolmente aggiornati
    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        // Chiama il refresh per aggiornare i livelli da server
        if (mounted) {
          widget.onRefreshStats();
        }
      },
    );
  }

  @override
  void dispose() {
    // Cancella il timer quando il widget viene distrutto
    _autoRefreshTimer?.cancel();
    super.dispose();
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

    if (oldMinutes.toString() != newMinutes.toString()) {
      setState(_buildStats);
    }
  }

  //---------------------------------------------------------------------------
  // costrisce stringa messaggio home in base a stato e giorni rimanenti
  //---------------------------------------------------------------------------
  String _buildHomeMessage() {
    switch (widget.homeStatus) {
      case HomeMessageStatus.guestActive:
        if (widget.remainingDays == 1) {
          return context.t.dash_modalita_ospite;
        }
        return '${context.t.dash_modalita} ${widget.remainingDays} ${context.t.dash_giorni_rimasti}';

      case HomeMessageStatus.trialActive:
        if (widget.remainingDays == 1) {
          return context.t.dash_prova_completa;
        }
        return '${context.t.dash_prova} ${widget.remainingDays} ${context.t.dash_giorni_rimasti}';

      case HomeMessageStatus.guestExpired:
        return context.t.dash_prova_terminata;

      case HomeMessageStatus.trialExpired:
        return context.t.dash_prova_terminata2;

      case HomeMessageStatus.ready:
        return context.t.dash_move_pronto;
    }
  }

  //---------------------------------------------------------------------
  //  Funzioni di supporto per costruzione statistiche e visualizzazioni
  //---------------------------------------------------------------------
  int _levelMinutes(int idx) {
    if (idx < 0 || idx >= widget.livelli.length) return 0;
    final dynamic value = widget.livelli[idx]['minuti'];
    if (value is num) return value.toInt();
    return 0;
  }

  //------------------------------------------------------------------------
  // ritorna data
  //------------------------------------------------------------------------
  String _todayLabel() {
    final now = DateTime.now();
    final dd = now.day.toString().padLeft(2, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final yyyy = now.year.toString();
    return '$dd/$mm/$yyyy';
  }

  //--------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
  // Queste funzioni mappano lo stato del log GPS a elementi visivi nella UI
  // Permettono di mostrare in modo chiaro e immediato lo stato di ogni rilevamento GPS
  //--------------------------------------------------------------------
  void _buildStats() {
    final now = DateTime.now();
    final currentMinuteOfDay = now.hour * 60 + now.minute;

    final fermoMin = _levelMinutes(0);
    final lentoMin = _levelMinutes(1);
    final veloceMin = _levelMinutes(2);
    final trackedMin = fermoMin + lentoMin + veloceMin;

    final nonTracciatoMin = trackedMin >= currentMinuteOfDay
        ? 0
        : (currentMinuteOfDay - trackedMin);
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

  //--------------------------------------------------------------------------
  // Funzione di supporto per visualizzazione log GPS (icona, colore, titolo)
  //-------------------------------------------------------------------------
  String _displayUserLabel() {
    final name = widget.nomeId.trim();
    final fallback = name.isNotEmpty ? name : 'Guest';
    final id = widget.utenteId.trim();
    return id.isNotEmpty ? '$fallback ($id)' : fallback;
  }

  //--------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo
  //-------------------------------------------------------------------------
  String _formatElapsed(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  //--------------------------------------------------------------------
  // Funzione di supporto per formattazione tempo in minuti (es. 1h 20min)
  //--------------------------------------------------------------------
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

  //--------------------------------------------------------------------
  // Funzione di supporto per calcolo percentuale totale (per verifica e debug)
  //------------------------------------------------------------------------
  double _totalPercentage() {
    final total = stats.values
        .map((v) => (v['percentage'] as double?) ?? 0.0)
        .fold<double>(0.0, (sum, p) => sum + p);
    // Cappa il valore massimo a 100.0 per evitare errori di arrotondamento (100.01%)
    final capped = total.clamp(0.0, 100.0);
    return double.parse(capped.toStringAsFixed(2));
  }

  //--------------------------------------------------------------------------
  // Funzione di supporto per costruzione barra 24h e barra periodo tracciato
  // Queste funzioni creano rappresentazioni visive del tempo tracciato e non tracciato
  // La barra 24h mostra la distribuzione del tempo tracciato e non tracciato durante la giornata
  // La barra periodo tracciato mostra la distribuzione del tempo tracciato durante il periodo di tracking attivo
  //--------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _moveBg,
      body: Stack(
        children: [
          // SOLO SFONDO
          Positioned.fill(
            child: Image.asset(
              'assets/img/dash_start.png',
              fit: BoxFit.cover,
            ),
          ),

          // VELO LEGGERO SOPRA L'IMMAGINE
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.30),
            ),
          ),

          // CONTENUTO ORIGINALE
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.person,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.welcomeUser(_displayUserLabel()),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_buildHomeMessage().trim().isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _buildHomeMessage(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    height: 1.30,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Text(
                          context.t.dash_oggi,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _todayLabel(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
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
                  //_build24hBar(),
                  //const SizedBox(height: 20),
                  /////=>_buildTrackedPeriodBar(),
                  const SizedBox(height: 16),
                  /////=>_buildStartStopButton(),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.white.withOpacity(0.22),
                    height: 1,
                  ),
                  const SizedBox(height: 12),
                  /////=>..._buildStatsItems(context),
                  const SizedBox(height: 12),
                  //const SizedBox(height: 60),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 10,
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildOutlineButton(
                              context.t.dash_dettaglio,
                              context,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOutlineButton(
                              context.t.dash_accedi,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
  //-------------------------------------------------------------------------
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

  //--------------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
  //--------------------------------------------------------------------------
  Widget _buildStartStopButton() {
    final bool isActive = widget.trackingAttivo;
    final bool isBlocked = widget.provaScaduta;

    final bool guestExpired = isBlocked && widget.utenteTemporaneo;
    final bool trialExpired = isBlocked && !widget.utenteTemporaneo;

    final Color baseColor = isBlocked
        ? const Color(0xFFBDBDBD)
        : (isActive ? const Color(0xFFF4511E) : const Color(0xFFFF7A00));

    final String topMessage = isBlocked
        ? (guestExpired
            ? context.t.dash_prova_terminata
            : context.t.dash_prova_terminata2)
        : (isActive ? context.t.dash_spento : context.t.dash_registrazione);

    final String buttonLabel = isBlocked
        ? (guestExpired ? context.t.dash_accedi : context.t.dash_acquista_piano)
        : (isActive ? context.t.dash_fine : context.t.dash_inizia);

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            topMessage,
            key: ValueKey('${isActive}_$isBlocked'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withOpacity(0.28),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isBlocked
                        ? const [
                            Color(0xFFE0E0E0),
                            Color(0xFFCCCCCC),
                            Color(0xFFB5B5B5),
                          ]
                        : (isActive
                            ? const [
                                Color(0xFFFF8A65),
                                Color(0xFFF4511E),
                                Color(0xFFD84315),
                              ]
                            : const [
                                Color(0xFFFF7A00),
                                Color(0xFFFFA000),
                                Color(0xFFFFC107),
                              ]),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: isBlocked
                      ? null
                      : () {
                          widget.onTrackingToggle(!widget.trackingAttivo);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.white70,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
                      vertical: 22,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    buttonLabel,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            if (isActive && !isBlocked) ...[
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD7DCE2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 20, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      _formatElapsed(widget.ascoltoSeconds),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  //--------------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
  //-------------------------------------------------------------------------
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
      {'color': const Color(0xFFBFC5CC), 'fraction': fraction(nonTracciatoMin)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE0E3E7),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Row(
                    children: segments.map((seg) {
                      final flex = ((seg['fraction'] as double) * 1000).round();
                      return flex <= 0
                          ? const SizedBox.shrink()
                          : Expanded(
                              flex: flex,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: seg['color'] as Color,
                                ),
                              ),
                            );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0h',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.45),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${currentHour}h${now.minute > 0 ? ' ${now.minute}min' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //--------------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
  //-------------------------------------------------------------------------
  Widget _buildTrackedPeriodBar() {
    final now = DateTime.now();
    final fermoMin = _levelMinutes(0);
    final lentoMin = _levelMinutes(1);
    final veloceMin = _levelMinutes(2);
    final totalTrackedMin = fermoMin + lentoMin + veloceMin;

    if (totalTrackedMin == 0) {
      return const SizedBox.shrink();
    }

    double fraction(int minutes) {
      if (totalTrackedMin <= 0) return 0.0;
      return minutes / totalTrackedMin;
    }

    final segments = [
      {'color': const Color(0xFF4CAF50), 'fraction': fraction(fermoMin)},
      {'color': const Color(0xFFFFC107), 'fraction': fraction(lentoMin)},
      {'color': const Color(0xFFFF4444), 'fraction': fraction(veloceMin)},
    ];

    final startTime = now.subtract(Duration(minutes: totalTrackedMin));
    final startHour = startTime.hour;
    final startMinute = startTime.minute;
    final endHour = now.hour;
    final endMinute = now.minute;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE0E3E7),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Row(
                    children: segments.map((seg) {
                      final flex = ((seg['fraction'] as double) * 1000).round();
                      return flex <= 0
                          ? const SizedBox.shrink()
                          : Expanded(
                              flex: flex,
                              child: Container(
                                color: seg['color'] as Color,
                              ),
                            );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.45),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //--------------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
  //-------------------------------------------------------------------------
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

  //--------------------------------------------------------------------------
  // Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
  //-------------------------------------------------------------------------
  Widget _buildOutlineButton(String label, BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        if (label == context.t.dash_dettaglio) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardSummaryPage(
                livelli: widget.livelli,
                datiLivelliSett: widget
                    .datiLivelliSett, // Passa i dati settimanali se disponibili
                homeMessage: _buildHomeMessage(),
                provaScaduta: widget.provaScaduta,
                utenteTemporaneo: widget.utenteTemporaneo,
                onToggleDashboard: widget.onToggleDashboard,
                onOpenSubscriptions: widget.onOpenSubscriptions,
              ),
            ),
          );
          return;
        }
        if (label == context.t.dash_accedi) {
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

//--------------------------------------------------------------------------
// Funzioni di supporto per visualizzazione log GPS (icona, colore, titolo)
//-------------------------------------------------------------------------
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
