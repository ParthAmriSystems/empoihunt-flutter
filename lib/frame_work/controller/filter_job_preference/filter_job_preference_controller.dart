import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/controller/home_controller/job_seeker_home_controller/job_seeker_home_controller.dart';
import 'package:emploiflutter/frame_work/controller/home_controller/recruiter_home_controller/recruiter_home_controller.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import '../../repository/model/user_model/user_with_device_token_model.dart';
import '../../repository/model/user_model/user_detail_data_model.dart';
import '../../repository/services/hive_service/box_service.dart';

final filterJobPreferenceController = ChangeNotifierProvider((ref) => FilterJobPreferenceController(ref));

class FilterJobPreferenceController extends ChangeNotifier{
  Ref ref;
  FilterJobPreferenceController(this.ref);
  late TabController tabController;


  int selectedFilterModeIndex = -1;
  void addModeToList({required int index,required bool selected,required String value}){
    if(selected && index != selectedFilterModeIndex){
      selectedValue[2].value = value;
      selectedFilterModeIndex = index;
    }else if(!selected && index == selectedFilterModeIndex){
      selectedValue[2].value = "";
      selectedFilterModeIndex = -1;
    }
    notifyListeners();
  }



  List<int> packageList = List.generate(25, (index) => index +1);
  int selectedFilterPackageIndex = -1;
  void addPackageToList({required int index,required bool selected,required String value}){
    if(selected && index != selectedFilterPackageIndex){
      selectedValue[3].value = value;
      selectedFilterPackageIndex = index;
    }else if(!selected && index == selectedFilterPackageIndex){
      selectedValue[3].value = "";
      selectedFilterPackageIndex = -1;
    }
    notifyListeners();
  }


  int selectedFilterDomainIndex = -1;
  void addDomainToList({required int index,required bool selected,required String value,}){
    if(selected && index != selectedFilterDomainIndex){
      selectedValue[0].value = value;
      selectedFilterDomainIndex = index;
      // print("$index,$value");
    }else if(!selected && index == selectedFilterDomainIndex){
      selectedValue[0].value="";
      selectedFilterDomainIndex = -1;
    }
    notifyListeners();
  }

  int selectedFilterLocationIndex = -1;
  void addLocationToList({required int index,required bool selected,required String value,}){
    if(selected && index != selectedFilterLocationIndex){
      selectedValue[1].value = value;
      selectedFilterLocationIndex = index;
      // print("$index,$value");
    }else if(!selected && index == selectedFilterLocationIndex){
      selectedValue[1].value="";
      selectedFilterLocationIndex = -1;
    }
    notifyListeners();
  }

  List<FilterValueAndMode> selectedValue = [
    FilterValueAndMode(mode: FilterMode.domain, value: ""),
    FilterValueAndMode(mode: FilterMode.location, value: ""),
    FilterValueAndMode(mode: FilterMode.mode, value: ""),
    FilterValueAndMode(mode: FilterMode.package, value: "")
  ];


  List<JobPostModel> jobPostList = [];
  Future filterApiForJobSeeker(BuildContext context)async{
    final jobSeekerHomeWatch = ref.watch(jobSeekerHomeController);
    try{
      jobPostList = [];
      jobSeekerHomeWatch.updateLoading(true);
      jobSeekerHomeWatch.loadFilterData(jobPostList);
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null){
        Options options = Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.tAuthToken}',
        });
        Response response = await DioClient.client.getDataWithBearerToken("${APIEndPoint.jobFilterApi}?vJobTitle=${selectedValue[0].value}&vAddress=${selectedValue[1].value}&vWrokingMode=${selectedValue[2].value}&vSalaryPackage=${selectedValue[3].value}&current_page=1", options);
        if(response.statusCode == 200){
          jobSeekerHomeWatch.updateLoading(false);
          List responseData = response.data["data"];
          print(responseData);
          for(dynamic i in responseData){
            JobPostModel jobSeeker = JobPostModel.fromJson(i);
            jobPostList.add(jobSeeker);
          }
          jobSeekerHomeWatch.loadFilterData(jobPostList);
          notifyListeners();
          selectedValue = [
            FilterValueAndMode(mode: FilterMode.domain, value: ""),
            FilterValueAndMode(mode: FilterMode.location, value: ""),
            FilterValueAndMode(mode: FilterMode.mode, value: ""),
            FilterValueAndMode(mode: FilterMode.package, value: "")
          ];
        }
      }
    }catch(e){
      jobSeekerHomeWatch.loadFilterData(jobPostList);
      jobSeekerHomeWatch.updateLoading(false);
      jobPostList = [];
      selectedValue = [
        FilterValueAndMode(mode: FilterMode.domain, value: ""),
        FilterValueAndMode(mode: FilterMode.location, value: ""),
        FilterValueAndMode(mode: FilterMode.mode, value: ""),
        FilterValueAndMode(mode: FilterMode.package, value: "")
      ];
      Future.error("Filter api----->$e");
    }
  }


  ///---------------------------- Filter for Recruiter Home screen -------------------------------------///
  List<UserWithDeviceTokenModel> jobSeekerList = [];
  Future filterApiForRecruiter(BuildContext context)async{
    final recruiterHomeWatch = ref.watch(recruiterHomeController);
    try{
      jobSeekerList = [];
      recruiterHomeWatch.updateLoading(true);
      recruiterHomeWatch.loadFilterData(jobSeekerList);
      final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      if(user !=null){
        Options options = Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.tAuthToken}',
        });
        Response response = await DioClient.client.getDataWithBearerToken("${APIEndPoint.getJobSeekerFilterApiApi}?vJobTitle=${selectedValue[0].value}&vAddress=${selectedValue[1].value}&vWrokingMode=${selectedValue[2].value}&current_page=1", options);
        if(response.statusCode == 200){
          recruiterHomeWatch.updateLoading(false);
          print(response.data);
          List responseData = response.data["data"];
          for(dynamic i in responseData){
            UserWithDeviceTokenModel jobSeeker = UserWithDeviceTokenModel.fromJson(i);
            jobSeekerList.add(jobSeeker);
          }
          recruiterHomeWatch.loadFilterData(jobSeekerList);
          notifyListeners();
          selectedValue = [
            FilterValueAndMode(mode: FilterMode.domain, value: ""),
            FilterValueAndMode(mode: FilterMode.location, value: ""),
            FilterValueAndMode(mode: FilterMode.mode, value: ""),
            FilterValueAndMode(mode: FilterMode.package, value: "")
          ];
        }
      }
    }catch(e){
      recruiterHomeWatch.loadFilterData(jobSeekerList);
      recruiterHomeWatch.updateLoading(false);
      selectedValue = [
        FilterValueAndMode(mode: FilterMode.domain, value: ""),
        FilterValueAndMode(mode: FilterMode.location, value: ""),
        FilterValueAndMode(mode: FilterMode.mode, value: ""),
        FilterValueAndMode(mode: FilterMode.package, value: "")
      ];
      Future.error("Filter api----->$e");
    }
  }
///---------------------------- Filter for Recruiter Home screen -------------------------------------///


}

class FilterValueAndMode{
  final int mode;
  String value;

  FilterValueAndMode({required this.mode,required this.value});
}