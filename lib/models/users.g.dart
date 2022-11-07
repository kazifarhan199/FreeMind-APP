// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

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
      userName: fields[0] as String,
      userImage: fields[1] as String,
      email: fields[2] as String,
      id: fields[3] as int,
      gid: fields[4] as int,
      token: fields[5] as String,
    )..surveyGiven = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.userImage)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.gid)
      ..writeByte(5)
      ..write(obj.token)
      ..writeByte(6)
      ..write(obj.surveyGiven);
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
