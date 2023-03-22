import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:make_a_req/model/alarm_model.dart';
import '../model/request_model.dart';
import '../providers/alarm_list_screen_manager.dart';
import '../providers/main_providers.dart';
import '../providers/make_request_screen_providers.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomeScreenListWidget extends ConsumerWidget {
  const HomeScreenListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RequestModel> requests = ref.watch(homeScreenListManagerProvider);
    return (requests.isEmpty)
        ? Center(
            child: Container(
              padding: EdgeInsets.all(0.025.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 0.1.sh,
                    color: Colors.amber.withOpacity(0.7),
                  ),
                  SizedBox(
                    height: 0.025.sh,
                  ),
                  Text(
                    'No Request Yet!',
                    style: TextStyle(
                      fontSize: 0.025.sh,
                      color: ref.read(primaryColorProvider),
                    ),
                  ),
                  SizedBox(
                    height: 0.025.sh,
                  ),
                  Text(
                    'Make a request by clicking the button below or swipe right.',
                    style: TextStyle(
                      fontSize: 0.016.sh,
                      color: ref.read(primaryColorProvider),
                    ),
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 0.12.sh),
            itemCount: requests.length,
            itemBuilder: (BuildContext context, int index) {
              RequestModel request = requests[requests.length - index - 1];
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (a) {
                  if (a == DismissDirection.startToEnd) {
                    ref
                        .read(homeScreenListManagerProvider.notifier)
                        .removeRequestModelList(request);
                  } else if (a == DismissDirection.endToStart) {
                    Navigator.pushNamed(context, 'make-request',
                        arguments: request);
                  }
                },
                secondaryBackground: Container(
                  color: const Color(0xffF2CB02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 0.01.sw,
                      ),
                      const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 0.02.sw,
                      ),
                    ],
                  ),
                ),
                background: Container(
                  color: const Color(0xffD42B2B),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 0.02.sw,
                      ),
                      const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 0.01.sw,
                      ),
                      const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F0F),
                    border: (index == requests.length - 1)
                        ? Border(
                            top: BorderSide(
                              width: 0.00035.sh,
                              color: Colors.white12,
                            ),
                            bottom: BorderSide(
                              width: 0.00035.sh,
                              color: Colors.white12,
                            ),
                          )
                        : Border(
                            top: BorderSide(
                              width: 0.00035.sh,
                              color: Colors.white12,
                            ),
                          ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(0.03.sw),
                    onTap: () {
                      Navigator.pushNamed(context, 'response',
                          arguments: request);
                    },
                    splashColor:
                        ref.read(primaryColorProvider).withOpacity(0.3),
                    highlightColor: Colors.transparent,
                    child: ListTile(
                      title: Text(
                        maxLines: 1,
                        request.requestName,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                            color: ref.read(primaryColorProvider),
                            fontSize: 0.05.sw),
                      ),
                      subtitle: Text(
                        request.requestUrl,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.blue.withOpacity(0.7),
                            fontSize: 0.03.sw),
                      ),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.001.sw),
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromRGBO(25, 34, 83, 1),
                              child: Text(
                                request.requestMethod,
                                style: TextStyle(
                                    color: ref.read(primaryColorProvider),
                                    fontSize: 0.033.sw,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.001.sw),
                            child: Icon(
                              Icons.ads_click_rounded,
                              color: ref.read(primaryColorProvider),
                              size: 0.035.sw,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
