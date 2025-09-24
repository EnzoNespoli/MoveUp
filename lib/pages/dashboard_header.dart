import 'package:flutter/material.dart';
import '../lingua.dart';

class DashboardHeader extends StatelessWidget {
  final bool consensoTrackingGps;
  final String nomeId;
  final String utenteId;
  final String livelloUtente;
  final int giorniRimanenti;
  final String Function(int?, String) labelGiorni;
  final Color Function(int?, String) coloreGiorni;
  final Widget chipGiorni;

  const DashboardHeader({
    Key? key,
    required this.consensoTrackingGps,
    required this.nomeId,
    required this.utenteId,
    required this.livelloUtente,
    required this.giorniRimanenti,
    required this.labelGiorni,
    required this.coloreGiorni,
    required this.chipGiorni,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.dashboard, size: 22, color: Colors.blue[700]),
            SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(width: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:
                    consensoTrackingGps ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: consensoTrackingGps ? Colors.green : Colors.red,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: consensoTrackingGps ? Colors.green : Colors.grey,
                  ),
                  SizedBox(width: 6),
                  Text(
                    consensoTrackingGps
                        ? context.t.gps_err17
                        : context.t.gps_err18,
                    style: TextStyle(
                      color: consensoTrackingGps
                          ? Colors.green[800]
                          : Colors.grey[500],
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.blue[400]),
            SizedBox(width: 8),
            Text(
              context.t.info_mes07,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.person, color: Colors.blue[700], size: 22),
            SizedBox(width: 8),
            Text(
                context.t.form_crono_03,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            Text(
              nomeId.isNotEmpty ? nomeId : context.t.user_err02,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),

            Text(
              ' ($utenteId) ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ), 
            ),

            Text(
              '!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber[700]),
            const SizedBox(width: 8),
            Text(
              '${context.t.dashboard_piano} $livelloUtente',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            chipGiorni,
          ],
        ),
      ],
    );
  }
}
