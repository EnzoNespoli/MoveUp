// gps_log.dart
import 'dart:async';
import 'dart:convert';

enum GpsLogStatus { queued, flushed, saved, error, info }

class GpsLogEntry {
  final DateTime ts;
  final GpsLogStatus status;
  final double? lat, lon, accM, altM;
  final String msg;

  GpsLogEntry({
    required this.ts,
    required this.status,
    this.lat,
    this.lon,
    this.accM,
    this.altM,
    this.msg = '',
  });
}

extension GpsLogExport on GpsLog {
  String exportText({int? maxLines}) {
    final items = current;
    final slice = (maxLines != null && items.length > maxLines)
        ? items.sublist(items.length - maxLines)
        : items;

    final sb = StringBuffer();
    sb.writeln(
        'MoveUP GPS LOG  | lines=${slice.length}  | utc=${DateTime.now().toUtc().toIso8601String()}');
    sb.writeln('---');
    for (final e in slice) {
      final ts = e.ts.toUtc().toIso8601String();
      final st = e.status.name;
      final lat = e.lat?.toStringAsFixed(6) ?? '';
      final lon = e.lon?.toStringAsFixed(6) ?? '';
      final acc = e.accM != null ? e.accM!.toStringAsFixed(0) : '';
      final alt = e.altM != null ? e.altM!.toStringAsFixed(0) : '';
      final msg = (e.msg).replaceAll('\n', ' ').trim();

      sb.writeln('$ts\t$st\t$lat\t$lon\tacc=$acc\talt=$alt\t$msg');
    }
    return sb.toString();
  }

  //------------------------------------------------------------------
  // Export JSON (es. per debug o esportazione manuale)
  //------------------------------------------------------------------
  String exportJson({int? maxLines}) {
    final items = current;
    final slice = (maxLines != null && items.length > maxLines)
        ? items.sublist(items.length - maxLines)
        : items;

    final map = {
      'generated_at_utc': DateTime.now().toUtc().toIso8601String(),
      'lines': slice.length,
      'items': slice
          .map((e) => {
                'ts_utc': e.ts.toUtc().toIso8601String(),
                'status': e.status.name,
                'lat': e.lat,
                'lon': e.lon,
                'acc_m': e.accM,
                'alt_m': e.altM,
                'msg': e.msg,
              })
          .toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }
}

//-----------------------------------------------------------------
// Log interno per debug e info
//-----------------------------------------------------------------
class GpsLog {
  void logInfo(String message) {
    _push(GpsLogEntry(
      ts: DateTime.now(),
      status: GpsLogStatus.info,
      msg: message,
    ));
  }

  GpsLog._();
  static final GpsLog instance = GpsLog._();

  final _items = <GpsLogEntry>[];
  final _ctrl = StreamController<List<GpsLogEntry>>.broadcast();
  int maxItems = 200;

  Stream<List<GpsLogEntry>> get stream => _ctrl.stream;
  List<GpsLogEntry> get current => List.unmodifiable(_items);

  //--------------------------------------------------
  // Log entry
  //--------------------------------------------------
  void _push(GpsLogEntry e) {
    _items.insert(0, e); // più recente in alto
    if (_items.length > maxItems) _items.removeLast();
    _ctrl.add(List.unmodifiable(_items));
  }

  //--------------------------------------------------
  // Log helpers
  //--------------------------------------------------
  void logQueued({
    required double lat,
    required double lon,
    required double accM,
    required double altM,
  }) {
    _push(GpsLogEntry(
      ts: DateTime.now(),
      status: GpsLogStatus.queued,
      lat: lat,
      lon: lon,
      accM: accM,
      altM: altM,
      msg: 'In queue for sending',
    ));
  }

  //--------------------------------------------------
  // Log flush result
  //--------------------------------------------------
  void logFlushed(int count) {
    _push(GpsLogEntry(
      ts: DateTime.now(),
      status: GpsLogStatus.flushed,
      msg: 'Flush queue: $count items sent',
    ));
  }

  //--------------------------------------------------
  // Log error
  //--------------------------------------------------
  void logSaved({
    required double lat,
    required double lon,
    required double accM,
    required double altM,
  }) {
    _push(GpsLogEntry(
      ts: DateTime.now(),
      status: GpsLogStatus.saved,
      lat: lat,
      lon: lon,
      accM: accM,
      altM: altM,
      msg: '>Save to server',
    ));
  }

  //--------------------------------------------------
  // Log error
  //--------------------------------------------------
  void logError(String message) {
    _push(GpsLogEntry(
      ts: DateTime.now(),
      status: GpsLogStatus.error,
      msg: message,
    ));
  }

  //--------------------------------------------------
  // Clear log
  //----------------------------------------------------
  void clear() {
    _items.clear();
    _ctrl.add(List.unmodifiable(_items));
  }
}
