import 'dart:convert';
import 'package:http/http.dart' as http;
import 'slide.dart';

Future<List<Slide>> loadSlides(String lang) async {
  final uri = Uri.parse(
      'https://mytrak.app/move/marketing/carousel_${lang}.json?v=20250926');

  try {
    final r = await http.get(uri);
    if (r.statusCode == 200) {
      final data = json.decode(r.body) as Map<String, dynamic>;
      final list = (data['slides'] as List)
          .map((e) => Slide.fromJson(e as Map<String, dynamic>))
          .where((s) => s.visible)
          .toList();
      if (list.isNotEmpty) return list; 
    }
  } catch (_) {/* ignore, fallback sotto */}

  // fallback EN
  if (lang != 'en') return loadSlides('en');
  return [];
}
