import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/main_providers.dart';
import '../providers/set_alarm_providers.dart';

class ChooseOperatorDropDownButtonWidget extends ConsumerWidget {

  const ChooseOperatorDropDownButtonWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      value: ref.watch(alarmOperatorProvider),
      items: const [
        DropdownMenuItem(
          value: '==',
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('== (is equal to)'),
            ),
          ),
        ),
        DropdownMenuItem(
          value: '!=',
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('!= (is not equal to)'),
            ),
          ),
        ),
        DropdownMenuItem(
          value: '<',
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('< (is less than)'),
            ),
          ),
        ),
        DropdownMenuItem(
          value: '>',
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('> (is greater than)'),
            ),
          ),
        ),
        DropdownMenuItem(
          value: '<=',
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('<= (is less than or equal to)'),
            ),
          ),
        ),
        DropdownMenuItem(
          value: '>=',
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('>= (is more than or equal to)'),
            ),
          ),
        ),
      ],
      onChanged: (value) {
        ref.read(alarmOperatorProvider.notifier).state = value!;
      },
      elevation: 0,
      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 0.023.sh, fontWeight: FontWeight.w300),
      iconEnabledColor: ref.read(primaryColorProvider),
      dropdownColor: const Color(0xFF202124),
      underline: Container(),
      alignment: Alignment.center,
      isExpanded: true,
      borderRadius: BorderRadius.all(
        Radius.circular(0.0125.sw),
      ),
    );
  }
}
