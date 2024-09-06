import 'package:emploiflutter/ui/campus/campus.dart';
import 'package:emploiflutter/ui/create_post_job/create_post_job.dart';
import 'package:emploiflutter/ui/home/helper/job_seeker/job_seeker_home.dart';
import 'package:emploiflutter/ui/home/helper/recruiter/recruiter_home.dart';
import 'package:emploiflutter/ui/settings/setting.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../../ui/ai_for_jobseeker/ai_for_jobseeker.dart';

final dashBoardController = ChangeNotifierProvider((ref) => DashBoardController());

class DashBoardController extends ChangeNotifier{

  int selectedIndex = 0;


  updateSelectedIndex(int index){
    selectedIndex = index;
    notifyListeners();
  }

  List<Widget> jobSeekerPages = [
    const JobSeekerHome(),
    const Campus(),
    ///Temporary stop fetching data
    const AIForJobSeeker(),
    const Setting()
  ];

  List<Widget> recruiterPages = [
    const RecruiterHome(),
    const CreatePostJob(),
    const Setting()
  ];


  bool isExitApp = false;

  updateIsExitApp(bool value){
    isExitApp = value;
    notifyListeners();
  }

  otherWidgetAllowToNavigate(int index){
    selectedIndex = index;
    notifyListeners();
  }
}