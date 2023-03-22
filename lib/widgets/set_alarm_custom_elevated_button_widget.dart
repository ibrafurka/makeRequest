import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/main_providers.dart';

class SetAlarmCustomElevatedButtonWidget extends ConsumerStatefulWidget {
  var onPressed;
  Color firstColor;
  Color secondColor;
  String textString;

  SetAlarmCustomElevatedButtonWidget({
    Key? key,
    required this.onPressed,
    required this.firstColor,
    required this.secondColor,
    required this.textString
  }) : super(key: key);

  @override
  ConsumerState createState() => _SetAlarmCustomElevatedButtonWidgetState();
}

class _SetAlarmCustomElevatedButtonWidgetState extends ConsumerState<SetAlarmCustomElevatedButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation colorAnimationFirst;
  late Animation colorAnimationSecond;

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
      begin: widget.firstColor,
      end: widget.secondColor,
    ).animate(animationController);
    colorAnimationSecond = ColorTween(
      begin: widget.secondColor,
      end: widget.firstColor,
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
      margin: EdgeInsets.only(top: 0.01.sh),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorAnimationFirst.value,
            colorAnimationSecond.value,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorAnimationFirst.value.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 0),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 0.2.sw,
        height: 0.045.sh,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: ref.watch(primaryColorProvider),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            minimumSize: Size(0.2.sw, 0.045.sh),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(widget.textString),
        ),
      ),
    );
  }
}
