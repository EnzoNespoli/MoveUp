import 'package:flutter/material.dart';
import 'package:move_app/lingua.dart';
import '../services/mod_esclusione_temporale.dart';

class EsclusioneTemporaleDialog extends StatefulWidget {
  final EsclusioneTemporale? esclusione;
  final int utenteId;
  const EsclusioneTemporaleDialog({this.esclusione, required this.utenteId, super.key});

  @override
  State<EsclusioneTemporaleDialog> createState() =>
      _EsclusioneTemporaleDialogState();
}

class _EsclusioneTemporaleDialogState extends State<EsclusioneTemporaleDialog> {
  late TextEditingController nomeCtrl;
  late TextEditingController oraInizioCtrl;
  late TextEditingController oraFineCtrl;
  late TextEditingController noteCtrl;
  bool attiva = true;
  List<bool> giorni = List.filled(7, false); // Lunedì-Domenica

  @override
  void initState() {
    super.initState();
    nomeCtrl = TextEditingController(text: widget.esclusione?.nome ?? '');
    oraInizioCtrl =
        TextEditingController(text: widget.esclusione?.oraInizio ?? '');
    oraFineCtrl = TextEditingController(text: widget.esclusione?.oraFine ?? '');
    noteCtrl = TextEditingController(text: widget.esclusione?.note ?? '');
    attiva = widget.esclusione?.attiva == 1;

    // Se stai modificando, imposta i giorni dal bitmask
    final mask = widget.esclusione?.giorniBitmask ?? 0;
    for (int i = 0; i < 7; i++) {
      giorni[i] = (mask & (1 << i)) != 0;
    }
  }

  int getBitmask() {
    int mask = 0;
    for (int i = 0; i < 7; i++) {
      if (giorni[i]) mask |= (1 << i);
    }
    return mask;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.esclusione == null
          ? context.t.escl_prog_06
          : context.t.escl_prog_07),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: oraInizioCtrl,
              decoration:
                  InputDecoration(labelText: '${context.t.escl_prog_08} (es: 08:00)'),
            ),
            TextField(
              controller: oraFineCtrl,
              decoration:
                  InputDecoration(labelText: '${context.t.escl_prog_09} (es: 18:00)'),
            ),
            TextField(
              controller: noteCtrl,
              decoration: InputDecoration(labelText: context.t.escl_prog_10),
            ),
            SwitchListTile(
              title: Text(context.t.escl_prog_11),
              value: attiva,
              onChanged: (val) => setState(() => attiva = val),
            ),
            const SizedBox(height: 8),
            Text(context.t.escl_prog_12,
                style: Theme.of(context).textTheme.bodyMedium),
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                const giorniSettimana = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun'
                ];
                return FilterChip(
                  label: Text(giorniSettimana[i]),
                  selected: giorni[i],
                  onSelected: (val) => setState(() => giorni[i] = val),
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(context.t.escl_prog_13),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(context.t.escl_prog_14),
          onPressed: () {
            final nuova = EsclusioneTemporale(
              id: widget.esclusione?.id ?? 0,
             utenteId: int.tryParse(widget.utenteId.toString()) ?? 0, // imposta l'utenteId corretto
              nome: nomeCtrl.text,
              giorniBitmask: getBitmask(), // <-- usa la funzione qui!
              oraInizio: oraInizioCtrl.text,
              oraFine: oraFineCtrl.text,
              note: noteCtrl.text,
              attiva: attiva ? 1 : 0,
              timezone: null,
              createdAt: null,
              updatedAt: null,
            );
            Navigator.of(context).pop(nuova);
          },
        ),
      ],
    );
  }
}
