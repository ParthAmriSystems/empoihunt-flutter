// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/frame_work/controller/create_post_job_controller/create_post_job_controller.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

class CreatePostJobSkillsWidget extends ConsumerWidget {
  const CreatePostJobSkillsWidget({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final createPostJobWatch = ref.watch(createPostJobController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Technical Skills ///
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          width: double.infinity,
          height: 150.h,
          color: AppColors.colors.whiteCatskill,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: CommonFormField(
                      controller: createPostJobWatch.requiredTechnicalSkillsController,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      hintText: "Developer",labelText: "Required Technical Skills",prefixIcon: SvgPicture.asset(AppAssets.skillsSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),)),
                    SizedBox(width: 10.w,),
                    Showcase(
                      key: createPostJobWatch.globalKeyTechSkill,
                      title: 'Technical Skills',
                      description: 'Define the technical skills and expertise required for this role',
                      targetBorderRadius:  BorderRadius.circular(8.r),
                      targetPadding: EdgeInsets.only(top: 5.h,left: 8.w,right: 8.w,bottom: 5.h),
                      child: IconButton(
                        onPressed: (){
                          createPostJobWatch.addTechnicalSkill();
                        }, icon: Icon(Icons.add,size: 20.sp,),style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: AppColors.colors.greyRegent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                          elevation: 1.5,
                          padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 8.h)
                      ),),
                    )
                  ],
                ),
               createPostJobWatch.technicalSkillsList.isEmpty?const SizedBox(): Wrap(
                  children: List.generate(createPostJobWatch.technicalSkillsList.length, (index) {
                    final skill = createPostJobWatch.technicalSkillsList[index];
                    return Container(
                      margin: EdgeInsets.all(10.sp),
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                          color: AppColors.colors.whiteColors,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: AppColors.colors.blueColors,width: 0.5.w)
                      ),
                      child: Text(skill,style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        createPostJobWatch.isTechnicalSkillEmpty?Text("Please add at least one skills",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

        /// Soft Skills ///
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          width: double.infinity,
          height: 150.h,
          color: AppColors.colors.whiteCatskill,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: CommonFormField(
                      controller: createPostJobWatch.requiredSoftSkillsController,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      hintText: "Communication",labelText: "Required Soft Skills",prefixIcon: SvgPicture.asset(AppAssets.skillsSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),)),
                    SizedBox(width: 10.w,),
                    Showcase(
                      key: createPostJobWatch.globalKeySoftSkill,
                      title: 'Soft Skills',
                      description: 'Define the soft skills required for this role, such as communication or teamwork',
                      targetBorderRadius:  BorderRadius.circular(8.r),
                      targetPadding: EdgeInsets.only(top: 5.h,left: 8.w,right: 8.w,bottom: 5.h),
                      child: IconButton(
                        onPressed: (){
                          createPostJobWatch.addSoftSkill();
                        }, icon: Icon(Icons.add,size: 20.sp,),style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: AppColors.colors.greyRegent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                          elevation: 1.5,
                          padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 8.h)
                      ),),
                    )
                  ],
                ),
               createPostJobWatch.softSkillsList.isEmpty?const SizedBox(): Wrap(
                  children: List.generate(createPostJobWatch.softSkillsList.length, (index) {
                    final skill = createPostJobWatch.softSkillsList[index];
                    return Container(
                      margin: EdgeInsets.all(10.sp),
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                          color: AppColors.colors.whiteColors,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: AppColors.colors.blueColors,width: 0.5.w)
                      ),
                      child: Text(skill,style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        createPostJobWatch.isSoftSkillEmpty?Text("Please add at least one skills",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),
      ],
    );
  }
}
