import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/request_model.dart';
import 'home_screen_list_manager.dart';

final makeRequestFormKeyProvider = StateProvider((ref) => GlobalKey<FormState>());

final makeRequestUrlControllerProvider = Provider((ref) => TextEditingController());

final makeRequestMethodProvider = StateProvider<String>((ref) => 'GET');

final textFieldStringsToMapProvider = Provider.family<Map<String, dynamic>, String>((ref, requestHeaders) {
  requestHeaders = requestHeaders.replaceAll('\n', '');
  requestHeaders = requestHeaders.replaceAll(' ', '');
  List<dynamic> requestHeadersList = requestHeaders.split(',');
  requestHeadersList = requestHeadersList.map((e) => e.split(':')).where((e) {
    if (e.length == 2 && !e.contains('') && !e.contains(null)) {
      return true;
    } else {
      return false;
    }
  }).toList();
  Map<String, dynamic> requestHeadersMap = {};
  for (var element in requestHeadersList) {
    requestHeadersMap[element[0]] = element[1];
  }
  return requestHeadersMap;
});

final homeScreenListManagerProvider = StateNotifierProvider<HomeScreenListNotifier, List<RequestModel>>((ref) {
  return HomeScreenListNotifier(ref: ref,);
});