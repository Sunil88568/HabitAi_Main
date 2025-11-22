import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter/foundation.dart';
import 'package:habitai/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final data = message.data;
  final habitId = (data['habitId'] ?? '') as String;
  final title = message.notification?.title ?? data['title'] ?? 'Habit Nudge';
  final body = message.notification?.body ?? data['body'] ?? 'Time for your habit';

  if (habitId.isNotEmpty) {
    await NotificationService().showRateLimitedNotification(habitId, title, body);
  } else {
    await NotificationService().showRateLimitedNotification('push_generic', title, body);
  }
}

class PushService {
  static final PushService _instance = PushService._internal();
  factory PushService() => _instance;
  PushService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      // Request permissions (iOS)
      await _fcm.requestPermission(alert: true, badge: true, sound: true);

      // Register background handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Foreground messages → convert to local notification
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final data = message.data;
        final habitId = (data['habitId'] ?? '') as String;
        final title = message.notification?.title ?? data['title'] ?? 'Habit Nudge';
        final body = message.notification?.body ?? data['body'] ?? 'Time for your habit';

        if (habitId.isNotEmpty) {
          NotificationService().showRateLimitedNotification(habitId, title, body);
        } else {
          NotificationService().showRateLimitedNotification('push_generic', title, body);
        }
      });

      // When the user taps a notification and opens the app
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final data = message.data;
        final habitId = (data['habitId'] ?? '') as String;
        if (habitId.isNotEmpty) {
          NotificationService().handleSelectNotification(habitId);
        }
      });

      final token = await _fcm.getToken();
      if (kDebugMode) print('FCM token: $token');
    } catch (e, st) {
      if (kDebugMode) print('PushService.init failed: $e\n$st');
    }
  }
}

