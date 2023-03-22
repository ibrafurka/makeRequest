import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_a_req/providers/make_request_screen_providers.dart';
import 'package:make_a_req/widgets/set_alarm_custom_elevated_button_widget.dart';
import 'package:uuid/uuid.dart';

import '../model/alarm_model.dart';
import '../providers/alarm_list_screen_manager.dart';
import '../providers/main_providers.dart';
import '../providers/set_alarm_providers.dart';
import 'alarm_name_text_form_field_widget.dart';
import 'check_period_text_form_field_widget.dart';
import 'check_period_type_drop_down_button_widget.dart';
import 'value_to_compare_text_form_field_widget.dart';
import 'choose_operator_drop_down_button_widget.dart';

class SetAlarmTextFormFieldWidget extends ConsumerStatefulWidget {
  final Map<String, dynamic> arguments;

  SetAlarmTextFormFieldWidget({Key? key, required this.arguments})
      : super(key: key);

  final alarmNameKey = GlobalKey<FormFieldState>();
  final valueCompareKey = GlobalKey<FormFieldState>();
  final checkPeriodKey = GlobalKey<FormFieldState>();

  @override
  ConsumerState createState() => _SetAlarmTextFormFieldWidgetState();
}

class _SetAlarmTextFormFieldWidgetState
    extends ConsumerState<SetAlarmTextFormFieldWidget>
    with SingleTickerProviderStateMixin {
  late List<Step> allSteps;
  AlarmModel? alarm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initAlarm();
  }

  void initAlarm() {
    if (!widget.arguments.containsKey('responseKeys')) {
      alarm = AlarmModel.fromJson(widget.arguments);
      Future.delayed(Duration.zero, () {
        ref.read(alarmOperatorProvider.notifier).state =
            alarm!.comparisonOperator;
        ref.read(valueRunTimeTypeProvider.notifier).state =
            alarm!.runTimeTypeOfDataToCheck;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.arguments.containsKey('responseKeys')) {
      allSteps = _allSteps(ref: ref, alarm: alarm);
    } else {
      allSteps = _allSteps(
        ref: ref,
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Stepper(
        physics: const ClampingScrollPhysics(),
        currentStep: ref.watch(currentStepStateProvider),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SetAlarmCustomElevatedButtonWidget(
                onPressed: details.onStepContinue,
                firstColor: Colors.indigo,
                secondColor: Colors.blueAccent,
                textString: (ref.watch(currentStepStateProvider) != 3)
                    ? 'NEXT'
                    : 'SAVE',
              ),
              SizedBox(width: 0.05.sw),
              (ref.watch(currentStepStateProvider) != 0)
                  ? SetAlarmCustomElevatedButtonWidget(
                      onPressed: details.onStepCancel,
                      firstColor: const Color.fromRGBO(179, 5, 1, 1),
                      secondColor: Colors.redAccent,
                      textString: 'BACK',
                    )
                  : Container(),
            ],
          );
        },
        steps: allSteps,
        onStepContinue: () {
          _continueButtonControl(alarm: alarm);
        },
        onStepCancel: () {
          if (ref.watch(currentStepStateProvider) > 0) {
            ref.read(currentStepStateProvider.notifier).state--;
          }
        },
      ),
    );
  }

  List<Step> _allSteps({required WidgetRef ref, AlarmModel? alarm}) {
    return <Step>[
      Step(
        title: const Text('Alarm Name'),
        subtitle: Text(
          'Please write as a minimum of 3, characters and a maximum of 30 characters.',
          style: TextStyle(fontSize: 0.011.sh),
        ),
        state: _adjustStepState(0),
        content: Container(
          margin: EdgeInsets.only(right: 0.035.sw),
          height: 0.09.sh,
          child: AlarmNameTextFormFieldWidget(
            formFieldKey: widget.alarmNameKey,
            initialValue: alarm?.alarmName,
          ),
        ),
      ),
      Step(
        title: const Text('Choose Operator'),
        state: _adjustStepState(1),
        subtitle: Text(
          'Select one of operators to compare value. Only == (is equal to) and != (is not equal to) can be used if the run time type is string!',
          style: TextStyle(fontSize: 0.011.sh),
        ),
        content: Container(
          margin: EdgeInsets.only(right: 0.035.sw, bottom: 0.015.sh),
          padding: EdgeInsets.all(0.00075.sh),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(0.0125.sw),
            ),
            color: ref.read(primaryColorLightProvider),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.all(
                Radius.circular(0.0125.sw),
              ),
            ),
            child: const ChooseOperatorDropDownButtonWidget(),
          ),
        ),
      ),
      Step(
        title: const Text('Value to compare'),
        state: _adjustStepState(2),
        subtitle: Text(
          'The alarm will be activated by comparing this value with the value in the request. Value type must be the same as run time type.',
          style: TextStyle(fontSize: 0.011.sh),
        ),
        content: Container(
          margin: EdgeInsets.only(right: 0.035.sw),
          height: 0.09.sh,
          child: ValueToCompareTextFormFieldWidget(
            formFieldKey: widget.valueCompareKey,
            initialValue: alarm?.valueToCompare,
          ),
        ),
      ),
      Step(
        title: const Text('Range to check'),
        state: _adjustStepState(3),
        subtitle: Text(
          'The default check period is 30 seconds if seconds, 5 minutes if minutes, and 1 hour if hours. The value you enter must be a number.',
          style: TextStyle(fontSize: 0.011.sh),
        ),
        content: Container(
          margin: EdgeInsets.only(right: 0.035.sw),
          height: 0.09.sh,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 0.0125.sw),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0125.sw),
                    topRight: Radius.circular(0.0125.sw),
                    bottomLeft: Radius.circular(5.r),
                  ),
                  color: ref.read(primaryColorLightProvider),
                ),
                child: CheckPeriodTypeDropDownButtonWidget(),
              ),
              Expanded(
                child: CheckPeriodTextFormFieldWidget(
                  formFieldKey: widget.checkPeriodKey,
                  initialValue: alarm?.checkPeriod,
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }

  StepState _adjustStepState(int currentStep) {
    if (ref.read(currentStepStateProvider) == currentStep) {
      if (ref.watch(errorCheckProvider)) {
        return StepState.error;
      } else {
        return StepState.editing;
      }
    } else if (ref.read(currentStepStateProvider) > currentStep) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  void _continueButtonControl({AlarmModel? alarm}) {
    switch (ref.watch(currentStepStateProvider)) {
      case 0:
        if (widget.alarmNameKey.currentState!.validate()) {
          //debugPrint('Set Alarm Screen: ${widget.alarmNameKey.currentState!.value}');
          widget.alarmNameKey.currentState!.save();
          ref.read(errorCheckProvider.notifier).state = false;
          ref.watch(currentStepStateProvider.notifier).state++;
        } else {
          ref.read(errorCheckProvider.notifier).state = true;
        }
        break;
      case 1:
        if (ref.read(valueRunTimeTypeProvider) == 'String' ||
            ref.read(valueRunTimeTypeProvider) == 'bool') {
          if (ref.watch(alarmOperatorProvider) == '==' ||
              ref.watch(alarmOperatorProvider) == '!=') {
            ref.read(errorCheckProvider.notifier).state = false;
            ref.watch(currentStepStateProvider.notifier).state++;
          } else {
            ref.read(errorCheckProvider.notifier).state = true;
          }
        } else if (ref.read(valueRunTimeTypeProvider) == 'int') {
          ref.read(errorCheckProvider.notifier).state = false;
          ref.watch(currentStepStateProvider.notifier).state++;
        }
        break;
      case 2:
        if (widget.valueCompareKey.currentState!.validate()) {
          //debugPrint(widget.valueCompareKey.currentState!.value.toString());
          widget.valueCompareKey.currentState!.save();
          ref.read(errorCheckProvider.notifier).state = false;
          ref.watch(currentStepStateProvider.notifier).state++;
        } else {
          ref.read(errorCheckProvider.notifier).state = true;
        }
        break;
      case 3:
        if (widget.checkPeriodKey.currentState!.validate()) {
          //debugPrint(widget.checkPeriodKey.currentState!.value.toString());
          widget.checkPeriodKey.currentState!.save();
          ref.read(errorCheckProvider.notifier).state = false;
          ref.watch(currentStepStateProvider.notifier).state = 0;
          _formCompleted(alarm: alarm);
        } else {
          ref.read(errorCheckProvider.notifier).state = true;
        }
        break;
    }
  }

  void _formCompleted({AlarmModel? alarm}) async {
    AlarmModel generatedAlarm;
    final int alarmNotificationId = Random().nextInt(100000);

    if (widget.arguments.containsKey('responseKeys')) {
      generatedAlarm = AlarmModel(
        alarmId: const Uuid().v4(),
        requestId: ref.watch(alarmRequestIdProvider),
        alarmNotificationId: alarmNotificationId,
        dataToCheck: widget.arguments['responseKeys'],
        runTimeTypeOfDataToCheck: ref.watch(valueRunTimeTypeProvider),
        alarmName: ref.watch(alarmNameProvider),
        comparisonOperator: ref.watch(alarmOperatorProvider),
        valueToCompare: ref.watch(alarmCompareValueProvider),
        checkPeriod: ref.watch(alarmCheckPeriodProvider),
        checkPeriodType: ref.watch(alarmCheckPeriodTypeProvider),
        isActive: true,
      );

      await ref
          .read(alarmListScreenManagerProvider.notifier)
          .saveAlarmModelList(generatedAlarm);
    } else {
      FlutterBackgroundService()
          .invoke('removeAlarm', {'alarmId': alarm!.alarmId});

      generatedAlarm = AlarmModel(
        alarmId: alarm.alarmId,
        requestId: alarm.requestId,
        alarmNotificationId: alarmNotificationId,
        dataToCheck: alarm.dataToCheck,
        runTimeTypeOfDataToCheck: ref.watch(valueRunTimeTypeProvider),
        alarmName: ref.watch(alarmNameProvider),
        comparisonOperator: ref.watch(alarmOperatorProvider),
        valueToCompare: ref.watch(alarmCompareValueProvider),
        checkPeriod: ref.watch(alarmCheckPeriodProvider),
        checkPeriodType: ref.watch(alarmCheckPeriodTypeProvider),
        isActive: true,
      );

      await ref
          .read(alarmListScreenManagerProvider.notifier)
          .updateAlarmModelList(generatedAlarm);
    }

    FlutterBackgroundService().invoke("setAlarm", {
      "alarm": generatedAlarm,
      'request': ref.read(homeScreenListManagerProvider).firstWhere(
          (element) => element.requestId == generatedAlarm.requestId)
    });

    Navigator.pushReplacementNamed(context, 'home', arguments: 2);
  }
}
