import 'package:flutter/material.dart';

//-----------------------------------------------------------
// Classe per le statistiche orarie
//-----------------------------------------------------------
class OraStat {
  final int ora;
  final int l0;
  final int l1;
  final int l2;
  final int lm1; // OFF
  OraStat(this.ora, this.l0, this.l1, this.l2, [this.lm1 = 0]);
  factory OraStat.fromJson(Map<String, dynamic> j) => OraStat(
        j['ora'] as int,
        j['sec_l0'] as int,
        j['sec_l1'] as int,
        j['sec_l2'] as int,
        (j['sec_off'] ?? j['sec_lm1'] ?? 0)
            as int, // <-- compatibile nuovo+vecchio
      );
}
