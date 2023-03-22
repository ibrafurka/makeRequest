import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../model/alarm_model.dart';

class AlarmListScreenNotifier extends StateNotifier<List<AlarmModel>> {
  Ref ref;

  AlarmListScreenNotifier(
      {List<AlarmModel>? initialRequests, required this.ref})
      : super(initialRequests ?? []);

  Future<void> saveAlarmModelList(AlarmModel alarm) async {
    state = [...state, alarm];
    Box box = await Hive.openBox<AlarmModel>('alarms');
    await box.put(alarm.alarmId, alarm);
  }

  Future<void> removeAlarmModelList(AlarmModel alarm) async {
    state = state.where((element) => element != alarm).toList();
    Box box = await Hive.openBox<AlarmModel>('alarms');
    await box.delete(alarm.alarmId);
  }

  Future<void> readInitialAlarmList() async {
    Box box = await Hive.openBox<AlarmModel>('alarms');
    state = [];
    box.toMap().forEach((key, value) {
      state = [...state, value];
    });
  }

  Future<void> updateAlarmModelList(AlarmModel alarm) async {
    state = state
        .map((element) => element.alarmId == alarm.alarmId ? alarm : element)
        .toList();
    Box box = await Hive.openBox<AlarmModel>('alarms');
    box.put(alarm.alarmId, alarm);
  }
}

final alarmListScreenManagerProvider =
    StateNotifierProvider<AlarmListScreenNotifier, List<AlarmModel>>((ref) {
  return AlarmListScreenNotifier(
    ref: ref,
  );
});

final activePassiveAlarmOpacityProvider = Provider.family<double, bool>(
    (ref, isActive) => (isActive == true) ? 1 : 0.5);
