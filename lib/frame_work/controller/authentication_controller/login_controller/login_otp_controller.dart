 import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/frame_work/repository/services/fire_base/firebase_auth_service.dart';
import 'package:emploiflutter/frame_work/repository/services/fire_base/firebase_singleton.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/dash_board/dash_board.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/helper.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:page_transition/page_transition.dart';

import '../../../repository/services/hive_service/box_service.dart';
import '../../../repository/services/ze_go_cloud_service/ze_go_cloud_service.dart';

final loginOtpController = ChangeNotifierProvider((ref) => LoginOtpController(ref));

class LoginOtpController extends ChangeNotifier{
  Ref ref;
  LoginOtpController(this.ref);

  final otpController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final GlobalKey<FormState> bottomSheetState = GlobalKey();


  String verId = '';
  bool codeSend = false;
  bool isLoading = false;



  addNumberToController(String phoneNumber){
    phoneNumberController.text = phoneNumber.substring(3);
    notifyListeners();
  }

  /// ----------------------------Country Picker--------------------------------///
  Country selectedCountry = Country(phoneCode: "91", countryCode: "IN", e164Sc: 0, geographic: true, level: 1, name: "India", example: "9123456789", displayName: "India (IN) [+91]", displayNameNoCountryCode: "India (IN)", e164Key: "91-IN-0");

  selectCountry(BuildContext context){
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
            textStyle: TextStyle(fontSize: 14.sp),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            inputDecoration: const InputDecoration(
                hintText: "Start typing to sear", labelText: "Search")),
        favorite: ['IN'],
        onSelect: (value) {
          selectedCountry = value;
          notifyListeners();
        });
    notifyListeners();
  }
  /// ----------------------------Country Picker--------------------------------///

  /// ------------- login with firebase otp--------------///
   Future  verifyPhoneNumber(
      {required String phoneNumber, required BuildContext context}) async {
    try {
      isLoading = true;
      await FirebaseAuthService.firebaseAuthService.signInWithPhone(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            verifyOtp(context: context,number: phoneNumber);
        },
        verificationFailed: (error) {
          isLoading =false;
          debugPrint("verification Failed error --------------->> $error");
          FirebaseCrashlytics.instance.recordError(
              error,
              null,
              reason: 'Phone Verification Failed');
          notifyListeners();
        },
        codeSent: (verificationId, forceResendingToken) {
          isLoading= false;
          codeSend = true;
          verId = verificationId;
          second = maxSecond;
          debugPrint("verification Id $verId");
          timerFunction();
          appCommonShowToast(context: context, msg: "Code have been Sent \n to this number $phoneNumber");
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (p0) {},
      );
    } on FirebaseAuthException catch (e) {
      isLoading =false;
      debugPrint("Firbase Exception ---------->>> ${e.message}");
    }
    notifyListeners();
  }

  int? forceResendingToken;
  Future  resendVerifyPhoneNumber(
      {required String phoneNumber, required BuildContext context}) async {
    try {
      forceResendingToken = null;
      isLoading = true;
      await FirebaseAuthService.firebaseAuthService.resendOtp(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          verifyOtp(context: context,number: phoneNumber);
        },
        verificationFailed: (error) {
          isLoading =false;
          debugPrint("verification Failed error --------------->> $error");
          FirebaseCrashlytics.instance.recordError(
              error,
              null,
              reason: 'Phone Verification Failed');
          notifyListeners();
        },
        codeSent: (verificationId, forceResendingToken) {
          isLoading= false;
          codeSend = true;
          verId = verificationId;
          second = maxSecond;
          this.forceResendingToken = forceResendingToken;
          debugPrint("verification Id $verId");
          timerFunction();
          appCommonShowToast(context: context, msg: "Code have been Sent \n to this number $phoneNumber");
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (p0) {}, forceResendingToken: forceResendingToken,
      );
    } on FirebaseAuthException catch (e) {
      isLoading =false;
      debugPrint("Firbase Exception ---------->>> ${e.message}");
    }
    notifyListeners();
  }



  Future verifyOtp(
      {required BuildContext context, required String number}) async {
    isLoading = true;
    final response = await FirebaseAuthService.firebaseAuthService
        .verifyOtp(verificationId: verId, smsCode: otpController.text);
    if (response.user != null) {
      if(context.mounted){
       await userDetailGetApi(number,context);
      }
      notifyListeners();
      isLoading = false;
      debugPrint("Logged in user phone-------> ${response.user!.userPhone}");

    } else {
      if (context.mounted) {
        isLoading= false;
        showSnackBar(context: context, error: "OTP does not match");
        debugPrint("something went wrong");
      }
    }
    notifyListeners();
  }

/// ------------- login with firebase otp--------------///




  ///----------------------------- get user data and store in hive storage ---------------------///

    Future userDetailGetApi(String number,BuildContext context) async{
     isLoading = true;
     final data = BoxService.boxService.nativeDeviceBox.get(deviceDetailKey);
     try{

       print("User Detail number ---------- $number");
       debugPrint("Android Device Version ----->${data!.deviceVersion}");
       debugPrint("Android Device ID -----> ${data.deviceId}");
       debugPrint("Android Device name -----> ${data.deviceName}");


       final uid = FireBaseSingleton.instance.firebaseAuth.currentUser!.uid;
       print(uid);
       Response response = await DioClient.client.postDataWithJson(APIEndPoint.loginApi,
           {
             "vMobile": number,
             "vDeviceId": data.deviceId,
             "vOSVersion": data.deviceVersion,
             "tDeviceToken": "string",
             "tDeviceName": data.deviceName,
             "vFirebaseId": uid
           });
       if(response.statusCode == 200){
         isLoading= false;
         // print(response.data["data"]);
         otpController.clear();
         UserDetailDataModel user = UserDetailDataModel.fromJson(response.data["data"]);
         await SharedPrefServices.services.setBool(isUserLoggedIn, true);
         // print("opt screen company name ------>${user.user.vCurrentCompany}");
         BoxService.boxService.addUserDetailToHive(userDetailKey, UserDetailDataModel(tAuthToken: user.tAuthToken, iUserId: user.iUserId, tDeviceToken: user.tDeviceToken, user: user.user));
         if(context.mounted){
           Navigator.pushAndRemoveUntil(context, PageTransition(
               child: const DashBoard(),
               type: PageTransitionType.rightToLeft,
               duration: const Duration(milliseconds: 300)), (route) => false);
         }
       }
     }catch (e){
       isLoading = false;
       Future.error(e);
       otpController.clear();
       notifyListeners();
     }
    notifyListeners();
    }

  ///----------------------------- get user data and store in hive storage ---------------------///

  ///----------------------------- Timer function -----------------------------///

  static const maxSecond = 30;
  Timer? time;
  int second = maxSecond;

  void timerFunction() {
    time = Timer.periodic(const Duration(seconds: 1), (_) {
      if (second > 0) {
        second--;
        notifyListeners();
      } else {
        stopAndResetTimer();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void stopAndResetTimer() {
    time?.cancel();
    notifyListeners();
  }
///----------------------------- Timer function -----------------------------///

@override
  void dispose() {
    super.dispose();
  }
}