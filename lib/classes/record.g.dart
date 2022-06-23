// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SRecordAdapter extends TypeAdapter<SRecord> {
  @override
  final int typeId = 0;

  @override
  SRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SRecord(
      amount: fields[1] as double,
      typeName: fields[2] as String,
      dateTime: fields[3] as DateTime,
      remark: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.remark)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.typeName)
      ..writeByte(3)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
