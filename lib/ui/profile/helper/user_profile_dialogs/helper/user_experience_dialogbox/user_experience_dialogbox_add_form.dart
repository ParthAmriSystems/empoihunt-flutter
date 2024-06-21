import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class UserExperienceDialogBoxAddForm extends ConsumerStatefulWidget {
  const UserExperienceDialogBoxAddForm({super.key});

  @override
  ConsumerState<UserExperienceDialogBoxAddForm> createState() => _UserExperienceDialogBoxAddFormState();
}

class _UserExperienceDialogBoxAddFormState extends ConsumerState<UserExperienceDialogBoxAddForm> {


  @override
  Widget build(BuildContext context) {

    final profileWatch = ref.watch(profileController);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.colors.whiteColors,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Form(
        key: profileWatch.experienceAddFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonFormField(
              controller: profileWatch.userExperienceAddDesignFieldController,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (val)=>requiredFieldValidator(input: val, errorMgs: "Please provide designation"),
              hintText: "Designation",labelText: "Designation",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),),
            SizedBox(height: 10.h,),
            CommonFormField(
              controller: profileWatch.userExperienceAddCompanyNameFieldController,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (val)=>requiredFieldValidator(input: val, errorMgs: "Please provide company name"),
              hintText: "Company name",labelText: "Company name",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),),
            SizedBox(height: 20.h,),
            CommonDropDownFormField(
              items: SharedPrefServices.services.getList(locationListKey)??["No data"],
              searchController: profileWatch.userExperienceAddSearchJobLocationFieldController,
              onChanged: (value) {
                profileWatch.updateUserExperienceAddSelectedJobLocation(value);
              },
              hintTextForDropdown: "Job Location",
              hintTextForField: "Job Location",
              selectedValue: profileWatch.userExperienceAddSelectedJobLocation,
            ),
            profileWatch.isUserExperienceAddJobSelected?Text("Please select job location",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),).paddingVertical(5.h):const SizedBox(),
            Row(
              children: [
                Checkbox(value: profileWatch.checkBoxValAddForm, onChanged: (val){
                  profileWatch.updateCheckBoxValAddForm(val!);
                }),
                SizedBox(width: 5.w,),
                Expanded(child: Text("Are you working here ?",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),))
              ],
            ).paddingOnly(top: 15.h,bottom: 10.h),
           profileWatch.checkBoxValAddForm? const SizedBox():Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFormField(
                  controller: profileWatch.userExperienceAddDurationFieldController,
                  hintText: "Duration",labelText: "Duration",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),),
                SizedBox(height: 5.h,),
                Text("Enter Duration in years",style: TextStyles.w300.copyWith(fontSize: 10.sp,color: AppColors.colors.greyRegent),),],),
            Row(
              children: [
                const Spacer(),
                CommonButton(btnText: "Add", onPressed: (){
                  profileWatch.userExperienceAddButton();
                },textColor: AppColors.colors.blueColors,backgroundColor: AppColors.colors.clayColors,txtPadding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 8.w),fontSize: 14.sp,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
