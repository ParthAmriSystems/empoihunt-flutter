import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_with_device_token_model.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../ui/utils/constant/app_constant.dart';
import '../../../repository/api_end_point.dart';
import '../../../repository/dio_client.dart';
import '../../../repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import '../../../repository/model/user_model/user_detail_data_model.dart';
import '../../../repository/services/hive_service/box_service.dart';

final makeNewChatController = ChangeNotifierProvider((ref) => MakeNewChatController());

class MakeNewChatController extends ChangeNotifier{


  bool isSearchFiledVisible = false;
  updateIsSearchFiledVisible(){
    isSearchFiledVisible = !isSearchFiledVisible;
    notifyListeners();
  }


  List<UserWithDeviceTokenModel> jobSeekerList=[];
  int? totalPages;
  int currentPage= 1;
  bool isLoading = false;



///-------------------------------------------------------------------------------------------------------------------///
///----------------------------------------------Recruiter Side-------------------------------------------------------///
///-------------------------------------------------------------------------------------------------------------------///

  ///------------------------------------------------ get job  seeker ---------------------------------------------------///
  Future getJobSeekerApiCall()async{
    try{
      jobSeekerList=[];
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
        Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.getJobSeekerApi}?tag=""&current_page=$currentPage", options);
        if(response.statusCode == 200){
          isLoading = false;
          currentPage += 1;
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          print(responseData);
          for(dynamic i in responseData){
            UserWithDeviceTokenModel jobSeeker = UserWithDeviceTokenModel.fromJson(i);
            jobSeekerList.add(jobSeeker);
          }
          notifyListeners();
          print("List Data $jobSeekerList");
        }
      }
    }catch(e) {
      // isLoading = false;
      Future.error(e);
    }
    notifyListeners();
  }
  ///------------------------------------------------ get job  seeker ---------------------------------------------------///


  ///----------------------------------- Fetch more data from api -----------------------------------------------///
  bool loadMoreData = false;

  Future<void> fetchItemsOfJobSeeker() async {
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
          Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.getJobSeekerApi}?&tag=${searchController.text}&current_page=$currentPage", options);
          if (response.statusCode == 200) {
            loadMoreData = false;
            List responseData = response.data["data"];
            totalPages = response.data["total_pages"];
            if (responseData.isNotEmpty) {
              for (dynamic i in responseData) {
                UserWithDeviceTokenModel jobPostModel = UserWithDeviceTokenModel.fromJson(i);
                jobSeekerList.add(jobPostModel);
              }
              currentPage ++;
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
  ///-------------------------------------- Fetch more data from api -----------------------------------------------///

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
                searchedDataOfJobSeeker();
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

  Future searchedDataOfJobSeeker()async{
    debugPrint("Search function call");
    try{
      jobSeekerList=[];
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
        Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.getJobSeekerApi}?&tag=${searchController.text}&current_page=$currentPage", options);
        if(response.statusCode == 200){
          isLoading = false;
          currentPage += 1;
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          for(dynamic i in responseData){
            UserWithDeviceTokenModel jobPostModel = UserWithDeviceTokenModel.fromJson(i);
            jobSeekerList.add(jobPostModel);
          }
          notifyListeners();
          print("List Data $jobSeekerList");
          searchController.clear();
        }
      }
    }catch(e) {
      isLoading = false;
      searchController.clear();
      Future.error(e);
    }
    notifyListeners();

  }

  ///---------------------------------------- Search Feature ----------------------------------------///

///-------------------------------------------------------------------------------------------------------------------///
///------------------------------------------------Recruiter Side-----------------------------------------------------///
///-------------------------------------------------------------------------------------------------------------------///


///---------------------------------------------------------------------------------------------------------------------------------------------------------------///

///-------------------------------------------------------------------------------------------------------------------///
///---------------------------------------------Job Seeker Side-------------------------------------------------------///
///-------------------------------------------------------------------------------------------------------------------///



  List<User> jobPostList = [];

  Future getRecruiterApiCall()async{
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
        Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.getRecruiterApi}?tag=""&current_page=$currentPage", options);
        if(response.statusCode == 200){
          isLoading = false;
          currentPage += 1;
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          print(totalPages);
          print(responseData);
          for(dynamic i in responseData){
            User recruiter = User.fromJson(i);
            jobPostList.add(recruiter);
          }
          notifyListeners();
        }
      }
    }catch(e) {
      isLoading = false;
      Future.error(e);
    }
    notifyListeners();
  }


  ///----------------------------------- Fetch more data from api -----------------------------------------------///

  Future<void> fetchMoreRecruiter() async {
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
          Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.getRecruiterApi}?tag=${searchController.text}&current_page=$currentPage", options);
          if (response.statusCode == 200) {
            loadMoreData = false;
            List responseData = response.data["data"];
            if (responseData.isNotEmpty) {
              for(dynamic i in responseData){
                User recruiter = User.fromJson(i);
                jobPostList.add(recruiter);
              }
              currentPage ++;
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
  ///-------------------------------------- Fetch more data from api -----------------------------------------------///




  ///---------------------------------------- Search Feature ----------------------------------------///


  ///------------- text to speech --------------///


  ///------------- text to speech --------------///

  Future searchedDataOfRecruiter()async{
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
        Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.getRecruiterApi}?tag=${searchController.text}&current_page=$currentPage", options);
        if(response.statusCode == 200){
          isLoading = false;
          currentPage += 1;
          print(response.data["data"]);
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          for(dynamic i in responseData){
            User recruiter = User.fromJson(i);
            jobPostList.add(recruiter);
          }
          notifyListeners();
          print("List Data $jobPostList");
          searchController.clear();
        }
      }
    }catch(e) {
      isLoading = false;
      searchController.clear();
      Future.error(e);
    }
    notifyListeners();

  }

///---------------------------------------- Search Feature ----------------------------------------///


///-------------------------------------------------------------------------------------------------------------------///
///---------------------------------------------Job Seeker Side-------------------------------------------------------///
///-------------------------------------------------------------------------------------------------------------------///
}