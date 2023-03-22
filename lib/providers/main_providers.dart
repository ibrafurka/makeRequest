import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final primaryColorProvider = Provider<Color>((ref) => Colors.white);
final primaryColorLightProvider =
    Provider<Color>((ref) => const Color.fromRGBO(0, 113, 189, 1));

final mainThemeProvider = Provider<ThemeData>(
  (ref) => ThemeData(
    primaryColor: ref.read(primaryColorProvider),
    primaryColorLight: ref.read(primaryColorLightProvider),
    fontFamily: 'Raleway',
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  ),
);

final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>(
        (ref) => FlutterLocalNotificationsPlugin());
