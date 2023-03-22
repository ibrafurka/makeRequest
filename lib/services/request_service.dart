import 'package:dio/dio.dart';
import 'package:make_a_req/model/request_model.dart';


class MakeRequestApi {

  static Future<Map<String, dynamic>> makeRequest({
    required RequestModel requestModel
  }) async {
    final _dio = Dio(
      BaseOptions(
        headers: requestModel.requestHeaders ?? {},
      ),
    );

    if (requestModel.requestMethod == 'GET') {
      final response = await _dio.get(requestModel.requestUrl);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw 'Something went wrong, ${response.statusMessage}!';
      }
    } else if (requestModel.requestMethod == 'POST') {
      final response = await _dio.post(requestModel.requestUrl, data: requestModel.requestPostBody);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw 'Something went wrong, ${response.statusMessage}!';
      }
    } else {
      throw 'Invalid request method!';
    }
  }

  static dynamic getValue(List<String> keys, Map<String, dynamic> json) {
    if (keys.length == 1) {
      return json[keys[0]];
    } else {
      return getValue(keys.sublist(1), json[keys[0]]);
    }
  }

  static bool compareValues(dynamic value1, dynamic value2, String comparisonType, String valueRunTimeType) {
    if (valueRunTimeType == 'int') {
      value1 = value1.runtimeType is int ? value1 : int.tryParse(value1);
      value2 = value2.runtimeType is int ? value2 : int.tryParse(value2);
    } else if (valueRunTimeType == 'double') {
      value1 = value1.runtimeType is double ? value1 : double.tryParse(value1);
      value2 = value2.runtimeType is double ? value2 : double.tryParse(value2);
    } else if (valueRunTimeType == 'bool') {
      value1 = value1 == 'true';
      value2 = value2 == 'true';
    } else if (valueRunTimeType == 'String') {
      value1 = value1.toString();
      value2 = value2.toString();
    }

    if (valueRunTimeType == 'int' || valueRunTimeType == 'double') {
      if (comparisonType == '==') {
        return value1 == value2;
      } else if (comparisonType == '!=') {
        return value1 != value2;
      } else if (comparisonType == '>') {
        return value1 > value2;
      } else if (comparisonType == '<') {
        return value1 < value2;
      } else if (comparisonType == '>=') {
        return value1 >= value2;
      } else if (comparisonType == '<=') {
        return value1 <= value2;
      } else {
        throw 'Invalid comparison type!';
      }
    } else if (valueRunTimeType == 'bool') {
      if (comparisonType == '==') {
        return value1 == value2;
      } else if (comparisonType == '!=') {
        return value1 != value2;
      } else {
        throw 'Invalid comparison type!';
      }
    } else if (valueRunTimeType == 'String') {
      if (comparisonType == '==') {
        return value1 == value2;
      } else if (comparisonType == '!=') {
        return value1 != value2;
      } else if (comparisonType == 'contains') {
        return value1.contains(value2);
      } else if (comparisonType == 'startsWith') {
        return value1.startsWith(value2);
      } else if (comparisonType == 'endsWith') {
        return value1.endsWith(value2);
      } else {
        throw 'Invalid comparison type!';
      }
    } else {
      throw 'Invalid value type!';
    }
  }
}
