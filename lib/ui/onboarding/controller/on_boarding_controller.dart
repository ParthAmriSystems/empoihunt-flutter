

import 'package:emploiflutter/ui/authentication/auth_intro.dart';
import 'package:emploiflutter/ui/dash_board/dash_board.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/theme/theme.dart';

final onBoardingController = ChangeNotifierProvider((ref) => OnBoardingController());

class OnBoardingController extends ChangeNotifier{
  PageController pageController = PageController();
  PageController jobSeekerPageController = PageController();
  PageController recruiterPageController = PageController();

  int index= 0;

   nextButton(BuildContext context){
      index ++;
      pageController.animateToPage(index,duration: const Duration(milliseconds: 200), curve:
      Curves.easeIn);
      if(index == 4){
      Navigator.pushAndRemoveUntil(context,PageTransition(child: const AuthIntro(), type: PageTransitionType.leftToRight,duration: const Duration(milliseconds: 600)), (route) => false);
      index = 0;
    }
    notifyListeners();
  }


  onPageChange(int i){
    index = i;
    notifyListeners();
  }


  /// JobSeeker Button ///
  jobSeekerNextButton(BuildContext context){
    index ++;
    jobSeekerPageController.animateToPage(index,duration: const Duration(milliseconds: 200), curve:
    Curves.easeIn);
    if(index == 4){
      print("Job Seeker home");
      Navigator.pushAndRemoveUntil(context,PageTransition(child: const DashBoard(), type: PageTransitionType.leftToRight,duration: const Duration(milliseconds: 600)), (route) => false);
      index = 0;
      print("Index value is $index");
    }
    notifyListeners();
  }

  /// Recruiter Button ///
  recruiterNextButton(BuildContext context){
    index ++;
    recruiterPageController.animateToPage(index,duration: const Duration(milliseconds: 200), curve:
    Curves.easeIn);
    if(index == 3){
      print("Recruiter home");
      Navigator.pushAndRemoveUntil(context,PageTransition(child: const DashBoard(), type: PageTransitionType.leftToRight,duration: const Duration(milliseconds: 600)), (route) => false);
      index = 0;
      print("Index value is $index");
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    jobSeekerPageController.dispose();
    recruiterPageController.dispose();
  }
}