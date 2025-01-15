import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      // Request Notification Permission
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');

        // Retrieve FCM Token
        final fcmToken = await firebaseMessaging.getToken();
        print('FCM Token: $fcmToken');

        // Listen for messages when the app is in the foreground
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Received a foreground notification: ${message.notification}');
        });

        // Handle notification clicks
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('Notification clicked! Data: ${message.data}');
          _handleNotificationClick(message);
        });

        // Check if the app was opened via a notification
        RemoteMessage? initialMessage =
            await firebaseMessaging.getInitialMessage();
        if (initialMessage != null) {
          print('App opened via notification: ${initialMessage.data}');
          _handleNotificationClick(initialMessage);
        }
      } else {
        print('User denied or has not granted permission');
      }

      // Register foreground notification for iOS
      if (Platform.isIOS) {
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  // Method to handle notification clicks
  void _handleNotificationClick(RemoteMessage message) {
    // Handle the notification click action
    // You can navigate to a specific screen or perform any desired action
    print('Notification Clicked: ${message.notification?.title}');
    print('Notification Data: ${message.data}');
  }
}
