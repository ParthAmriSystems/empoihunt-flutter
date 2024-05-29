// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/frame_work/controller/create_post_job_controller/create_post_job_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_typ_ahead_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePostJobDropDownForms extends ConsumerWidget {
  const CreatePostJobDropDownForms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPostJobWatch = ref.watch(createPostJobController);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTypeAheadFormField(
          direction: VerticalDirection.up,
          prefixIcon: SvgPicture.asset(AppAssets.qualificationSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),
          controller: createPostJobWatch.educationSearchController,
            hintText: "Bachelor of Engineering(BE)",
            labelText: "Required Education",
            onSuggestionSelected: (value) {
              createPostJobWatch.educationSearchController.text = value;
            },
            suggestionsCallback: (pattern){
          return createPostJobWatch.checkEducation(pattern);
        }),
        createPostJobWatch.isEducationSelected?Text("Education is required",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

        SizedBox(
          height: 10.h,
        ),
        CommonDropDownFormField(
          items: SharedPrefServices.services.getList(locationListKey)??["No data"],
          searchController: createPostJobWatch.jobLocationSearchController,
          onChanged: (value) {
            createPostJobWatch.updateSelectedJobLocation(value);
          },
          hintTextForDropdown: "Job Location",
          hintTextForField: "Job Location",
          selectedValue: createPostJobWatch.selectedJobLocation,
        ),
        createPostJobWatch.isJobLocationSelect?Text("Job Location is required",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

      ],
    );
  }
}
