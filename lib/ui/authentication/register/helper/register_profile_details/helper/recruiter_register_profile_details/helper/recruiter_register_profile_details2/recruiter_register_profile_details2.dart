import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/recruiter_register_profile_details_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_typ_ahead_form_field.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

class RecruiterRegisterProfileDetails2 extends ConsumerWidget {
  const RecruiterRegisterProfileDetails2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerProfileDetailsWatch =
        ref.watch(recruiterRegisterProfileDetailsController);
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
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     CommonFormField(
                         maxLength: 50,
                         buildCounter: (p0, {required currentLength, required isFocused, maxLength}) =>const SizedBox(),
                       controller: registerProfileDetailsWatch.companyNameController,
                         keyboardType: TextInputType.name,
                         onChanged: (value){
                           registerProfileDetailsWatch.updateIsCompanyEmpty(value);
                         },
                        hintText: "Company name",
                        prefixIcon: const Icon(
                          Icons.location_city_sharp,
                        ),
                        labelText: "Company name"),
                    registerProfileDetailsWatch.isCompanyEmpty?Text("please enter the company name",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(
                      height: 15.h,
                    ),
                    CommonTypeAheadFormField(
                        prefixIcon: null,
                        direction: VerticalDirection.up,
                        onChanged: (value){
                          registerProfileDetailsWatch.isDesignationEmptyUpdate(value);
                        },
                        controller: registerProfileDetailsWatch.designationSearchController,
                        hintText: "Designation",
                        labelText: "Designation",
                        suggestionsCallback: (pattern) {
                          return registerProfileDetailsWatch.checkDesignation(pattern);
                        },
                        onSuggestionSelected: (value) {
                          registerProfileDetailsWatch.designationSearchController.text = value;
                          registerProfileDetailsWatch.isDesignationEmptyUpdate(value);
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
                    registerProfileDetailsWatch.isDesignationEmpty?Text("please Select the above Designation",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(
                      height: 20.h,
                    ),
                    CommonTypeAheadFormField(
                        prefixIcon: null,
                        direction: VerticalDirection.up,
                        onChanged: (value){
                          registerProfileDetailsWatch.isJobLocationEmptyUpdate(value);
                        },
                        controller: registerProfileDetailsWatch.jobLocationSearchController,
                        hintText: "Prefer City",
                        labelText: "Prefer City",
                        suggestionsCallback: (pattern) {
                          return registerProfileDetailsWatch.checkJobLocation(pattern);
                        },
                        onSuggestionSelected: (value) {
                          registerProfileDetailsWatch.jobLocationSearchController.text = value;
                          registerProfileDetailsWatch.isJobLocationEmptyUpdate(value);
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
                    registerProfileDetailsWatch.isJobLocationEmpty? Text("please Select the Job Location",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(height: 5.h,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select your prefer working mode",
                          style: TextStyles.w400.copyWith(
                              fontSize: 12.sp, color: AppColors.colors.blueColors),
                        ),
                        SizedBox(
                          height: 5.h,
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
