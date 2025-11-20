import 'package:flutter/material.dart';

//---------------------------------------------------------------------
// info
//---------------------------------------------------------------------
class LockedInfo extends StatelessWidget {
  final String text;
  const LockedInfo({required this.text});
  @override
  Widget build(BuildContext context) => Container(
        height: 120,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Text(text, textAlign: TextAlign.center),
      );
}

