import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:flutter_svg/svg.dart';

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
                  CommonTypeAheadFormField(
                      prefixIcon: null,
                      direction: VerticalDirection.up,
                      onChanged: (value){
                        registerProfileDetailsWatch.isSelectedJobTitleEmtUpdate(value);
                      },
                      controller: registerProfileDetailsWatch.jobSearchController,
                      hintText: "Job Title",
                      labelText: "Job Title",
                      suggestionsCallback: (pattern) {
                        return registerProfileDetailsWatch.checkJobSearch(pattern);
                      },
                      onSuggestionSelected: (value) {
                        registerProfileDetailsWatch.jobSearchController.text = value;
                        registerProfileDetailsWatch.isSelectedJobTitleEmtUpdate(value);
                      }
                  ),
                  // CommonDropDownFormField(
                  //   items: designationList,
                  //   searchController:
                  //       registerProfileDetailsWatch.jobSearchController,
                  //   onChanged: (value) {
                  //     registerProfileDetailsWatch
                  //         .updateSelectedJobTitle(value);
                  //   },
                  //   hintTextForDropdown: "Job Title",
                  //   hintTextForField: "Job Title",
                  //   selectedValue:
                  //       registerProfileDetailsWatch.selectedJobTitle,
                  // ),
                  registerProfileDetailsWatch.isSelectedJobTitleEmt?Text("Please select Job title",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
        
                  SizedBox(
                    height: 20.h,
                  ),
                  CommonTypeAheadFormField(
                      prefixIcon: null,
                      direction: VerticalDirection.up,
                      onChanged: (value){
                        registerProfileDetailsWatch.isSelectedPrefCityEmtUpdate(value);
                      },
                      controller: registerProfileDetailsWatch.preferCitySearchController,
                      hintText: "Prefer City",
                      labelText: "Prefer City",
                      suggestionsCallback: (pattern) {
                        return registerProfileDetailsWatch.checkJobLocation(pattern);
                      },
                      onSuggestionSelected: (value) {
                        registerProfileDetailsWatch.preferCitySearchController.text = value;
                        registerProfileDetailsWatch.isSelectedPrefCityEmtUpdate(value);
                      }
                  ),
                  // CommonDropDownFormField(
                  //   items: SharedPrefServices.services.getList(locationListKey)??["No data"],
                  //   searchController:
                  //   registerProfileDetailsWatch.preferCitySearchController,
                  //   onChanged: (value) {
                  //     registerProfileDetailsWatch
                  //         .updateSelectedPreferCity(value);
                  //   },
                  //   hintTextForDropdown: "Prefer City",
                  //   hintTextForField: "Prefer City",
                  //   selectedValue:
                  //   registerProfileDetailsWatch.selectedPreferCity,
                  // ),
                  registerProfileDetailsWatch.isSelectedPrefCityEmt?Text("Please select Prefer City",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Select your prefer working mode",
                  style: TextStyles.w400.copyWith(
                      fontSize: 12.sp, color: AppColors.colors.blueColors),
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
                IconButton(
                  onPressed: (){
                    registerProfileDetailsWatch.addExpertise();
                  }, icon: Icon(Icons.add,size: 20.sp,),style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: AppColors.colors.greyRegent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                    elevation: 1.5,
                    padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 8.h)
                ),)
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
