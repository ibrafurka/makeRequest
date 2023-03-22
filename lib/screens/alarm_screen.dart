import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/alarm_model.dart';
import '../providers/home_screen_providers.dart';
import '../providers/main_providers.dart';
import '../providers/make_request_screen_providers.dart';
import '../providers/set_alarm_providers.dart';
import '../widgets/go_back_button_widget.dart';
import '../widgets/set_alarm_screen_text_form_field_widget.dart';

class AlarmScreen extends ConsumerWidget {
  final Map<String, dynamic> arguments;

  const AlarmScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String requestName = '';
    String keys = 'Keys: ';
    String valueRunTimeType = '';
    if (arguments.containsKey('responseKeys')) {
      requestName = ref
          .read(homeScreenListManagerProvider)
          .firstWhere((element) =>
              element.requestId == ref.watch(alarmRequestIdProvider))
          .requestName;

      for (int i = 0; i < arguments['responseKeys'].length; i++) {
        if (i < arguments['responseKeys'].length - 1) {
          keys += '${arguments['responseKeys'][i]} -> ';
        } else {
          keys += '${arguments['responseKeys'][i]}';
        }
      }

      valueRunTimeType = ref.watch(valueRunTimeTypeProvider);
    } else {
      AlarmModel alarm = AlarmModel.fromJson(arguments);

      requestName = ref
          .read(homeScreenListManagerProvider)
          .firstWhere((element) => element.requestId == alarm.requestId)
          .requestName;

      for (int i = 0; i < alarm.dataToCheck.length; i++) {
        if (i < alarm.dataToCheck.length - 1) {
          keys += '${alarm.dataToCheck[i]} -> ';
        } else {
          keys += alarm.dataToCheck[i];
        }
      }

      valueRunTimeType = alarm.runTimeTypeOfDataToCheck;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Theme(
        data: ThemeData(
            colorScheme: ColorScheme.dark(
          background: ref.read(primaryColorLightProvider),
        ).copyWith()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  Text(
                    'Set Alarm',
                    style: ref.read(homeTitleTextStyleProvider),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 0.015.sw,
                      left: 0.015.sw,
                      bottom: 0.005.sh,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Icon(
                                Icons.request_page,
                                color: Colors.green.withOpacity(0.7),
                                size: 0.03.sw,
                              ),
                            ),
                            SizedBox(
                              width: 0.015.sw,
                            ),
                            Expanded(
                              flex: 7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  'Request: $requestName',
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 0.025.sw),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.005.sh,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Icon(
                                Icons.key,
                                color: Colors.deepOrange.withOpacity(0.7),
                                size: 0.03.sw,
                              ),
                            ),
                            SizedBox(
                              width: 0.015.sw,
                            ),
                            Expanded(
                              flex: 7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  keys,
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 0.025.sw),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.005.sh,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Icon(
                                Icons.type_specimen,
                                color: Colors.blue.withOpacity(0.7),
                                size: 0.03.sw,
                              ),
                            ),
                            SizedBox(
                              width: 0.015.sw,
                            ),
                            Expanded(
                              flex: 7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  'Value Run Time Type: $valueRunTimeType',
                                  style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 0.025.sw),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SetAlarmTextFormFieldWidget(arguments: arguments),
                  SizedBox(
                    height: 0.035.sh,
                  ),
                  const GoBackButtonWidget(returnPage: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
