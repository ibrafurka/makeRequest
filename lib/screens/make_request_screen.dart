import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/request_model.dart';
import '../providers/home_screen_providers.dart';
import '../widgets/go_back_button_widget.dart';
import '../widgets/make_request_screen_text_form_field_widget.dart';

class MakeRequestScreen extends ConsumerWidget {
  final RequestModel? request;

  const MakeRequestScreen({Key? key, this.request}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Column(
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
                  request == null ? 'Make A Request' : 'Edit Request',
                  style: ref.read(homeTitleTextStyleProvider),
                ),
                SizedBox(
                  height: 0.005.sh,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                MakeRequestTextFormFieldWidget(request: request),
                SizedBox(
                  height: 0.05.sh,
                ),
                request != null
                    ? const GoBackButtonWidget(
                        returnPage: 0,
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
