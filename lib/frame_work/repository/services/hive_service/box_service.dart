import 'dart:async';
import 'package:emploiflutter/frame_work/repository/model/splash/native_device_model/native_device_model.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_experience_model.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:hive/hive.dart';


class BoxService{
  late Box<NativeDeviceDetailModel> nativeDeviceBox;
  late Box<UserDetailDataModel> userGetDetailBox;
  late Box<UserModel> userModelBox;
  late Box<UserExperienceModel> userExperienceBox;

  BoxService._private();
  static BoxService boxService = BoxService._private();

  Future<void> addNativeDeviceDetailsToHive(dynamic key,NativeDeviceDetailModel deviceDetail)async{
    await nativeDeviceBox.put(key,deviceDetail);
  }

  Future<void> addUserDetailToHive(dynamic userDetailDataKey,UserDetailDataModel userDetails)async{
    await userGetDetailBox.put(userDetailDataKey,userDetails);
  }

  Future<void> addUserExperienceToHive(dynamic useExperienceKey,UserExperienceModel userExperience)async{
    await userExperienceBox.put(useExperienceKey,userExperience);
  }

  Future<void> deleteData(int index)async{
    await nativeDeviceBox.deleteAt(index);
  }

  Future<void> updateNativeDeviceDetails(int key,NativeDeviceDetailModel deviceDetail)async{
    final box = Hive.box(nativeDeviceDetailsBox);
    // ignore: unrelated_type_equality_checks
    box.values.toList().indexWhere((element) => (element as NativeDeviceDetailModel).deviceId == key);
    await nativeDeviceBox.putAt(key, deviceDetail);
  }

  Future<void> clearAllBoxes() async {
    await userGetDetailBox.clear();
    await userModelBox.clear();
  }

}