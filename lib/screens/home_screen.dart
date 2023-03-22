import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_a_req/screens/requests_list_screen.dart';
import '../providers/main_providers.dart';
import 'alarms_list_screen.dart';
import 'make_request_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  int tabIndex;
  final requestListKey = const PageStorageKey('requestListKey');
  final alarmListPageKey = const PageStorageKey('alarmListPageKey');

  HomeScreen({Key? key, required this.tabIndex}) : super(key: key);

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late int _tabIndex;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {_tabIndex = v; setState(() {});}
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.tabIndex;
    pageController = PageController(initialPage: _tabIndex, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: [
          Container(
            margin: EdgeInsets.all(0.0025.sh),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(25,34,83,1),
              borderRadius: BorderRadius.circular(0.75.sh),
            ),
            child: Icon(Icons.home, color: ref.read(primaryColorProvider)),
          ),
          Container(
            margin: EdgeInsets.all(0.0025.sh),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(25,34,83,1),
              borderRadius: BorderRadius.circular(0.75.sh),
            ),
            child: Icon(Icons.add, color: ref.read(primaryColorProvider)),
          ),
          Container(
            margin: EdgeInsets.all(0.0025.sh),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(25,34,83,1),
              borderRadius: BorderRadius.circular(0.75.sh),
            ),
            child: Icon(Icons.alarm, color: ref.read(primaryColorProvider)),
          ),
        ],
        inactiveIcons: [
          Text(
            "Home",
            style: TextStyle(color: ref.read(primaryColorProvider), fontWeight: FontWeight.bold),
          ),
          Text(
            "Make Request",
            style: TextStyle(color: ref.read(primaryColorProvider), fontWeight: FontWeight.bold),
          ),
          Text(
            "Alarms",
            style: TextStyle(color: ref.read(primaryColorProvider), fontWeight: FontWeight.bold),
          ),
        ],
        color: const Color.fromRGBO(25,34,83,1),
        circleGradient: const LinearGradient(
          colors: [
            Colors.red,
            Colors.amber,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        height: 0.077.sh,
        circleWidth: 0.077.sh,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        padding: EdgeInsets.only(
          left: 0.015.sh,
          right: 0.015.sh,
          top: 0.025.sh,
          bottom: 0.03.sh,
        ),
        cornerRadius: BorderRadius.only(
          topLeft: Radius.circular(0.01.sh),
          topRight: Radius.circular(0.01.sh),
          bottomLeft: Radius.circular(0.035.sh),
          bottomRight: Radius.circular(0.035.sh),
        ),
        shadowColor: Colors.black,
        elevation: 2,
        circleShadowColor: Colors.black,
        iconDurationMillSec: 500,
        tabDurationMillSec: 1000,
        iconCurve: Curves.easeInOutCubic,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          RequestListScreen(key: widget.requestListKey),
          const MakeRequestScreen(),
          AlarmListScreen(key: widget.alarmListPageKey,),
        ],
      )
    );
  }
}

