// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailDataModelAdapter extends TypeAdapter<UserDetailDataModel> {
  @override
  final int typeId = 2;

  @override
  UserDetailDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetailDataModel(
      tAuthToken: fields[0] as String,
      iUserId: fields[1] as int,
      tDeviceToken: fields[2] as String,
      user: fields[3] as UserModel,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetailDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tAuthToken)
      ..writeByte(1)
      ..write(obj.iUserId)
      ..writeByte(2)
      ..write(obj.tDeviceToken)
      ..writeByte(3)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 3;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      vFirstName: fields[0] as String,
      vJobLocation: fields[1] as String?,
      tResumeUrl: fields[2] as String?,
      tVideoResumeUrl: fields[3] as String?,
      vLastName: fields[4] as String,
      vDuration: fields[5] as String?,
      vWorkingMode: fields[6] as String?,
      vMobile: fields[7] as String,
      vPreferCity: fields[8] as String?,
      tTagLine: fields[9] as String?,
      vEmail: fields[10] as String,
      vPreferJobTitle: fields[11] as String?,
      isBlock: fields[12] as int,
      id: fields[13] as int,
      vCity: fields[14] as String,
      vQualification: fields[15] as String?,
      isLogin: fields[16] as int,
      vFirebaseId: fields[17] as String,
      tBio: fields[18] as String?,
      tProfileUrl: fields[19] as String?,
      tCreatedAt: fields[20] as String,
      iRole: fields[21] as int,
      vCurrentCompany: fields[22] as String?,
      tProfileBannerUrl: fields[23] as String?,
      tUpadatedAt: fields[24] as String?,
      vDesignation: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.vFirstName)
      ..writeByte(1)
      ..write(obj.vJobLocation)
      ..writeByte(2)
      ..write(obj.tResumeUrl)
      ..writeByte(3)
      ..write(obj.tVideoResumeUrl)
      ..writeByte(4)
      ..write(obj.vLastName)
      ..writeByte(5)
      ..write(obj.vDuration)
      ..writeByte(6)
      ..write(obj.vWorkingMode)
      ..writeByte(7)
      ..write(obj.vMobile)
      ..writeByte(8)
      ..write(obj.vPreferCity)
      ..writeByte(9)
      ..write(obj.tTagLine)
      ..writeByte(10)
      ..write(obj.vEmail)
      ..writeByte(11)
      ..write(obj.vPreferJobTitle)
      ..writeByte(12)
      ..write(obj.isBlock)
      ..writeByte(13)
      ..write(obj.id)
      ..writeByte(14)
      ..write(obj.vCity)
      ..writeByte(15)
      ..write(obj.vQualification)
      ..writeByte(16)
      ..write(obj.isLogin)
      ..writeByte(17)
      ..write(obj.vFirebaseId)
      ..writeByte(18)
      ..write(obj.tBio)
      ..writeByte(19)
      ..write(obj.tProfileUrl)
      ..writeByte(20)
      ..write(obj.tCreatedAt)
      ..writeByte(21)
      ..write(obj.iRole)
      ..writeByte(22)
      ..write(obj.vCurrentCompany)
      ..writeByte(23)
      ..write(obj.tProfileBannerUrl)
      ..writeByte(24)
      ..write(obj.tUpadatedAt)
      ..writeByte(25)
      ..write(obj.vDesignation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
