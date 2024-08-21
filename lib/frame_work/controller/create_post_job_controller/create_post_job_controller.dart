import 'dart:io';

import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/controller/dash_board_controller/dash_board_controller.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/helper.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:file_picker/file_picker.dart';

import '../../../ui/utils/constant/app_constant.dart';
import '../../repository/services/hive_service/box_service.dart';

final createPostJobController = ChangeNotifierProvider((ref) => CreatePostJobController(ref));

class CreatePostJobController extends ChangeNotifier{
  final Ref ref;
   CreatePostJobController(this.ref);

  final GlobalKey<FormState> formKey = GlobalKey();

  final ScrollController scrollController = ScrollController();

  final jobTitleFocusNode = FocusNode();
  final jobTitleFieldController = TextEditingController();
  final companyNameFieldController = TextEditingController();
  final jobDescriptionFieldController = TextEditingController();
  final jobRoleRespFieldController = TextEditingController();
  final experienceFieldController = TextEditingController();
  final salaryFieldController = TextEditingController();
  final numberOfEmpFieldController = TextEditingController();



   bool isJobTitleEmpty = false;

   updateIsJobTitleEmpty(String title){
     if(title.isEmpty){
       isJobTitleEmpty = true;
     }else{
       isJobTitleEmpty = false;
     }
   }

  Future<List<String>> checkJobTitle(String query) async{
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    query = query.toUpperCase().trim();
    return designationList.where((jobTitle) => jobTitle.toUpperCase().trim().contains(query)).toList();
  }


  ///--------------- Working Mode ----------------///
  String selectedWorkingModeValue = "";
  bool isSelectRemoteValue = false;
  List<RadioButtonModel> workingModeList = [
    RadioButtonModel(title: "On-Site", value: "On-Site"),
    RadioButtonModel(title: "Remote", value: "Remote"),
    RadioButtonModel(title: "Hybrid", value: "Hybrid"),
  ];
  updateSelectedValue(String value){
    selectedWorkingModeValue = value;
    notifyListeners();
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

  addTechnicalSkill(){
    if(requiredTechnicalSkillsController.text != ""){
      technicalSkillsList.add(requiredTechnicalSkillsController.text);
      requiredTechnicalSkillsController.clear();
      isTechnicalSkillEmpty = false;
    }
    notifyListeners();
  }

  addSoftSkill(){
    if(requiredSoftSkillsController.text != ""){
      softSkillsList.add(requiredSoftSkillsController.text);
      requiredSoftSkillsController.clear();
      isSoftSkillEmpty = false;
    }
    notifyListeners();
  }

/// -------Required Skills ----------------------///


///----------------- DropDown Filed -----------------///
  final jobLocationSearchController = TextEditingController();
  // String? selectedJobLocation;
  bool isJobLocationSelect = false;
  updateSelectedJobLocation(String? value) {
    // selectedJobLocation = value;
    if(value !=""){
      isJobLocationSelect = false;
    }else{
      isJobLocationSelect = true;
    }
    notifyListeners();
  }

  final educationSearchController = TextEditingController();
  bool isEducationSelected = false;
  updateIsQualificationSelected(String value){
    if(value != ""){
      isEducationSelected = false;
    }else{
      isEducationSelected = true;
    }
  }

 /* List<String> checkEducation(String query){
    query = query.toUpperCase().trim();
    return qualificationsList.where((education) => education.toUpperCase().trim().contains(query)).toList();
  }*/
///----------------- DropDown Filed -----------------///

/// ------------------ Bottom Buttons -----------------///
  postButton(BuildContext context)async{
    if(formKey.currentState!.validate()){
      if(jobTitleFieldController.text.isNotEmpty){
        isJobTitleEmpty = false;
        if(imageName != ""){
          isFileSelected = false;
          if(technicalSkillsList.isNotEmpty){
            isTechnicalSkillEmpty =false;
            if(softSkillsList.isNotEmpty){
              isSoftSkillEmpty = false;
              if(educationSearchController.text != ""){
                isEducationSelected = false;
                if(jobLocationSearchController.text != ""){
                  isJobLocationSelect = false;
                  if(selectedWorkingModeValue !=""){
                    isSelectRemoteValue = false;
                    debugPrint("success");
                    await postJobInsertApi(context);
                  }else{
                    isSelectRemoteValue = true;
                  }
                }else{
                  isJobLocationSelect = true;
                }
              }else{
                isEducationSelected = true;
              }
            }else{
              isSoftSkillEmpty =true;
            }
          }else{
            isTechnicalSkillEmpty =true;
          }
        }else{
          isFileSelected = true;
        }
      }else{
        isJobTitleEmpty = true;
      }
    }else{
    }
    notifyListeners();
  }
  cancelButton(){
    technicalSkillsList = [];
    softSkillsList = [];
    final dashBoardWatch = ref.watch(dashBoardController);
    dashBoardWatch.otherWidgetAllowToNavigate(0);
    notifyListeners();
    imageName ="";
    imgUrl =null;
    imageFile = null;
    techSkillTagline="";
    softSkillTagline = "";
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

  clearForm(){
    technicalSkillsList = [];
    softSkillsList = [];
    imageName ="";
    imgUrl =null;
    imageFile = null;
    techSkillTagline="";
    softSkillTagline = "";
    jobTitleFieldController.text = "";
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
  String imageName ="";
  String? imgUrl;
  bool isFileSelected = false;
  File? imageFile;
  Future<void> imagePicker() async{
    final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
    );
    if(result != null){
      isFileSelected =false;
      final PlatformFile file = result.files.first;
      imageName = file.name;
      imgUrl = file.path;
      imageFile = File(file.path!);
    }else{
    }
    notifyListeners();
  }

///------------------ Pick Company Logo ---------------------///

    Future postJobInsertApi(BuildContext context)async{
    try{
      techSkillToTagline();
      softSkillToTagline();
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user != null) {
        Options options = Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.tAuthToken}',
          }
        );
        FormData formData = FormData.fromMap(
            {
              "vJobTitle":jobTitleFieldController.text,
              "vCompanyName":companyNameFieldController.text,
              "tDes":jobDescriptionFieldController.text,
              "vJobLevel":" ",
              "vExperience":experienceFieldController.text,
              "iNumberOfVacancy":numberOfEmpFieldController.text,
              "vJobRoleResponsbility":jobRoleRespFieldController.text,
              "tTechnicalSkill":techSkillTagline,
              "tSoftSkill":softSkillTagline,
              "vEducation":educationSearchController.text,
              "vAddress":jobLocationSearchController.text,
              "vSalaryPackage":salaryFieldController.text,
              "vWrokingMode":selectedWorkingModeValue,
              "tCompanyPic":await MultipartFile.fromFile(imgUrl!, filename: imageName),
            });

        Response response = await DioClient.client
            .postDataWithFormWithBearerToken("/job/insert_jobs_flutter",formData: formData,
            options: options);
        if(response.statusCode == 200){
          debugPrint("Job Post Done--------->");
          clearForm();
          scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          );
          if(context.mounted){
          showSnackBar(context: context, error: "Your Job Posted");}
          notifyListeners();
        }
      }
    }catch(e){
      Future.error("Post Job Insert API-------> $e");
    }
    notifyListeners();
    }


}

class RadioButtonModel{
  final String title;
  final String value;

  RadioButtonModel({required this.title, required this.value});

}