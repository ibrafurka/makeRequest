import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/main_providers.dart';

class RequestHeadersTextFormFieldWidget extends ConsumerWidget {
  final TextEditingController requestHeadersController;

  const RequestHeadersTextFormFieldWidget({Key? key, required this.requestHeadersController}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: requestHeadersController,
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
              return 'You must enter a header name!';
            }
            if (sList.any((element) => element[1].isEmpty)) {
              return 'You must enter a header value!';
            }
          } else {
            if (s.contains(':')) {
              return s.split(':').length % 2 != 0
                  ? 'You must separate headers with a colon!'
                  : s.split(':')[0].isEmpty
                      ? 'You must enter a header name!'
                      : s.split(':')[1].isEmpty
                          ? 'You must enter a header value!'
                          : null;
            } else {
              return 'You must separate headers with a colon!';
            }
          }
        }
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontSize: 0.015.sh,
        ),
        prefixIcon: Transform.rotate(
          alignment: Alignment.center,
          angle: 3.14 * 1.5,
          child: Text(
            '{ Headers }',
            style: TextStyle(
              color: ref.read(primaryColorLightProvider),
              fontSize: 0.02.sh,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        hintText: '\nAccept: application/json,\nContent-Type: application/json,\nContent-Length: 3,\n',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 0.02.sh),
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
