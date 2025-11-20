import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:latlong2/latlong.dart' as ll;
import '../lingua.dart';

class MappaPercorsi extends StatefulWidget {
  const MappaPercorsi({
    super.key,
    required this.segments,
    this.bbox,
    this.height = 300,
    this.padding = const EdgeInsets.all(24),
    this.levelsToShow = const {'L1', 'L2'},
    this.minSegmentMeters = 5,
  });

  final List<dynamic> segments;
  final List<dynamic>? bbox; // [minLat, minLon, maxLat, maxLon]
  final double height;
  final EdgeInsets padding;
  final Set<String> levelsToShow;
  final double minSegmentMeters;
 


  @override
  State<MappaPercorsi> createState() => _MappaPercorsiState();
}

class _MappaPercorsiState extends State<MappaPercorsi> {
  gmap.GoogleMapController? _ctrl;

  final _geo = const ll.Distance();
  final List<gmap.Polyline> _polylines = [];
  gmap.LatLng _initialCenter = const gmap.LatLng(43.331627, 11.753286);
  gmap.LatLngBounds? _bounds;

  @override
  void initState() {
    super.initState();
    _buildGraphics();
  }

  @override
  void didUpdateWidget(covariant MappaPercorsi oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildGraphics();
    _fitIfReady();
  }

  // ----------------- helpers -----------------
  String _normalizeLevelTag(dynamic v) {
    if (v is num) {
      final n = v.toInt();
      if (n <= -1) return 'OFF';
      if (n == 0) return 'L0';
      if (n == 1) return 'L1';
      return 'L2';
    }
    if (v is String) {
      final s = v.toUpperCase();
      if (s == 'OFF' || s == 'L0' || s == 'L1' || s == 'L2') return s;
      final n = int.tryParse(s);
      if (n != null) return _normalizeLevelTag(n);
    }
    return 'L1';
  }

  double _segmentLengthMeters(List<ll.LatLng> pts) {
    if (pts.length < 2) return 0;
    double m = 0;
    for (var i = 1; i < pts.length; i++) {
      m += _geo(pts[i - 1], pts[i]);
    }
    return m;
  }

  gmap.LatLng _toG(ll.LatLng p) => gmap.LatLng(p.latitude, p.longitude);

  void _fitIfReady() {
    if (_ctrl == null || _bounds == null) return;
    Future.microtask(() {
      _ctrl?.animateCamera(gmap.CameraUpdate.newLatLngBounds(_bounds!, 40));
    });
  }

  void _buildGraphics() {
    _polylines.clear();
    _bounds = null;

    // raccogliamo tutti i punti (per bounds e fit)
    final allPointsLL = <ll.LatLng>[];

    int z = 1; // zIndex crescente per “stare sopra” su Web
    for (final seg in widget.segments) {
      final levelTag = _normalizeLevelTag(seg['level']);
      if (!widget.levelsToShow.contains(levelTag)) continue;

      final rawPts = (seg['points'] as List<dynamic>? ?? const []);
      final ptsLL = <ll.LatLng>[];
      for (final p in rawPts) {
        // p = [lat, lon, "HH:mm:ss"]
        if (p is List && p.length >= 2 && p[0] is num && p[1] is num) {
          final lat = (p[0] as num).toDouble();
          final lon = (p[1] as num).toDouble();
          ptsLL.add(ll.LatLng(lat, lon));
        }
      }

      if (ptsLL.isNotEmpty) {
        allPointsLL.addAll(ptsLL);
      }
      if (ptsLL.length < 2) continue;
      if (_segmentLengthMeters(ptsLL) < widget.minSegmentMeters) continue;

      Color color;
      switch (levelTag) {
        case 'L2':
          color = Colors.red;
          break;
        case 'L1':
          color = Colors.orange;
          break;
        default:
          color = Colors.blueGrey;
      }

      _polylines.add(
        gmap.Polyline(
          polylineId: gmap.PolylineId('seg_${_polylines.length}'),
          points: ptsLL.map(_toG).toList(),
          width: 6,
          color: color,
          geodesic: false,       // su Web a volte geodesic “sparisce”
          zIndex: z++,
          visible: true,
        ),
      );
    }

    // bounds da bbox o da tutti i punti raccolti
    if (widget.bbox != null &&
        widget.bbox!.length == 4 &&
        widget.bbox!.every((e) => e is num)) {
      final minLat = (widget.bbox![0] as num).toDouble();
      final minLon = (widget.bbox![1] as num).toDouble();
      final maxLat = (widget.bbox![2] as num).toDouble();
      final maxLon = (widget.bbox![3] as num).toDouble();
      _bounds = gmap.LatLngBounds(
        southwest: gmap.LatLng(minLat, minLon),
        northeast: gmap.LatLng(maxLat, maxLon),
      );
      _initialCenter =
          gmap.LatLng((minLat + maxLat) / 2, (minLon + maxLon) / 2);
    } else if (allPointsLL.length >= 2) {
      double minLat = allPointsLL.first.latitude, maxLat = allPointsLL.first.latitude;
      double minLon = allPointsLL.first.longitude, maxLon = allPointsLL.first.longitude;
      for (final p in allPointsLL) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLon) minLon = p.longitude;
        if (p.longitude > maxLon) maxLon = p.longitude;
      }
      _bounds = gmap.LatLngBounds(
        southwest: gmap.LatLng(minLat, minLon),
        northeast: gmap.LatLng(maxLat, maxLon),
      );
      _initialCenter =
          gmap.LatLng((minLat + maxLat) / 2, (minLon + maxLon) / 2);
    } else if (allPointsLL.isNotEmpty) {
      final p = allPointsLL.first;
      _initialCenter = gmap.LatLng(p.latitude, p.longitude);
    }
  }

  // ----------------- UI -----------------
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: gmap.GoogleMap(
  initialCameraPosition:
      gmap.CameraPosition(target: _initialCenter, zoom: 13),

  mapType: gmap.MapType.satellite, // o hybrid se vuoi etichette

  onMapCreated: (c) {
    _ctrl = c;
    _fitIfReady();
  },
          polylines: _polylines.toSet(),

          // 1. Abilita le gesture standard
  zoomGesturesEnabled: true,
  scrollGesturesEnabled: true,
  rotateGesturesEnabled: true,
  tiltGesturesEnabled: false, // opzionale, se non ti serve inclinare la vista

  // 2. Dai priorità alla mappa sui tocchi
  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  },

          mapToolbarEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
        ),
      ),
    );
  }
}
