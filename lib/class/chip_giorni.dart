import 'package:flutter/material.dart';

//--------------------------------------------------------------
// Widget per visualizzare i giorni rimanenti
//---------------------------------------------------------------
class ChipGiorni extends StatelessWidget {
  final String text;
  final Color color;
  const ChipGiorni({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text, style: TextStyle(color: color)),
      );
}