import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/ui/authentication/register/helper/register_profile_details/helper/job_seeker_register_profile_details/helper/job_seeker_register_profile_details_appbar.dart';
import 'package:emploiflutter/ui/authentication/register/helper/register_profile_details/helper/job_seeker_register_profile_details/helper/job_seeker_register_profile_details_backrgound.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_loading.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../../../frame_work/repository/services/shared_pref_services.dart';
import '../../../../../../utils/constant/app_constant.dart';

class JobSeekerRegisterProfileDetails extends ConsumerStatefulWidget {
  const JobSeekerRegisterProfileDetails({super.key});

  @override
  ConsumerState<JobSeekerRegisterProfileDetails> createState() => _RegisterProfileDetailsState();
}

class _RegisterProfileDetailsState extends ConsumerState<JobSeekerRegisterProfileDetails> with TickerProviderStateMixin{

  @override
  void initState() {
    final vsync1 = this;
    final vsync2 = this;
    ref.read(jobSeekerRegisterProfileDetailsController).initializeLottie(vsync1,vsync2);
    super.initState();
    /// For the First show case ///
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      if(!SharedPrefServices.services.getBool(registerShowCaseJobSeeker)){
        final jobSeekerRead = ref.read(jobSeekerRegisterProfileDetailsController);
        Future.delayed(Duration(milliseconds: 300),
                () => ShowCaseWidget.of(context).startShowCase([jobSeekerRead.globalKeyBio,jobSeekerRead.globalKeyQualification,jobSeekerRead.globalKeyIsExperience]));
      }
    },);
  }

  @override
  void deactivate() {
    super.deactivate();
    ref.read(jobSeekerRegisterProfileDetailsController).resumeLottieController.dispose();
    ref.read(jobSeekerRegisterProfileDetailsController).videoResumeLottieController.dispose();
    ref.read(jobSeekerRegisterProfileDetailsController).uploadImgLottieController.dispose();
  }
  @override
  Widget build(BuildContext context,) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: AppColors.colors.clayColors,
    ));
    return CommonLoading(
      show: ref.watch(jobSeekerRegisterProfileDetailsController).isLoading,
      child: PopScope(
        canPop: true,
        onPopInvoked: (v){
          ref.watch(jobSeekerRegisterProfileDetailsController).clearData();
        },
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: const Scaffold(
            backgroundColor:  Colors.white,
            appBar: JobSeekerRegisterProfileDetailsAppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                        JobSeekerRegisterProfileDetailsBackGround(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
