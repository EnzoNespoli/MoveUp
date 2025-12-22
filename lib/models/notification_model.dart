// models/notification_model.dart
enum NotificationType {
  info,
  success,
  warning,
  error,
  achievement,
  reminder,
}

class AppNotification {
  final String id;

  /// Fallback (testo libero dal backend)
  final String title;
  final String message;

  /// Nuovo: codice notifica (per traduzione lato app)
  final String? code;

  /// Nuovo: parametri per template (es. {"nome":"Enzo"})
  final Map<String, dynamic>? params;

  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionRoute; // Per navigazione quando si clicca
  final Map<String, dynamic>? data; // Dati extra opzionali

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    this.code,
    this.params,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
    this.data,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? code,
    Map<String, dynamic>? params,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? actionRoute,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      code: code ?? this.code,
      params: params ?? this.params,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'code': code,
      'params': params,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionRoute': actionRoute,
      'data': data,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    // type può arrivare come "info" (dal backend) oppure "NotificationType.info" (vecchio)
    final rawType = (json['type'] ?? '').toString();

    NotificationType parsedType = NotificationType.info;
    if (rawType.startsWith('NotificationType.')) {
      parsedType = NotificationType.values.firstWhere(
        (e) => e.toString() == rawType,
        orElse: () => NotificationType.info,
      );
    } else {
      parsedType = NotificationType.values.firstWhere(
        (e) => e.name == rawType, // "info"
        orElse: () => NotificationType.info,
      );
    }

    final rawParams = json['params'];
    final params =
        (rawParams is Map) ? Map<String, dynamic>.from(rawParams as Map) : null;

    final rawData = json['data'];
    final data =
        (rawData is Map) ? Map<String, dynamic>.from(rawData as Map) : null;

    return AppNotification(
      id: (json['id'] ?? '').toString(),
      code: json['code'] as String?,
      params: params,
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: parsedType,
      timestamp: DateTime.parse((json['timestamp'] ?? '').toString()),
      isRead: json['isRead'] as bool? ?? false,
      actionRoute: json['actionRoute'] as String?,
      data: data,
    );
  }
}
