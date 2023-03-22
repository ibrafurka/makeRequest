import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/main_providers.dart';
import '../providers/make_request_screen_providers.dart';

class RequestMethodDropDownButtonWidget extends ConsumerStatefulWidget {
  final String requestMethod;
  const RequestMethodDropDownButtonWidget({Key? key, this.requestMethod = 'GET'}) : super(key: key);

  @override
  ConsumerState createState() => _RequestMethodDropDownButtonWidgetState();
}

class _RequestMethodDropDownButtonWidgetState extends ConsumerState<RequestMethodDropDownButtonWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(makeRequestMethodProvider.notifier).state = widget.requestMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: ref.watch(makeRequestMethodProvider),
      items: const [
        DropdownMenuItem(value: 'GET', child: Text('GET')),
        DropdownMenuItem(value: 'POST', child: Text('POST')),
      ],
      onChanged: (value) {
        ref.read(makeRequestMethodProvider.notifier).state = value.toString();
      },
      elevation: 9,
      style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 0.023.sh,
          fontWeight: FontWeight.w300),
      iconEnabledColor: ref.read(primaryColorProvider),
      dropdownColor: const Color(0xFF0F0F0F),
      underline: Container(),
      alignment: Alignment.center,
    );
  }
}

