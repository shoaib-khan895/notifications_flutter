import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_api.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      /*
      options: FirebaseOptions(
          apiKey: 'AIzaSyDqB-_vPwc7lOkdcJW8YQfgWDKFgeXeI_U',
          appId: '1:1022334788518:android:826bfeb5b9ff99cea6a567',
          messagingSenderId: '1022334788518',
          projectId: 'flutter-notification-9b075')*/
      );
  await FirebaseApi().initNotifications();

  // Initialization Settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification response
      openAppSettings(); // Opens app settings
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotificationDemo(),
    );
  }
}

class NotificationDemo extends StatelessWidget {
  const NotificationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications Demo')),
      body: const Center(
        child: ElevatedButton(
          onPressed: showNotification,
          child: Text('Schedule Notifications'),
        ),
      ),
    );
  }
}

void showNotification() {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    '10_sec_channel_id',
    '10_sec_channel_name',
    channelDescription: 'Notifications every 10 seconds',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: DarwinNotificationDetails(),
  );

  flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch % 100000,
    'Repeating Notification',
    'This notification repeats every 10 seconds.',
    // RepeatInterval.everyMinute,
    notificationDetails,
    // androidScheduleMode: AndroidScheduleMode.exact
  );
}

// enum AndroidScheduleMode {
//   /// Used to specify that the notification should be scheduled to be shown at
//   /// the exact time specified AND will execute whilst device is in
//   /// low-power idle mode. Requires SCHEDULE_EXACT_ALARM permission.
//   alarmClock,
//
//   /// Used to specify that the notification should be scheduled to be shown at
//   /// the exact time specified but may not execute whilst device is in
//   /// low-power idle mode.
//   exact,
//
//   /// Used to specify that the notification should be scheduled to be shown at
//   /// the exact time specified and will execute whilst device is in
//   /// low-power idle mode.
//   exactAllowWhileIdle,
//
//   /// Used to specify that the notification should be scheduled to be shown at
//   /// at roughly specified time but may not execute whilst device is in
//   /// low-power idle mode.
//   inexact,
//
//   /// Used to specify that the notification should be scheduled to be shown at
//   /// at roughly specified time and will execute whilst device is in
//   /// low-power idle mode.
//   inexactAllowWhileIdle,
// }
