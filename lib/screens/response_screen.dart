import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/request_model.dart';
import '../providers/home_screen_providers.dart';
import '../providers/response_screen_refresh_manager.dart';

class ResponseScreen extends ConsumerStatefulWidget {
  final RequestModel? request;

  const ResponseScreen({Key? key, required this.request}) : super(key: key);

  @override
  ConsumerState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends ConsumerState<ResponseScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation colorAnimationFirst, colorAnimationSecond, colorAnimationThird, colorAnimationFourth;
  late Future<Widget> body;
  late Completer<void> _refreshCompleter = Completer<void>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    body = Future.delayed(Duration.zero, () => ref.watch(responseScreenRefreshProvider(widget.request!)));
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    animationController.addListener(() {
      setState(() {});
    });

    colorAnimationFirst = ColorTween(
      begin: Colors.red,
      end: Colors.amber,
    ).animate(animationController);

    colorAnimationSecond = ColorTween(
      begin: Colors.amber,
      end: Colors.red,
    ).animate(animationController);

    colorAnimationThird = ColorTween(
      begin: Colors.green,
      end: Colors.lightBlue,
    ).animate(animationController);

    colorAnimationFourth = ColorTween(
      begin: Colors.lightBlueAccent,
      end: Colors.green,
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

    _refreshCompleter.complete();
    _refreshCompleter = Completer<void>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 0.05.sh,
                ),
                Text(
                  'Response Data',
                  style: ref.read(homeTitleTextStyleProvider),
                ),
                SizedBox(
                  height: 0.0025.sh,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.015.sw,),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 0.05.sw,
                        child: Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_circle_right,
                            color: Colors.green.withOpacity(0.7),
                            size: 0.03.sw,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.005.sw,
                      ),
                      Text(
                        'Hold on keys to to go to alarm page.',
                        style: TextStyle(color: Colors.white38, fontSize: 0.025.sw),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 0.05.sw,
                        child: Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.info,
                            color: const Color(0xffF2CB02).withOpacity(0.7),
                            size: 0.03.sw,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.005.sw,
                      ),
                      Text(
                        'Double click keys to inform.',
                        style: TextStyle(color: Colors.white38, fontSize: 0.025.sw),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0.015.sh,
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: const Color(0xFF0F0F0F),
              color: Colors.white,
              onRefresh: () {
                ref.read(responseScreenRefreshProvider(widget.request!).notifier).refreshResponse();
                body = Future.delayed(Duration.zero, () => ref.watch(responseScreenRefreshProvider(widget.request!)));
                return _refreshCompleter.future;
              },
              child: FutureBuilder<Widget>(
                future: body,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong!',
                        style: ref.read(homeTitleTextStyleProvider),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colorAnimationFirst.value,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: ScreenUtil().screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(0.001.sh),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.sh),
                shape: BoxShape.rectangle,
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
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.sh),
                  color: const Color(0xFF0F0F0F),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.sh),
                    ),
                    shadowColor: Colors.transparent,
                    elevation: 7,
                    fixedSize: Size(0.33.sw, 0.061.sh),
                  ),
                  child: SizedBox(
                    width: ScreenUtil().screenWidth * 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 0.05.sw,
                        ),
                        SizedBox(
                          width: 0.01.sw,
                        ),
                        Text(
                          'Go Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 0.045.sw,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (widget.request != null)
              Container(
                padding: EdgeInsets.all(0.001.sh),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.sh),
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                    colors: [
                      colorAnimationThird.value,
                      colorAnimationFourth.value,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorAnimationThird.value.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.sh),
                    color: const Color(0xFF0F0F0F),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(responseScreenRefreshProvider(widget.request!).notifier).refreshResponse();
                      body = Future.delayed(Duration.zero, () => ref.watch(responseScreenRefreshProvider(widget.request!)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      //const Color(0xFF0F0F0F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.sh),
                      ),
                      shadowColor: Colors.transparent,
                      elevation: 7,
                      fixedSize: Size(0.33.sw, 0.061.sh),
                    ),
                    child: SizedBox(
                      width: ScreenUtil().screenWidth * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 0.05.sw,
                          ),
                          SizedBox(
                            width: 0.01.sw,
                          ),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 0.045.sw,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
