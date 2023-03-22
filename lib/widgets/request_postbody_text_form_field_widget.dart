import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/main_providers.dart';

class RequestPostBodyTextFormFieldWidget extends ConsumerWidget {
  final TextEditingController requestPostBodyController;
  const RequestPostBodyTextFormFieldWidget({Key? key, required this.requestPostBodyController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: requestPostBodyController,
      minLines: 5,
      maxLines: 5,
      cursorHeight: 0.027.sh,
      cursorColor: ref.read(primaryColorLightProvider),
      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 0.02.sh),
      validator: (s) {
        if (s!.isNotEmpty) {
          if (s.contains('\n')) {
            List<String> sList = s.split('\n');
            if (sList.any((element) => element[element.length - 1] != ',')) {
              return 'You must separate lines with a comma!';
            }
            sList = sList.toSet().toList();
            sList.removeWhere((element) => element.isEmpty);
            if (sList.any((element) => element.contains(':') == false)) {
              return 'You must separate keys and values with a colon!';
            }
            sList.map((e) => e.split(':')).toList();
            if (sList.any((element) => element[0].isEmpty)) {
              return 'You must enter a value\'s key!';
            }
            if (sList.any((element) => element[1].isEmpty)) {
              return 'You must enter a key\'s value!';
            }
          } else {
            if (s.contains(':')) {
              return s.split(':').length != 2
                  ? 'You must separate key and value with a colon!'
                  : s.split(':')[0].isEmpty
                  ? 'You must enter a value\'s key!'
                  : s.split(':')[1].isEmpty
                  ? 'You must enter a key\'s value!'
                  : null;
            } else {
              return 'You must separate key and value with a colon!';
            }
          }
        }
        return null;
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 0.015.sh,
        ),
        prefixIcon: Transform.rotate(
          alignment: Alignment.center,
          angle: 3.14 * 1.5,
          child: Text(
            '{ Post Body }',
            style: TextStyle(
              color: ref.read(primaryColorLightProvider),
              fontSize: 0.02.sh,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        hintText: '\nkey: value,\nkey: value,\nkey: value,\n',
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