// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/frame_work/controller/create_post_job_controller/create_post_job_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_typ_ahead_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../utils/constant/app_string_constant.dart';

class CreatePostJobDropDownForms extends ConsumerWidget {
  const CreatePostJobDropDownForms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPostJobWatch = ref.watch(createPostJobController);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Showcase(
          key: createPostJobWatch.globalKeyEducation,
          title: 'Education',
          description: 'Specify the educational qualifications required for this role',
          targetBorderRadius:  BorderRadius.circular(8.r),
          child: CommonTypeAheadFormField(
            // onTap: () => ShowCaseWidget.of(context).startShowCase([createPostJobWatch.globalKeyEducation]),
            leadingIcon: SvgPicture.asset(AppAssets.qualificationSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),
              width: context.screenWidth * 0.93,
              controller: createPostJobWatch.educationSearchController,
              hintText: "Bachelor of Engineering(BE)",
              labelText: "Required Education",
              dropdownMenuEntries: qualificationsList
                  .map((element) => DropdownMenuEntry(
                  value: element,
                  label: element))
                  .toList(),
              onSelected: (value)  {
                createPostJobWatch.educationSearchController.text = value?? createPostJobWatch.educationSearchController.text;
              }),
        ),
        createPostJobWatch.isEducationSelected?Text("Education is required",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),
        SizedBox(
          height: 10.h,
        ),
        Showcase(
          key: createPostJobWatch.globalKeyLocation,
          title: 'Location',
          description: 'Enter the city where the job position is based',
          targetBorderRadius:  BorderRadius.circular(8.r),
          child: CommonTypeAheadFormField(
              width: context.screenWidth * 0.93  ,
              controller: createPostJobWatch.jobLocationSearchController,
              hintText: "Job Location",
              labelText: "Job Location",
              dropdownMenuEntries: SharedPrefServices.services.getList(locationListKey)!
                  .map((element) => DropdownMenuEntry(
                  value: element,
                  label: element))
                  .toList(),
              onSelected: (value)  {
                // createPostJobWatch.updateSelectedJobLocation(value);
                createPostJobWatch.jobLocationSearchController.text = value?? createPostJobWatch.jobLocationSearchController.text;
              }),
        ),
        createPostJobWatch.isJobLocationSelect?Text("Job Location is required",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

      ],
    ).paddingOnly(top: 8.h);
  }
}
