import 'package:flutter/material.dart';
import '../lingua.dart';


/// --------------------------------------------------------------
/// Costruisce il widget di intestazione per un livello specifico
/// -----------------------------------------------------------------
class DettagliLivelloPage extends StatelessWidget {
  final int livello;

  const DettagliLivelloPage({super.key, required this.livello});

  @override
  Widget build(BuildContext context) {
    // Se ti servono utenteId e nomeId, recuperali qui da SharedPreferences
    return Scaffold(
      appBar: AppBar(title: Text('${context.t.form_crono_08} ${livello + 1}')),
      body: Center(
        child: Text(
          '${context.t.form_crono_09} ${livello + 1}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
