import 'package:emploiflutter/frame_work/controller/setting_controller/job_preference/job_preference_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/job_preference_model/job_preference_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';

import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/job_preference/add_job_preference.dart';

class JobPreferenceTile extends ConsumerWidget {
  final JobPreferenceModel jobData;
  const JobPreferenceTile( {required this.jobData,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobPreferenceWatch = ref.watch(jobPreferenceController);
    return  Padding(
      padding:  EdgeInsets.only(top: 8.0.h),
      child: GestureDetector(
        onTap: (){
          jobPreferenceWatch.getPreviousValue(jobData);
          jobPreferenceWatch.updateIsUpdateFunc(true);
          Navigator.push(context, PageTransition(child: const AddJobPreference(), type: PageTransitionType.rightToLeft,childCurrent: this,duration: const Duration(milliseconds: 300)));
        },
        child: Card(
          elevation: 6.5,
          shadowColor: Colors.grey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.colors.whiteColors,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(jobData.vJobTitle!,style: TextStyles.w500.copyWith(fontSize: 16.sp,color: AppColors.colors.blackColors),softWrap: true,)),
                    Text("${jobData.vExpectedSalary} LPA +",style: TextStyles.w400.copyWith(fontSize: 16.sp,color: AppColors.colors.blueColors),)
                  ],
                ),
                SizedBox(height: 5.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(jobData.vJobLocation!,style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors),),
                    Icon(Icons.keyboard_double_arrow_right_outlined,color: AppColors.colors.clayColors,size: 25,)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: Duration(milliseconds: 300));
  }
}
