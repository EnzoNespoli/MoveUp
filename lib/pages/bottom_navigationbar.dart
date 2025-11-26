import 'package:flutter/material.dart';
import 'impostazioni_page.dart';
import 'cronologia_page.dart';
import '../pages/abbonamenti_page.dart';
import '../lingua.dart';

class BottomNavBar extends StatelessWidget {
  // NEW (opzionali)
  final int? currentIndex;
  final ValueChanged<int>? onItemSelected;

  // tuoi parametri originali restano
  final bool utenteTemporaneo;
  final String utenteId;
  final String nomeId;
  final Function() leggiConsensi;
  final Function(BuildContext) mostraLoginDialog;
  final Function() eseguiLogout;

  const BottomNavBar({
    Key? key,
    this.currentIndex, // NEW
    this.onItemSelected, // NEW
    required this.utenteTemporaneo,
    required this.utenteId,
    required this.nomeId,
    required this.leggiConsensi,
    required this.mostraLoginDialog,
    required this.eseguiLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < 370; // telefoni “stretti”
    final isUltra = w < 340; // super-stretti (tipo 320px)

    String lblImp() => isUltra
        ? ''
        : (isNarrow
            ? context.t.bottom_impostazioni_short
            : context.t.bottom_impostazioni);
    String lblCro() => isUltra
        ? ''
        : (isNarrow
            ? context.t.bottom_cronologia_short
            : context.t.bottom_cronologia);
    String lblPro() => isUltra
        ? ''
        : (isNarrow
            ? context.t.bottom_profilo_short
            : context.t.bottom_profilo);
    String lblAbb() => isUltra
        ? ''
        : (isNarrow
            ? context.t.bottom_abbonamenti_short
            : context.t.bottom_abbonamenti);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey[200],
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black87,
      currentIndex: currentIndex ?? 0, // NEW (fallback 0)
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: lblImp(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: lblCro(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: lblPro(),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.workspace_premium),
          label: lblAbb(),
        ),
      ],
      onTap: (index) async {
        // NEW: se il parent gestisce le tab, delega e non fare push
        if (onItemSelected != null) {
          onItemSelected!(index);
          return;
        }

        // --- sotto: tuo comportamento originale invariato ---
        if (index == 0) {
          if (utenteTemporaneo) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(context.t.bottom_err01),
                  backgroundColor: Colors.red),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ImpostazioniPage(utenteId: utenteId, nomeId: nomeId)),
          ).then((_) async => await leggiConsensi());
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CronologiaPage(utenteId: utenteId, nomeId: nomeId)),
          );
        } else if (index == 2) {
          if (utenteTemporaneo) {
            mostraLoginDialog(context);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(context.t.bottom_profilo),
                content: Text(
                    '${context.t.bottom_nome} ${nomeId.isNotEmpty ? nomeId : context.t.bottom_err02}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      eseguiLogout();
                    },
                    child: Text(context.t.bottom_logout),
                  ),
                ],
              ),
            );
          }
        } else if (index == 3) {
          if (utenteTemporaneo) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(context.t.bottom_err01),
                  backgroundColor: Colors.red),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AbbonamentiPage(utenteId: utenteId, nomeId: nomeId)),
          );
        }
      },
    );
  }
}
