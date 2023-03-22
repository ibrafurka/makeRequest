import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:make_a_req/providers/notification_api.dart';
import 'package:make_a_req/services/request_service.dart';
import 'package:intl/intl.dart';

import 'model/alarm_model.dart';
import 'model/request_model.dart';

class MyBackgroundService {
  static Map<String, Timer> timers = <String, Timer>{};

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            iOS: DarwinInitializationSettings(
                requestAlertPermission: false,
                requestBadgePermission: false,
                requestSoundPermission: false,
                onDidReceiveLocalNotification: (int? id, String? title,
                    String? body, String? payload) async {})),
      );
    }

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      );
    }

    await Hive.initFlutter('makeAReq');
    Hive.registerAdapter(RequestModelAdapter());
    Hive.registerAdapter(AlarmModelAdapter());
    await Hive.openBox<RequestModel>('requests');
    await Hive.openBox<AlarmModel>('alarms');

    List<RequestModel> requests =
        Hive.box<RequestModel>('requests').values.toList();

    List<AlarmModel> alarms = Hive.box<AlarmModel>('alarms').values.toList();

    for (AlarmModel alarm in alarms) {
      if (alarm.isActive) {
        RequestModel request = requests
            .firstWhere((element) => element.requestId == alarm.requestId);

        String alarmTitle = '${request.requestName}';
        for (String reqKeys in alarm.dataToCheck) {
          alarmTitle += ' > $reqKeys';
        }
        DateTime now = DateTime.now();
        alarmTitle += ' - ${DateFormat('HH:mm dd/MM/yyyy').format(now)}';

        timers[alarm.alarmId] = Timer.periodic(
            alarm.checkPeriodType == 'second'
                ? Duration(seconds: int.tryParse(alarm.checkPeriod) ?? 30)
                : alarm.checkPeriodType == 'minute'
                    ? Duration(minutes: int.tryParse(alarm.checkPeriod) ?? 5)
                    : Duration(hours: int.tryParse(alarm.checkPeriod) ?? 1),
            (timer) async {
          Map<String, dynamic> response =
              await MakeRequestApi.makeRequest(requestModel: request);

          dynamic valueToCompare =
              MakeRequestApi.getValue(alarm.dataToCheck, response);

          if (MakeRequestApi.compareValues(
              valueToCompare.toString(),
              alarm.valueToCompare,
              alarm.comparisonOperator,
              alarm.runTimeTypeOfDataToCheck)) {
            NotificationApi.showBigTextNotification(
              id: alarm.alarmNotificationId,
              title: alarmTitle,
              body:
                  'Condition ${valueToCompare} ${alarm.comparisonOperator} ${alarm.valueToCompare} is true! Please check your stats.',
              channelId: alarm.alarmId,
              channelName: alarm.alarmName,
              sound: 'mynoti',
            );

            // flutterLocalNotificationsPlugin.show(
            //   alarm.alarmNotificationId,
            //   alarmTitle,
            //   'Condition ${valueToCompare} ${alarm.comparisonOperator} ${alarm.valueToCompare} is true! Please check your stats.',
            //   NotificationDetails(
            //     android: AndroidNotificationDetails(
            //         alarm.alarmId, alarm.alarmName,
            //         icon: '@mipmap/ic_launcher',
            //         enableVibration: true,
            //         vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            //         importance: Importance.max,
            //         priority: Priority.high,
            //         showWhen: false,
            //         enableLights: true,
            //         color: const Color(0xFFFFFFFF),
            //         ledColor: const Color.fromARGB(255, 255, 0, 0),
            //         ledOnMs: 1000,
            //         ledOffMs: 500),
            //     iOS: DarwinNotificationDetails(
            //       presentAlert: true,
            //       presentBadge: true,
            //       presentSound: true,
            //       interruptionLevel: InterruptionLevel.critical,
            //     ),
            //   ),
            // );
          }
        });
      }
    }

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    service.on('setAlarm').listen((event) async {
      event!['alarm']['dataToCheck'] =
          (event['alarm']['dataToCheck'] as List<dynamic>)
              .map((e) => e.toString())
              .toList();

      final AlarmModel alarm = AlarmModel.fromJson(event['alarm']);

      final RequestModel request = RequestModel.fromJson(event['request']);

      timers[alarm.alarmId] = Timer.periodic(
          alarm.checkPeriodType == 'second'
              ? Duration(seconds: int.tryParse(alarm.checkPeriod) ?? 30)
              : alarm.checkPeriodType == 'minute'
                  ? Duration(minutes: int.tryParse(alarm.checkPeriod) ?? 5)
                  : Duration(hours: int.tryParse(alarm.checkPeriod) ?? 1),
          (timer) async {
        String alarmTitle = '${request.requestName}';
        for (String reqKeys in alarm.dataToCheck) {
          alarmTitle += ' > $reqKeys';
        }

        DateTime now = DateTime.now();

        alarmTitle += ' - ${DateFormat('HH:mm dd/MM/yyyy').format(now)}';

        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            Map<String, dynamic> response =
                await MakeRequestApi.makeRequest(requestModel: request);

            dynamic valueToCompare =
                MakeRequestApi.getValue(alarm.dataToCheck, response);

            if (MakeRequestApi.compareValues(
                valueToCompare.toString(),
                alarm.valueToCompare,
                alarm.comparisonOperator,
                alarm.runTimeTypeOfDataToCheck)) {
              NotificationApi.showBigTextNotification(
                id: alarm.alarmNotificationId,
                title: alarmTitle,
                body:
                    'Condition ${valueToCompare} ${alarm.comparisonOperator} ${alarm.valueToCompare} is true! Please check your stats.',
                channelId: alarm.alarmId,
                channelName: alarm.alarmName,
                sound: 'mynoti',
              );

              //   flutterLocalNotificationsPlugin.show(
              //     alarm.alarmNotificationId,
              //     alarmTitle,
              //     'Condition ${valueToCompare} ${alarm.comparisonOperator} ${alarm.valueToCompare} is true! Please check your stats.',
              //     NotificationDetails(
              //       android: AndroidNotificationDetails(
              //           alarm.alarmId, alarm.alarmName,
              //           icon: '@mipmap/ic_launcher',
              //           enableVibration: true,
              //           vibrationPattern:
              //               Int64List.fromList([0, 1000, 500, 1000]),
              //           importance: Importance.max,
              //           priority: Priority.high,
              //           showWhen: false,
              //           enableLights: true,
              //           color: const Color(0xFFFFFFFF),
              //           ledColor: const Color.fromARGB(255, 255, 0, 0),
              //           ledOnMs: 1000,
              //           ledOffMs: 500),
              //     ),
              //   );
            }
          }
        } else {
          Map<String, dynamic> response =
              await MakeRequestApi.makeRequest(requestModel: request);

          dynamic valueToCompare =
              MakeRequestApi.getValue(alarm.dataToCheck, response);

          if (MakeRequestApi.compareValues(
              valueToCompare.toString(),
              alarm.valueToCompare,
              alarm.comparisonOperator,
              alarm.runTimeTypeOfDataToCheck)) {
            NotificationApi.showBigTextNotification(
              id: alarm.alarmNotificationId,
              title: alarmTitle,
              body:
                  'Condition ${valueToCompare} ${alarm.comparisonOperator} ${alarm.valueToCompare} is true! Please check your stats.',
              channelId: alarm.alarmId,
              channelName: alarm.alarmName,
              sound: 'mynoti',
            );

            // flutterLocalNotificationsPlugin.show(
            //     alarm.alarmNotificationId,
            //     alarmTitle,
            //     'Condition ${valueToCompare} ${alarm.comparisonOperator} ${alarm.valueToCompare} is true! Please check your stats.',
            //     NotificationDetails(
            //       iOS: DarwinNotificationDetails(
            //         presentAlert: true,
            //         presentBadge: true,
            //         presentSound: true,
            //         interruptionLevel: InterruptionLevel.critical,
            //       ),
            //     ));
          }
        }
      });
    });

    service.on('removeAlarm').listen((event) async {
      final String alarmId = event!['alarmId'].toString();
      event['alarmNotificationId'] != null
          ? flutterLocalNotificationsPlugin.cancel(event['alarmNotificationId'])
          : null;
      timers[alarmId]?.cancel();
    });
  }
}
