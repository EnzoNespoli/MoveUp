// services/notification_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const int _maxNotifications = 100;

  final _controller = StreamController<List<AppNotification>>.broadcast();
  List<AppNotification> _notifications = [];

  Stream<List<AppNotification>> get stream => _controller.stream;
  List<AppNotification> get current => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void dispose() {
    _controller.close();
  }

  //---------------------------------------------------------------------
  // Scarica le notifiche dal backend.
  // - Richiede utenteId + token (utente loggato).
  // - Se fallisce (rete/500), non rompe nulla.
  //----------------------------------------------------------------------
  Future<void> syncFromApi({
    required int utenteId,
    required String token,
    required String baseUrl,
    required String lang,
    int limit = 100,
  }) async {
    try {
      final uri =
          Uri.parse('$baseUrl/notifica_lista.php').replace(queryParameters: {
        'utente_id': utenteId.toString(),
        'limit': limit.toString(),
        'lang': lang,
      });

      final res = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
      debugPrint('lista_notifiche: ${res.statusCode} ${res.body}');

      if (res.statusCode != 200) return;

      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) return;

      if (decoded['ok'] != true) return;

      final items = decoded['items'];
      if (items is! List) return;

      final serverList = items
          .whereType<Map<String, dynamic>>()
          .map((j) => AppNotification.fromJson(j))
          .toList();

      // Ordina: più recenti prima
      serverList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Limite massimo
      _notifications = serverList.take(_maxNotifications).toList();

      _controller.add(_notifications);
    } catch (_) {
      // Silenzioso: niente crash se rete/JSON non ok
    }
  }

  //---------------------------------------------------------------------
  // Segna come letta una notifica sul backend.
  // - Richiede utenteId + token (utente loggato).
  //----------------------------------------------------------------------
  Future<void> markAsReadRemote({
    required int utenteId,
    required String token,
    required String id,
    required String baseUrl,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/notifica_letta.php');

      final res = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'utente_id': utenteId,
          'id': int.tryParse(id) ?? id,
        }),
      );
      debugPrint('markAsReadRemote: ${res.statusCode} ${res.body}');
    } catch (_) {
      // Silenzioso
    }
  }

  //---------------------------------------------------------------------
  // Segna tutte come lette sul backend.
  // - Richiede utenteId + token (utente loggato).
  //----------------------------------------------------------------------
  Future<void> markAllAsReadRemote({
    required int utenteId,
    required String token,
    required String baseUrl,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/notifica_letta_all.php');

      final res = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'utente_id': utenteId,
        }),
      );
      debugPrint('markAllAsReadRemote: ${res.statusCode} ${res.body}');
    } catch (_) {
      // Silenzioso
    }
  }

  //---------------------------------------------------------------------
  // Segna tutte come lette sia localmente che sul backend.
  // Elimina tutte le notifiche sul backend.
  // - Richiede utenteId + token (utente loggato).
  //----------------------------------------------------------------------
  Future<void> deleteAllRemote({
    required int utenteId,
    required String token,
    required String baseUrl,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/notifica_delete_all.php');

      final res = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'utente_id': utenteId,
        }),
      );
      debugPrint('deleteAllRemote: ${res.statusCode} ${res.body}');
    } catch (_) {
      // Silenzioso
    }
  }
}
