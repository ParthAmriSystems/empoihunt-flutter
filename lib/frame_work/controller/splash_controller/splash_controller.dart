// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/model/splash/native_device_model/native_device_model.dart';
import 'package:emploiflutter/frame_work/repository/model/splash/splashmodel.dart';
import 'package:emploiflutter/frame_work/repository/services/box_service.dart';
import 'package:emploiflutter/ui/splash/helper/splash_blocked_user_bottom_sheet.dart';
import 'package:emploiflutter/ui/splash/helper/splash_update_app_bottom_sheet.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import '../../../ui/authentication/auth_intro.dart';
import '../../../ui/onboarding/on_boarding.dart';
import '../../../ui/utils/app_constant.dart';
import '../../repository/api_end_point.dart';
import '../../repository/dio_client.dart';
import '../../repository/services/shared_pref_services.dart';


final splashController = ChangeNotifierProvider((ref) => SplashController());


class SplashController extends ChangeNotifier{

  Future getAppVersion() async {
    print("getAppversion call");
    try{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print("project version ${packageInfo.buildNumber}");
    } catch(e){
      print(e);
    }
  }



  ///------------------------------- Version Update call Api -----------------------------////
  Future getSplashData(BuildContext context) async{
    try{
      Response response = await DioClient.client.getData(APIEndPoint.splashUpdateApp);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if(response.statusCode == 200){
        SplashModel splashData = SplashModel.fromJson(response.data);
        if(splashData.status == 200){
          final data = splashData.data;
         int  updatedVersion = data!.latestAppVersionCode!;
          debugPrint(" update api app version--->>>> $updatedVersion");
          ///-------------- get current application version ---------------////
          int currentAppVersion = int.parse(packageInfo.buildNumber);
          print("project version $currentAppVersion");
            if(data.isBlock == 0){
              print(data.isBlock);
              if(currentAppVersion == updatedVersion){
                Future.delayed(const Duration(seconds: 2),() {
                  checkUserOpenAppFirstTime(context);
                },);
              }else{
                showModalBottomSheet(
                  enableDrag: false,
                  isDismissible: false,
                  context: context, builder: (context) {
                  return  SplashUpdateAppBottomSheet(data.tMessage);
                },);
              }
            }else{
              showModalBottomSheet(
                enableDrag: false,
                isDismissible: false,
                context: context, builder: (context) {
                return const SplashBlockedUserBottomSheet();
              },);
              print(data.isBlock);
            }
        }
      }else{
        debugPrint(response.statusCode.toString());
      }
    }catch(e){
      Future.error(e);
    }
  }
  ///------------------------------- Version Update call Api -----------------------------////


  ///--------------- on boarding Check --------------////
  checkUserOpenAppFirstTime(BuildContext context){
    if(SharedPrefServices.services.getBool(onBoardingKey)){
      Navigator.pushReplacement(
          context,
          PageTransition(child: const AuthIntro(), type: PageTransitionType.topToBottom,duration: const Duration(milliseconds: 700))
      );
    }else{
      Navigator.pushReplacement(
          context,
          PageTransition(child: const OnBoarding(), type: PageTransitionType.topToBottom,duration: const Duration(milliseconds: 700))
      );
    }
    notifyListeners();
  }
  ///--------------- on boarding Check --------------////


///---------- User Device Detail --------//////
 Future getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        print("Android Device Version ----->${build.version.release}");
        print("Android Device ID -----> ${build.id}");
        print("Android Device name -----> ${build.model}");
        await BoxService.boxService.addDataToHive(deviceDetailKey, NativeDeviceDetailModel(deviceId: build.id!, deviceName: build.model!, deviceVersion: build.version.release.toString(), deviceType: 0));
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfoPlugin.iosInfo;
        print("IOS Device ID -----> ${iosInfo.identifierForVendor}");
        print("IOS Device Version -----> ${iosInfo.systemVersion}");
        print("IOS Device Name -----> ${iosInfo.name}");
        // await BoxService.boxService.addDataToHive(deviceDetailKey, NativeDeviceDetailModel(deviceId: build.id!, deviceName: build.model!, deviceVersion: build.version.release.toString(), deviceType: 1));
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }


}