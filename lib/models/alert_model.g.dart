// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlertModelAdapter extends TypeAdapter<AlertModel> {
  @override
  final int typeId = 0;

  @override
  AlertModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlertModel(
      errMsg: fields[1] as String,
      dateTime: DateTime.parse(fields[2] as String),
    );
  }

  @override
  void write(BinaryWriter writer, AlertModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.alertIcon)
      ..writeByte(1)
      ..write(obj.errMsg)
      ..writeByte(2)
      ..write(obj.timeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
