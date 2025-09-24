import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../lingua.dart';

class MappaPercorsi extends StatefulWidget {
  const MappaPercorsi({
    super.key,
    required this.segments,
    this.bbox, // [minLat, minLon, maxLat, maxLon]
    this.height = 300,
    this.padding = const EdgeInsets.all(24),
    this.levelsToShow = const {'L1', 'L2'}, // default: solo movimenti
    this.minSegmentMeters = 5, // scarta segmenti troppo corti
  });

  final List<dynamic> segments;
  final List<dynamic>? bbox;
  final double height;
  final EdgeInsets padding;
  final Set<String> levelsToShow;
  final double minSegmentMeters;

  @override
  State<MappaPercorsi> createState() => _MappaPercorsiState();
}

class _MappaPercorsiState extends State<MappaPercorsi> {
  final mapController = MapController();

  final List<Polyline> _polylines = [];
  LatLng _initialCenter = const LatLng(43.331627, 11.753286);
  LatLngBounds? _bounds;
  final _geo = const Distance();
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _buildGraphics();
  }

  @override
  void didUpdateWidget(covariant MappaPercorsi oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildGraphics(); // ricalcolo grafiche/bounds
    _tryFit();        // se mappa già pronta, fitto
  }

  void _tryFit() {
    if (!_mapReady || _bounds == null) return;
    Future.microtask(() {
      if (!mounted) return;
      mapController.fitCamera(
        CameraFit.bounds(bounds: _bounds!, padding: widget.padding),
      );
    });
  }

  double _segmentLengthMeters(List<LatLng> pts) {
    if (pts.length < 2) return 0;
    double m = 0;
    for (var i = 1; i < pts.length; i++) {
      m += _geo(pts[i - 1], pts[i]);
    }
    return m;
  }

  // Normalizza qualsiasi rappresentazione di livello in tag string
  // -1 -> 'OFF', 0 -> 'L0', 1 -> 'L1', 2 -> 'L2'
  String _normalizeLevelTag(dynamic v) {
    if (v is num) {
      final n = v.toInt();
      if (n <= -1) return 'OFF';
      if (n == 0) return 'L0';
      if (n == 1) return 'L1';
      if (n >= 2) return 'L2';
    }
    if (v is String) {
      final s = v.toUpperCase();
      if (s == 'OFF' || s == 'L0' || s == 'L1' || s == 'L2') return s;
      // accetta anche "0","1","2","-1"
      final parsed = int.tryParse(s);
      if (parsed != null) return _normalizeLevelTag(parsed);
    }
    // fallback prudente
    return 'L1';
  }

  void _buildGraphics() {
    _polylines.clear(); // 👈 evita accumulo
    _bounds = null;

    final allPoints = <LatLng>[];

    for (final seg in widget.segments) {
      final levelTag = _normalizeLevelTag(seg['level']);
      if (!widget.levelsToShow.contains(levelTag)) continue;

      final rawPts = (seg['points'] as List<dynamic>? ?? const []);
      final pts = <LatLng>[];
      for (final p in rawPts) {
        // p = [lat, lon, "HH:mm:ss"]
        if (p is List && p.length >= 2 && p[0] is num && p[1] is num) {
          pts.add(LatLng((p[0] as num).toDouble(), (p[1] as num).toDouble()));
        }
      }

      // 👉 bounds anche se il segmento è corto
      if (pts.isNotEmpty) allPoints.addAll(pts);

      if (pts.length < 2) continue;

      // scarta segmenti troppo corti
      if (_segmentLengthMeters(pts) < widget.minSegmentMeters) continue;

      allPoints.addAll(pts);

      // colore per livello
      Color color;
      switch (levelTag) {
        case 'L2':
          color = Colors.red;
          break;
        case 'L1':
          color = Colors.orange;
          break;
        case 'L0':
        default:
          color = Colors.blueGrey; // se mai decidessi di mostrarlo
      }

      _polylines.add(
        Polyline(
          points: pts,
          color: color,
          strokeWidth: 4,
          strokeCap: StrokeCap.round,
        ),
      );
    }

    // bounds
    if (widget.bbox != null &&
        widget.bbox!.length == 4 &&
        widget.bbox!.every((e) => e is num)) {
      final minLat = (widget.bbox![0] as num).toDouble();
      final minLon = (widget.bbox![1] as num).toDouble();
      final maxLat = (widget.bbox![2] as num).toDouble();
      final maxLon = (widget.bbox![3] as num).toDouble();
      _bounds = LatLngBounds(LatLng(minLat, minLon), LatLng(maxLat, maxLon));
      _initialCenter = _bounds!.center;
    } else if (allPoints.length >= 2) {
      _bounds = LatLngBounds.fromPoints(allPoints);
      _initialCenter = _bounds!.center;
    } else if (allPoints.isNotEmpty) {
      _initialCenter = allPoints.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_polylines.isEmpty) {
      return Container(
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey.shade300),
        ),
        child: Text(context.t.card_percorso_5),
      );
    }

    return SizedBox(
      height: widget.height,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 13,
          onMapReady: () {
            _mapReady = true;
            _tryFit();
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayer(polylines: _polylines),
        ],
      ),
    );
  }
}
