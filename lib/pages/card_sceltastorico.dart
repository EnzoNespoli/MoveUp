import 'package:flutter/material.dart';
import '../lingua.dart';

class CardSceltaStorico extends StatelessWidget {
  final Widget Function({required String titolo, required String descrizione})
      pianoDescrizioneBuilder;

  const CardSceltaStorico({Key? key, required this.pianoDescrizioneBuilder})
      : super(key: key);

 @override
Widget build(BuildContext context) {
  return Card(
    color: Colors.blueGrey[50],
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.blueGrey, width: 2),
    ),
    child: ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        context.t.storico_01,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pianoDescrizioneBuilder(
                titolo: context.t.storico_02,
                descrizione: context.t.storico_03,
              ),
              pianoDescrizioneBuilder(
                titolo: context.t.storico_04,
                descrizione: context.t.storico_05,
              ),
              pianoDescrizioneBuilder(
                titolo: context.t.storico_06,
                descrizione: context.t.storico_07,
              ),
              pianoDescrizioneBuilder(
                titolo: context.t.storico_08,
                descrizione: context.t.storico_09,
              ),
              pianoDescrizioneBuilder(
                titolo: context.t.storico_10,
                descrizione: context.t.storico_11,
              ),
              SizedBox(height: 12),
              Divider(),
              Text(
                context.t.storico_12,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                context.t.storico_13,
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
