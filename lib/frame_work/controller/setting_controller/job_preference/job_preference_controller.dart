import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/model/job_preference_model/job_preference_model.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../../../ui/utils/common_widget/helper.dart';
import '../../../repository/api_end_point.dart';
import '../../../repository/dio_client.dart';
import '../../../repository/services/hive_service/box_service.dart';
import '../../../repository/services/shared_pref_services.dart';
import '../../create_post_job_controller/create_post_job_controller.dart';

final jobPreferenceController = ChangeNotifierProvider((ref) => JobPreferenceController());

class JobPreferenceController extends ChangeNotifier{

  ///--------------- Working Mode ----------------///
  String selectedRemoteValue = "";
  bool isSelectRemoteValue = false;
  List<RadioButtonModel> workingModeList = [
    RadioButtonModel(title: "On-Site", value: "On-Site"),
    RadioButtonModel(title: "Remote", value: "Remote"),
    RadioButtonModel(title: "Hybrid", value: "Hybrid"),
  ];
  updateSelectedValue(String value){
    selectedRemoteValue = value;
    notifyListeners();
  }
///--------------- Working Mode ----------------///

  ///--------------- search Field -----------------///
  final jobTitleSearchController = TextEditingController();

  List<String> checkJobTitle(String query){
    query = query.toUpperCase().trim();
    return designationList.where((education) => education.toUpperCase().trim().contains(query)).toList();
  }

  final cityController = TextEditingController();

  List<String> checkCity(String query){
    query = query.toUpperCase().trim();
    return SharedPrefServices.services.getList(locationListKey)!.where((city) => city.toUpperCase().trim().contains(query)).toList();
  }
  ///--------------- search Field -----------------///

  int selectedLPA = 1;
   updateSelectedLPA(int value){
    selectedLPA = value;
    notifyListeners();
  }


  ///--------------------------------------------- Job Preference Api -------------------------------------///


  List<JobPreferenceModel> jobPreferenceList = [];
  int? totalPages;
  // int currentPage= 1;
  bool isLoading = false;
  int  lenghtOfList = 0;

  Future jobPreferenceApiCall()async{
    try{
      jobPreferenceList=[];
      isLoading = true;
      notifyListeners();
      // currentPage = 1;
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null) {
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.tAuthToken}',
            }
        );
        Response response =await DioClient.client.getDataWithBearerToken(APIEndPoint.jobPreferenceApi, options);
        if(response.statusCode == 200){
          isLoading = false;
          // currentPage += 1;
          print(response.data["data"]);
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          for(dynamic i in responseData){
            JobPreferenceModel job = JobPreferenceModel.fromJson(i);
            jobPreferenceList.add(job);
          }
          lenghtOfList = jobPreferenceList.length;
          clearData();
          notifyListeners();
          print("List Data $jobPreferenceList");
          // JobPostModel data = JobPostModel.fromJson(response.data["data"]);
          // print(data);
        }
      }
    }catch(e) {
      isLoading = false;
      Future.error(e);
    }
    notifyListeners();
  }


  Future insertJobPreferenceApiCall(BuildContext context)async{
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.tAuthToken}',
          }
      );
      Response response = await DioClient.client.postDataWithJsonWithBearerToken(APIEndPoint.jobPreferenceInsertApi,
          {
            "vJobTitle": jobTitleSearchController.text,
            "vWorkingMode": selectedRemoteValue,
            "vExpectedSalary": selectedLPA.toString(),
            "vJobLocation": cityController.text
          },options);
      if(response.statusCode == 200){
        if(context.mounted){
          context.pop();
          showSnackBar(context: context, error: "You've Successfully Added");
        }
      }
    }catch(e) {
      isLoading = false;
      Future.error(e);
    }
    notifyListeners();
  }


  int? id;
  Future updateJobPreferenceApiCall(BuildContext context,)async{
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user!.tAuthToken}',
            }
        );
      Response response = await DioClient.client.postDataWithJsonWithBearerToken(APIEndPoint.jobPreferenceUpdateApi,
          {
            "id":id ?? 0,
            "vJobTitle": jobTitleSearchController.text,
            "vWorkingMode": selectedRemoteValue,
            "vExpectedSalary": selectedLPA.toString(),
            "vJobLocation": cityController.text
          },options);
      if(response.statusCode == 200){
        if(context.mounted){
          context.pop();
          showSnackBar(context: context, error: "You've Successfully Updated");
        }
      }
    }catch(e) {
      isLoading = false;
      Future.error(e);
    }
    notifyListeners();
  }
    submitButton(BuildContext context,){
    if(jobTitleSearchController.text.isNotEmpty){
      if(selectedRemoteValue!=""){
        if(cityController.text.isNotEmpty){
          isUpdateFunc?updateJobPreferenceApiCall(context,): insertJobPreferenceApiCall(context);
        }else{
          showSnackBar(context: context, error: "Prefer city is required!");
        }
      }else{
        showSnackBar(context: context, error: "Please select working mode");
      }
    }else{
      showSnackBar(context: context, error: "Job title is required!");
    }
    notifyListeners();
    }

  bool isUpdateFunc=false;
  updateIsUpdateFunc(bool value){
    isUpdateFunc = value;
    notifyListeners();
  }
  
  getPreviousValue(JobPreferenceModel model){
    id = model.id;
    jobTitleSearchController.text = model.vJobTitle!;
    cityController.text = model.vJobLocation!;
    selectedRemoteValue =  model.vWorkingMode!;
    selectedLPA = int.parse(model.vExpectedSalary!);
    notifyListeners();
  }

  clearData(){
    jobTitleSearchController.clear();
    cityController.clear();
    selectedRemoteValue ="";
    selectedLPA = 1;
    notifyListeners();
    }

///--------------------------------------------- Job Preference Api -------------------------------------///
}