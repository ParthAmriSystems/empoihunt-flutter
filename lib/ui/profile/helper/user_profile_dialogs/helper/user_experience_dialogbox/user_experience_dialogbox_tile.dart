import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'user_experience_dialogbox_update_form.dart';

class UserExperienceDialogBoxTile extends ConsumerWidget {
  const UserExperienceDialogBoxTile({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return profileWatch.isExperienceLoading? const Center(child: CircularProgressIndicator(),):
      Column(
      children:
      List.generate(profileWatch.userExperienceList.length, (index) {
        final experience = profileWatch.userExperienceList[index];
        return Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 5.h,),
                Container(
                  padding:EdgeInsets.symmetric(vertical: 14.h),
                  color: AppColors.colors.whiteColors,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.colors.whiteColors,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: AppColors.colors.blueDark,width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(experience.vDesignation??"",style: TextStyles.w400.copyWith(fontSize: 18.sp,color: AppColors.colors.blueColors),),
                          Text(experience.vCompanyName??"",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(experience.vJobLocation??"",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.greyRegent),),
                              Text(experience.vDuration != "0" ? experience.vDuration! :"Present",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.clayColors),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                profileWatch.selectedUserExperienceListIndex == index ?  UserExperienceDialogBoxUpdateFrom(model: experience,): const SizedBox()
              ],
            ),
            Positioned(
              top: 0,
              right: 5.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){
                    profileWatch.listEditButton(index: index, designation: experience.vDesignation??"", companyName: experience.vCompanyName??"",jobLocation: experience.vJobLocation??"",duration: experience.vDuration??"");
                  }, icon: Icon(profileWatch.selectedUserExperienceListIndex == index ? Icons.cancel_outlined :Icons.edit,color: AppColors.colors.whiteColors,size: 18.sp),style:  ElevatedButton.styleFrom(backgroundColor: AppColors.colors.blueColors,padding: EdgeInsets.all(4.sp)),),
                  SizedBox(width: 5.w,),
                  IconButton(onPressed: (){
                    profileWatch.listDeleteButton(experience);
                  }, icon: Icon(Icons.delete,color: AppColors.colors.whiteColors,size: 18.sp),style:  ElevatedButton.styleFrom(backgroundColor: AppColors.colors.blueColors,padding: EdgeInsets.all(6.sp)),),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
