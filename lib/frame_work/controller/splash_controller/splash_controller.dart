// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/model/splash/native_device_model/native_device_model.dart';
import 'package:emploiflutter/frame_work/repository/model/splash/splashmodel.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/dash_board/dash_board.dart';
import 'package:emploiflutter/ui/splash/helper/splash_blocked_user_bottom_sheet.dart';
import 'package:emploiflutter/ui/splash/helper/splash_update_app_bottom_sheet.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import '../../../ui/authentication/auth_intro.dart';
import '../../../ui/onboarding/on_boarding.dart';
import '../../../ui/utils/constant/app_constant.dart';
import '../../repository/api_end_point.dart';
import '../../repository/dio_client.dart';
import '../../repository/services/shared_pref_services.dart';


final splashController = ChangeNotifierProvider((ref) => SplashController(ref));


class SplashController extends ChangeNotifier{
  Ref ref;
  SplashController(this.ref);

  Future getAppVersion() async {
    debugPrint("getAppversion call");
    try{
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      debugPrint("project version ${packageInfo.buildNumber}");
    } catch(e){
      debugPrint(e.toString());
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

          await SharedPrefServices.services.setString(notificationVKey, data!.nothing!.vKey!);
         int  updatedVersion = data.latestAppVersionCode!;
         int updatedVersionForIos = data.latestAppVersionCodeIOS!;
          debugPrint(" update api app version android--->>>> $updatedVersion");
          debugPrint(" update api app version ios--->>>> $updatedVersionForIos");
          ///-------------- get current application version ---------------////
          // int currentAppVersion = int.parse(packageInfo.buildNumber);

          PackageInfo currentAppVersion = await PackageInfo.fromPlatform();

          debugPrint("project version ${currentAppVersion}");
            // await userAuthenticatedOrNot(context);
            if(data.isBlock == 0){
              print(data.isBlock);
              if(Platform.isIOS){
                if(int.parse(currentAppVersion.buildNumber) < updatedVersionForIos ){
                  showModalBottomSheet(
                    enableDrag: false,
                    isDismissible: false,
                    context: context, builder: (context) {
                    return  SplashUpdateAppBottomSheet(data.tMessage);
                  },);
                }else{
                  Future.delayed(const Duration(seconds: 2),() {
                    userAuthenticatedOrNot(context);
                  },);
                }
              }else{
                if(int.parse(currentAppVersion.buildNumber) < updatedVersion ){
                  showModalBottomSheet(
                    enableDrag: false,
                    isDismissible: false,
                    context: context, builder: (context) {
                    return  SplashUpdateAppBottomSheet(data.tMessage);
                  },);
                }else{
                  Future.delayed(const Duration(seconds: 2),() {
                    userAuthenticatedOrNot(context);
                  },);
                }
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
      Future.error("Get Splash Data error----->$e");
    }
  }
  ///------------------------------- Version Update call Api -----------------------------////
  userAuthenticatedOrNot(BuildContext context){
    bool value = SharedPrefServices.services.getBool(isUserLoggedIn);
    print("is log in -----> $value");

    if(value){
      Navigator.pushAndRemoveUntil(context, PageTransition(
          child: const DashBoard(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300)), (route) => false);
    }else{
      checkUserOpenAppFirstTime(context);
    }
  }

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
        debugPrint("Android Device Version ----->${build.version.release}");
        debugPrint("Android Device ID -----> ${build.id}");
        debugPrint("Android Device name -----> ${build.model}");
        await BoxService.boxService.addNativeDeviceDetailsToHive(deviceDetailKey, NativeDeviceDetailModel(deviceId: build.id, deviceName: build.model, deviceVersion: build.version.release.toString(), deviceType: 0));
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfoPlugin.iosInfo;
        debugPrint("IOS Device ID -----> ${iosInfo.identifierForVendor}");
        debugPrint("IOS Device Version -----> ${iosInfo.systemVersion}");
        debugPrint("IOS Device Name -----> ${iosInfo.name}");
        await BoxService.boxService.addNativeDeviceDetailsToHive(deviceDetailKey, NativeDeviceDetailModel(deviceId:iosInfo.identifierForVendor!, deviceName:iosInfo.name, deviceVersion:iosInfo.systemVersion, deviceType: 1));
      }
    } on PlatformException {
      debugPrint('Failed to get platform version');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}