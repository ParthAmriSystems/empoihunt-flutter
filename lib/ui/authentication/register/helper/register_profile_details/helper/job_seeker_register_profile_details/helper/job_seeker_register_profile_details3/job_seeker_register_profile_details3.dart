import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../../../../utils/common_widget/common_typ_ahead_form_field.dart';

class JobSeekerRegisterProfileDetails3 extends ConsumerWidget {
  const JobSeekerRegisterProfileDetails3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerProfileDetailsWatch =
        ref.watch(jobSeekerRegisterProfileDetailsController);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Your job Preference",
              style: TextStyles.w400
                  .copyWith(fontSize: 18.sp, color: AppColors.colors.blueColors),
            ),
            Divider(
              color: AppColors.colors.blueColors,
              thickness: 4.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h,bottom: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Showcase(
                    key: registerProfileDetailsWatch.globalKeyJobTitle,
                    title: 'Job Title',
                    description: 'Enter the role or job title you aspire to work in',
                    targetBorderRadius:  BorderRadius.circular(8.r),
                    targetPadding: EdgeInsets.only(top: 8.h,left: 8.w,right: 8.w,bottom: 8.h),
                    child: CommonTypeAheadFormField(
                        width: context.screenWidth * 0.85,
                        controller: registerProfileDetailsWatch.jobSearchController,
                        hintText: "Job Title",
                        labelText: "Job Title",
                        dropdownMenuEntries: designationList
                            .map((element) => DropdownMenuEntry(
                            value: element,
                            label: element))
                            .toList(),
                        onSelected: (value)  {
                          registerProfileDetailsWatch.isSelectedJobTitleEmtUpdate(value);
                          registerProfileDetailsWatch.jobSearchController.text = value??registerProfileDetailsWatch.jobSearchController.text;
                        }),
                  ),
                  registerProfileDetailsWatch.isSelectedJobTitleEmt?Text("Please select Job title",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
        
                  SizedBox(
                    height: 20.h,
                  ),
                  Showcase(
                    key: registerProfileDetailsWatch.globalKeyPreferCity,
                    title: 'Prefer City',
                    description: 'Enter the city where you would prefer to work',
                    targetBorderRadius:  BorderRadius.circular(8.r),
                    targetPadding: EdgeInsets.only(top: 8.h,left: 8.w,right: 8.w,bottom: 8.h),
                    child: CommonTypeAheadFormField(
                        width: context.screenWidth * 0.85,
                        controller: registerProfileDetailsWatch.preferCitySearchController,
                        hintText: "Prefer City",
                        labelText: "Prefer City",
                        dropdownMenuEntries: SharedPrefServices.services.getList(locationListKey)!
                            .map((element) => DropdownMenuEntry(
                            value: element,
                            label: element))
                            .toList(),
                        onSelected: (value)  {
                          registerProfileDetailsWatch.isSelectedPrefCityEmtUpdate(value);
                          registerProfileDetailsWatch.preferCitySearchController.text = value??registerProfileDetailsWatch.preferCitySearchController.text;
                        }),
                  ),
                  registerProfileDetailsWatch.isSelectedPrefCityEmt?Text("Please select Prefer City",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Showcase(
                  key: registerProfileDetailsWatch.globalKeyWorkingMode,
                  title: 'Working mode',
                  description: 'Select your preferred working mode: remote, onsite, or hybrid',
                  targetBorderRadius:  BorderRadius.circular(8.r),
                  targetPadding: EdgeInsets.only(top: 5.h,left: 8.w,right: 8.w,bottom: 5.h),
                  child: Text(
                    "Select your prefer working mode",
                    style: TextStyles.w400.copyWith(
                        fontSize: 12.sp, color: AppColors.colors.blueColors),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.grey),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(registerProfileDetailsWatch.workingModeList.length, (index) {
                      final workingMode = registerProfileDetailsWatch.workingModeList[index];
                      return   GestureDetector(
                        onTap: () {
                          registerProfileDetailsWatch.updateWorkingMode(index);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.h,
                          width: 108.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: registerProfileDetailsWatch.selectedWorkingMode == index?
                              AppColors.colors.blueColors
                                  : Colors.grey),
                          child: Text(
                            workingMode,
                            style: TextStyles.w500.copyWith(
                                fontSize: 14.sp,
                                color:registerProfileDetailsWatch.selectedWorkingMode == index?
                                AppColors.colors.whiteColors
                                    : AppColors.colors.blackColors),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(child: CommonFormField(
                  controller: registerProfileDetailsWatch.expertiseController,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  hintText: "Developer",labelText: "Expertise",prefixIcon: SvgPicture.asset(AppAssets.skillsSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),)),
                SizedBox(width: 10.w,),
                Showcase(
                  key: registerProfileDetailsWatch.globalKeyExpertise,
                  title: 'Add your Expertise',
                  description: 'Specify the skills, knowledge, or expertise you have in your field',
                  targetBorderRadius:  BorderRadius.circular(8.r),
                  targetPadding: EdgeInsets.only(top: 5.h,left: 8.w,right: 8.w,bottom: 5.h),
                  child: IconButton(
                    onPressed: (){
                      registerProfileDetailsWatch.addExpertise();
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
            registerProfileDetailsWatch.expertiseList.isEmpty?const SizedBox(): Wrap(
              children: List.generate(registerProfileDetailsWatch.expertiseList.length, (index) {
                final expertise = registerProfileDetailsWatch.expertiseList[index];
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10.sp),
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                          color: AppColors.colors.whiteColors,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: AppColors.colors.blueColors,width: 0.5.w)
                      ),
                      child: Text(expertise,style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),),
                    ),
                    Positioned(
                      right: 4,
                      top:5,
                        child: GestureDetector(
                            onTap:(){
                              registerProfileDetailsWatch.removeDataInExpertiseList(index);
                            },
                            child: Icon(Icons.cancel,color: Colors.black,size: 16.sp,)))
                  ],
                );
              }),
            ),
            registerProfileDetailsWatch.isExpertiseEmpty?Text("Please add your expertise ",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox()          ],
        ),
      ),
    );
  }
}
