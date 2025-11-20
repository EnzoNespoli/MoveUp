import 'package:flutter/material.dart';

//---------------------------------------------------------------
// export dati
//-----------------------------------------------------------------------
class ExportChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const ExportChip({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => ActionChip(
        label: Text(label),
        avatar: const Icon(Icons.download),
        onPressed: onTap,
      );
}
