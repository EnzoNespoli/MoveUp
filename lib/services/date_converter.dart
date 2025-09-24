import 'package:intl/intl.dart';

DateTime _toLocal(String s) {
  // ISO 8601 (con 'T' e offset/Z)
  if (s.contains('T')) return DateTime.parse(s).toLocal();
  // "YYYY-MM-DD HH:mm:ss" senza offset -> trattala come UTC
  return DateFormat('yyyy-MM-dd HH:mm:ss').parseUtc(s).toLocal();
}

String hmLocal(dynamic v) {
  final s = (v ?? '').toString();
  if (s.isEmpty) return '';
  final dt = _toLocal(s);
  return DateFormat('HH:mm').format(dt);
}

String ymdLocal(dynamic v) {
  final s = (v ?? '').toString();
  if (s.isEmpty) return '';
  final dt = _toLocal(s);
  return DateFormat('yyyy-MM-dd').format(dt);
}