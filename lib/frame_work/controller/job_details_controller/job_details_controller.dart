import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/ui/job_details/helper/job_details_bottom_sheet.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../../ui/utils/constant/app_constant.dart';
import '../../repository/services/hive_service/box_service.dart';

final jobDetailsController = ChangeNotifierProvider((ref) => JobDetailsController());

class JobDetailsController extends ChangeNotifier{
  final ScrollController scrollController = ScrollController();
  double offset = 0.0;

  updateOffSetValue(double value){
    offset = value;
    notifyListeners();
  }

  bool isApplied = false;
  bool isFavorite = false;

  intAppliedValue(){
    isApplied = false;
    notifyListeners();
  }

  provideFavoriteValue(bool value){
    isFavorite = value;
    notifyListeners();
  }


  updateFavoriteValue(){
    isFavorite = !isFavorite;
    notifyListeners();
  }



  bool isAnythingUpdated = false;
  updateIsAnythingUpdated(){
    isAnythingUpdated = false;
    notifyListeners();
  }

  Future appliedApi(String jobId,BuildContext context,String companyName)async{
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null) {
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.tAuthToken}',
            }
        );
     Response response =await DioClient.client.postDataWithBearerToken("${APIEndPoint.jobAppliedApi}$jobId",options);
     if(response.statusCode == 200){
       isApplied = true;
       isAnythingUpdated = true;
       print(response.data);
       if(context.mounted){
       showModalBottomSheet(
           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
           context: context,
           builder: (context) => JobDetailsBottomSheet(companyName: companyName));
       }
     }}
    }catch(e){
      isApplied = false;
      isAnythingUpdated = false;
      Future.error(e);
    }
    notifyListeners();
  }


  Future jobSavedApi(String jobId)async{
    print("Save api call");
    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null) {
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.tAuthToken}',
            }
        );
        Response response =await DioClient.client.postDataWithBearerToken("${APIEndPoint.saveJobApi}$jobId",options);
        if(response.statusCode == 200){
          isAnythingUpdated = true;
          print(response.data);
        }}
    }catch(e){
      isAnythingUpdated = false;
      Future.error(e);
    }
    notifyListeners();
  }

  Future jobUnSavedApi(String jobId)async{
    print("UnSave api call");

    try{
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null) {
        Options options = Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.tAuthToken}',
            }
        );
        Response response =await DioClient.client.postDataWithBearerToken("${APIEndPoint.unSaveJobApi}$jobId",options);
        if(response.statusCode == 200){
          isAnythingUpdated = true;
          print(response.data);
        }}
    }catch(e){
      isAnythingUpdated = false;
      Future.error(e);
    }
    notifyListeners();
  }
}