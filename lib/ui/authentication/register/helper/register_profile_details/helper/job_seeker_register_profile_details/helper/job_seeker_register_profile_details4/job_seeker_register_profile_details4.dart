import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:lottie/lottie.dart';
import 'package:showcaseview/showcaseview.dart';

class JobSeekerRegisterProfileDetails4 extends ConsumerWidget {
  const JobSeekerRegisterProfileDetails4({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final registerProfileDetailsWatch =
        ref.watch(jobSeekerRegisterProfileDetailsController);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          Text(
            "Resume",
            style: TextStyles.w400
                .copyWith(fontSize: 18.sp, color: AppColors.colors.blueColors),
          ),
          Divider(
            color: AppColors.colors.blueColors,
            thickness: 4.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child:  SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   Lottie.asset(
                     height: 200.h,
                     width: 180.w,
                     AppAssets.resumeLottie,
                     controller: registerProfileDetailsWatch.resumeLottieController,
                   ),
                    SizedBox(height: 10.h,),
                    GestureDetector(
                      onTap: (){
                        registerProfileDetailsWatch.pickPdfFile();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: AppColors.colors.blueColors,width: 1.5.w)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(AppAssets.resumeUpload,scale: 27,color: AppColors.colors.blueColors,),
                            SizedBox(width: 8.w,),
                            Expanded(child: Showcase(
                                key: registerProfileDetailsWatch.globalKeyResume,
                                title: 'Resume',
                                description: 'Provide your latest resume or CV that highlights your qualifications and work experience',
                                targetBorderRadius:  BorderRadius.circular(8.r),
                                targetPadding: EdgeInsets.only(top: 5.h,left: 8.w,right: 8.w,bottom: 5.h),
                                child: Text(registerProfileDetailsWatch.pdfName !=null ? "${registerProfileDetailsWatch.pdfName}" : "Choose Pdf File",style: TextStyles.w400.copyWith(fontSize: 16.sp,color: AppColors.colors.blueColors),softWrap: true,)))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
