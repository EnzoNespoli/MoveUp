// pages/card_notifiche.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../lingua.dart';

class CardNotifiche extends StatelessWidget {
  final NotificationService service;
  final int utenteId;
  final String token;
  final String baseUrl;

  const CardNotifiche({
    super.key,
    required this.service,
    required this.utenteId,
    required this.token,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy HH:mm');

    IconData _icon(NotificationType type) {
      switch (type) {
        case NotificationType.info:
          return Icons.info_outline;
        case NotificationType.success:
          return Icons.check_circle_outline;
        case NotificationType.warning:
          return Icons.warning_amber;
        case NotificationType.error:
          return Icons.error_outline;
        case NotificationType.achievement:
          return Icons.stars;
        case NotificationType.reminder:
          return Icons.notifications_active;
      }
    }

    Color _color(NotificationType type) {
      switch (type) {
        case NotificationType.info:
          return Colors.blue;
        case NotificationType.success:
          return Colors.green;
        case NotificationType.warning:
          return Colors.orange;
        case NotificationType.error:
          return Colors.red;
        case NotificationType.achievement:
          return Colors.purple;
        case NotificationType.reminder:
          return Colors.teal;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueGrey, width: 1),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: StreamBuilder<List<AppNotification>>(
          stream: service.stream,
          initialData: service.current,
          builder: (context, snapshot) {
            final unreadCount = service.unreadCount;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Badge(
                  label: Text('$unreadCount'),
                  isLabelVisible: unreadCount > 0,
                  child: const Icon(Icons.notifications, size: 20),
                ),
                const SizedBox(width: 12),
                Text(context.t.notifiche_testa),
              ],
            );
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Segna tutte come lette
            IconButton(
              tooltip: context.t.notifiche_segnala,
              icon: const Icon(Icons.done_all, size: 20),
              onPressed: () async {
                await service.markAllAsReadRemote(
                  utenteId: utenteId,
                  token: token,
                  baseUrl: baseUrl,
                );
                await service.syncFromApi(
                  utenteId: utenteId,
                  token: token,
                  baseUrl: baseUrl,
                  lang: Localizations.localeOf(context).languageCode,
                );
              },
            ),
            // Elimina tutte
            IconButton(
              tooltip: context.t.notifiche_elimina_tutte,
              icon: const Icon(Icons.delete_sweep, size: 20),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(context.t.notifiche_conferma),
                    content: Text(
                      context.t.notifiche_conferma_msg,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(context.t.notifiche_annulla),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(context.t.notifiche_elimina),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await service.deleteAllRemote(
                    utenteId: utenteId,
                    token: token,
                    baseUrl: baseUrl,
                  );
                  await service.syncFromApi(
                    utenteId: utenteId,
                    token: token,
                    baseUrl: baseUrl,
                    lang: Localizations.localeOf(context).languageCode,
                  );
                }
              },
            ),
          ],
        ),
        children: [
          SizedBox(
            height: 300,
            child: StreamBuilder<List<AppNotification>>(
              stream: service.stream,
              initialData: service.current,
              builder: (context, snapshot) {
                final notifications = snapshot.data ?? [];

                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.t.notifiche_vuota,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    final color = _color(notif.type);

                    return Dismissible(
                      key: Key(notif.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _icon(notif.type),
                            color: color,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                notif.title,
                                style: TextStyle(
                                  fontWeight: notif.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (!notif.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif.message,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              df.format(notif.timestamp),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          // Segna come letta + ricarica
                          if (!notif.isRead) {
                            await service.markAsReadRemote(
                              utenteId: utenteId,
                              token: token,
                              id: notif.id,
                              baseUrl: baseUrl,
                            );

                            await service.syncFromApi(
                              utenteId: utenteId,
                              token: token,
                              baseUrl: baseUrl,
                              lang:
                                  Localizations.localeOf(context).languageCode,
                            );
                          }

                          // Se ha un'azione, naviga
                          if (notif.actionRoute != null) {
                            Navigator.pushNamed(
                              context,
                              notif.actionRoute!,
                              arguments: notif.data,
                            );
                          } else {
                            // Mostra dettaglio notifica
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(_icon(notif.type), color: color),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(notif.title)),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notif.message),
                                    const SizedBox(height: 16),
                                    Text(
                                      df.format(notif.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Chiudi'),
                                  ),
                                  if (!notif.isRead)
                                    TextButton(
                                      onPressed: () async {
                                        await service.markAsReadRemote(
                                          utenteId: utenteId,
                                          token: token,
                                          id: notif.id,
                                          baseUrl: baseUrl,
                                        );
                                        await service.syncFromApi(
                                          utenteId: utenteId,
                                          token: token,
                                          baseUrl: baseUrl,
                                          lang: Localizations.localeOf(context)
                                              .languageCode,
                                        );
                                        Navigator.pop(ctx);
                                      },
                                      child:
                                          Text(context.t.notifiche_segnalate),
                                    ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
