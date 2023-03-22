import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/main_providers.dart';
import '../providers/set_alarm_providers.dart';

class ValueToCompareTextFormFieldWidget extends ConsumerWidget {
  final GlobalKey<FormFieldState> formFieldKey;
  final String? initialValue;
  const ValueToCompareTextFormFieldWidget({Key? key, required this.formFieldKey,this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return
      TextFormField(
        key: formFieldKey,
        initialValue: initialValue ?? initialValue,
        keyboardType: (ref.watch(valueRunTimeTypeProvider) == 'int') ? TextInputType.number : TextInputType.text,
        inputFormatters: (ref.watch(valueRunTimeTypeProvider) == 'int') ? [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
          TextInputFormatter.withFunction(
                (oldValue, newValue) => newValue.copyWith(
              text: newValue.text.replaceAll('.', ','),
            ),
          ),
        ] : null,
        cursorHeight: 0.027.sh,
        cursorColor: ref.read(primaryColorLightProvider),
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 0.02.sh),
        validator: (s) {
          if (s!.isEmpty) {
            return 'Value to compare cannot be empty!';
          }
          return null;
        },
        onSaved: (enteredValue) {
          ref.read(alarmCompareValueProvider.notifier).state = enteredValue!;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 0.013.sh,
          ),
          prefixIcon: Icon(
            Icons.compare_arrows,
            color: ref.read(primaryColorLightProvider),
            size: 0.05.sh,
          ),
          floatingLabelAlignment: FloatingLabelAlignment.center,
          hintText: 'Write your alarm name here.',
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
