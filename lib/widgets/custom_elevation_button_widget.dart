import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../model/request_model.dart';
import '../providers/main_providers.dart';
import '../providers/make_request_screen_providers.dart';

class CustomElevationButtonWidget extends ConsumerStatefulWidget {
  final RequestModel? request;
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> requestControllers;
  const CustomElevationButtonWidget(
      {Key? key,
      this.request,
      required this.formKey,
      required this.requestControllers})
      : super(key: key);

  @override
  ConsumerState createState() => _CustomElevationButtonWidgetState();
}

class _CustomElevationButtonWidgetState
    extends ConsumerState<CustomElevationButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation colorAnimationFirst;
  late Animation colorAnimationSecond;
  late Animation colorAnimationThird;
  late Animation colorAnimationFourth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animationController.addListener(() {
      setState(() {});
    });

    colorAnimationFirst = ColorTween(
      begin: Colors.green,
      end: Colors.lightGreenAccent,
    ).animate(animationController);
    colorAnimationSecond = ColorTween(
      begin: Colors.lightGreenAccent,
      end: Colors.green,
    ).animate(animationController);

    colorAnimationThird = ColorTween(
      begin: Colors.amber,
      end: Colors.yellowAccent,
    ).animate(animationController);
    colorAnimationFourth = ColorTween(
      begin: Colors.yellowAccent,
      end: Colors.amber,
    ).animate(animationController);

    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.00075.sh),
      decoration: BoxDecoration(
        gradient: widget.request != null
            ? LinearGradient(
                colors: [
                  colorAnimationThird.value,
                  colorAnimationFourth.value,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : LinearGradient(
                colors: [
                  colorAnimationFirst.value,
                  colorAnimationSecond.value,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        boxShadow: [
          widget.request != null
              ? BoxShadow(
                  color: colorAnimationThird.value.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                )
              : BoxShadow(
                  color: colorAnimationFirst.value.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: ref.watch(primaryColorProvider),
          backgroundColor: const Color(0xFF0F0F0F),
          elevation: 7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 0.11.sw,
            vertical: 0.023.sh,
          ),
          minimumSize: Size(0.11.sw, 0.019.sh),
          textStyle: TextStyle(
            fontSize: 0.02.sh,
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: () async {
          try {
            if (widget.formKey.currentState!.validate()) {
              final requestId = widget.request != null
                  ? widget.request!.requestId
                  : const Uuid().v4();
              final requestName =
                  widget.requestControllers['requestNameController']!.text;
              final requestUrl =
                  widget.requestControllers['requestUrlController']!.text;
              final requestMethod = ref.read(makeRequestMethodProvider);
              final requestHeaders =
                  widget.requestControllers['requestHeadersController']!.text;
              final requestPostBody =
                  widget.requestControllers['requestPostBodyController']!.text;

              final Map<String, dynamic>? requestHeadersMap =
                  ref.read(textFieldStringsToMapProvider(requestHeaders));
              final Map<String, dynamic>? requestBodyMap =
                  ref.read(textFieldStringsToMapProvider(requestPostBody));

              RequestModel requestModel = RequestModel(
                requestId: requestId,
                requestName: requestName,
                requestUrl: requestUrl,
                requestMethod: requestMethod,
                requestHeaders: requestHeadersMap,
                requestPostBody: requestBodyMap,
              );

              if (widget.request != null) {
                ref
                    .read(homeScreenListManagerProvider.notifier)
                    .updateRequestModelList(requestModel);
              } else {
                ref
                    .read(homeScreenListManagerProvider.notifier)
                    .saveRequestModelList(requestModel);
              }

              Navigator.pushReplacementNamed(context, 'home', arguments: 0);
            }
          } catch (e) {
            SnackBar snackBar = SnackBar(
              backgroundColor:
                  ref.read(primaryColorLightProvider).withOpacity(0.7),
              content: Text(
                e.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 0.02.sh,
                ),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Text(widget.request != null ? 'Update Request' : 'Save Request'),
      ),
    );
  }
}
