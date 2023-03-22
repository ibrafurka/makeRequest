import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/request_model.dart';
import '../providers/main_providers.dart';
import '../providers/set_alarm_providers.dart';
import '../services/request_service.dart';

RegExp _numeric = RegExp(r'^-?[0-9]+$');

/// check if the string contains only numbers
bool isNumeric(String str) {
  return _numeric.hasMatch(str);
}

class ResponseDataFutureBuilderWidget extends ConsumerWidget {
  final RequestModel request;

  const ResponseDataFutureBuilderWidget({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: MakeRequestApi.makeRequest(requestModel: request),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dynamic myMap = snapshot.data!;
          if (myMap.containsKey('data')) myMap = myMap['data'];
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              ..._buildListViewList(context, ref, myMap, [], []),
              SizedBox(
                height: 0.1.sh,
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red.withOpacity(0.5),
                size: 0.11.sh,
              ),
              SizedBox(
                height: 0.05.sh,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0.01.sw),
                child: Text(
                  style: TextStyle(
                    fontSize: 0.02.sh,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  'Something went wrong! Please check your request url, method, headers and post-data and try again.',
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: ref.read(primaryColorLightProvider),
            ),
          );
        }
      },
    );
  }

  List<Widget> _buildListViewList(BuildContext context, WidgetRef ref, dynamic jsonMap, List<String> jsonElementKeys, List<String> keys) {

    jsonMap.forEach((key, value){
      if (value is String) {
        if (isNumeric(value)) {
          //debugPrint('$key: $value');
          jsonMap[key] = int.parse(value);
        }
      }
    });

    List<Widget> listViewList = [];

    if (jsonMap is Map) {
      jsonMap.forEach((key, value) {
        List<Widget> subListViewList = [];
        if (value is Map || value is List) {
          subListViewList.add(
            Container(
              margin: EdgeInsets.only(top: 0.00025.sh, bottom: 0.00025.sh),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ref.read(primaryColorLightProvider).withOpacity(0.15),
                borderRadius: BorderRadius.circular(0.013.sw),
                border: Border.all(
                  color: ref.read(primaryColorLightProvider),
                  width: 0.00125.sw,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.005.sh,
                  horizontal: 0.0005.sh,
                ),
                child: Column(
                  children: [
                    Text(
                      '$key',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 0.021.sh,
                        fontWeight: FontWeight.w700,
                        color: Colors.orangeAccent.withOpacity(0.7),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.005.sh,
                      ),
                      child: Divider(
                        color: ref.read(primaryColorLightProvider),
                        thickness: 0.001.sw,
                      ),
                    ),
                    for (var item in _buildListViewList(context, ref, value, [key], keys)) item,
                  ],
                ),
              ),
            ),
          );
          subListViewList.add(SizedBox(
            height: 0.0075.sh,
          ));
        } else {
          subListViewList.add(Padding(
            padding: EdgeInsets.only(
              right: 0.00025.sh,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(0.013.sw),
                  onLongPress: () {
                    if (jsonElementKeys.isNotEmpty) keys = [...keys, ...jsonElementKeys];
                    keys.add(key);
                    ref.read(alarmRequestIdProvider.notifier).state = request.requestId;
                    ref.read(valueRunTimeTypeProvider.notifier).state = value.runtimeType.toString();
                    Navigator.pushNamed(context, 'set-alarm', arguments: {
                      'responseKeys': keys,
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0055.sw, vertical: 0.0055.sh),
                    child: Text(
                      '$key: ',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 0.02.sh,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      '\t$value',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 0.02.sh,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
        }
        listViewList.add(Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.013.sh,
          ),
          child: Column(
            children: subListViewList,
          ),
        ));
      });
    } else if (jsonMap is List) {
      for (var value in jsonMap) {
        List<Widget> subListViewList = [];
        if (value is Map || value is List) {
          _buildListViewList(context, ref, value, [], []).forEach((element) {
            subListViewList.add(element);
          });
        } else {
          subListViewList.add(
            Expanded(
              child: Text(
                '\t$value',
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 0.02.sh,
                  color: ref.read(primaryColorLightProvider),
                ),
              ),
            ),
          );
        }
        listViewList.add(Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.0033.sh,
          ),
          child: Column(
            children: subListViewList,
          ),
        ));
      }
    }
    return listViewList;
  }
}
