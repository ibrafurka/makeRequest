import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi extends ChangeNotifier {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    AndroidInitializationSettings androidInitialize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iOSInitialize =
        new DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        debugPrint('onDidReceiveLocalNotification called.');
      },
    );
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showBigTextNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required String sound,
    var payload,
  }) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    final BigTextStyleInformation longData = BigTextStyleInformation(body);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      channelId,
      channelName,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(sound),
      vibrationPattern: vibrationPattern,
      enableVibration: true,
      channelShowBadge: true,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 255, 255),
      ledColor: const Color.fromARGB(255, 255, 255, 255),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: longData,
      icon: '@mipmap/ic_launcher',
    );

    DarwinNotificationDetails darwinNotificationDetails =
        new DarwinNotificationDetails(
      sound: sound,
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      subtitle: title,
      interruptionLevel: InterruptionLevel.critical,
    );

    NotificationDetails notificationDetails = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(id, title, body, await notificationDetails, payload: payload);
  }
}
