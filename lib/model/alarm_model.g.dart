// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmModelAdapter extends TypeAdapter<AlarmModel> {
  @override
  final int typeId = 1;

  @override
  AlarmModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmModel(
      alarmId: fields[0] as String,
      requestId: fields[1] as String,
      alarmNotificationId: fields[2] as int,
      dataToCheck: (fields[3] as List).cast<String>(),
      runTimeTypeOfDataToCheck: fields[4] as String,
      alarmName: fields[5] as String,
      comparisonOperator: fields[6] as String,
      valueToCompare: fields[7] as String,
      checkPeriod: fields[8] as String,
      checkPeriodType: fields[9] as String,
      isActive: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.alarmId)
      ..writeByte(1)
      ..write(obj.requestId)
      ..writeByte(2)
      ..write(obj.alarmNotificationId)
      ..writeByte(3)
      ..write(obj.dataToCheck)
      ..writeByte(4)
      ..write(obj.runTimeTypeOfDataToCheck)
      ..writeByte(5)
      ..write(obj.alarmName)
      ..writeByte(6)
      ..write(obj.comparisonOperator)
      ..writeByte(7)
      ..write(obj.valueToCompare)
      ..writeByte(8)
      ..write(obj.checkPeriod)
      ..writeByte(9)
      ..write(obj.checkPeriodType)
      ..writeByte(10)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
