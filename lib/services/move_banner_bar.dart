import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BannerType { info, warning, success, error, promo }

class MoveBannerBar extends StatefulWidget {
  final String id; // es. "gps_off_2025-08"
  final String message; // testo riga singola o breve
  final String? ctaText; // es. "Attiva" / "Scopri"
  final VoidCallback? onCta;
  final BannerType type;
  final bool dismissible; // mostra la X
  final Duration? dismissFor; // quanto tempo ricordare la chiusura

  const MoveBannerBar({
    super.key,
    required this.id,
    required this.message,
    this.ctaText,
    this.onCta,
    this.type = BannerType.info,
    this.dismissible = true,
    this.dismissFor, // se null: per sempre
  });

  @override
  State<MoveBannerBar> createState() => _MoveBannerBarState();
}

class _MoveBannerBarState extends State<MoveBannerBar> {
  bool _hidden = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'banner_dismiss_${widget.id}';
    final untilIso = prefs.getString(key);
    if (untilIso == null) return;
    final until = DateTime.tryParse(untilIso);
    if (until == null) return;
    if (DateTime.now().isBefore(until)) {
      setState(() => _hidden = true);
    } else {
      // scaduto → si può rivedere
      await prefs.remove(key);
    }
  }

  Future<void> _dismiss() async {
    setState(() => _hidden = true);
    final prefs = await SharedPreferences.getInstance();
    final key = 'banner_dismiss_${widget.id}';
    final until = widget.dismissFor == null
        ? DateTime(9999) // praticamente per sempre
        : DateTime.now().add(widget.dismissFor!);
    await prefs.setString(key, until.toIso8601String());
  }

  (Color bg, Color fg) _colors(ColorScheme cs) {
    switch (widget.type) {
      case BannerType.warning:
        return (cs.tertiaryContainer, cs.onTertiaryContainer);
      case BannerType.success:
        return (cs.secondaryContainer, cs.onSecondaryContainer);
      case BannerType.error:
        return (cs.errorContainer, cs.onErrorContainer);
      case BannerType.promo:
        return (cs.primaryContainer, cs.onPrimaryContainer);
      case BannerType.info:
        return (cs.surfaceContainerHighest, cs.onSurface);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hidden) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = _colors(cs);

    return Material(
      color: bg,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              switch (widget.type) {
                BannerType.warning => Icons.warning_amber_outlined,
                BannerType.success => Icons.check_circle_outlined,
                BannerType.error => Icons.error_outline,
                BannerType.promo => Icons.local_offer_outlined,
                _ => Icons.info_outline,
              },
              color: fg,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: fg, fontWeight: FontWeight.w600),
              ),
            ),
            if (widget.ctaText != null && widget.onCta != null)
              TextButton(
                onPressed: widget.onCta,
                child: Text(widget.ctaText!, style: TextStyle(color: fg)),
              ),
            if (widget.dismissible)
              IconButton(
                onPressed: _dismiss,
                splashRadius: 18,
                icon: Icon(Icons.close, color: fg),
              ),
          ],
        ),
      ),
    );
  }
}
