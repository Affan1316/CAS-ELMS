// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_sessions_for_a_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllSessionsForADayAdapter extends TypeAdapter<AllSessionsForADay> {
  @override
  final int typeId = 1;

  @override
  AllSessionsForADay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllSessionsForADay(
      date: fields[0] as DateTime,
      sessions: (fields[1] as List).cast<Sessions>(),
      totalDuration: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AllSessionsForADay obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.sessions)
      ..writeByte(2)
      ..write(obj.totalDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllSessionsForADayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
