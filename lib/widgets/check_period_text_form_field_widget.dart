import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/main_providers.dart';
import '../providers/set_alarm_providers.dart';

class CheckPeriodTextFormFieldWidget extends ConsumerWidget {
  final GlobalKey<FormFieldState> formFieldKey;
  final String? initialValue;
  const CheckPeriodTextFormFieldWidget({Key? key, required this.formFieldKey, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return TextFormField(
      key: formFieldKey,
      initialValue: initialValue ?? initialValue,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
        TextInputFormatter.withFunction(
              (oldValue, newValue) => newValue.copyWith(
            text: newValue.text.replaceAll('.', ','),
          ),
        ),
      ],
      cursorHeight: 0.027.sh,
      cursorColor: ref.read(primaryColorLightProvider),
      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 0.02.sh),
      validator: (s) {
        if (s!.isEmpty) {
          return 'Value to compare cannot be empty!';
        } else {
          return null;
        }
      },
      onSaved: (enteredValue) {
        ref.read(alarmCheckPeriodProvider.notifier).state = enteredValue!;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 0.013.sh,
        ),
        prefixIcon: Icon(
          Icons.timer,
          color: ref.read(primaryColorLightProvider),
          size: 0.025.sh,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        hintText: 'Write the data to be compared here.',
        hintStyle:
        TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 0.015.sh),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ref.read(primaryColorLightProvider).withOpacity(0.7), width: 0.0025.sw),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red.withOpacity(0.7), width: 0.0025.sw),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ref.read(primaryColorLightProvider), width: 0.0025.sw),
        ),
      ),
    );
  }
}
