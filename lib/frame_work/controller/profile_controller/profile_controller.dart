import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_banner_image_dialogbox.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_current_position_dialogbox.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_experience_dialogbox.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_about_dialogbox.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_details_dialogbox.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_profile_image_change_dialogbox.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_qualification_dialogbox.dart';
import 'package:emploiflutter/ui/profile/helper/user_profile_dialogs/user_resume_dialogbox.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../ui/utils/app_constant.dart';
import '../../repository/model/user_model/user_experience_model.dart';
import '../../repository/services/hive_service/box_service.dart';

final profileController = ChangeNotifierProvider((ref) => ProfileController(ref));

class ProfileController extends ChangeNotifier {
  Ref ref;
  ProfileController(this.ref);

  bool isDialogShow = false;
  int dialogValue = 0;


  ///---------------- get user data from hive storage --------------------///
  ///
  final userModelData = BoxService.boxService.userGetDetailBox.get(userDetailKey)!;


  ///---------------- get user data from hive storage --------------------///


  ///----------- Form keys ----------------///

    final GlobalKey<FormState> userDetailFormKey = GlobalKey();
    final GlobalKey<FormState> aboutFormKey = GlobalKey();
    final GlobalKey<FormState> currentPositionFormKey = GlobalKey();
    final GlobalKey<FormState> experienceAddFormKey = GlobalKey();
    final GlobalKey<FormState> experienceUpdateFormKey = GlobalKey();

  ///----------- Form keys ----------------///



  ///--------- User Detail Change ------------- ///

  final jobLocationSearchController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final expertiseController = TextEditingController();

  List<String> expertiseList=[];

  taglineToExpertiseList(UserModel model){
    expertiseList=[];
    if(model.tTagLine != ""){
       List<String>  list = model.tTagLine!.split(" || ");
       for(String i in list){
      expertiseList.add(i);
     }
    }
    notifyListeners();
  }

  String tagline ="";

  expertiseToTagline(){
    tagline ="";
    tagline = expertiseList.join(" || ");
    notifyListeners();
  }

  addUserDetailToDialog(UserModel user){
    userDetailSelectedJobLocation = user.vCity;
    firstNameController.text = user.vFirstName;
    lastNameController.text = user.vLastName;
    emailController.text = user.vEmail;
    notifyListeners();
  }

  bool isExpertiseAdded = false;
  addExpertise(){
    if(expertiseController.text !=""){
      expertiseList.add(expertiseController.text);
      isExpertiseAdded = false;
      expertiseController.clear();
    }
    notifyListeners();
  }
  String? userDetailSelectedJobLocation;
  bool isUserDetailsJobSelect = false;

  updateSelectedJobLocation(String? value) {
    userDetailSelectedJobLocation = value;
    isUserDetailsJobSelect = false;
    notifyListeners();
  }

  userDetailChangeCancelButton(){
    // clearUserDetailForms();
    updateIsDialogShow();
    notifyListeners();
  }

  userDetailChangeDoneButton(){
    expertiseToTagline();
    userModelData.user.vFirstName = firstNameController.text;
    userModelData.user.vLastName = lastNameController.text;
    userModelData.user.vCity = userDetailSelectedJobLocation!;
    userModelData.user.vEmail = emailController.text;
    userModelData.user.tTagLine = tagline;
    if(userDetailFormKey.currentState!.validate()){
      if(expertiseList.isNotEmpty){
        isExpertiseAdded = false;
        if(userDetailSelectedJobLocation != null){
          isUserDetailsJobSelect = false;
          /// Success
          BoxService.boxService.addUserDetailToHive(userDetailKey, userModelData);
          updateIsDialogShow();
          // clearUserDetailForms();
        }else{
          isUserDetailsJobSelect = true;
        }
      }else{
        isExpertiseAdded = true;
      }
    }
    notifyListeners();
  }

  ///--------- User Detail Change ------------- ///


  ///---------------- About Change ------------------///

  final bioController = TextEditingController();

  addBioToDialog(UserModel user){
    bioController.text = user.tBio??"";
    notifyListeners();
  }

  bioCancelButton(){
    updateIsDialogShow();
    bioController.clear();
    notifyListeners();
  }
  bioDoneButton(){
    userModelData.user.tBio = bioController.text;
    if(aboutFormKey.currentState!.validate()){
      debugPrint("Success");
      BoxService.boxService.addUserDetailToHive(userDetailKey, userModelData);
      updateIsDialogShow();
      // bioController.clear();
    }
    notifyListeners();
  }

  ///---------------- About Change ------------------///

  ///---------------- Show dialog according to its value --------------///

  updateIsDialogShow() {
    isDialogShow = !isDialogShow;
    notifyListeners();
  }

  setDialogValue(int value) {
    dialogValue = value;
    notifyListeners();
  }


  /// ------------ for Job Seeker ------------///
  jobSeekerShowDialogs() {
    final userData = BoxService.boxService.userGetDetailBox.get(userDetailKey)!.user;
    if (dialogValue == 0) {
      return UserBannerImageDialogBox(userModel: userModelData.user,);
    } else if (dialogValue == 1) {
      return UserProfileImageChangeDialogBox(userModel:  userModelData.user,);
    } else if (dialogValue == 2) {
      return const UserDetailsDialogBox();
    } else if (dialogValue == 3) {
      return const UserAboutDialogBox();
    } else if (dialogValue == 4) {
      return const UserQualificationDialogBox();
    }else if(dialogValue == 5){
      return userData.iRole  == 0? const UserExperienceDialogBox() : const UserCurrentPositionDialogBox();
    }else if(dialogValue == 6){
      return const UserResumeDialogBox();
    }
    notifyListeners();
  }
  /// ------------ for Job Seeker ------------///

  ///---------------- Show dialog according to its value --------------///


  /// ------ Banner Image ----///
  late AnimationController uploadBannerLottieController;

  bool isBannerAnimationRun = false;
  String? bannerImgUrl;
  File? bannerImg;
  String bannerImgName ="";

  Future<void> pickBannerImg() async{
    isBannerAnimationRun = true;
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg','png','jpeg']
    );
    bannerImgUrl = null;
    notifyListeners();
    uploadBannerLottieController.stop();
    if(result != null){
      final PlatformFile file = result.files.first;
      uploadBannerLottieController.reset();
      uploadBannerLottieController.forward();
      await Future.delayed(const Duration(seconds: 3),);
      bannerImg = File(file.path!);
      bannerImgUrl = file.path;
      bannerImgName = file.name;
      isBannerAnimationRun=false;
      notifyListeners();
    }else{
      uploadBannerLottieController.stop();
      isBannerAnimationRun=false;
      notifyListeners();
    }
    notifyListeners();
  }


  Future bannerImgApiCall(String bannerName,String bannerUrl)async{
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {'Accept': 'application/json','Authorization': 'Bearer ${user?.tAuthToken}',});
      FormData formData = FormData.fromMap({
        "bannerPic": await MultipartFile.fromFile(bannerUrl, filename: bannerName),
      });
      Response response = await DioClient.client.postDataWithFormWithBearerToken(APIEndPoint.userUpdateBannerPicApi, formData: formData, options: options);
      if(response.statusCode == 200){
       UserModel user = UserModel.fromJson(response.data["data"]);
        userModelData.user.tProfileBannerUrl = user.tProfileBannerUrl;
       BoxService.boxService.addUserDetailToHive(userDetailKey, userModelData);
       debugPrint("banner url------->${userModelData.user.tProfileBannerUrl} ");
        bannerImgUrl=null;
        bannerImgName="";
       bannerImg=null;
       notifyListeners();
      }
    }catch(e){
      bannerImg=null;
      bannerImgUrl=null;
      bannerImgName="";
      Future.error(e);
    }
    notifyListeners();
  }
  /// ------ Banner Image ----///



  /// ------ profile Image ----///
  late AnimationController uploadProfileImgLottieController;

  bool isProfileImgAnimationRun = false;
  String? profileImgUrl;
  String profileImgName = "";
  File? profileImg;

  Future<void> pickProfileImg() async{
    isProfileImgAnimationRun = true;
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg','png','jpeg']
    );
    profileImg = null;
    notifyListeners();
    uploadProfileImgLottieController.stop();
    if(result != null){
      final PlatformFile file = result.files.first;
      // print("image name --->${file.name}");
      uploadProfileImgLottieController.reset();
      uploadProfileImgLottieController.forward();
      await Future.delayed(const Duration(seconds: 5),);
      profileImg = File(file.path!);
      profileImgUrl = file.path;
      profileImgName = file.name;
      isProfileImgAnimationRun=false;
      notifyListeners();
    }else{
      uploadProfileImgLottieController.stop();
      isProfileImgAnimationRun=false;
      notifyListeners();
    }
    notifyListeners();
  }


  Future profileImgApiCall(String profileName,String profilePicUrl)async{
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {'Accept': 'application/json','Authorization': 'Bearer ${user?.tAuthToken}',});
      FormData formData = FormData.fromMap({
        "profilePic": await MultipartFile.fromFile(profilePicUrl, filename: profileName),
      });
      Response response = await DioClient.client.postDataWithFormWithBearerToken(APIEndPoint.userUpdateProfilePicApi, formData: formData, options: options);
      if(response.statusCode == 200){
        UserModel user = UserModel.fromJson(response.data["data"]);
        userModelData.user.tProfileUrl = user.tProfileUrl;
        BoxService.boxService.addUserDetailToHive(userDetailKey, userModelData);
        debugPrint("Image url------->${userModelData.user.tProfileBannerUrl} ");
        profileImgUrl=null;
        profileImgName="";
        profileImg=null;
        notifyListeners();
      }
    }catch(e){
      profileImgUrl=null;
      profileImgName="";
      profileImg=null;
      Future.error(e);
    }
    notifyListeners();
  }
  /// ------ profile Image ----///


  /// ------ resume Edit ----////
  late AnimationController resumeLottieController;

  String resumeName="";
  String? resumeUrl;
  // File? pdfFile;

  addResumeNameToDialog(String name){
  resumeName = name;
  notifyListeners();
  }

  Future<void> pickResumeFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    resumeLottieController.stop();
    if (result != null) {
      resumeLottieController.reset();
      resumeLottieController.forward();
      final PlatformFile file = result.files.first;
      resumeUrl = file.path;
      resumeName = file.name;
      notifyListeners();
    } else {
      resumeLottieController.stop();
    }
  }

  Future resumeApiCall(String resumeName,String resumeUrl)async{
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {'Accept': 'application/json','Authorization': 'Bearer ${user?.tAuthToken}',});
      FormData formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(resumeUrl, filename: resumeName),
      });
      Response response = await DioClient.client.postDataWithFormWithBearerToken(APIEndPoint.userUpdateResumeApi, formData: formData, options: options);
      if(response.statusCode == 200){
        UserModel user = UserModel.fromJson(response.data["data"]);
        userModelData.user.tResumeUrl = user.tResumeUrl;
        BoxService.boxService.addUserDetailToHive(userDetailKey, userModelData);
        debugPrint("resume url------->${userModelData.user.tProfileBannerUrl} ");
        this.resumeUrl = null;
        this.resumeName="";
        notifyListeners();
      }
    }catch(e){
      this.resumeUrl = null;
      this.resumeName="";
      Future.error(e);
    }
    notifyListeners();
  }
  /// ------ resume Edit ----////




  /// ------ User Experience  ----////

  final userExperienceAddDesignFieldController = TextEditingController();
  final userExperienceAddCompanyNameFieldController = TextEditingController();
  final userExperienceAddSearchJobLocationFieldController = TextEditingController();
  final userExperienceAddDurationFieldController = TextEditingController();

  final userExperienceUpdateDesignFieldController = TextEditingController();
  final userExperienceUpdateCompanyNameFieldController = TextEditingController();
  final userExperienceUpdateSearchJobLocationFieldController = TextEditingController();
  final userExperienceUpdateDurationFieldController = TextEditingController();

  int selectedUserExperienceListIndex = -1;
  int updateItemIndex = 0;


  String? userExperienceUpdateSelectedJobLocation;
  bool isUserExperienceUpdateJobSelected = false;
  updateUserExperienceUpdateSelectedJobLocation(String? value) {
    userExperienceUpdateSelectedJobLocation = value;
    isUserExperienceUpdateJobSelected = false;
    notifyListeners();
  }
  bool checkBoxValUpdateForm = false;

  updateCheckBoxValUpdateForm(bool value){
    checkBoxValUpdateForm = value;
    notifyListeners();
  }

  updateListItemButton(UserExperienceModel model) async{
    if(experienceUpdateFormKey.currentState!.validate()){
      if(userExperienceUpdateSelectedJobLocation != null){
        isUserExperienceUpdateJobSelected = false;

        await  updateExperienceApi(model);
        await getUserExperienceApi();
        /// Clear form after update ///
        userExperienceUpdateDesignFieldController.clear();
        userExperienceUpdateCompanyNameFieldController.clear();
        userExperienceUpdateSearchJobLocationFieldController.clear();
        userExperienceUpdateSelectedJobLocation =null;
        userExperienceUpdateDurationFieldController.clear();
        selectedUserExperienceListIndex = -1;
      }else{
        isUserExperienceUpdateJobSelected = true;
      }
    }
    notifyListeners();
  }


  bool checkBoxValAddForm = false;
  updateCheckBoxValAddForm(bool value){
    checkBoxValAddForm = value;
    notifyListeners();
  }


  listDeleteButton(UserExperienceModel model)async{
    await deleteExperienceApi(model);
    await getUserExperienceApi();
    notifyListeners();
  }

  listEditButton({
    required int index,
    required String designation,
    required String companyName,
    required String jobLocation,
    String? duration,
  }) {
    if (selectedUserExperienceListIndex == index) {
      selectedUserExperienceListIndex = -1;
    } else {
      updateItemIndex = index;
      selectedUserExperienceListIndex = index;
      userExperienceUpdateDesignFieldController.text = designation;
      userExperienceUpdateCompanyNameFieldController.text = companyName;
      userExperienceUpdateSelectedJobLocation = jobLocation;
      userExperienceUpdateDurationFieldController.text = duration ?? "";
    }
    notifyListeners();
  }

  bool isExperienceExpanded = false;
  bool isExperienceAddShow = false;

  updateIsExperienceAddShow(bool value) {
    isExperienceAddShow = value;
    notifyListeners();
  }

  updateIsExperienceExpanded(bool value){
    isExperienceExpanded = value;
    notifyListeners();
  }


  String? userExperienceAddSelectedJobLocation;
  bool isUserExperienceAddJobSelected = false;
  updateUserExperienceAddSelectedJobLocation(String? value) {
    userExperienceAddSelectedJobLocation = value;
    isUserExperienceAddJobSelected = false;
    notifyListeners();
  }

  userExperienceAddButton() {
    // print(" add Button $userExperienceAddSelectedJobLocation");
    // print(" add designation $userExperienceAddDesignFieldController");
    // print(" add company name $userExperienceAddCompanyNameFieldController");
    if(experienceAddFormKey.currentState!.validate()){
      if(userExperienceAddSelectedJobLocation != null){
        isUserExperienceAddJobSelected = false;
        insertExperienceApi();
        getUserExperienceApi();
        /// Clear after adding ////
        userExperienceAddDesignFieldController.clear();
        userExperienceAddSearchJobLocationFieldController.clear();
        userExperienceAddDurationFieldController.clear();
        userExperienceAddSelectedJobLocation = null;
        userExperienceAddCompanyNameFieldController.clear();
        isExperienceAddShow = false;
      }else{
        isUserExperienceAddJobSelected = true;
      }
    }
    notifyListeners();
  }

  experienceOkButton(){
    updateIsDialogShow();
      selectedUserExperienceListIndex = -1;
     notifyListeners();
  }
  /// ------ User Experience ----////



  /// ------ User Current Position ----////

  final userCurrentPosDesignFieldController = TextEditingController();
  final userCurrentPosCompanyNameFieldController = TextEditingController();
  final userCurrentPosSearchJobLocationController = TextEditingController();

  String? userCurrentPosSelectedJobLocation;
  bool isUserCurrentPosJobSelected = false;
  updateUserCurrentPosSearchJobLocationController(String? value) {
    userCurrentPosSelectedJobLocation = value;
    isUserCurrentPosJobSelected = false;
    notifyListeners();
  }

  addCurrentPositionToDialog(UserModel user){
    userCurrentPosDesignFieldController.text = user.vDesignation!;
    userCurrentPosCompanyNameFieldController.text = user.vCurrentCompany!;
    userCurrentPosSelectedJobLocation = user.vJobLocation!;
    setValueOfWorkingMode(user.vWorkingMode!);
    notifyListeners();
  }

  List<String> workingModeList=[
    "On-Site",
    "Remote",
    "Hybrid",
  ];

  setValueOfWorkingMode(String site){
    if(site == "On-Site"){
      selectedWorkingMode=0;
    }else if(site == "Remote"){
      selectedWorkingMode=1;
    }else if(site == "Hybrid"){
      selectedWorkingMode=2;
    }
    notifyListeners();
  }

  int selectedWorkingMode = 0;
  String selectedWorkingText = "";
  updateWorkingMode(int index){
    selectedWorkingMode = index;
    debugPrint(workingModeList[index]);
    selectedWorkingText = workingModeList[index];
    notifyListeners();
  }

  clearCurrentPosForm(){
    userCurrentPosDesignFieldController.clear();
    userCurrentPosCompanyNameFieldController.clear();
    userCurrentPosSelectedJobLocation = null;
    selectedWorkingMode =0;
    notifyListeners();
  }
  currentPositionCancelButton(){
    updateIsDialogShow();
    clearCurrentPosForm();
  }

  currentPositionDoneButton(){
    userModelData.user.vDesignation = userCurrentPosDesignFieldController.text;
    userModelData.user.vCurrentCompany = userCurrentPosCompanyNameFieldController.text;
    userModelData.user.vJobLocation = userCurrentPosSelectedJobLocation;
    userModelData.user.vWorkingMode = selectedWorkingText;
    if(currentPositionFormKey.currentState!.validate()){
      if(userCurrentPosSelectedJobLocation != null){
        isUserCurrentPosJobSelected = false;
        BoxService.boxService.addUserDetailToHive(userDetailKey, userModelData);
        debugPrint("Success");
        updateIsDialogShow();
        clearCurrentPosForm();
      }else{
        isUserCurrentPosJobSelected =true;
      }
      notifyListeners();
    }
  }
  /// ------ User Current Position ----////



  /// ------ User Qualification ------- ///

  final qualificationSearchController = TextEditingController();
  bool isQualificationSelected = false;
  String? selectedQualification;

  updateSelectedQualification(String? value) {
    selectedQualification = value;
    isQualificationSelected = false;
    notifyListeners();
  }

  addQualificationToDialog(UserModel  user){
    selectedQualification = user.vQualification;
    notifyListeners();
  }
  qualificationChangeCancelButton(){
    updateIsDialogShow();
    selectedQualification = null;
    notifyListeners();
  }

  qualificationChangeDoneButton(){
    userModelData.user.vQualification = selectedQualification;
    if(selectedQualification != null){
      isQualificationSelected = false;
      BoxService.boxService.addUserDetailToHive(userDetailKey, userModelData);
      updateIsDialogShow();
      selectedQualification = null;
    }else{
      isQualificationSelected = true;
    }
    notifyListeners();
  }
/// ------ User Qualification ------- ///



  ///----------------User Experience Api call and Store Data on hive -----------------------///

  List<UserExperienceModel> userExperienceList = [];
  bool isExperienceLoading = false;
  Future getUserExperienceApi()async{
    isExperienceLoading= true;
    userExperienceList = [];
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user?.tAuthToken}',
          }
      );
      Response response = await DioClient.client.getDataWithBearerToken(APIEndPoint.userExperienceApi,options);
      if(response.statusCode == 200){
        List responseData = response.data["data"];
        for(dynamic i in responseData) {
          UserExperienceModel job = UserExperienceModel.fromJson(i);
          userExperienceList.add(job);
        }
        isExperienceLoading= false;
        notifyListeners();
        // print(response.data['data']);
      }
    }catch(e){
      isExperienceLoading= false;
      Future.error(e);
    }
    notifyListeners();
  }

  Future insertExperienceApi()async{
    isExperienceLoading= true;
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {'Accept': 'application/json','Authorization': 'Bearer ${user?.tAuthToken}',});
      Response response = await
      DioClient.client.postDataWithJsonWithBearerToken(
          APIEndPoint.userExperienceInsertApi,
          {
            "vDesignation": userExperienceAddDesignFieldController.text,
            "vCompany": userExperienceAddCompanyNameFieldController.text,
            "vDuration":checkBoxValAddForm?"Present": userExperienceAddDurationFieldController.text,
            "vJobLocation": userExperienceAddSelectedJobLocation,
            "bIsCurrentCompany":checkBoxValAddForm? 1: 0
          },options);
      if(response.statusCode == 200){
        // var responseData = response.data["data"];
         var responseData = UserExperienceModel.fromJson(response.data["data"]);
        userExperienceList.add(responseData);
        isExperienceLoading= false;
        notifyListeners();
      }
    }catch(e){
      isExperienceLoading= false;
      Future.error(e);
    }
    notifyListeners();
  }


  Future updateExperienceApi(UserExperienceModel model)async{
    isExperienceLoading= true;
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {'Accept': 'application/json','Authorization': 'Bearer ${user?.tAuthToken}',});
      // print(options.headers);
      Response response = await
      DioClient.client.postDataWithJsonWithBearerToken(
          APIEndPoint.userExperienceUpdateApi,
          {
            "id": model.id,
            "vDesignation": userExperienceUpdateDesignFieldController.text,
            "vCompany": userExperienceUpdateCompanyNameFieldController.text,
            "vDuration":checkBoxValUpdateForm? "Present":userExperienceUpdateDurationFieldController.text,
            "vJobLocation": userExperienceUpdateSelectedJobLocation,
            "bIsCurrentCompany":checkBoxValUpdateForm? 1: 0
          },options);
      if(response.statusCode == 200){
        // var responseData = response.data["data"];
        var responseData = UserExperienceModel.fromJson(response.data["data"]);
        userExperienceList.add(responseData);
        isExperienceLoading= false;
        notifyListeners();
      }
    }catch(e){
      isExperienceLoading= false;
      Future.error(e);
    }
    notifyListeners();
  }


  Future deleteExperienceApi(UserExperienceModel model)async{
    isExperienceLoading= true;
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {'Accept': 'application/json','Authorization': 'Bearer ${user?.tAuthToken}',});
      Response response = await
      DioClient.client.postDataWithBearerToken(
          "${APIEndPoint.userExperienceDeleteApi}?id=${model.id}",options);
      if(response.statusCode == 200){
        isExperienceLoading= false;
        notifyListeners();
      }
    }catch(e){
      isExperienceLoading= false;
      Future.error(e);
    }
    notifyListeners();
  }


   Future userProfileDetailUpdateApi() async{
     expertiseToTagline();
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {'Accept': 'application/json','Authorization': 'Bearer ${user?.tAuthToken}',});
      Response response = await
      DioClient.client.postDataWithBearerToken("${APIEndPoint.userUpdateProfileDetailsApi}?vFirstName=${user!.user.vFirstName}&vLastName=${user.user.vLastName}&vEmail=${user.user.vEmail}&tBio=${user.user.tBio}&vcity=${user.user.vCity}&vCurrentCompany=${user.user.vCurrentCompany}&vDesignation=${user.user.vDesignation}&vJobLocation=${user.user.vJobLocation}&vQualification=${user.user.vQualification}&vWorkingMode=${user.user.vWorkingMode}&tTagLine=$tagline",
          options);
      if(response.statusCode == 200){
        debugPrint("Success update profile Screen to the local data base");
        notifyListeners();
      }
    }catch(e){
      Future.error(e);
    }
    notifyListeners();
  }
///----------------User Experience Api call and Store Data on hive -----------------------///

  File? pdfFile;
  bool isFetchingPdf= false;

  Future urlToFilePdf(String pdfUrl)async{
    try{
      isFetchingPdf = true;
      final response = await DioClient.dio.get("https://api.emploihunt.com$pdfUrl", options: Options(responseType: ResponseType.bytes));
      if(response.statusCode == 200){
        final Uint8List bytes = Uint8List.fromList(response.data);
        List<String> list = pdfUrl.split("/");
        String baseName = list[4].trim();
        final filename = basename(baseName);
        final dir = await getApplicationDocumentsDirectory();
        var file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes, flush: true);
        pdfFile = file;
        isFetchingPdf = false;
        notifyListeners();
      }
    }catch(e){
      isFetchingPdf = false;
      Future.error("fetch pdf error-----> $e");
    }
    notifyListeners();
  }

}


