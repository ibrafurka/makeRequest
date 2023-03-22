 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/main_providers.dart';

class RequestNameTextFormFieldWidget extends ConsumerWidget {
  final TextEditingController requestNameController;
  const RequestNameTextFormFieldWidget({Key? key, required this.requestNameController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: requestNameController,
      cursorHeight: 0.027.sh,
      cursorColor: ref.read(primaryColorLightProvider),
      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 0.02.sh),
      validator: (s) {
        if (s!.isEmpty) {
          return 'Request name cannot be empty!';
        } else if (s.length > 35) {
          return 'Request name cannot be more than 35 characters!';
        } else if (s.length < 3) {
          return 'Request name cannot be less than 3 characters!';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 0.013.sh,
        ),
        prefixIcon: Icon(
          Icons.abc,
          color: ref.read(primaryColorLightProvider),
          size: 0.05.sh,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        hintText: 'Write your request name here.',
        hintStyle:
        TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 0.02.sh),
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