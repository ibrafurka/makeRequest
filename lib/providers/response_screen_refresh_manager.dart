import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/request_model.dart';
import '../widgets/response_data_screen_future_builder_widget.dart';

class ResponseScreenRefreshNotifier extends StateNotifier<ResponseDataFutureBuilderWidget> {
  Ref ref;
  RequestModel request;

  ResponseScreenRefreshNotifier({required this.ref, required this.request})
      : super(ResponseDataFutureBuilderWidget(request: request));

  void refreshResponse() {
    state = ResponseDataFutureBuilderWidget(request: request);
  }
}

final responseScreenRefreshProvider =
    StateNotifierProvider.family<ResponseScreenRefreshNotifier, ResponseDataFutureBuilderWidget, RequestModel>(
  (ref, request) => ResponseScreenRefreshNotifier(ref: ref, request: request,),
);
