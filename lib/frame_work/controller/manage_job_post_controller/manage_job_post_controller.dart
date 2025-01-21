import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/controller/create_post_job_controller/create_post_job_controller.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../ui/utils/constant/app_constant.dart';
import '../../../ui/utils/common_widget/helper.dart';
import '../../repository/api_end_point.dart';
import '../../repository/dio_client.dart';
import '../../repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import '../../repository/services/hive_service/box_service.dart';

final manageJobPostController =
    ChangeNotifierProvider((ref) => ManageJobPostController());

class ManageJobPostController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey();

  final ScrollController scrollController = ScrollController();


  Future<void> saveNetworkImageToFile(JobPostModel jobPostModel) async {
    isLoading = true;
    try{
      final response = await DioClient.dio.get('https://api.emploihunt.com${jobPostModel.tCompanyLogoUrl}', options: Options(responseType: ResponseType.bytes));
      if(response.statusCode == 200){
        isLoading = false;
        final Uint8List bytes = Uint8List.fromList(response.data);
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        List<String> list = jobPostModel.tCompanyLogoUrl!.split("/");
        String fileName = list[4].trim();
        imageName = list[4].trim();
        final File file = File('$appDocPath/$fileName');
        await file.writeAsBytes(bytes);
        imageFile = file;
        imgUrl = file.path;
        notifyListeners();
      }
    }catch(e){
    isLoading = false;
    Future.error("network image to file error-------$e");
    }
    notifyListeners();
  }






  final jobTitleFocusNode = FocusNode();
  final jobTitleFieldController = TextEditingController();
  final companyNameFieldController = TextEditingController();
  final jobDescriptionFieldController = TextEditingController();
  final jobRoleRespFieldController = TextEditingController();
  final experienceFieldController = TextEditingController();
  final salaryFieldController = TextEditingController();
  final numberOfEmpFieldController = TextEditingController();

  ///--------------- Working Mode ----------------///
  String selectedWorkingModeValue = "";
  bool isSelectRemoteValue = false;
  List<RadioButtonModel> workingModeList = [
    RadioButtonModel(title: "On-Site", value: "On-Site"),
    RadioButtonModel(title: "Remote", value: "Remote"),
    RadioButtonModel(title: "Hybrid", value: "Hybrid"),
  ];

  updateSelectedValue(String value) {
    selectedWorkingModeValue = value;
    isSelectRemoteValue = false;
    notifyListeners();
    print(value);
    // print(selectedValue);
  }

  ///--------------- Working Mode ----------------///

  /// -------Required Skills ----------------------///

  List<String> technicalSkillsList = [];
  List<String> softSkillsList = [];
  bool isTechnicalSkillEmpty = false;
  bool isSoftSkillEmpty = false;

  final requiredTechnicalSkillsController = TextEditingController();
  final requiredSoftSkillsController = TextEditingController();

  techTagLineToTechList(JobPostModel model){
    technicalSkillsList=[];
    if(model.tTechnicalSkill != ""){
     List<String> list = model.tTechnicalSkill!.split(" || ");
      for(String i in list){
        technicalSkillsList.add(i);
      }
      print(technicalSkillsList);
    }
    notifyListeners();
  }

  softTagLineToSoftList(JobPostModel model){
    softSkillsList=[];
    if(model.tSoftSkill != ""){
      List<String> list = model.tSoftSkill!.split(" || ");
      for(String i in list){
        softSkillsList.add(i);
      }
    }
    notifyListeners();
  }

  String? techSkillTagline;

  techSkillToTagline(){
    techSkillTagline = "";
    techSkillTagline = technicalSkillsList.join(" || ");
    notifyListeners();
  }

  String? softSkillTagline;

  softSkillToTagline(){
    softSkillTagline = "";
    softSkillTagline = softSkillsList.join(" || ");
    notifyListeners();
  }

  addTechnicalSkill() {
    if (requiredTechnicalSkillsController.text != "") {
      technicalSkillsList.add(requiredTechnicalSkillsController.text);
      requiredTechnicalSkillsController.clear();
      isTechnicalSkillEmpty = false;
    }
    notifyListeners();
  }

  addSoftSkill() {
    if (requiredSoftSkillsController.text != "") {
      softSkillsList.add(requiredSoftSkillsController.text);
      requiredSoftSkillsController.clear();
      isSoftSkillEmpty = false;
    }
    notifyListeners();
  }

  /// -------Required Skills ----------------------///

  ///----------------- DropDown Filed -----------------///
  final jobLocationSearchController = TextEditingController();
  String? selectedJobLocation;
  bool isJobLocationSelect = false;

  updateSelectedJobLocation(String? value) {
    selectedJobLocation = value;
    isJobLocationSelect = false;
    notifyListeners();
  }

  final educationSearchController = TextEditingController();
  bool isEducationSelected = false;

  updateIsQualificationSelected(String value) {
    if (value != "") {
      isEducationSelected = false;
    } else {
      isEducationSelected = true;
    }
  }

  List<String> checkEducation(String query) {
    query = query.toUpperCase().trim();
    return qualificationsList
        .where((education) => education.toUpperCase().trim().contains(query))
        .toList();
  }

  ///----------------- DropDown Filed -----------------///

  /// ------------------ Bottom Buttons -----------------///
  updateButton(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (imageName != "") {
        isFileSelected = false;
        if (technicalSkillsList.isNotEmpty) {
          isTechnicalSkillEmpty = false;
          if (softSkillsList.isNotEmpty) {
            isSoftSkillEmpty = false;
            if (educationSearchController.text != "") {
              isEducationSelected = false;
              if (selectedJobLocation != null) {
                isJobLocationSelect = false;
                if (selectedWorkingModeValue != "") {
                  isSelectRemoteValue = false;
                  debugPrint("success");
                  await updatePostApi(context);
                } else {
                  isSelectRemoteValue = true;
                }
              } else {
                isJobLocationSelect = true;
              }
            } else {
              isEducationSelected = true;
            }
          } else {
            isSoftSkillEmpty = true;
          }
        } else {
          isTechnicalSkillEmpty = true;
        }
      } else {
        isFileSelected = true;
      }
    } else {
      jobTitleFocusNode.requestFocus();
    }
    notifyListeners();
  }

  cancelButton() {
    notifyListeners();
    imageName = "";
    imgUrl = null;
    imageFile = null;
    techSkillTagline = null;
    softSkillTagline = null;
    jobTitleFieldController.clear();
    companyNameFieldController.clear();
    jobDescriptionFieldController.clear();
    jobRoleRespFieldController.clear();
    experienceFieldController.clear();
    salaryFieldController.clear();
    numberOfEmpFieldController.clear();
    requiredTechnicalSkillsController.clear();
    requiredSoftSkillsController.clear();
    jobLocationSearchController.clear();
    educationSearchController.clear();
  }

  clearForm() {
    imageName = "";
    imgUrl = null;
    imageFile = null;
    techSkillTagline = null;
    softSkillTagline = null;
    jobTitleFieldController.clear();
    companyNameFieldController.clear();
    jobDescriptionFieldController.clear();
    jobRoleRespFieldController.clear();
    experienceFieldController.clear();
    salaryFieldController.clear();
    numberOfEmpFieldController.clear();
    requiredTechnicalSkillsController.clear();
    requiredSoftSkillsController.clear();
    jobLocationSearchController.clear();
    educationSearchController.clear();
    notifyListeners();
  }

  /// ------------------ Bottom Buttons -----------------///

  ///------------------ Pick Company Logo ---------------------///
  String imageName = "";
  String? imgUrl;
  bool isFileSelected = false;
  File? imageFile;

  Future<void> imagePicker() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
    if (result != null) {
      isFileSelected = false;
      final PlatformFile file = result.files.first;
      imageName = file.name;
      imgUrl = file.path;
      imageFile = File(file.path!);
    } else {}
    notifyListeners();
  }

  ///------------------ Pick Company Logo ---------------------///


  ///------------------------------ add Data to the Update page ------------------------------///

  int? iJobId;
  addJobDetailToField(JobPostModel jobPostModel){
    print(jobPostModel.tSoftSkill);
    print(jobPostModel.tTechnicalSkill);
    iJobId = jobPostModel.id;
    if(jobPostModel.vWrokingMode !=""){
      isSelectRemoteValue = false;
      selectedWorkingModeValue = jobPostModel.vWrokingMode??"";
    }
    List<String> url = jobPostModel.tCompanyLogoUrl!.split("/");
    techTagLineToTechList(jobPostModel);
    softTagLineToSoftList(jobPostModel);
    imageName = url[4].trimLeft();
    imgUrl = jobPostModel.tCompanyLogoUrl;
    jobTitleFieldController.text = jobPostModel.vJobTitle??"";
    companyNameFieldController.text = jobPostModel.vCompanyName??"";
    jobDescriptionFieldController.text = jobPostModel.tDes??"";
    jobRoleRespFieldController.text = jobPostModel.vJobRoleResponsbility??"";
    experienceFieldController.text = jobPostModel.vExperience??"";
    salaryFieldController.text = jobPostModel.vSalaryPackage??"";
    numberOfEmpFieldController.text = jobPostModel.iNumberOfVacancy.toString();
    selectedJobLocation = jobPostModel.vAddress??"";
    educationSearchController.text = jobPostModel.vEducation??"";
    notifyListeners();
  }

  ///------------------------------ add Data to the Update page ------------------------------///

  ///----------------------------------- take epochTime and return how long ago the post is --------------------------///
  String getTimeAgo(int epochTime) {
    final now = DateTime.now().toUtc();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(epochTime * 1000).toUtc();

    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      final months = difference.inDays ~/ 30;
      return '$months months ago';
    }
  }
  ///----------------------------------- take epochTime and return how long ago the post is --------------------------///


  ///--------------------------------------------- APIs -------------------------------------------///
  Future updatePostApi(BuildContext context) async {
    try {
      techSkillToTagline();
      softSkillToTagline();
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if (user != null) {
        Options options = Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.tAuthToken}',
        });
        FormData formData = FormData.fromMap({
          "tCompanyPic":
              await MultipartFile.fromFile(imgUrl!, filename: imageName),
        });
        Response response = await DioClient.client.postDataWithFormWithBearerToken(
            "${APIEndPoint.jobUpdateApi}?iJobId=$iJobId.&vJobTitle=${jobTitleFieldController.text}&vCompanyName=${companyNameFieldController.text}&tDes=${jobDescriptionFieldController.text}&vJobLevel=""&vExperience=${experienceFieldController.text}&iNumberOfVacancy=${numberOfEmpFieldController.text}&vJobRoleResponsbility=${jobRoleRespFieldController.text}&tTechnicalSkill=$techSkillTagline&tSoftSkill=$softSkillTagline&vEducation=${educationSearchController.text}&vAddress=$selectedJobLocation&vSalaryPackage=${salaryFieldController.text}&vWrokingMode=$selectedWorkingModeValue",
            formData: formData,
            options: options);
        if (response.statusCode == 200) {
          debugPrint("Job Post Update Successfully--------->");
          clearForm();
          if(context.mounted){
          context.pop();
          getJobPostApi(context);
          }
          if (context.mounted) {
            showSnackBar(
                context: context, error: "Job Post Update Successfully");
          }
          notifyListeners();
        }
      }
    } catch (e) {
      Future.error("Job Update API-------> $e");
    }
    notifyListeners();
  }


  Future deleteJobAPi(int jobId,BuildContext context)async{
      try{
        final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
        Options options = Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user!.tAuthToken}',
        });
        Response response = await DioClient.client.postDataWithBearerToken("${APIEndPoint.jobDeleteApi}?jobId=$jobId", options);
        if(response.statusCode == 200){
          if(context.mounted){
          getJobPostApi(context);}
        }
      }catch(e){
        Future.error("Delete Post Api----------->$e");
      }
  }


  Future disableJobAPi(int jobId,BuildContext context)async{
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user!.tAuthToken}',
      });
      Response response = await DioClient.client.postDataWithBearerToken("${APIEndPoint.jobDisableApi}?jobId=$jobId", options);
      if(response.statusCode == 200){
        if(context.mounted){
          getJobPostApi(context);}
      }
    }catch(e){
      Future.error("Delete Post Api----------->$e");
    }
  }

  List<JobPostModel> jobPostList = [];
  int? totalPages;
  int currentPage = 1;
  bool isLoading = false;

  Future getJobPostApi(BuildContext context) async {
    try {
      jobPostList = [];
      isLoading = true;
      notifyListeners();
      loadMoreData = false;
      currentPage = 1;
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if (user != null) {
        Options options = Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.tAuthToken}',
        });
        Response response = await DioClient.client
            .getDataWithBearerToken(APIEndPoint.jobGetJobByHrIdApi, options);
        if (response.statusCode == 200) {
          isLoading = false;
          currentPage += 1;
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          for (dynamic i in responseData) {
            JobPostModel jobPostModel = JobPostModel.fromJson(i);
            jobPostList.add(jobPostModel);
          }
          notifyListeners();
          print("List Data $jobPostList");
          notifyListeners();
        }
      }
    } catch (e) {
      isLoading = false;
      jobPostList = [];
      Future.error("Post Job Insert API-------> $e");
    }
    notifyListeners();
  }

  bool loadMoreData = false;

  Future<void> fetchItems() async {
    if (currentPage <= totalPages!) {
      loadMoreData = true;
      notifyListeners();
      try {
        final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
        if (user != null) {
          Options options = Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.tAuthToken}',
          });
          Response response = await DioClient.client.getDataWithBearerToken(
              "${APIEndPoint.jobGetJobByHrIdApi}?&current_page=$currentPage",
              options);
          if (response.statusCode == 200) {
            loadMoreData = false;
            List responseData = response.data["data"];
            if (responseData.isNotEmpty) {
              for (dynamic i in responseData) {
                JobPostModel jobPostModel = JobPostModel.fromJson(i);
                jobPostList.add(jobPostModel);
              }
              currentPage++;
            }
          }
        }
      } catch (e) {
        loadMoreData = false;
        Future.error(e);
      }
      loadMoreData = false;
    }
    notifyListeners();
  }

  ///--------------------------------------------- APIs -------------------------------------------///
}
