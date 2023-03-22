import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoBackButtonWidget extends ConsumerStatefulWidget {
  final int returnPage;
  const GoBackButtonWidget({Key? key, required this.returnPage})
      : super(key: key);

  @override
  ConsumerState createState() => _GoBackButtonWidgetState();
}

class _GoBackButtonWidgetState extends ConsumerState<GoBackButtonWidget>
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
      begin: Colors.red,
      end: Colors.orange,
    ).animate(animationController);
    colorAnimationSecond = ColorTween(
      begin: Colors.orange,
      end: Colors.red,
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
      margin: EdgeInsets.only(
        left: 0.27.sw,
        right: 0.27.sw,
        bottom: 0.015.sh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.sh),
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          colors: [
            colorAnimationFirst.value,
            colorAnimationSecond.value,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorAnimationFirst.value.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'home',
              arguments: widget.returnPage);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F0F0F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.25.sw),
          ),
          shadowColor: Colors.transparent,
          elevation: 7,
          fixedSize: Size(
            0.3.sw,
            0.07.sh,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 0.035.sw,
            ),
            SizedBox(
              width: 0.01.sw,
            ),
            Text(
              'Go Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 0.035.sw,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
