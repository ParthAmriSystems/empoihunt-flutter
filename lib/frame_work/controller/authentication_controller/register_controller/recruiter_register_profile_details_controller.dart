import 'dart:io';

import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/services/fire_base/firebase_singleton.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/dash_board/dash_board.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/helper.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../ui/utils/constant/app_string_constant.dart';
import '../../../repository/model/user_model/user_detail_data_model.dart';
import 'register_controller.dart';

final recruiterRegisterProfileDetailsController = ChangeNotifierProvider(
    (ref) => RecruiterRegisterProfileDetailsController(ref));

class RecruiterRegisterProfileDetailsController extends ChangeNotifier {
  final Ref ref;

  RecruiterRegisterProfileDetailsController(this.ref);

  final GlobalKey<FormState> registerProfileDetailsGlobalKey = GlobalKey();

  PageController pageController = PageController();

  int pageIndex = 0;

  forwardBtn(BuildContext context) {
    if (pageIndex < 2) {
      pageIndex++;
      pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      registerSubmitButton(context);
    }
    notifyListeners();
  }

  backwardBtn() {
    if (pageIndex > 0) {
      pageIndex--;
      pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
    notifyListeners();
  }

  registerSubmitButton(BuildContext context) async {
    debugPrint("final button called");
    if (bioController.text != "") {
      isBioEmpty = false;
      if (qualificationSearchController.text != "") {
        isQualificationEmpty = false;
          if (companyNameController.text != "") {
            if(designationSearchController.text != ""){
              isDesignationEmpty = false;
              if(jobLocationSearchController.text != ""){
                isJobLocationEmpty = false;
                if (profilePic != null) {
                  await registerApiCall(context);
                  clearForm();
                } else {
                  showSnackBar(context: context, error: "Please select an image");
                }
              }else{
                isJobLocationEmpty = true;
                pageIndex = 1;
                pageController.animateToPage(pageIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }
            }else{
              isDesignationEmpty = true;
              pageIndex = 1;
              pageController.animateToPage(pageIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            }
          } else {
            isCompanyEmpty = true;
            pageIndex = 1;
            pageController.animateToPage(pageIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          }

      } else {
        isQualificationEmpty = true;
        pageIndex = 0;
        pageController.animateToPage(pageIndex,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      notifyListeners();
      }
    } else {
      print("Bio empty");
      isBioEmpty = true;
      pageIndex = 0;
      pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn);
      notifyListeners();
    }
    notifyListeners();
  }

  ///---Lottie Controller ---///
  late AnimationController uploadImgLottieController;

  ///---Lottie Controller ---///

  ///-----------------Profile1--------------///
  final bioController = TextEditingController();
  bool isBioEmpty = false;
  final qualificationSearchController = TextEditingController();
  bool isQualificationEmpty = false;

  updateIsBioEmpty(String value) {
    if (value != "") {
      isBioEmpty = false;
    } else {
      isBioEmpty = true;
    }
    notifyListeners();
  }
  List<String> checkEducation(String query){
    query = query.toUpperCase().trim();
    return qualificationsList.where((city) => city.toUpperCase().trim().contains(query)).toList();
  }

  // String? selectedQualification;

  isQualificationEmptyUpdate(String? value){
    if(value !=""){
      isQualificationEmpty = false;
      notifyListeners();
    }else{
      isQualificationEmpty = true;
      notifyListeners();
    }
  }

  ///-----------------Profile1--------------///

  ///-----------------Profile2--------------///

  final companyNameController = TextEditingController();
  final designationSearchController = TextEditingController();
  final jobLocationSearchController = TextEditingController();
  bool isCompanyEmpty = false;
  bool isDesignationEmpty = false;
  bool isJobLocationEmpty = false;

  List<String> workingModeList = [
    "On-Site",
    "Remote",
    "Hybrid",
  ];

  int selectedWorkingMode = 0;
  String selectedWorkingModeText = "";

  updateWorkingMode(int index) {
    selectedWorkingMode = index;
    selectedWorkingModeText = workingModeList[index];
    debugPrint(selectedWorkingModeText);
    notifyListeners();
  }

  updateIsCompanyEmpty(String value) {
    if (value != "") {
      isCompanyEmpty = false;
    } else {
      isCompanyEmpty = true;
    }
    notifyListeners();
  }

  // String? selectedDesignation;

  isDesignationEmptyUpdate(String? value){
    if(value !=""){
      isDesignationEmpty = false;
      notifyListeners();
    }else{
      isDesignationEmpty = true;
      notifyListeners();
    }
  }
  List<String> checkDesignation(String query){
    query = query.toUpperCase().trim();
    return designationList.where((city) => city.toUpperCase().trim().contains(query)).toList();
  }

  // String? selectedJobLocation;

  isJobLocationEmptyUpdate(String? value){
    if(value !=""){
      isJobLocationEmpty = false;
      notifyListeners();
    }else{
      isJobLocationEmpty = true;
      notifyListeners();
    }
  }
  List<String> checkJobLocation(String query){
    query = query.toUpperCase().trim();
    return SharedPrefServices.services.getList(locationListKey)!.where((city) => city.toUpperCase().trim().contains(query)).toList();
  }

  ///-----------------Profile2--------------///

  ///-----------------Profile3--------------///

  bool isPicAnimationRun = false;
  String? imgUrl;
  File? profilePic;
  String profilePicName = "";

  Future<void> imagePicker() async {
    isPicAnimationRun = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    profilePic = null;
    notifyListeners();
    uploadImgLottieController.stop();
    if (result != null) {
      final PlatformFile file = result.files.first;
      // print("image name --->${file.name}");
      uploadImgLottieController.reset();
      uploadImgLottieController.forward();
      await Future.delayed(
        const Duration(seconds: 3),
      );
      profilePic = File(file.path!);
      imgUrl = file.path;
      profilePicName = file.name;
      isPicAnimationRun = false;
      notifyListeners();
    } else {
      uploadImgLottieController.stop();
      isPicAnimationRun = false;
      notifyListeners();
    }
    notifyListeners();
  }

  ///-----------------Profile3--------------///

  ///----------------- Register Api ----------------------////
  String phoneNumber = "";
  String email = "";
  String lastName = "";
  String firstName = "";
  String city = "";

  assignRegisterData(
      {required String phone,
      required String firstName,
      required String lastName,
      required String city,
      required String email}) {
    phoneNumber = phone;
    this.email = email;
    this.firstName = firstName;
    this.lastName = lastName;
    this.city = city;
    notifyListeners();
  }

  bool isLoading = false;

  double latitude = 0.0;
  double longitude = 0.0;

  Future getLocation() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      notifyListeners();
    } else {
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude = position.latitude;
        longitude = position.longitude;
      }
    }
  }

  Future registerApiCall(BuildContext context) async {
    debugPrint(selectedWorkingModeText);
    isLoading = true;
    final uid = FireBaseSingleton.instance.firebaseAuth.currentUser!.uid;
    final deviceData =
        BoxService.boxService.nativeDeviceBox.get(deviceDetailKey)!;
    print(
        "FCM Token------->${SharedPrefServices.services.getString(fcmTokenKey)}");
    print(uid);
    try {
      FormData formData = FormData.fromMap({
        "profilePic":
            await MultipartFile.fromFile(imgUrl!, filename: profilePicName),
        "resume": "",
        "videoResume": "",
      });
      int userDeletedValue = ref.read(registerController).userDeleted;
      Response response = await DioClient.client.postDataWithForm(
          "${APIEndPoint.registerUserApi}?iRole=1&vFirebaseId=$uid&vMobile=%2B$phoneNumber&vDeviceId=${deviceData.deviceId}&vDeviceType=${deviceData.deviceType}&vOSVersion=${deviceData.deviceVersion}&tDeviceToken=$fcmTokenKey&tDeviceName=${deviceData.deviceName}&vFirstName=$firstName&vLastName=$lastName&vEmail=$email&tBio=${bioController.text}&vCity=$city&vCurrentCompany=${companyNameController.text}&vDesignation=${designationSearchController.text}&vJobLocation=${jobLocationSearchController.text}&vDuration="
          "&vPreferCity="
          "&vPreferJobTitle="
          "&vQualification=${qualificationSearchController.text}&vWorkingMode=$selectedWorkingModeText&tTagLine="
          "&tLatitude=$latitude&tLongitude=$longitude&tAppVersion=0&isDeleted=$userDeletedValue",
          formData: formData);
      if (response.statusCode == 200) {
        isLoading = false;
        UserDetailDataModel user =
            UserDetailDataModel.fromJson(response.data["data"]);
        BoxService.boxService.addUserDetailToHive(
            userDetailKey,
            UserDetailDataModel(
                tAuthToken: user.tAuthToken,
                iUserId: user.iUserId,
                tDeviceToken: user.tDeviceToken,
                user: user.user));
        await SharedPrefServices.services.setBool(isUserLoggedIn, true);
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const DashBoard(),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 300)),
              (route) => false);
        }
        print("Succesfully register");
      }
    } catch (e) {
      isLoading = false;
      Future.error(e);
    }
    notifyListeners();
  }

  ///----------------- Register Api ----------------------////

  @override
  void notifyListeners() {
    super.notifyListeners();
  }


  clearForm(){
    qualificationSearchController.clear();
    bioController.clear();
    companyNameController.clear();
    designationSearchController.clear();
    jobLocationSearchController.clear();
    profilePic = null;
    companyNameController.dispose();
    designationSearchController.dispose();
    qualificationSearchController.dispose();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    companyNameController.dispose();
    designationSearchController.dispose();
    qualificationSearchController.dispose();
    super.dispose();
  }
}
