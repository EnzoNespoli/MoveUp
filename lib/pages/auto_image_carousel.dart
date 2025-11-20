import 'dart:async';
import 'package:flutter/material.dart';

class AutoImageCarousel extends StatefulWidget {
  final List<String> immagini;
  final List<String> testi;
  final double altezza;

  const AutoImageCarousel({
    super.key,
    required this.immagini,
    required this.testi,
    this.altezza = 220,
  });

  @override
  State<AutoImageCarousel> createState() => _AutoImageCarouselState();
}

class _AutoImageCarouselState extends State<AutoImageCarousel>
    with AutomaticKeepAliveClientMixin<AutoImageCarousel> {
  int _currentPage = 0;
  Timer? _timer;

  @override
  bool get wantKeepAlive => true; // <-- tiene montato il widget

  @override
  void initState() {
    super.initState();

    // Precarica tutte le immagini dopo il primo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final url in widget.immagini) {
        precacheImage(NetworkImage(url), context);
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.immagini.isEmpty) return;
      setState(() {
        _currentPage = (_currentPage + 1) % widget.immagini.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // <-- richiama keepAlive
    final larghezza = MediaQuery.of(context).size.width.clamp(320, 700);
    final altezza = larghezza * 6 / 16;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          width: larghezza.toDouble(),
          height: altezza.toDouble(),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                // 🔹 L'AnimatedSwitcher commuta SOLO l'immagine
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: Image.network(
                    key: ValueKey(widget.immagini[_currentPage]),
                    widget.immagini[_currentPage],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    gaplessPlayback: true, // 🔹 niente flash bianco/nero
                    cacheWidth: 1600,
                  ),
                ),
              ),
              // Overlay testo NON cambia widget → niente flicker
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.testi[_currentPage],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
