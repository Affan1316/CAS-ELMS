// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionsAdapter extends TypeAdapter<Sessions> {
  @override
  final int typeId = 0;

  @override
  Sessions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sessions(
      checkInTime: fields[0] as DateTime,
      checkOutTime: fields[1] as DateTime,
      timeSpend: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Sessions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.checkInTime)
      ..writeByte(1)
      ..write(obj.checkOutTime)
      ..writeByte(2)
      ..write(obj.timeSpend);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
