import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/model/save_job_model/save_job_model.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';


final saveJobController = ChangeNotifierProvider((ref) => SaveJobController());

class SaveJobController extends ChangeNotifier{


  List<SaveJobModel> saveJobList = [];
  int? totalPages;
  int currentPage= 1;
  bool isLoading = false;

  Future saveListApiCall()async{
    try{
      saveJobList=[];
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
        Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.saveListApi}&current_page=$currentPage", options);
        if(response.statusCode == 200){
          isLoading = false;
          currentPage += 1;
          print(response.data["data"]);
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          for(dynamic i in responseData){
            SaveJobModel job = SaveJobModel.fromJson(i);
            saveJobList.add(job);
          }
          notifyListeners();
          print("List Data $saveJobList");
        }
      }
    }catch(e) {
      isLoading = false;
      Future.error(e);
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
          Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.saveListApi}&current_page=$currentPage", options);
          if (response.statusCode == 200) {
            loadMoreData = false;
            List responseData = response.data["data"];
            if (responseData.isNotEmpty) {
              for (dynamic i in responseData) {
                SaveJobModel job = SaveJobModel.fromJson(i);
                saveJobList.add(job);
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

}