import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../repository/api_end_point.dart';
import '../../../repository/model/job_preference_model/job_preference_model.dart';

final jobSeekerHomeController = ChangeNotifierProvider((ref) => JobSeekerHomeController());

class JobSeekerHomeController extends ChangeNotifier{


  bool isSearchFiledVisible = false;
  updateIsSearchFiledVisible(){
    isSearchFiledVisible = !isSearchFiledVisible;
    notifyListeners();
  }


  List<JobPostModel> jobPostList = [];
  int? totalPages;
  int currentPage= 1;
  bool isLoading = false;
  String preferenceId = "0";

  Future getJobsPostApiCall()async{
    try{
      jobPostList=[];
      isLoading = true;
      notifyListeners();
      loadMoreData = false;
      currentPage = 1;
        final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
        if(user !=null) {
          Options options = Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.tAuthToken}',
              }
          );
          Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.jobPostApi}$preferenceId&tag=""&current_page=$currentPage", options);
          if(response.statusCode == 200){
            isLoading = false;
            currentPage += 1;
            List responseData = response.data["data"];
            totalPages = response.data["total_pages"];
            for(dynamic i in responseData){
              JobPostModel jobPostModel = JobPostModel.fromJson(i);
              jobPostList.add(jobPostModel);
            }
            notifyListeners();
            print("List Data $jobPostList");
            // JobPostModel data = JobPostModel.fromJson(response.data["data"]);
            // print(data);
          }
        }
    }catch(e) {
      isLoading = false;
      Future.error("get job error---->$e");
    }
    notifyListeners();
  }


  ///----------------------------------- Fetch more data from api -----------------------------------------------///
  bool loadMoreData = false;

  Future<void> fetchItems() async {
    if(currentPage <= totalPages!) {
      loadMoreData = true;
      notifyListeners();
      try {
        final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
        if (user != null) {
          Options options = Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.tAuthToken}',
              }
          );
          Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.jobPostApi}&tag=${searchController.text}&current_page=$currentPage", options);
          if (response.statusCode == 200) {
            loadMoreData = false;
            List responseData = response.data["data"];
            totalPages = response.data["total_pages"];
            if (responseData.isNotEmpty) {
              for (dynamic i in responseData) {
                JobPostModel jobPostModel = JobPostModel.fromJson(i);
                jobPostList.add(jobPostModel);
              }
              currentPage ++;
            }
          }
        }
      } catch (e) {
        loadMoreData = false;
        Future.error("job fetch error------->$e");
      }
      loadMoreData = false;
    }
    notifyListeners();
  }
  ///-------------------------------------- Fetch more data from api -----------------------------------------------///




  ///---------------------------------------- Search Feature ----------------------------------------///

  final searchController = TextEditingController();

  ///------------- text to speech --------------///
  final SpeechToText speechToText = SpeechToText();

  listeningVoice(BuildContext context)async{
isVoiceListening= true;
    if(isVoiceListening) {
      final available = await speechToText.initialize();
      if (available) {
        speechToText.listen(
          onResult: (result) {
            searchController.text = result.recognizedWords;
            notifyListeners();
            if (result.finalResult) {
              isVoiceListening= false;
              context.pop();
              Future.delayed(const Duration(seconds: 2), () {
                searchedData();
              });
            }else{
              isVoiceListening= false;
              speechToText.stop();
            }
          },
          listenMode: ListenMode.search,
        );
      } else {
        speechToText.stop();
        isVoiceListening= false;
        notifyListeners();
      }
    } else {
      speechToText.stop();
      isVoiceListening= false;
      notifyListeners();
    }
    notifyListeners();
  }

  bool isVoiceListening= false;
  dialogCancelButton(){
    isVoiceListening = false;
    speechToText.stop();
    notifyListeners();
  }

  ///------------- text to speech --------------///

  Future searchedData()async{
    print("Search function call");
    try{
      jobPostList=[];
      isLoading = true;
      notifyListeners();
      loadMoreData = false;
      currentPage = 1;
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null) {
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.tAuthToken}',
            }
        );
        Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.jobPostApi}0&tag=${searchController.text}&current_page=$currentPage", options);
        if(response.statusCode == 200){
          isLoading = false;
          currentPage += 1;
          print(response.data["data"]);
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          for(dynamic i in responseData){
            JobPostModel jobPostModel = JobPostModel.fromJson(i);
            jobPostList.add(jobPostModel);
          }
          notifyListeners();
          print("List Data $jobPostList");
          searchController.clear();
        }
      }
    }catch(e) {
      isLoading = false;
      searchController.clear();
      Future.error("Search job error------->$e");
    }
    notifyListeners();

  }

  ///---------------------------------------- Search Feature ----------------------------------------///

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


///----------------------------------- Job Preference if given ---------------------------------------------------///


  Map<String,dynamic> selectedPostJob = {};
  updateSelectedPostJob(Map<String,dynamic> value){
    selectedPostJob = value;
    preferenceId = value.values.first.toString();
    getJobsPostApiCall();
    print(value.values.first);
    notifyListeners();
  }

  List<Map<String,dynamic>> jobPreferenceList = [];
  int  lenghtOfList = 1;

  Future getJobPrefApiCall()async{
    try{
      jobPreferenceList= [];
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
          jobPreferenceList.add({"For you":0});
          selectedPostJob = jobPreferenceList[0];
          print(selectedPostJob);
          for(dynamic i in responseData) {
            JobPreferenceModel job = JobPreferenceModel.fromJson(i);
            jobPreferenceList.add({"${job.vJobTitle!} - ${job.vJobLocation!} - ${job.vExpectedSalary}":job.id});
          }

          // jobPreferenceList = jobPreferenceList + preferTitleList;
          lenghtOfList = jobPreferenceList.length;
          notifyListeners();
          print("Preference Data------->$jobPreferenceList");
        }
      }
    }catch(e) {
      jobPreferenceList = [];
      isLoading = false;
      Future.error("Job Pre Error------->$e");
    }
    notifyListeners();
  }


///----------------------------------- Job Preference if given ---------------------------------------------------///



  ///------------ methods for Filter ------------///

  updateLoading(bool value){
    isLoading = value;
    notifyListeners();
  }

  loadFilterData(List<JobPostModel> userModel){
    if(userModel.isNotEmpty){
      jobPostList =[];
      jobPostList.addAll(userModel);
    }else{
      jobPostList = [];
    }
    notifyListeners();
  }

  ///------------------------- get campus add api --------------------------------------///


  String campusDetailMessage = "";
  int campusShowStatus = 0;
  Future  checkCampusFound() async{
    campusShowStatus = 0;
    notifyListeners();
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user != null){
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.tAuthToken}',
            });
        Response response = await DioClient.client.getDataWithBearerToken("/update_app/notity", options);
        print(response);
        if(response.statusCode == 200){
          campusDetailMessage = response.data["data"]["tMessage"];
          print("campus found ${response.data["data"]["isShow"]}");
          campusShowStatus = response.data["data"]["isShow"];
          notifyListeners();
        }
      }
    }catch(e){
      Future.error(e.toString());
    }
    notifyListeners();
    }

    campusMessageReadApi() async{
      try{
        final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
        if(user != null){
          Options options = Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.tAuthToken}',
              });
          Response response = await DioClient.client.getDataWithBearerToken("/update_app/update_isMessageRead", options);
          print(response);
        }
      }catch(e){
        Future.error(e.toString());
      }
    }
  ///------------------------- get campus add api --------------------------------------///
}