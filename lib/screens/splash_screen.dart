import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/main_providers.dart';
import '../providers/splash_screen_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
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
      begin: Colors.purple,
      end: Colors.pink,
    ).animate(animationController);
    colorAnimationSecond = ColorTween(
      begin: Colors.pink,
      end: Colors.purple,
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Make A Req',
              style: ref.read(titleTextStyleProvider),
            ),
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.center,
                end: FractionalOffset.bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: const Image(
              image: AssetImage('assets/images/splash5.png'),
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.all(0.00075.sh),
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
                  spreadRadius: 5,
                  blurRadius: 5,
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: ref.watch(primaryColorProvider),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 7,
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.19.sw,
                    vertical: 0.02.sh,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, 'home', arguments: 0);
                },
                child: const Text('Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
