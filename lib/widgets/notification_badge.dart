// widgets/notification_badge.dart
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

/// Widget che mostra un badge con il numero di notifiche non lette
/// Può essere usato nell'AppBar, BottomNavigationBar, o ovunque tu voglia
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const NotificationBadge({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppNotification>>(
      stream: NotificationService().stream,
      initialData: NotificationService().current,
      builder: (context, snapshot) {
        final unreadCount = NotificationService().unreadCount;

        Widget badgedChild = Badge(
          label: Text('$unreadCount'),
          isLabelVisible: unreadCount > 0,
          child: child,
        );

        if (onTap != null) {
          return InkWell(
            onTap: onTap,
            child: badgedChild,
          );
        }

        return badgedChild;
      },
    );
  }
}

/// Esempio di utilizzo nell'AppBar:
/// 
/// AppBar(
///   actions: [
///     NotificationBadge(
///       onTap: () {
///         // Scroll a CardNotifiche o apri pagina notifiche
///       },
///       child: Icon(Icons.notifications),
///     ),
///   ],
/// )
/// 
/// Esempio nell'BottomNavigationBar:
/// 
/// BottomNavigationBarItem(
///   icon: NotificationBadge(
///     child: Icon(Icons.notifications),
///   ),
///   label: 'Notifiche',
/// )
