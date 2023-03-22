import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/request_model.dart';
import '../services/request_service.dart';
import 'make_request_screen_providers.dart';

class ChooseParameterNotifier extends StateNotifier<List<String>> {
  final Ref ref;

  ChooseParameterNotifier({required this.ref}) : super(['No Parameter']);

  Future<List<String>> getParameterKeys(String? requestId) async {
    List<RequestModel> allRequests = ref.read(homeScreenListManagerProvider);

    RequestModel request = allRequests.firstWhere((element) => element.requestId == requestId);
    Map<String, dynamic> response = await MakeRequestApi.makeRequest(requestModel: request);

    List<String> keys = getKeys(response);

    state = keys;
    return keys;
  }

  List<String> getKeys(json) {
    List<String> keys = [];

    debugPrint(json.toString());

    if (json is Map) {
      json.forEach(
        (key, value) {
          if (value is Map) {
            getKeys(value);
          } else if (value is String || value is int || value is bool) {
            keys.add(key);
          }
        },
      );
    } else if (json is List) {
      for (var value in json) {
        if (value is Map) {
          getKeys(value);
        }
      }
    }

    return keys;
  }
}

final chooseParameterNotifierProvider =
    StateNotifierProvider<ChooseParameterNotifier, List<String>>((ref) => ChooseParameterNotifier(ref: ref));

final chooseParameterProvider = StateProvider<String>((ref) => ref.read(chooseParameterNotifierProvider).last);