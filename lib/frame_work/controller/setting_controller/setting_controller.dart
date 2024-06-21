import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/applied_candidate_list/applied_candidate_list.dart';
import 'package:emploiflutter/ui/contact_us/contact_us.dart';
import 'package:emploiflutter/ui/job_preference/job_preference.dart';
import 'package:emploiflutter/ui/manages_jobs/manages_jobs.dart';
import 'package:emploiflutter/ui/privacy_policy/privacy_policy.dart';
import 'package:emploiflutter/ui/save_job/save_job.dart';
import 'package:emploiflutter/ui/settings/helper/setting_delete_ac_bottom_sheet.dart';
import 'package:emploiflutter/ui/splash/splash.dart';
import 'package:emploiflutter/ui/terms_and_condition/terns_and_condition.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/view_applylist/view_applied_job_list.dart';
import '../../../ui/utils/constant/app_constant.dart';
import '../../repository/services/hive_service/box_service.dart';
import '../dash_board_controller/dash_board_controller.dart';

final settingController = ChangeNotifierProvider((ref) => SettingController(ref));

class SettingController extends ChangeNotifier{
 Ref ref;
 SettingController(this.ref);

///--------------Job Seeker-----------------///
  List<Map<String,dynamic>> seekerSettingList=[
    {"Icon": Icons.person,"Text":"View ApplyList"},
    {"Icon": Icons.app_settings_alt,"Text":"Job Preference"},
    {"Icon": Icons.save,"Text":"Save Job"},
    {"Icon": Icons.phone,"Text":"Contact Us"},
    {"Icon": Icons.security,"Text":"Privacy Policy"},
    {"Icon": Icons.menu_book_rounded,"Text":"Terms & Condition"},
    {"Icon": Icons.delete,"Text":"Delete account"},
  ];

  seekerNavigatingToList(int index,BuildContext context){
    switch(index){
      case 0:
        context.push(const ViewAppliedJobList());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const ViewApplyList()));
        break;
      case 1:
        context.push(const JobPreference());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const JobPreference()));
        break;
      case 2:
        context.push(const SaveJob());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const SaveJob()));
        break;
      case 3:
        context.push(const ContactUs());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const ContactUs()));
        break;
      case 4:
        context.push(const PrivacyPolicy());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const PrivacyPolicy()));
        break;
      case 5:
        context.push(const TermsAndCondition());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const TermsAndCondition()));
        break;
      case 6:
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            context: context,
            builder: (context) => const SettingDeleteAcBottomSheet());
         break;
    }
  }
///--------------Job Seeker-----------------///

///--------------Recruiter ----------------////
  List<Map<String,dynamic>> recruiterSettingList=[
    {"Icon": Icons.work,"Text":"Manage Jobs"},
    {"Icon": Icons.person,"Text":"Applied Candidate List"},
    {"Icon": Icons.phone,"Text":"Contact Us"},
    {"Icon": Icons.security,"Text":"Privacy Policy"},
    {"Icon": Icons.menu_book_rounded,"Text":"Terms & Condition"},
    {"Icon": Icons.delete,"Text":"Delete account"},
  ];

  recruiterNavigatingToList(int index,BuildContext context){
    switch(index){
      case 0:
        context.push(const ManagesJobs());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const ManagesJobs()));
        break;
      case 1:
        context.push(const AppliedCandidateList());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const AppliedCandidateList()));
        break;
      case 2:
        context.push(const ContactUs());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const ContactUs()));
        break;
      case 3:
        context.push(const PrivacyPolicy());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const PrivacyPolicy()));
        break;
      case 4:
        context.push(const TermsAndCondition());
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>const TermsAndCondition()));
        break;
      case 5:
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            context: context,
            builder: (context) => const SettingDeleteAcBottomSheet());
        break;
    }
  }
///--------------Recruiter ----------------////

    Future singOutApi(BuildContext context)async{
       try{
         final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
         if(user != null) {
           Options options = Options(
               headers: {
                 'Accept': 'application/json',
                 'Authorization': 'Bearer ${user.tAuthToken}',
               }
           );
           Response response = await DioClient.client.postDataWithBearerToken(
               APIEndPoint.signOutApi, options);
           if (response.statusCode == 200) {
             if (context.mounted) {
               debugPrint("Logout successfully");
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const Splash()),(route) => false);
             }
           }
         }
       }catch(e){
         Future.error(" setting screen------->$e");
       }
       notifyListeners();
    }

 Future deleteAccountApi(BuildContext context)async{
   try{
     final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
     if(user != null) {
       Options options = Options(
           headers: {
             'Accept': 'application/json',
             'Authorization': 'Bearer ${user.tAuthToken}',
           }
       );
       Response response = await DioClient.client.postDataWithBearerToken(
           APIEndPoint.deleteAccountApi, options);
       if (response.statusCode == 200) {
         if (context.mounted) {
           debugPrint("Delete successfully");
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const Splash()),(route) => false);
         }
       }
     }
   }catch(e){
     Future.error(" setting screen------->$e");
   }
   notifyListeners();
 }
}