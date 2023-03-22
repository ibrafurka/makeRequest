import 'package:hive/hive.dart';
part 'request_model.g.dart';

@HiveType(typeId: 0)
class RequestModel {
  @HiveField(0)
  final String requestId;
  @HiveField(1)
  final String requestName;
  @HiveField(2)
  final String requestUrl;
  @HiveField(3)
  final String requestMethod;
  @HiveField(4, defaultValue: {})
  final Map<String, dynamic>? requestHeaders;
  @HiveField(5, defaultValue: {})
  final Map<String, dynamic>? requestPostBody;

  RequestModel({
    required this.requestId,
    required this.requestName,
    required this.requestUrl,
    required this.requestMethod,
    this.requestHeaders,
    this.requestPostBody,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'requestName': requestName,
      'requestUrl': requestUrl,
      'requestMethod': requestMethod,
      'requestHeaders': requestHeaders,
      'requestPostBody': requestPostBody,
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> map) {
    return RequestModel(
      requestId: map['requestId'] as String,
      requestName: map['requestName'] as String,
      requestUrl: map['requestUrl'] as String,
      requestMethod: map['requestMethod'] as String,
      requestHeaders: map['requestHeaders'] as Map<String, dynamic>,
      requestPostBody: map['requestPostBody'] as Map<String, dynamic>,
    );
  }

  @override
  String toString() {
    return 'RequestModel{requestId: $requestId, requestName: $requestName, requestUrl: $requestUrl, requestMethod: $requestMethod, requestHeaders: $requestHeaders, requestPostBody: $requestPostBody}';
  }

}
