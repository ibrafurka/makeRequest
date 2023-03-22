import 'package:hive/hive.dart';
part 'alarm_model.g.dart';

@HiveType(typeId: 1)
class AlarmModel {
  @HiveField(0)
  final String alarmId;
  @HiveField(1)
  final String requestId;
  @HiveField(2)
  final int alarmNotificationId;
  @HiveField(3)
  final List<String> dataToCheck;
  @HiveField(4)
  final String runTimeTypeOfDataToCheck;
  @HiveField(5)
  final String alarmName;
  @HiveField(6)
  final String comparisonOperator;
  @HiveField(7)
  final String valueToCompare;
  @HiveField(8)
  final String checkPeriod;
  @HiveField(9)
  final String checkPeriodType;
  @HiveField(10)
  final bool isActive;

  AlarmModel({
    required this.alarmId,
    required this.requestId,
    required this.alarmNotificationId,
    required this.dataToCheck,
    required this.runTimeTypeOfDataToCheck,
    required this.alarmName,
    required this.comparisonOperator,
    required this.valueToCompare,
    required this.checkPeriod,
    required this.checkPeriodType,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'alarmId': alarmId,
      'requestId': requestId,
      'alarmNotificationId': alarmNotificationId,
      'dataToCheck': dataToCheck,
      'runTimeTypeOfDataToCheck': runTimeTypeOfDataToCheck,
      'alarmName': alarmName,
      'comparisonOperator': comparisonOperator,
      'valueToCompare': valueToCompare,
      'checkPeriod': checkPeriod,
      'checkPeriodType': checkPeriodType,
      'isActive': isActive,
    };
  }

  factory AlarmModel.fromJson(Map<String, dynamic> map) {
    return AlarmModel(
      alarmId: map['alarmId'] as String,
      requestId: map['requestId'] as String,
      alarmNotificationId: map['alarmNotificationId'] as int,
      dataToCheck: map['dataToCheck'] as List<String>,
      runTimeTypeOfDataToCheck: map['runTimeTypeOfDataToCheck'] as String,
      alarmName: map['alarmName'] as String,
      comparisonOperator: map['comparisonOperator'] as String,
      valueToCompare: map['valueToCompare'] as String,
      checkPeriod: map['checkPeriod'] as String,
      checkPeriodType: map['checkPeriodType'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  @override
  String toString() {
    return 'AlarmModel{alarmId: $alarmId, '
        'requestId: $requestId, '
        'alarmNotificationId: $alarmNotificationId, '
        'dataToCheck: $dataToCheck, '
        'runTimeTypeOfDataToCheck: $runTimeTypeOfDataToCheck, '
        'alarmName: $alarmName, '
        'comparisonOperator: $comparisonOperator, '
        'valueToCompare: $valueToCompare, '
        'checkPeriod: $checkPeriod, '
        'checkPeriodType: $checkPeriodType, '
        'isActive: $isActive}';
  }
}
