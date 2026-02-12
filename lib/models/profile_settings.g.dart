// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileSettingsAdapter extends TypeAdapter<ProfileSettings> {
  @override
  final int typeId = 5;

  @override
  ProfileSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileSettings(
      monthlyIncome: fields[0] as double,
      expectedBudget: fields[1] as double,
      smsSyncEnabled: fields[2] as bool,
      notificationsEnabled: fields[3] as bool,
    )..lastConfettiDate = fields[4] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, ProfileSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.monthlyIncome)
      ..writeByte(1)
      ..write(obj.expectedBudget)
      ..writeByte(2)
      ..write(obj.smsSyncEnabled)
      ..writeByte(3)
      ..write(obj.notificationsEnabled)
      ..writeByte(4)
      ..write(obj.lastConfettiDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
