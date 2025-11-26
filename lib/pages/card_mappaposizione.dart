import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:latlong2/latlong.dart' as ll;
import '../lingua.dart';

class CardMappaPosizione extends StatefulWidget {
  // ⬇️ mapController di flutter_map non serve più: rimosso
  final ll.LatLng? posizioneUtente;
  final double zoom;
  final VoidCallback onRefresh;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final List<ll.LatLng> path;

  // ⬇️ nuovo: espone il controller Google al padre
  final void Function(gmap.GoogleMapController controller)? onMapCreated;

  const CardMappaPosizione({
    super.key,
    required this.posizioneUtente,
    required this.zoom,
    required this.onRefresh,
    required this.onZoomIn,
    required this.onZoomOut,
    this.path = const [],
    this.onMapCreated,
  });

  @override
  State<CardMappaPosizione> createState() => _CardMappaPosizioneState();
}

class _CardMappaPosizioneState extends State<CardMappaPosizione> {
  gmap.GoogleMapController? _ctrl;

  gmap.LatLng _toG(ll.LatLng p) => gmap.LatLng(p.latitude, p.longitude);

  final double grandezzaMappa = 320; // altezza fissa della mappa

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50],
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.my_location, color: Colors.blue, size: 18),
                          SizedBox(width: 6),
                          Text(
                            context.t.posizione,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      tooltip: context.t.map_mes_01,
                      onPressed: widget.onRefresh,
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.blue),
                      tooltip: 'Zoom -',
                      onPressed: widget.onZoomOut,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      tooltip: 'Zoom +',
                      onPressed: widget.onZoomIn,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: grandezzaMappa,
              child: widget.posizioneUtente == null
                  ? const Center(child: CircularProgressIndicator())
                  : _buildGoogleMap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    final start = _toG(widget.posizioneUtente!);

    final polyline = gmap.Polyline(
      polylineId: const gmap.PolylineId('percorso'),
      points: widget.path.map(_toG).toList(),
      width: 6,
      color: Colors.blue,
      geodesic: true,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: gmap.GoogleMap(
        initialCameraPosition:
            gmap.CameraPosition(target: start, zoom: widget.zoom),
        //mapType: gmap.MapType.satellite,     // 👈 solo satellite (niente etichette)
        mapType: gmap.MapType.hybrid, // 👈 satellite + etichette
        onMapCreated: (c) {
          //debugPrint('GoogleMap created on device'); // <-- aggiunto
          _ctrl = c;
          widget.onMapCreated?.call(c); // ⬅️ consegna il controller al padre
        },
        polylines: {if (widget.path.isNotEmpty) polyline},
        markers: {
          gmap.Marker(markerId: const gmap.MarkerId('user'), position: start),
        },
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: false,
        compassEnabled: true,
        //trafficEnabled: true,                // (opz) traffico in tempo reale
      ),
    );
  }
}
