import 'package:flutter/material.dart';

//----------------------------------------------------------------------
// Widget di caricamento
//----------------------------------------------------------------------
class LoadingCard extends StatelessWidget {
  const LoadingCard();
  @override
  Widget build(BuildContext context) => Container(
        height: 260,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey.shade300),
        ),
        child: const CircularProgressIndicator(),
      );
}

