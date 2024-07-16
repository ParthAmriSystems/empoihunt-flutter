import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/recruiter_register_profile_details_controller.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

import '../../../../../../../../utils/common_widget/common_typ_ahead_form_field.dart';

class RecruiterRegisterProfileDetails1 extends ConsumerWidget {
  const RecruiterRegisterProfileDetails1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerProfileDetailsWatch =
        ref.watch(recruiterRegisterProfileDetailsController);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          Text(
            "Tell about your self",
            style: TextStyles.w400
                .copyWith(fontSize: 18.sp, color: AppColors.colors.blueColors),
          ),
          Divider(
            color: AppColors.colors.blueColors,
            thickness: 4.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonFormField(
                      controller: registerProfileDetailsWatch.bioController,
                      maxLength: 2000,
                      hintText: "Bio",
                      onChanged: (value)=>registerProfileDetailsWatch.updateIsBioEmpty(value),
                      prefixIcon: const Icon(Icons.file_copy_rounded),
                      maxLine: 4,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 10.w),
                    ),
                    registerProfileDetailsWatch.isBioEmpty? Text("please write something there",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox(),
                    SizedBox(
                      height: 10.h,
                    ),
                    CommonTypeAheadFormField(
                        width: context.screenWidth * 0.85,
                        controller: registerProfileDetailsWatch.qualificationSearchController,
                        hintText: "Qualification",
                        labelText: "Qualification",
                        dropdownMenuEntries: qualificationsList
                            .map((element) => DropdownMenuEntry(
                            value: element,
                            label: element))
                            .toList(),
                        onSelected: (value)  {
                          registerProfileDetailsWatch.isQualificationEmptyUpdate(value);
                          registerProfileDetailsWatch.qualificationSearchController.text = value??registerProfileDetailsWatch.qualificationSearchController.text;
                        }),
                    /*CommonTypeAheadFormField(
                        prefixIcon: null,
                        direction: VerticalDirection.up,
                        onChanged: (value){
                          registerProfileDetailsWatch.isQualificationEmptyUpdate(value);
                        },
                        controller: registerProfileDetailsWatch.qualificationSearchController,
                        hintText: "Qualification",
                        labelText: "Qualification",
                        suggestionsCallback: (pattern)async {
                          return await registerProfileDetailsWatch.checkEducation(pattern);
                        },
                        onSelected: (value) {
                          registerProfileDetailsWatch.qualificationSearchController.text = value;
                          registerProfileDetailsWatch.isQualificationEmptyUpdate(value);
                        }
                    ),*/

                   registerProfileDetailsWatch.isQualificationEmpty? Text("please Select the about Qualification",style: TextStyles.w300.copyWith(fontSize: 12.sp,color: Colors.red),):const SizedBox()

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