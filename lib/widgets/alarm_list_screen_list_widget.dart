import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/alarm_model.dart';
import '../model/request_model.dart';
import '../providers/alarm_list_screen_manager.dart';
import '../providers/main_providers.dart';
import '../providers/make_request_screen_providers.dart';

class AlarmListScreenListWidget extends ConsumerWidget {
  const AlarmListScreenListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<AlarmModel> alarms = ref.watch(alarmListScreenManagerProvider);
    return (alarms.isEmpty)
        ? Center(
            child: Container(
              padding: EdgeInsets.all(0.025.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 0.1.sh,
                    color: Colors.amber.withOpacity(0.7),
                  ),
                  SizedBox(
                    height: 0.025.sh,
                  ),
                  Text(
                    'No Alarm Yet!',
                    style: TextStyle(
                      fontSize: 0.025.sh,
                      color: ref.read(primaryColorProvider),
                    ),
                  ),
                  SizedBox(
                    height: 0.025.sh,
                  ),
                  Text(
                    'To set an alarm, double-click the keys on the response page and go to the set alarm page.',
                    style: TextStyle(
                      fontSize: 0.016.sh,
                      color: ref.read(primaryColorProvider),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 0.12.sh),
            itemCount: alarms.length,
            itemBuilder: (BuildContext context, int index) {
              AlarmModel alarm = alarms[alarms.length - index - 1];
              RequestModel request = ref
                  .watch(homeScreenListManagerProvider)
                  .firstWhere(
                      (element) => element.requestId == alarm.requestId);
              String subtitleText = '${request.requestName}/';
              for (int i = 0; i < alarm.dataToCheck.length; i++) {
                if (i != alarm.dataToCheck.length - 1) {
                  subtitleText += '${alarm.dataToCheck[i]}/';
                } else {
                  subtitleText += alarm.dataToCheck[i];
                }
              }
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (a) {
                  if (a == DismissDirection.startToEnd) {
                    ref
                        .read(alarmListScreenManagerProvider.notifier)
                        .removeAlarmModelList(alarm);
                    if (alarm.isActive) {
                      FlutterBackgroundService().invoke('removeAlarm', {
                        'alarmId': alarm.alarmId,
                        'alarmNotificationId': alarm.alarmNotificationId
                      });
                    }
                  } else if (a == DismissDirection.endToStart) {
                    Navigator.pushReplacementNamed(context, 'set-alarm',
                        arguments: alarm.toJson());
                  }
                },
                secondaryBackground: Container(
                  color: const Color(0xffF2CB02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 0.01.sw,
                      ),
                      const Text(
                        'Edit Alarm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 0.02.sw,
                      ),
                    ],
                  ),
                ),
                background: Container(
                  color: const Color(0xffD42B2B),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 0.02.sw,
                      ),
                      const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 0.01.sw,
                      ),
                      const Text(
                        'Delete Alarm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F0F),
                    border: (index == alarms.length - 1)
                        ? Border(
                            top: BorderSide(
                              width: 0.00035.sh,
                              color: Colors.white12,
                            ),
                            bottom: BorderSide(
                              width: 0.00035.sh,
                              color: Colors.white12,
                            ),
                          )
                        : Border(
                            top: BorderSide(
                              width: 0.00035.sh,
                              color: Colors.white12,
                            ),
                          ),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          maxLines: 1,
                          alarm.alarmName,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(
                              color: ref.read(primaryColorProvider).withOpacity(
                                  ref.watch(activePassiveAlarmOpacityProvider(
                                      alarm.isActive))),
                              fontSize: 0.04.sw),
                        ),
                        const Spacer(),
                        Text(
                          'period: ${alarm.checkPeriod} ${alarm.checkPeriodType}' +
                              (((int.tryParse(alarm.checkPeriod) ?? 0) > 1)
                                  ? 's'
                                  : ''),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.grey.withOpacity(ref.watch(
                                  activePassiveAlarmOpacityProvider(
                                      alarm.isActive))),
                              fontSize: 0.027.sw),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              maxLines: 1,
                              'if: $subtitleText ${alarm.comparisonOperator} ${alarm.valueToCompare}',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.grey.withOpacity(ref.watch(
                                    activePassiveAlarmOpacityProvider(
                                        alarm.isActive))),
                                fontSize: 0.033.sw,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.001.sw),
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(
                                25,
                                34,
                                83,
                                ref.watch(activePassiveAlarmOpacityProvider(
                                    alarm.isActive))),
                            child: Text(
                              alarm.runTimeTypeOfDataToCheck,
                              style: TextStyle(
                                  color: ref
                                      .read(primaryColorProvider)
                                      .withOpacity(ref.watch(
                                          activePassiveAlarmOpacityProvider(
                                              alarm.isActive))),
                                  fontSize: 0.033.sw,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.001.sw),
                          child: Switch(
                            value: alarm.isActive,
                            onChanged: (value) {
                              final int alarmNotificationId =
                                  Random().nextInt(100000);
                              AlarmModel newAlarm = AlarmModel(
                                alarmId: alarm.alarmId,
                                requestId: alarm.requestId,
                                alarmNotificationId: alarmNotificationId,
                                dataToCheck: alarm.dataToCheck,
                                runTimeTypeOfDataToCheck:
                                    alarm.runTimeTypeOfDataToCheck,
                                alarmName: alarm.alarmName,
                                comparisonOperator: alarm.comparisonOperator,
                                valueToCompare: alarm.valueToCompare,
                                checkPeriod: alarm.checkPeriod,
                                checkPeriodType: alarm.checkPeriodType,
                                isActive: !alarm.isActive,
                              );

                              if (alarm.isActive) {
                                FlutterBackgroundService().invoke(
                                    'removeAlarm', {
                                  'alarmId': alarm.alarmId,
                                  'alarmNotificationId':
                                      alarm.alarmNotificationId
                                });
                              } else {
                                FlutterBackgroundService().invoke("setAlarm",
                                    {"alarm": alarm, 'request': request});
                              }

                              ref
                                  .read(alarmListScreenManagerProvider.notifier)
                                  .updateAlarmModelList(newAlarm);
                            },
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.withOpacity(0.3),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
