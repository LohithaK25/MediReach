import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this once at app start (main.dart)
  static Future<void> initFCM(BuildContext context) async {
    // Request permission (Web & Mobile)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications");

      // Get the device token
      String? token = await _messaging.getToken();
      print("FCM Token: $token");
      // Save token to Firestore if you want to send notifications to this user
    } else {
      print("User declined or has not accepted notifications");
    }

    // Listen to messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title} - ${message.notification?.body}");

      // Show a simple SnackBar in app
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message.notification?.body ?? "New notification",
              maxLines: 2,
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  /// Get FCM device token (useful to send notifications to specific users)
  static Future<String?> getDeviceToken() async {
    return await _messaging.getToken();
  }
}
