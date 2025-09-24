import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../lingua.dart';

class CardMappaPosizione extends StatelessWidget {
  final MapController mapController;
  final LatLng? posizioneUtente;
  final double zoom;
  final VoidCallback onRefresh; 
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const CardMappaPosizione({
    Key? key,
    required this.mapController,
    required this.posizioneUtente,
    required this.zoom,
    required this.onRefresh,
    required this.onZoomIn,
    required this.onZoomOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50],
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  tooltip: context.t.map_mes_01,
                  onPressed: onRefresh,
                ),
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.blue),
                  tooltip: 'Zoom -',
                  onPressed: onZoomOut,
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  tooltip: 'Zoom +',
                  onPressed: onZoomIn,
                ),
              ],
            ),
            SizedBox(
              height: 220,
              child: posizioneUtente == null
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: posizioneUtente!,
                            initialZoom: zoom,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.drag |
                                  InteractiveFlag.pinchZoom,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: posizioneUtente!,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
