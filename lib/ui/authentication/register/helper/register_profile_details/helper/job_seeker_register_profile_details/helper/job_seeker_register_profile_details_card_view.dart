import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/ui/authentication/register/helper/register_profile_details/helper/job_seeker_register_profile_details/helper/job_seeker_register_profile_details5/job_seeker_register_profile_details5.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'job_seeker_register_profile_details1/job_seeker_register_profile_details1.dart';
import 'job_seeker_register_profile_details2/job_seeker_register_profile_details2.dart';
import 'job_seeker_register_profile_details3/job_seeker_register_profile_details3.dart';
import 'job_seeker_register_profile_details4/job_seeker_register_profile_details4.dart';
import 'job_seeker_register_profile_details6/job_seeker_register_profile_details6.dart';

class JobSeekerRegisterProfileDetailsCardView extends ConsumerWidget {
  const JobSeekerRegisterProfileDetailsCardView({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final registerProfileDetailWatch = ref.watch(jobSeekerRegisterProfileDetailsController);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: registerProfileDetailWatch.registerProfileDetailsGlobalKey,
      child: Card(
        // margin: EdgeInsets.only(top: 100.h),
        elevation: 4,
        child: Container(
          width: width * 0.93,
          height: height * 0.58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: registerProfileDetailWatch.pageController,
                onPageChanged: (index){
                      registerProfileDetailWatch.index = index;
                      // print(registerProfileDetailWatch.index);
                },
                children: registerProfileDetailWatch.isExperienced? [
                  const JobSeekerRegisterProfileDetails1(),
                  const JobSeekerRegisterProfileDetails2(),
                  const JobSeekerRegisterProfileDetails3(),
                  const JobSeekerRegisterProfileDetails4(),
                  const JobSeekerRegisterProfileDetails5(),
                  const JobSeekerRegisterProfileDetails6(),
                ]:
                [
                  const JobSeekerRegisterProfileDetails1(),
                  const JobSeekerRegisterProfileDetails3(),
                  const JobSeekerRegisterProfileDetails4(),
                  const JobSeekerRegisterProfileDetails5(),
                  const JobSeekerRegisterProfileDetails6(),
                ],
              )),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///---------------- Backward Button--------- ///
                    registerProfileDetailWatch.index == 0 ? const SizedBox():
                    IconButton(
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                            backgroundColor: AppColors.colors.blueColors,
                            fixedSize: Size(60.w, 50.h)),
                        onPressed: () {
                          registerProfileDetailWatch.backwardBtn();
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.colors.whiteColors,
                        )),

                   /// Forward Button ///
                   registerProfileDetailWatch.isExperienced ?
///-----------------------------------------------------------------------------------------------------------------------------------------///

                   ///------------------ if user select Experience --------------------///
                   registerProfileDetailWatch.index == 5 && registerProfileDetailWatch.profilePic  != null?
                   IconButton(
                       style: ElevatedButton.styleFrom(
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10.r)),
                           backgroundColor: AppColors.colors.clayColors,
                           fixedSize: Size(60.w, 50.h)),
                       onPressed: () {
                         registerProfileDetailWatch.experienceRegisterSubmitButton(context);
                       },
                       icon: Icon(Icons.check,
                           color: AppColors.colors.whiteColors)):
                   IconButton(
                       style: ElevatedButton.styleFrom(
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10.r)),
                           backgroundColor: AppColors.colors.blueColors,
                           fixedSize: Size(60.w, 50.h)),
                       onPressed: () {
                         registerProfileDetailWatch.index == 5?  registerProfileDetailWatch.experienceRegisterSubmitButton(context):
                         registerProfileDetailWatch.forwardBtn(context);
                       },
                       icon: Icon(Icons.arrow_forward_rounded,
                           color: AppColors.colors.whiteColors))
                       :
                   ///------------------ if user select Experience --------------------///

///-----------------------------------------------------------------------------------------------------------------------------------------///

                   ///------------------ if user select Fresher --------------------///
                    registerProfileDetailWatch.index == 4 && registerProfileDetailWatch.profilePic  != null?
                   IconButton(
                       style: ElevatedButton.styleFrom(
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10.r)),
                           backgroundColor: AppColors.colors.clayColors,
                           fixedSize: Size(60.w, 50.h)),
                       onPressed: () {
                         print("fresher 1 button pressed");
                         registerProfileDetailWatch.freshersRegisterSubmitButton(context);
                       },
                       icon: Icon(Icons.check,
                           color: AppColors.colors.whiteColors))
                        :
                   IconButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            backgroundColor: AppColors.colors.blueColors,
                            fixedSize: Size(60.w, 50.h)),
                        onPressed: () {
                          print("fresher 2 button pressed");
                          registerProfileDetailWatch.index == 4? registerProfileDetailWatch.freshersRegisterSubmitButton(context): registerProfileDetailWatch.forwardBtn(context);
                        },
                        icon: Icon(Icons.arrow_forward_rounded,
                            color: AppColors.colors.whiteColors)),
                    ///------------------ if user select Fresher --------------------///
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
