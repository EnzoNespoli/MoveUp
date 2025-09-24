import 'dart:convert';
import 'package:intl/intl.dart';

Map<String, dynamic> normalizePiano(dynamic raw) {
  final m = (raw is Map) ? Map<String, dynamic>.from(raw) : <String, dynamic>{};

  // ---- funzioni ----
  final funzioniRaw = m['funzioni_attive'] ?? m['funzioni']; // DB o legacy
  final funzioni = _toMap(funzioniRaw); // sempre Map<String,bool/num>

  // ---- prezzo ----
  final num? prezzoEuro = _toNum(m['prezzo_euro']) ?? _toNum(m['prezzo']);
  final valuta = (m['valuta'] ?? 'EUR').toString();
  final prezzoLabel = (prezzoEuro != null)
      ? NumberFormat.currency(
              name: valuta, symbol: valuta == 'EUR' ? '€' : valuta)
          .format(prezzoEuro)
      : (m['prezzo']?.toString() ?? '-');

  // ---- durata ----
  final int? giorni = (m['durata_giorni'] as num?)?.toInt();
  final durataLabel =
      m['durata']?.toString() ?? (giorni != null ? '$giorni giorni' : '-');

  return {
    'id': m['id'],
    'nome': m['nome'] ?? '',
    'prezzo': prezzoLabel, // stringa per la UI
    'prezzo_euro': prezzoEuro, // anche numerico se ti serve
    'durata': durataLabel, // stringa per la UI
    'durata_giorni': giorni, // anche numerico
    'funzioni_attive': funzioni, // => Map<String, dynamic>
    'is_subscription':
        m['is_subscription'] == 1 || m['is_subscription'] == true,
    'retention_giorni': (m['retention_giorni'] as num?)?.toInt(),
    'stripe_price_id': m['stripe_price_id'],
    'valuta': valuta,
  };
}

Map<String, dynamic> _toMap(dynamic v) {
  if (v == null) return {};
  if (v is Map) return Map<String, dynamic>.from(v);
  if (v is List)
    return {for (final e in v) e.toString(): true}; // ["a"] -> {"a":true}
  if (v is String) {
    try {
      return _toMap(jsonDecode(v));
    } catch (_) {}
  } // TEXT JSON dal DB
  return {};
}

num? _toNum(dynamic v) {
  if (v is num) return v;
  if (v is String) return num.tryParse(v.replaceAll(',', '.'));
  return null;
}
