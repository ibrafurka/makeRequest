import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/main_providers.dart';
import '../providers/set_alarm_providers.dart';

class CheckPeriodTypeDropDownButtonWidget extends ConsumerWidget {
  const CheckPeriodTypeDropDownButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      value: ref.watch(alarmCheckPeriodTypeProvider),
      items: const [
        DropdownMenuItem(value: 'second', child: Text('Second')),
        DropdownMenuItem(value: 'minute', child: Text('Minute')),
        DropdownMenuItem(value: 'hour', child: Text('Hour')),
      ],
      onChanged: (value) {
        ref.read(alarmCheckPeriodTypeProvider.notifier).state =
            value.toString();
      },
      elevation: 9,
      style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 0.019.sh,
          fontWeight: FontWeight.w300),
      iconEnabledColor: ref.read(primaryColorProvider),
      dropdownColor: const Color(0xFF0F0F0F),
      underline: Container(),
      alignment: Alignment.center,
    );
  }
}
