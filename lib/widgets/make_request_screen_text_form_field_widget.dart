import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_elevation_button_widget.dart';
import 'request_headers_text_form_field_widget.dart';
import 'request_name_text_form_field_widget.dart';
import 'request_postbody_text_form_field_widget.dart';
import 'request_url_text_form_field_widget.dart';
import '../model/request_model.dart';
import '../providers/main_providers.dart';
import 'request_method_drop_down_button_widget.dart';

class MakeRequestTextFormFieldWidget extends ConsumerWidget {
  final RequestModel? request;
  late String requestMethod;

  MakeRequestTextFormFieldWidget({Key? key, this.request}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController requestNameController = TextEditingController();
  final TextEditingController requestUrlController = TextEditingController();
  final TextEditingController requestHeadersController = TextEditingController();
  final TextEditingController requestPostBodyController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (request != null) {
      requestNameController.text = request!.requestName;
      requestMethod = request!.requestMethod;
      requestUrlController.text = request!.requestUrl;
      if (request!.requestHeaders!.isNotEmpty) {
        requestHeadersController.text =
            request!.requestHeaders!.toString().replaceAll('{', '').replaceAll('}', ',').replaceAll(', ', ',\n');
      }
      if (request!.requestPostBody!.isNotEmpty) {
        requestPostBodyController.text =
            request!.requestPostBody!.toString().replaceAll('{', '').replaceAll('}', ',').replaceAll(', ', ',\n');
      }
    } else {
      requestMethod = 'GET';
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            height: 0.1.sh,
            margin: EdgeInsets.only(right: 0.05.sw, left: 0.05.sw),
            padding: EdgeInsets.only(right: 0.0125.sw, left: 0.0125.sw),
            child: RequestNameTextFormFieldWidget(
              requestNameController: requestNameController,
            ),
          ),
          SizedBox(
            height: 0.015.sh,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 0.062.sw),
                padding: EdgeInsets.only(left: 0.0125.sw),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0125.sw),
                    topRight: Radius.circular(0.0125.sw),
                    bottomLeft: Radius.circular(5.r),
                  ),
                  color: ref.read(primaryColorLightProvider),
                ),
                child: RequestMethodDropDownButtonWidget(requestMethod: requestMethod),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: 0.1.sh,
                    margin: EdgeInsets.only(right: 0.05.sw),
                    padding: EdgeInsets.only(right: 0.0125.sw),
                    child: RequestUrlTextFormFieldWidget(
                      requestUrlController: requestUrlController,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 0.2.sh,
            margin: EdgeInsets.only(right: 0.05.sw, left: 0.05.sw),
            padding: EdgeInsets.only(right: 0.0125.sw, left: 0.0125.sw),
            child: RequestHeadersTextFormFieldWidget(
              requestHeadersController: requestHeadersController,
            ),
          ),
          Container(
            height: 0.2.sh,
            margin: EdgeInsets.only(right: 0.05.sw, left: 0.05.sw),
            padding: EdgeInsets.only(right: 0.0125.sw, left: 0.0125.sw),
            child: RequestPostBodyTextFormFieldWidget(
              requestPostBodyController: requestPostBodyController,
            ),
          ),
          SizedBox(
            height: (request == null) ? 0.0025.sh : 0.025.sh,
          ),
          CustomElevationButtonWidget(
            request: request,
            formKey: formKey,
            requestControllers: {
              'requestNameController': requestNameController,
              'requestUrlController': requestUrlController,
              'requestHeadersController': requestHeadersController,
              'requestPostBodyController': requestPostBodyController,
            },
          ),
        ],
      ),
    );
  }
}
