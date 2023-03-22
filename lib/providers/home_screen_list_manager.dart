import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/alarm_model.dart';
import '../model/request_model.dart';
import 'alarm_list_screen_manager.dart';

class HomeScreenListNotifier extends StateNotifier<List<RequestModel>> {
  Ref ref;

  HomeScreenListNotifier(
      {List<RequestModel>? initialRequests, required this.ref})
      : super(initialRequests ?? []);

  void saveRequestModelList(RequestModel request) async {
    state = [...state, request];
    Box box = await Hive.openBox<RequestModel>('requests');
    await box.put(request.requestId, request);
  }

  void removeRequestModelList(RequestModel request) async {
    List<AlarmModel> alarms = ref
        .read(alarmListScreenManagerProvider)
        .where((element) => element.requestId == request.requestId)
        .toList();

    if (alarms.isNotEmpty) {
      for (AlarmModel alarm in alarms) {
        ref
            .read(alarmListScreenManagerProvider.notifier)
            .removeAlarmModelList(alarm);
        if (alarm.isActive) {
          FlutterBackgroundService().invoke('removeAlarm', {
            'alarmId': alarm.alarmId,
            'alarmNotificationId': alarm.alarmNotificationId
          });
        }
      }
    }

    state = state.where((element) => element != request).toList();
    Box box = await Hive.openBox<RequestModel>('requests');
    await box.delete(request.requestId);
  }

  Future<void> readInitialRequestList() async {
    Box box = await Hive.openBox<RequestModel>('requests');
    state = [];
    box.toMap().forEach((key, value) {
      state = [...state, value];
    });
  }

  void updateRequestModelList(RequestModel request) async {
    List<AlarmModel> alarms = ref
        .read(alarmListScreenManagerProvider)
        .where((element) => element.requestId == request.requestId)
        .toList();

    if (alarms.isNotEmpty) {
      for (AlarmModel alarm in alarms) {
        ref
            .read(alarmListScreenManagerProvider.notifier)
            .removeAlarmModelList(alarm);
        if (alarm.isActive) {
          FlutterBackgroundService().invoke('removeAlarm', {
            'alarmId': alarm.alarmId,
            'alarmNotificationId': alarm.alarmNotificationId
          });
        }
      }
    }
    state = state
        .map((element) =>
            element.requestId == request.requestId ? request : element)
        .toList();
    Box box = await Hive.openBox<RequestModel>('requests');
    await box.put(request.requestId, request);
  }
}
