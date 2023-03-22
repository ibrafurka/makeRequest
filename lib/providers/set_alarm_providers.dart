import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentStepStateProvider = StateProvider<int>((ref) => 0);
final alarmNameProvider = StateProvider<String>((ref) => 'No Name');
final alarmOperatorProvider = StateProvider<String>((ref) => '==');
final alarmCompareValueProvider = StateProvider<String>((ref) => 'No Value');
final alarmCheckPeriodProvider = StateProvider<String>((ref) => 'No Period');
final alarmCheckPeriodTypeProvider = StateProvider<String>((ref) => 'minute');
final errorCheckProvider = StateProvider<bool>((ref) => false);
final isCheckedProvider = StateProvider<bool>((ref) => false);
final valueRunTimeTypeProvider = StateProvider<String>((ref) => 'String');
final alarmRequestIdProvider = StateProvider<String>((ref) => 'No Id');
