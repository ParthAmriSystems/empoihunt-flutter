// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/frame_work/controller/setting_controller/job_preference/job_preference_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/common_widget/common_typ_ahead_form_field.dart';
import '../utils/theme/app_assets.dart';
import '../utils/theme/app_color.dart';
import '../utils/theme/text_styles.dart';

class AddJobPreference extends ConsumerWidget {
  const AddJobPreference({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobPreferenceWatch = ref.watch(jobPreferenceController);
    return  PopScope(
      canPop: true,
      onPopInvoked: (value){
        jobPreferenceWatch.updateIsUpdateFunc(false);
        jobPreferenceWatch.jobPreferenceApiCall();
      },
      child: Scaffold(
        appBar: const CommonAppBar(isLeadingShow: true,title: "Add job preference"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CommonTypeAheadFormField(
                leadingIcon: SvgPicture.asset(AppAssets.jobTitleSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),
                  width: context.screenWidth * 0.93,
                  controller: jobPreferenceWatch.jobTitleSearchController,
                  hintText: "Android Developer",
                  labelText: "Job Title",
                  dropdownMenuEntries: designationList
                      .map((element) => DropdownMenuEntry(
                      value: element,
                      label: element))
                      .toList(),
                  onSelected: (value)  {
                    jobPreferenceWatch.jobTitleSearchController.text = value??jobPreferenceWatch.jobTitleSearchController.text;
                  }),
             /* CommonTypeAheadFormField(
                direction: VerticalDirection.down,
                  prefixIcon: SvgPicture.asset(AppAssets.jobTitleSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),
                  controller: jobPreferenceWatch.jobTitleSearchController,
                  hintText: "Android Developer",
                  labelText: "Job Title",
                  onSelected: (value) {
                    jobPreferenceWatch.jobTitleSearchController.text = value;
                  },
                  suggestionsCallback: (pattern) async{
                    return await jobPreferenceWatch.checkJobTitle(pattern);
                  }),*/

              ///--------------- working mode ---------///
              Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.colors.whiteColors,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.colors.blueColors),
                      ),
                      child: Column(
                          children: List.generate(
                              jobPreferenceWatch.workingModeList.length, (index) {
                            final radioButton = jobPreferenceWatch.workingModeList[index];
                            return RadioListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                                title: Text(
                                  radioButton.title,
                                  style: TextStyles.w400.copyWith(
                                      fontSize: 12.sp, color: AppColors.colors.blackColors),
                                ),
                                value: radioButton.value,
                                groupValue: jobPreferenceWatch.selectedRemoteValue,
                                onChanged: (value) {
                                  jobPreferenceWatch.updateSelectedValue(value!);
                                });
                          })),
                    ),
                    Positioned(
                      top: 0,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.only(top: 8.h),
                        color: AppColors.colors.whiteColors,
                        child: Text("Working Mode",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),),
                      ),
                    )
                  ],
                ),
              ),

              ///------------------- LPA spinner --------------------///
              GestureDetector(
                onTap: (){
                    showDialog(context: context, builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: Colors.transparent,
                          ),
                          height: 200.h,
                          child: CupertinoPicker(
                            backgroundColor: Colors.white,
                            scrollController: FixedExtentScrollController(
                              initialItem: jobPreferenceWatch.selectedLPA
                            ),
                            itemExtent: 25,
                            onSelectedItemChanged: (int value) {
                              jobPreferenceWatch.updateSelectedLPA(value);
                            },
                            children: List.generate(26, (index) => Text(index.toString())),
                          ),
                        ),
                      );
                    },);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.colors.blueColors,width: 1.w),
                    color: Colors.white
                  ),
                  child:Row(
                    children: [
                      Icon(Icons.currency_rupee,color: AppColors.colors.blueColors,),
                      SizedBox(width: 6.w,),
                      Text("${jobPreferenceWatch.selectedLPA} LPA+",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.greyRegent),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h,),

              ///----------------- City Form Field ------------------///
              CommonTypeAheadFormField(
                  width: context.screenWidth * 0.93,
                  controller: jobPreferenceWatch.cityController,
                  hintText: "City",
                  labelText: "City",
                  dropdownMenuEntries: SharedPrefServices.services.getList(locationListKey)!
                      .map((element) => DropdownMenuEntry(
                      value: element,
                      label: element))
                      .toList(),
                  onSelected: (value)  {
                    jobPreferenceWatch.cityController.text = value??jobPreferenceWatch.cityController.text;
                  }),
             /* CommonTypeAheadFormField(
                  direction: VerticalDirection.up,
                  onChanged: (value)=>notAllowSpecialChar(jobPreferenceWatch.cityController, value),
                  controller: jobPreferenceWatch.cityController,
                  hintText: "City",
                  labelText: "City",
                  suggestionsCallback: (pattern) async {
                    return await jobPreferenceWatch.checkCity(pattern);
                  },
                  onSelected: (value) =>
                  jobPreferenceWatch.cityController.text = value),*/
               SizedBox(height: 10.h,),
              CommonButton(
                backgroundColor: AppColors.colors.blueColors,
                onPrimary: AppColors.colors.blueDark,
                btnText:jobPreferenceWatch.isUpdateFunc?"Update":"Submit", onPressed:(){
                jobPreferenceWatch.submitButton(context);
              },fontSize: 18.sp,txtPadding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 70.w),)

            ],
          ).paddingOnly(left: 12.w,right: 12.w,top: 10.h),
        ),
      ),
    );
  }
}
