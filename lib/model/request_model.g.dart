// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestModelAdapter extends TypeAdapter<RequestModel> {
  @override
  final int typeId = 0;

  @override
  RequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RequestModel(
      requestId: fields[0] as String,
      requestName: fields[1] as String,
      requestUrl: fields[2] as String,
      requestMethod: fields[3] as String,
      requestHeaders:
          fields[4] == null ? {} : (fields[4] as Map?)?.cast<String, dynamic>(),
      requestPostBody:
          fields[5] == null ? {} : (fields[5] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, RequestModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.requestId)
      ..writeByte(1)
      ..write(obj.requestName)
      ..writeByte(2)
      ..write(obj.requestUrl)
      ..writeByte(3)
      ..write(obj.requestMethod)
      ..writeByte(4)
      ..write(obj.requestHeaders)
      ..writeByte(5)
      ..write(obj.requestPostBody);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
