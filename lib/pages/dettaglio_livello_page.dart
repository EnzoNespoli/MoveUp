import 'package:flutter/material.dart';

class DettaglioLivelloPage extends StatelessWidget {
  final int livello;

  const DettaglioLivelloPage({super.key, required this.livello});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dettaglio Livello \$livello')),
      body: Center(
        child: Text(
          'Qui mostrerai i dati per il livello \$livello',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
