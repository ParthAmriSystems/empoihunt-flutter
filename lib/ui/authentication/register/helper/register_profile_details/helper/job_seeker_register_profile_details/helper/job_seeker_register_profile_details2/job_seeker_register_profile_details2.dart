import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../../../../utils/common_widget/common_typ_ahead_form_field.dart';

class JobSeekerRegisterProfileDetails2 extends ConsumerWidget {
  const JobSeekerRegisterProfileDetails2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerProfileDetailsWatch =
        ref.watch(jobSeekerRegisterProfileDetailsController);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          Text(
            "Current Position Details",
            style: TextStyles.w400
                .copyWith(fontSize: 18.sp, color: AppColors.colors.blueColors),
          ),
          Divider(
            color: AppColors.colors.blueColors,
            thickness: 4.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Showcase(
                       key: registerProfileDetailsWatch.globalKeyCompanyName,
                       title: 'Company',
                       description: 'Specify the company you work for or have worked for recently',
                       targetBorderRadius:  BorderRadius.circular(8.r),
                       targetPadding: EdgeInsets.only(top: 10.h,left: 8.w,right: 8.w,bottom: 10.h),
                       child: CommonFormField(
                         controller: registerProfileDetailsWatch.companyNameController,
                        validator:(value)=> requiredFieldValidator(input: value!, errorMgs: "Please Add Company name"),
                          hintText: "Company name",
                          prefixIcon: const Icon(
                            Icons.location_city_sharp,
                          ),
                          onChanged: (value){
                           registerProfileDetailsWatch.updateIsCompanyNameEmt(value);
                          },
                          labelText: "Company name"),
                     ),
                    registerProfileDetailsWatch.isCompanyNameEmpty?  Text("Required field",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(
                      height: 15.h,
                    ),
                    Showcase(
                      key: registerProfileDetailsWatch.globalKeyDesignation,
                      title: 'Designation',
                      description: 'Specify your job title or designation in your current or past organization',
                      targetBorderRadius:  BorderRadius.circular(8.r),
                      targetPadding: EdgeInsets.only(top: 8.h,left: 8.w,right: 8.w,bottom: 8.h),
                      child: CommonTypeAheadFormField(
                          width: context.screenWidth * 0.87,
                          controller: registerProfileDetailsWatch.designationSearchController,
                          hintText: "Designation",
                          labelText: "Designation",
                          dropdownMenuEntries: designationList
                              .map((element) => DropdownMenuEntry(
                              value: element,
                              label: element))
                              .toList(),
                          onSelected: (value)  {
                            registerProfileDetailsWatch.isSelectedDesignEmptyUpdate(value);
                            registerProfileDetailsWatch.designationSearchController.text = value??registerProfileDetailsWatch.designationSearchController.text;
                          }),
                    ),
                    registerProfileDetailsWatch.isSelectedDesignEmpty?  Text("Please select designation",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(
                      height: 15.h,
                    ),

                    Showcase(
                      key: registerProfileDetailsWatch.globalKeyCLocation,
                      title: 'Location',
                      description: 'Specify the city or office location of your company',
                      targetBorderRadius:  BorderRadius.circular(8.r),
                      targetPadding: EdgeInsets.only(top: 8.h,left: 8.w,right: 8.w,bottom: 8.h),
                      child: CommonTypeAheadFormField(
                          width: context.screenWidth * 0.87,
                          controller: registerProfileDetailsWatch.jobLocationSearchController,
                          hintText: "Job Location",
                          labelText: "Job Location",
                          dropdownMenuEntries: SharedPrefServices.services.getList(locationListKey)!
                              .map((element) => DropdownMenuEntry(
                              value: element,
                              label: element))
                              .toList(),
                          onSelected: (value)  {
                            registerProfileDetailsWatch.isSelectedJobLocEmptyUpdate(value);
                            registerProfileDetailsWatch.jobLocationSearchController.text = value??registerProfileDetailsWatch.jobLocationSearchController.text;
                          }),
                    ),
                    registerProfileDetailsWatch.isSelectedJobLocEmpty?  Text("Please select job location",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),

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
