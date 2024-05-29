// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/frame_work/controller/manage_job_post_controller/manage_job_post_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/common_widget/common_typ_ahead_form_field.dart';
import '../../utils/theme/app_assets.dart';
import '../../utils/theme/app_color.dart';
import '../../utils/theme/text_styles.dart';

class UpdatePostDropDownForms extends ConsumerWidget {
  const UpdatePostDropDownForms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managePostJobWatch = ref.watch(manageJobPostController);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTypeAheadFormField(
            direction: VerticalDirection.up,
            prefixIcon: SvgPicture.asset(AppAssets.qualificationSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),
            controller: managePostJobWatch.educationSearchController,
            hintText: "Bachelor of Engineering(BE)",
            labelText: "Required Education",
            onSuggestionSelected: (value) {
              managePostJobWatch.educationSearchController.text = value;
            },
            suggestionsCallback: (pattern){
              return managePostJobWatch.checkEducation(pattern);
            }),
        managePostJobWatch.isEducationSelected?Text("Education is required",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

        SizedBox(
          height: 10.h,
        ),
        CommonDropDownFormField(
          items: SharedPrefServices.services.getList(locationListKey)??["No data"],
          searchController: managePostJobWatch.jobLocationSearchController,
          onChanged: (value) {
            managePostJobWatch.updateSelectedJobLocation(value);
          },
          hintTextForDropdown: "Job Location",
          hintTextForField: "Job Location",
          selectedValue: managePostJobWatch.selectedJobLocation,
        ),
        managePostJobWatch.isJobLocationSelect?Text("Job Location is required",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

      ],
    );
  }
}
