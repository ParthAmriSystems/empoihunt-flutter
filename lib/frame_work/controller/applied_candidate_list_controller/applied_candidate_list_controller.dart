import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/model/applied_candidate_list_model/applied_user_model.dart';
import 'package:emploiflutter/frame_work/repository/model/job_preference_model/job_preference_model.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';


final appliedCandidateListController = ChangeNotifierProvider((ref) => AppliedCandidateListController());

class AppliedCandidateListController extends ChangeNotifier{

  List<Map<String,dynamic>> jobPreferenceList = [];


  bool isLoading = false;
  String? jobId;
  Map<String,dynamic> selectedPostJob = {};

  updateSelectedPostJob(Map<String,dynamic> value)async{
    selectedPostJob = value;
    jobId = value.values.first.toString();
   await getJobSeekerByTagId(jobId!);
    print(value.values.first);
    notifyListeners();
  }


  Future jobsByHRIdWithoutPaginationApi() async{
    try{
      isLoading = true;
      jobPreferenceList  =[];
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user!.tAuthToken}',
        }
      );

      Response response = await DioClient.client.getDataWithBearerToken(APIEndPoint.jobsByHrIdWOPagination, options);
      if(response.statusCode == 200){
        isLoading = false;
        final responseData = response.data["data"];
        if (responseData.isNotEmpty) {
          for (dynamic i in responseData) {
            JobPreferenceModel jobPostModel = JobPreferenceModel.fromJson(i);
            jobPreferenceList.add({jobPostModel.vJobTitle!:jobPostModel.id});
            print(jobPreferenceList);
          }
          selectedPostJob = jobPreferenceList[0];
          jobId = selectedPostJob.values.first.toString();
          print(jobId);
          await getJobSeekerByTagId(jobId!);
          notifyListeners();

        }
      }
    }catch (e){
      isLoading = false;
      jobPreferenceList  =[];
      Future.error("Applied Candidate Api Error---------> $e");
    }
    notifyListeners();
  }


  List<AppliedUserModel> appliedUserList = [];

  Future getJobSeekerByTagId(String id) async{
    try{
      isLoading = true;
      appliedUserList = [];
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Options options = Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.tAuthToken}',
          }
      );
      Response response = await DioClient.client.getDataWithBearerToken("${APIEndPoint.getAppliedUserByTagApi}?jobId=$id&current_page=1", options);
      if(response.statusCode == 200){
        isLoading = false;
        print("response 200");
        final data = response.data["data"];
        for(dynamic i in data){
          AppliedUserModel user = AppliedUserModel.fromJson(i);
          appliedUserList.add(user);
        }
        notifyListeners();
        debugPrint("applied User------->$appliedUserList");
      }
    }catch(e){
      isLoading = false;
      Future.error("get user error--------> $e");
    }
    notifyListeners();
  }
}