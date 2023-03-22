import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/home_screen_providers.dart';
import '../widgets/home_screen_list_widget.dart';

class RequestListScreen extends ConsumerStatefulWidget {
  const RequestListScreen({Key? key,}) : super(key: key);

  @override
  ConsumerState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends ConsumerState<RequestListScreen> with SingleTickerProviderStateMixin{

  late AnimationController swipeController;
  late Animation swipeLeftAnimation;
  late Animation swipeRightAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    swipeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    swipeController.addListener(() {
      setState(() {

      });
    });

    swipeLeftAnimation = AlignmentTween(begin: const Alignment(1, 0), end: const Alignment(-1, 0)).animate(swipeController);
    swipeRightAnimation = AlignmentTween(begin: const Alignment(-1, 0), end: const Alignment(1, 0)).animate(swipeController);

    swipeController.forward();
    swipeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        swipeController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        swipeController.forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    swipeController.dispose();
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
            child: Column(
              children: [
                SizedBox(
                  height: 0.05.sh,
                ),
                Text(
                  'Saved Requests',
                  style: ref.read(homeTitleTextStyleProvider),
                ),
                SizedBox(
                  height: 0.005.sh,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.075.sw, vertical: 0.01.sh),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 0.05.sw,
                        child: Container(
                          alignment: swipeLeftAnimation.value,
                          child: Icon(
                            Icons.arrow_back,
                            color: const Color(0xffF2CB02).withOpacity(0.7),
                            size: 0.03.sw,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.005.sw,
                      ),
                      Text(
                        'Swipe Left to Edit Request',
                        style: TextStyle(color: Colors.white24, fontSize: 0.025.sw),
                      ),
                      const Spacer(),
                      Text(
                        'Swipe Right to Delete Request',
                        style: TextStyle(color: Colors.white24, fontSize: 0.025.sw),
                      ),
                      SizedBox(
                        width: 0.005.sw,
                      ),
                      SizedBox(
                        width: 0.05.sw,
                        child: Container(
                          alignment: swipeRightAnimation.value,
                          child: Icon(
                            Icons.arrow_forward,
                            color: const Color(0xffD42B2B).withOpacity(0.7),
                            size: 0.03.sw,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: HomeScreenListWidget(),
          ),
          SizedBox(
            height: 0.025.sh,
          ),
        ],
      ),
    );
  }
}
