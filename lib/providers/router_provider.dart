import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/request_model.dart';
import '../screens/alarm_screen.dart';
import '../screens/alarms_list_screen.dart';
import '../screens/home_screen.dart';
import '../screens/make_request_screen.dart';
import '../screens/response_screen.dart';
import '../screens/splash_screen.dart';

final routerProvider = Provider<Map<String, WidgetBuilder>>(
  (ref) => <String, WidgetBuilder>{
    'splash': (BuildContext context) => const SplashScreen(),
    'home': (BuildContext context) {
      final arguments = ModalRoute.of(context)!.settings.arguments as int;
      return HomeScreen(tabIndex: arguments,);
    },
    'make-request': (BuildContext context) {
      final arguments = ModalRoute.of(context)!.settings.arguments;
      return MakeRequestScreen(request: arguments as RequestModel?);
    },
    'response': (BuildContext context) {
      final RequestModel arguments = ModalRoute.of(context)?.settings.arguments as RequestModel;
      return ResponseScreen(
        request: arguments,
      );
    },
    'set-alarm': (BuildContext context) {
      final Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      return AlarmScreen(arguments: arguments);
    },
    'alarm-list-screen': (BuildContext context) => const AlarmListScreen(),
  },
);
