import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/model/applied_list_model/applied_list_model.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../../../ui/utils/app_constant.dart';
import '../../../repository/api_end_point.dart';
import '../../../repository/dio_client.dart';
import '../../../repository/services/hive_service/box_service.dart';

final viewApplyListController = ChangeNotifierProvider((ref) => ViewApplyListController());

class ViewApplyListController extends ChangeNotifier{



  List<AppliedListModel> appliedJobList = [];
  int? totalPages;
  int currentPage= 1;
  bool isLoading = false;

  Future appliedListApiCall()async{
    try{
      appliedJobList=[];
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
        Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.appliedListApi}&current_page=$currentPage", options);
        if(response.statusCode == 200){
          isLoading = false;
          currentPage += 1;
          print(response.data["data"]);
          List responseData = response.data["data"];
          totalPages = response.data["total_pages"];
          for(dynamic i in responseData){
            AppliedListModel job = AppliedListModel.fromJson(i);
            appliedJobList.add(job);
          }
          notifyListeners();
          print("List Data $appliedJobList");
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
                AppliedListModel job = AppliedListModel.fromJson(i);
                appliedJobList.add(job);
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