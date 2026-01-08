// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      deviceId: fields[1] as String?,
      createdAt: fields[2] as DateTime,
      name: fields[3] as String?,
      age: fields[4] as int?,
      weightKg: fields[5] as double?,
      heightCm: fields[6] as double?,
      gender: fields[7] as String?,
      activityLevel: fields[8] as String?,
      goal: fields[9] as String?,
      tdee: fields[10] as int?,
      calorieTarget: fields[11] as int?,
      proteinTargetG: fields[12] as int?,
      carbsTargetG: fields[13] as int?,
      fatTargetG: fields[14] as int?,
      subscriptionStatus: fields[15] as String,
      trialStartDate: fields[16] as DateTime?,
      notificationsEnabled: fields[17] as bool,
      theme: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deviceId)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.weightKg)
      ..writeByte(6)
      ..write(obj.heightCm)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.activityLevel)
      ..writeByte(9)
      ..write(obj.goal)
      ..writeByte(10)
      ..write(obj.tdee)
      ..writeByte(11)
      ..write(obj.calorieTarget)
      ..writeByte(12)
      ..write(obj.proteinTargetG)
      ..writeByte(13)
      ..write(obj.carbsTargetG)
      ..writeByte(14)
      ..write(obj.fatTargetG)
      ..writeByte(15)
      ..write(obj.subscriptionStatus)
      ..writeByte(16)
      ..write(obj.trialStartDate)
      ..writeByte(17)
      ..write(obj.notificationsEnabled)
      ..writeByte(18)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
