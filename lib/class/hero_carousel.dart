import 'package:flutter/material.dart';
import '../services/slide.dart';
import '../pages/auto_image_carousel.dart';
import '../services/marketing_content.dart';


//--------------------------------------------------------------
// HERO CAROUSEL — mettilo in un file o sopra alla tua pagina
//--------------------------------------------------------------
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

//------------------------------------------------------------------------
// Mantieni lo stato del carousel (lingua, immagini) anche se non visibile
//------------------------------------------------------------------------
class _HeroCarouselState extends State<HeroCarousel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Slide>>? _future;
  String? _loadedLang;
  List<String>? _imgs, _txts;

  String _bestLang() {
    final code =
        Localizations.maybeLocaleOf(context)?.languageCode?.toLowerCase() ??
            'en';
    const supported = {'it', 'en', 'es', 'fr', 'de'};
    return supported.contains(code) ? code : 'en';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = _bestLang();
    if (_future == null || _loadedLang != lang) {
      _loadedLang = lang;
      _future = loadSlides(lang); // usa la tua funzione
      _imgs = null; // reset cache quando cambia lingua
      _txts = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // keepAlive
    return FutureBuilder<List<Slide>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox(height: 220);
        }
        final slides = snap.data ?? const [];
        if (slides.isEmpty) return const SizedBox.shrink();

        _imgs ??= slides.map((s) => s.image).toList(growable: false);
        _txts ??= slides.map((s) => s.title).toList(growable: false);

        return RepaintBoundary(
          child: AutoImageCarousel(
            immagini: _imgs!, // liste stabili → niente flicker
            testi: _txts!,
            altezza: 220,
          ),
        );
      },
    );
  }
}
