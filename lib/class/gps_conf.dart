import 'package:flutter/material.dart';


//---------------------------------------------------------------
// configurazione gps
//-----------------------------------------------------------------------
class GpsConf {
  final String accuracyMode;
  final double maxAccM;
  final int sampleSec;
  final int minDistanceM;
  final int uploadSec;
  final bool background;

  GpsConf({
    required this.accuracyMode,
    required this.maxAccM,
    required this.sampleSec,
    required this.minDistanceM,
    required this.uploadSec,
    required this.background,
  });

  factory GpsConf.fromFeatures(Map<String, dynamic> f) {
    num _n(dynamic v, num def) {
      if (v is num) return v;
      if (v is String) return num.tryParse(v) ?? def;
      return def;
    }

    return GpsConf(
      accuracyMode: (f['gps_accuracy_mode']?.toString() ?? 'balanced'),
      maxAccM: _n(f['gps_max_acc_m'], 80).toDouble(),
      sampleSec: _n(f['gps_sample_sec'], 15).toInt(),
      minDistanceM: _n(f['gps_min_distance_m'], 10).toInt(),
      uploadSec: _n(f['gps_upload_sec'], 60).toInt(),
      background: f['gps_background'] == true,
    );
  }
}