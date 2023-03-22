import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/main_providers.dart';

class RequestUrlTextFormFieldWidget extends ConsumerWidget {
  final TextEditingController requestUrlController;
  const RequestUrlTextFormFieldWidget({Key? key, required this.requestUrlController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: requestUrlController,
      cursorHeight: 0.027.sh,
      cursorColor: ref.read(primaryColorLightProvider),
      style:
      TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 0.02.sh),
      validator: (s) {
        if (s!.isEmpty) {
          return 'Request url cannot be empty!';
        } else if (!s.startsWith('http://') && !s.startsWith('https://')) {
          return 'Request url must start with http:// or https://';
        } else if (s.contains(' ')) {
          return 'Request url cannot contain spaces!';
        } else if (s.length < 13) {
          return 'Request url is too short!';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 0.015.sh,
        ),
        prefixIcon: Icon(
          Icons.link,
          color: ref.read(primaryColorLightProvider),
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        hintText: 'Write your request url here.',
        hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5), fontSize: 0.02.sh),
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