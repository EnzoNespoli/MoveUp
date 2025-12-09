import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:fl_chart/fl_chart.dart';
import 'package:latlong2/latlong.dart' as ll;

class MapWithPieLevels extends StatelessWidget {
  const MapWithPieLevels({
    super.key,
    required this.center,
    this.zoom = 15,
    this.path = const <ll.LatLng>[],
    required this.secondsByLevel, // es: {'OFF': 3600, 'L0': 1200, 'L1': 900, 'L2': 300}
    this.height = 280,
    this.title = 'Map + Levels',
  });

  final gmap.LatLng center;
  final double zoom;
  final List<ll.LatLng> path;
  final Map<String, num> secondsByLevel;
  final double height;
  final String title;

  gmap.Polyline? _buildPolyline() {
    if (path.isEmpty) return null;
    return gmap.Polyline(
      polylineId: const gmap.PolylineId('path'),
      points: path.map((p) => gmap.LatLng(p.latitude, p.longitude)).toList(),
      color: Colors.blue,
      width: 5,
      geodesic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Normalizza dati torta
    final levels = ['OFF', 'L0', 'L1', 'L2'];
    final data = {for (final k in levels) k: (secondsByLevel[k] ?? 0).toDouble()};
    final total = data.values.fold<double>(0, (a, b) => a + b);
    final sections = total <= 0
        ? <PieChartSectionData>[
            PieChartSectionData(
              value: 1,
              title: 'No data',
              radius: 38,
              titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
              color: Colors.grey.shade400,
            ),
          ]
        : <PieChartSectionData>[
            PieChartSectionData(value: data['OFF'], title: 'OFF', color: Colors.grey.shade500, radius: 44),
            PieChartSectionData(value: data['L0'],  title: 'L0',  color: Colors.blue.shade200,  radius: 44),
            PieChartSectionData(value: data['L1'],  title: 'L1',  color: Colors.blue.shade600,  radius: 44),
            PieChartSectionData(value: data['L2'],  title: 'L2',  color: Colors.indigo.shade800, radius: 44),
          ];

    Widget legendItem(Color c, String label, double secs) {
      final perc = total > 0 ? (secs / total * 100) : 0;
      final mm = (secs / 60).round();
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label  ${perc.toStringAsFixed(0)}%  (${mm}m)', style: const TextStyle(fontSize: 12)),
        ],
      );
    }

    final poly = _buildPolyline();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.map, color: Colors.blue),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
          ]),
          const SizedBox(height: 8),

          // MAPPA
          SizedBox(
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: gmap.GoogleMap(
                initialCameraPosition: gmap.CameraPosition(target: center, zoom: zoom),
                polylines: {if (poly != null) poly},
                markers: {gmap.Marker(markerId: const gmap.MarkerId('center'), position: center)},
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: true,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // TORTA + LEGENDA
          Row(
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 22,
                    sectionsSpace: 2,
                    sections: sections,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    legendItem(Colors.grey.shade500, 'OFF', data['OFF']!),
                    legendItem(Colors.blue.shade200, 'L0',  data['L0']!),
                    legendItem(Colors.blue.shade600, 'L1',  data['L1']!),
                    legendItem(Colors.indigo.shade800, 'L2',  data['L2']!),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
