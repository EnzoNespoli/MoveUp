import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // per formattare la data
import 'package:fl_chart/fl_chart.dart';
import 'mappa_percorsi.dart';
import '../lingua.dart';

// ====== WRAPPER ======
class CardPercorsoGiorno extends StatefulWidget {
  const CardPercorsoGiorno({
    super.key,
    required this.fetchTraccia, // <- funzione che chiama la tua API
    this.initialDate,
    this.height = 300,
    this.levelsToShow = const {'L1', 'L2'},
    this.minSegmentMeters = 1,
    this.title,
    this.framed = true, // <--- NUOVO
    this.showHeader = true, // <--- NUOVO
  });

  /// Deve ritornare una mappa con almeno: {'segments': List, 'bbox': List?}
  final Future<Map<String, dynamic>> Function(DateTime date) fetchTraccia;

  final DateTime? initialDate;
  final double height;
  final Set<String> levelsToShow;
  final double minSegmentMeters;
  final String? title;
  final bool framed; // <--- NUOVO
  final bool showHeader; // <--- NUOVO

  @override
  State<CardPercorsoGiorno> createState() => _CardPercorsoGiornoState();
}

class _CardPercorsoGiornoState extends State<CardPercorsoGiorno> {
  late DateTime _date;
  bool _loading = false;
  String? _error;
  List<dynamic> _segments = const [];
  List<dynamic>? _bbox;

  final double grandezzaMappa = 320; // altezza fissa della mappa

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate ?? DateTime.now();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.fetchTraccia(_date);
      _segments = (data['segments'] as List?) ?? const [];
      _bbox = data['bbox'] as List?;
      if (_segments.isNotEmpty) {
        // guarda i primi due segmenti in console
        // per scegliere i campi giusti (secs / t0-t1 / points.ts)
        // ignore: avoid_print
        print(_segments.take(2).toList());
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  void _changeDay(int delta) {
    setState(() {
      _date = _date.add(Duration(days: delta));
    });
    _load();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      helpText: context.t.card_percorso_1,
      cancelText: context.t.card_percorso_2,
      confirmText: context.t.card_percorso_3,
    );
    if (!context.mounted) return;
    if (picked != null) {
      setState(() {
        _date = picked;
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMEd().format(_date);
    final title = widget.title ?? '${context.t.card_percorso_4} $dateLabel';
    final safeBbox = _fixBbox(_bbox) ?? _bboxFromSegments(_segments);

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader)
            Row(
              children: [
                const Icon(Icons.map, color: Colors.blue),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _loading ? null : () => _changeDay(-1)),
                IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _loading ? null : _pickDate),
                IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _loading ? null : () => _changeDay(1)),
              ],
            ),
          const SizedBox(height: 8),
          if (_loading)
            SizedBox(
                height: widget.height,
                child: const Center(child: CircularProgressIndicator()))
          else if (_error != null)
            SizedBox(
                height: widget.height,
                child: Center(
                    child: Text('Errore: $_error',
                        style: TextStyle(color: Colors.red))))
          else
            MappaPercorsi(
              segments: _segments,
              bbox: safeBbox,
              height: widget.height,
              levelsToShow: widget.levelsToShow,
              minSegmentMeters: widget.minSegmentMeters,
            ),

          const SizedBox(height: 12),

          // === Pie livelli (OFF/L0/L1/L2) ===
          Builder(builder: (_) {
            
            final data  = _secondsByLevel(_segments, _date); // <-- passa _date
            final total = data.values.fold<double>(0, (a, b) => a + b);

            final sections = total <= 0
                ? <PieChartSectionData>[
                    PieChartSectionData(
                      value: 1,
                      title: 'No data',
                      radius: 38,
                      titleStyle:
                          const TextStyle(fontSize: 12, color: Colors.white),
                      color: Colors.grey.shade400,
                    ),
                  ]
                : <PieChartSectionData>[
                    PieChartSectionData(
                        value: data['OFF'] ?? 0.0,
                        title: 'OFF',
                        color: Colors.grey.shade500,
                        radius: 44),
                    PieChartSectionData(
                        value: data['L0'] ?? 0.0,
                        title: 'L0',
                        color: Colors.blue.shade200,
                        radius: 44),
                    PieChartSectionData(
                        value: data['L1'] ?? 0.0,
                        title: 'L1',
                        color: Colors.blue.shade600,
                        radius: 44),
                    PieChartSectionData(
                        value: data['L2'] ?? 0.0,
                        title: 'L2',
                        color: Colors.indigo.shade800,
                        radius: 44),
                  ];

            return Row(
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: PieChart(PieChartData(
                      centerSpaceRadius: 22,
                      sectionsSpace: 2,
                      sections: sections)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _legendItem(
                          Colors.grey.shade500, 'OFF', data['OFF'] ?? 0, total),
                      _legendItem(
                          Colors.blue.shade200, 'L0', data['L0'] ?? 0, total),
                      _legendItem(
                          Colors.blue.shade600, 'L1', data['L1'] ?? 0, total),
                      _legendItem(
                          Colors.indigo.shade800, 'L2', data['L2'] ?? 0, total),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );

    // Se framed=true, avvolgi in una Card; altrimenti restituisci solo il contenuto
    return widget.framed
        ? Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.blueGrey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blueGrey.shade300, width: 2),
            ),
            child: content,
          )
        : content;
  }

// Sanifica un bbox generico [swLat, swLng, neLat, neLng]
// - mette i min/max al posto giusto
// - allarga di un epsilon se degenero
  List<double>? _fixBbox(List<dynamic>? raw) {
    if (raw == null || raw.length < 4) return null;

    double? swLat = (raw[0] as num?)?.toDouble();
    double? swLng = (raw[1] as num?)?.toDouble();
    double? neLat = (raw[2] as num?)?.toDouble();
    double? neLng = (raw[3] as num?)?.toDouble();
    if (swLat == null || swLng == null || neLat == null || neLng == null) {
      return null;
    }

    double south = swLat;
    double north = neLat;
    double west = swLng;
    double east = neLng;

    // Riordina se arrivano invertiti
    if (south > north) {
      final tmp = south;
      south = north;
      north = tmp;
    }
    if (west > east) {
      final tmp = west;
      west = east;
      east = tmp;
    }

    // Evita bounds degeneri
    const double eps = 0.0005; // ~50 m
    if (south == north) {
      south -= eps;
      north += eps;
    }
    if (west == east) {
      west -= eps;
      east += eps;
    }

    return <double>[south, west, north, east];
  }

// (opzionale) Se non hai bbox, prova a dedurlo dai segmenti
  List<double>? _bboxFromSegments(List<dynamic> segments) {
    // Atteso: ogni punto come {lat: ..., lng: ...} oppure [lat,lng]
    double? south, north, west, east;

    void addPoint(double lat, double lng) {
      south = (south == null) ? lat : (lat < south! ? lat : south);
      north = (north == null) ? lat : (lat > north! ? lat : north);
      west = (west == null) ? lng : (lng < west! ? lng : west);
      east = (east == null) ? lng : (lng > east! ? lng : east);
    }

    for (final seg in segments) {
      final pts = (seg is Map) ? (seg['points'] ?? seg['coords']) : null;
      if (pts is List) {
        for (final p in pts) {
          if (p is Map && p['lat'] != null && p['lng'] != null) {
            addPoint(
                (p['lat'] as num).toDouble(), (p['lng'] as num).toDouble());
          } else if (p is List && p.length >= 2) {
            final lat = (p[0] as num?)?.toDouble();
            final lng = (p[1] as num?)?.toDouble();
            if (lat != null && lng != null) addPoint(lat, lng);
          }
        }
      }
    }

    if (south == null || north == null || west == null || east == null)
      return null;

    // stessa protezione anti-degenere
    const eps = 0.0005;
    if (south == north) {
      south = south! - eps;
      north = north! + eps;
    }
    if (west == east) {
      west = west! - eps;
      east = east! + eps;
    }

    return <double>[south!, west!, north!, east!];
  }

  // ── sostituisci questa ────────────────────────────────────────────────────────
Map<String, double> _secondsByLevel(List<dynamic> segments, DateTime day) {
  final out = <String, double>{'OFF': 0, 'L0': 0, 'L1': 0, 'L2': 0};

  String _toLabel(dynamic level, dynamic fonte) {
    // Se arriva explicit “Gap/Off”, forziamo OFF
    if (fonte is String && fonte.toLowerCase().contains('off')) return 'OFF';
    if (level is int) {
      switch (level) {
        case -1: return 'OFF';
        case 0:  return 'L0';
        case 1:  return 'L1';
        case 2:  return 'L2';
      }
    }
    if (level is String) {
      final l = level.toUpperCase();
      if (l == 'OFF' || l == 'L0' || l == 'L1' || l == 'L2') return l;
      final n = int.tryParse(level);
      if (n != null) return _toLabel(n, fonte);
    }
    return 'OFF';
  }

  DateTime? _parseHms(dynamic v) {
    if (v == null) return null;
    if (v is String && v.length >= 5) {
      try {
        final t = DateFormat('HH:mm:ss').parseStrict(v); // 1970-01-01
        return DateTime(day.year, day.month, day.day, t.hour, t.minute, t.second);
      } catch (_) {}
      try {
        final t2 = DateFormat('HH:mm').parseStrict(v);
        return DateTime(day.year, day.month, day.day, t2.hour, t2.minute);
      } catch (_) {}
    }
    return null;
  }

  double _durationFromPoints(List pts) {
    // punti come [lat, lng, "HH:mm:ss"] oppure map {lat,lng,ts:"HH:mm:ss"}
    DateTime? prev;
    double secs = 0;
    for (final p in pts) {
      DateTime? ts;
      if (p is List && p.length >= 3) {
        ts = _parseHms(p[2]);
      } else if (p is Map) {
        ts = _parseHms(p['ts'] ?? p['t']);
      }
      if (ts != null) {
        if (prev != null) secs += ts.difference(prev).inSeconds;
        prev = ts;
      }
    }
    return secs < 0 ? 0 : secs;
  }

  for (final seg in segments) {
    if (seg is! Map) continue;

    final label = _toLabel(seg['level'], seg['fonte']);
    double secs = 0;

    // 1) prova start/end (HH:mm[:ss])
    final t0 = _parseHms(seg['start']);
    final t1 = _parseHms(seg['end']);
    if (t0 != null && t1 != null) {
      secs = t1.difference(t0).inSeconds.toDouble();
      // se end < start (mezzanotte), aggiungi 24h
      if (secs < 0) secs += 24 * 3600;
    }

    // 2) fallback: differenze dai punti con timestamp
    if (secs == 0) {
      final pts = seg['points'];
      if (pts is List && pts.length > 1) {
        secs = _durationFromPoints(pts);
      }
    }

    if (secs > 0) out[label] = (out[label] ?? 0) + secs;
  }
  return out;
}



  Widget _legendItem(Color c, String label, double secs, double total) {
    final perc = total > 0 ? (secs / total * 100) : 0;
    final mm = (secs / 60).round();
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text('$label  ${perc.toStringAsFixed(0)}%  (${mm}m)',
          style: const TextStyle(fontSize: 12)),
    ]);
  }
}
