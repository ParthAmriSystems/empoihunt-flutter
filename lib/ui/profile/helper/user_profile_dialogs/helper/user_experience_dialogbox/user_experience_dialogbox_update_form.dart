import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_experience_model.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

class UserExperienceDialogBoxUpdateFrom extends ConsumerWidget {
  final UserExperienceModel model;
  const UserExperienceDialogBoxUpdateFrom({super.key,required this.model});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 10.h),
      color: AppColors.colors.whiteColors,
      child: Form(
        key: profileWatch.experienceUpdateFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonFormField(
              controller: profileWatch.userExperienceUpdateDesignFieldController,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (val)=>requiredFieldValidator(input: val, errorMgs: "Please provide designation"),
              hintText: "Designation",labelText: "Designation",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),),
            SizedBox(height: 10.h,),
            CommonFormField(
              controller: profileWatch.userExperienceUpdateCompanyNameFieldController,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (val)=>requiredFieldValidator(input: val, errorMgs: "Please provide company name"),
              hintText: "Company name",labelText: "Company name",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),),
            SizedBox(height: 15.h,),
            CommonDropDownFormField(
              items: SharedPrefServices.services.getList(locationListKey)??["No data"],
              searchController: profileWatch.userExperienceUpdateSearchJobLocationFieldController,
              onChanged: (value) {
                profileWatch.updateUserExperienceUpdateSelectedJobLocation(value);
              },
              hintTextForDropdown: "Job Location",
              hintTextForField: "Job Location",
              selectedValue: profileWatch.userExperienceUpdateSelectedJobLocation,
            ),
            Row(
              children: [
                Checkbox(value: profileWatch.checkBoxValUpdateForm, onChanged: (val){
                  profileWatch.updateCheckBoxValUpdateForm(val!);
                }),
                SizedBox(width: 5.w,),
                Expanded(child: Text("Are you working here ?",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),))
              ],
            ).paddingOnly(top: 15.h,bottom: 6.h),
            profileWatch.checkBoxValUpdateForm?   const SizedBox():Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFormField(
                  controller: profileWatch.userExperienceUpdateDurationFieldController,
                  hintText: "Duration",labelText: "Duration",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),),
                Text("Enter Duration in years",style: TextStyles.w300.copyWith(fontSize: 10.sp,color: AppColors.colors.greyRegent),)],),
            Row(
              children: [
                const Spacer(),
                CommonButton(btnText: "Update", onPressed: (){
                  profileWatch.updateListItemButton(model);
                },textColor: AppColors.colors.blueColors,backgroundColor: AppColors.colors.clayColors,txtPadding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 8.w),fontSize: 14.sp,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
