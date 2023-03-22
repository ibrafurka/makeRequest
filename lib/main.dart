import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:make_a_req/providers/alarm_list_screen_manager.dart';
import 'package:make_a_req/providers/main_providers.dart';
import 'package:make_a_req/providers/make_request_screen_providers.dart';
import 'package:make_a_req/providers/router_provider.dart';

import 'model/alarm_model.dart';
import 'model/request_model.dart';
import 'background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter('makeAReq');
  Hive.registerAdapter(RequestModelAdapter());
  Hive.registerAdapter(AlarmModelAdapter());
  await Hive.openBox<RequestModel>('requests');
  await Hive.openBox<AlarmModel>('alarms');

  await MyBackgroundService.initializeService();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const ProviderScope(child: MyApp()));

  FlutterBackgroundService().invoke('fetchStats');
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool isServiceRunning = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(homeScreenListManagerProvider.notifier).readInitialRequestList();
    ref.read(alarmListScreenManagerProvider.notifier).readInitialAlarmList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2280),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'Make A Req',
        debugShowCheckedModeBanner: false,
        theme: ref.read(mainThemeProvider),
        initialRoute: 'splash',
        routes: ref.read(routerProvider),
      ),
    );
  }
}
