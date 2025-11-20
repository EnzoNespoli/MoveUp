import 'package:flutter/material.dart';
import 'impostazioni_page.dart';
import 'cronologia_page.dart';
import '../pages/abbonamenti_page.dart';
import '../lingua.dart';

class BottomNavBar extends StatelessWidget {
  final bool utenteTemporaneo;
  final String utenteId;
  final String nomeId;
  final Function() leggiConsensi;
  final Function(BuildContext) mostraLoginDialog;
  final Function() eseguiLogout;

  const BottomNavBar({
    Key? key,
    required this.utenteTemporaneo,
    required this.utenteId,
    required this.nomeId,
    required this.leggiConsensi,
    required this.mostraLoginDialog,
    required this.eseguiLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: context.t.bottom_impostazioni,
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.history), label: context.t.bottom_cronologia),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: context.t.bottom_profilo),
        BottomNavigationBarItem(
          icon: Icon(Icons.workspace_premium),
          label: context.t.bottom_abbonamenti,
        ),
      ],
      onTap: (index) async {
        if (index == 0) {
          if (utenteTemporaneo) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.t.bottom_err01,
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ImpostazioniPage(utenteId: utenteId, nomeId: nomeId),
            ),
          ).then((_) async {
            await leggiConsensi();
          });
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CronologiaPage(utenteId: utenteId, nomeId: nomeId),
            ),
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
                  '${context.t.bottom_nome} ${nomeId.isNotEmpty ? nomeId : context.t.bottom_err02}',
                ),
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
                content: Text(
                  context.t.bottom_err01,
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AbbonamentiPage(utenteId: utenteId, nomeId: nomeId),
            ),
          );
        }
      },
    );
  }
}
