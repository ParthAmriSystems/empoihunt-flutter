import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/model/recommendation_model/recommendatio_model.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../ui/utils/constant/app_constant.dart';
import '../../../repository/api_end_point.dart';
import '../../../repository/dio_client.dart';
import '../../../repository/model/user_model/user_with_device_token_model.dart';
import '../../../repository/services/hive_service/box_service.dart';

final recruiterHomeController = ChangeNotifierProvider((ref) => RecruiterHomeController());

class RecruiterHomeController extends ChangeNotifier{


  bool isSearchFiledVisible = false;
  updateIsSearchFiledVisible(){
    isSearchFiledVisible = !isSearchFiledVisible;
    notifyListeners();
  }


  List<UserWithDeviceTokenModel> jobSeekerList=[];
  int? totalPages;
  int currentPage= 1;
  bool isLoading = false;


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
          // print(responseData);
          for(dynamic i in responseData){
            UserWithDeviceTokenModel jobSeeker = UserWithDeviceTokenModel.fromJson(i);
            jobSeekerList.add(jobSeeker);
          }
          ///Temporary stop fetching data
          // fetchRecommendationData();
          notifyListeners();
          // print("List Data $jobSeekerList");
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



///------------ methods for Filter ------------///

updateLoading(bool value){
    isLoading = value;
    notifyListeners();
}

loadFilterData(List<UserWithDeviceTokenModel> userModel){
    if(userModel.isNotEmpty){
      jobSeekerList =[];
      jobSeekerList.addAll(userModel);
    }else{
      jobSeekerList = [];
    }
    notifyListeners();
}

///=============================== Recommendation ===============================///
  List<RecommendationModel> recommendationList = [];
  bool recommendationLoading = false;
  Future<void> fetchRecommendationData() async{
    recommendationLoading = true;
    notifyListeners();
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null){
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.tAuthToken}',
            }
        );
        final Response response = await DioClient.client.getDataWithBearerToken("${APIEndPoint.recommendationApi}?skills=developer&quantity=10",options);
        if(response.statusCode == 200){
          recommendationLoading = false;
          final data = response.data;
          // print(data);
          for(var i in data){
            recommendationList.add(RecommendationModel.fromMap(i));
          }
          debugPrint("Length of the recommendation ====> ${recommendationList.length}");
        }else{
          recommendationLoading = false;
          notifyListeners();
        }
      }
      notifyListeners();
    }on DioException catch(e){
      recommendationLoading = false;
      notifyListeners();
      Future.error("Recommendation error====> $e");
    }
    notifyListeners();
  }

///=============================== Recommendation ===============================///

}