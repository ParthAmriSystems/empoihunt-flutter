import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

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
                     CommonFormField(
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
                    registerProfileDetailsWatch.isCompanyNameEmpty?  Text("Required field",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(
                      height: 15.h,
                    ),
                    CommonTypeAheadFormField(
                        prefixIcon: null,
                        direction: VerticalDirection.up,
                        onChanged: (value){
                          // notAllowSpecialChar(registerProfileDetailsWatch.designationSearchController, value);
                          registerProfileDetailsWatch.isSelectedDesignEmptyUpdate(value);
                        },
                        controller: registerProfileDetailsWatch.designationSearchController,
                        hintText: "Designation",
                        labelText: "Designation",
                        suggestionsCallback: (pattern) {
                          return registerProfileDetailsWatch.checkDesignation(pattern);
                        },
                        onSuggestionSelected: (value) {
                          registerProfileDetailsWatch.designationSearchController.text = value;
                          registerProfileDetailsWatch.isSelectedDesignEmptyUpdate(value);
                        }
                    ),
                    // CommonDropDownFormField(
                    //   items: designationList,
                    //   searchController: registerProfileDetailsWatch
                    //       .designationSearchController,
                    //   onChanged: (value) {
                    //     registerProfileDetailsWatch
                    //         .updateSelectedDesignation(value);
                    //   },
                    //   hintTextForDropdown: "Designation",
                    //   hintTextForField: "Designation",
                    //   selectedValue:
                    //       registerProfileDetailsWatch.selectedDesignation,
                    // ),
                    registerProfileDetailsWatch.isSelectedDesignEmpty?  Text("Please select designation",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(
                      height: 15.h,
                    ),
                    CommonTypeAheadFormField(
                        prefixIcon: null,
                        direction: VerticalDirection.up,
                        onChanged: (value){
                          // notAllowSpecialChar(registerProfileDetailsWatch.jobLocationSearchController, value);
                          registerProfileDetailsWatch.isSelectedJobLocEmptyUpdate(value);
                        },
                        controller: registerProfileDetailsWatch.jobLocationSearchController,
                        hintText: "Job Location",
                        labelText: "Job Location",
                        suggestionsCallback: (pattern) {
                          return registerProfileDetailsWatch.checkJobLocation(pattern);
                        },
                        onSuggestionSelected: (value) {
                          registerProfileDetailsWatch.jobLocationSearchController.text = value;
                          registerProfileDetailsWatch.isSelectedJobLocEmptyUpdate(value);
                        }
                    ),
                    // CommonDropDownFormField(
                    //   items: SharedPrefServices.services.getList(locationListKey)??["No data"],
                    //   searchController: registerProfileDetailsWatch
                    //       .jobLocationSearchController,
                    //   onChanged: (value) {
                    //     registerProfileDetailsWatch
                    //         .updateSelectedJobLocation(value);
                    //   },
                    //   hintTextForDropdown: "Job Location",
                    //   hintTextForField: "Job Location",
                    //   selectedValue:
                    //   registerProfileDetailsWatch.selectedJobLocation,
                    // ),
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
