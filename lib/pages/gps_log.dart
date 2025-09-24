// gps_log.dart
import 'dart:async';


enum GpsLogStatus { queued, flushed, saved, error }

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

class GpsLog {
  GpsLog._();
  static final GpsLog instance = GpsLog._();

  final _items = <GpsLogEntry>[];
  final _ctrl = StreamController<List<GpsLogEntry>>.broadcast();
  int maxItems = 200;

  Stream<List<GpsLogEntry>> get stream => _ctrl.stream;
  List<GpsLogEntry> get current => List.unmodifiable(_items);

  void _push(GpsLogEntry e) {
    _items.insert(0, e); // più recente in alto
    if (_items.length > maxItems) _items.removeLast();
    _ctrl.add(List.unmodifiable(_items));
  }

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

  void logFlushed(int count) {
    _push(GpsLogEntry(
      ts: DateTime.now(),
      status: GpsLogStatus.flushed,
      msg: 'Flush queue: $count items sent',
    ));
  }

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

  void logError(String message) {
    _push(GpsLogEntry(
      ts: DateTime.now(),
      status: GpsLogStatus.error,
      msg: message,
    ));
  }

  void clear() {
    _items.clear();
    _ctrl.add(List.unmodifiable(_items));
  }
}
