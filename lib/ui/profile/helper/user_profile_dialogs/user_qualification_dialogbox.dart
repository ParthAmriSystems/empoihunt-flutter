import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class UserQualificationDialogBox extends ConsumerWidget {
  final UserDetailDataModel userDetailDataModel;
  const UserQualificationDialogBox({super.key,required this.userDetailDataModel});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return SafeArea(
      child: Container(
        width: 340.w,
        height: 220.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom> 0? 160 : 0),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(4.r)
        ),
        child: SingleChildScrollView(
          child: Form(
            key: profileWatch.currentPositionFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Edit Qualification",style: TextStyles.w600.copyWith(fontSize: 22.sp,color: AppColors.colors.blueColors),).paddingVertical(10.h),
                 CommonDropDownFormField(
                     items: qualificationsList,
                     searchController: profileWatch.qualificationSearchController,
                     selectedValue: profileWatch.selectedQualification,
                     onChanged: (value){
                   profileWatch.updateSelectedQualification(value);
                 }, hintTextForDropdown: "Qualification", hintTextForField: "Qualification"),
                profileWatch.isQualificationSelected?Text("Please select qualification",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),).paddingVertical(5.h):const SizedBox(),
                SizedBox(height: 10.h,),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(onPressed: (){
                      profileWatch.qualificationChangeCancelButton();
                    }, child: Text("CANCEL",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                    SizedBox(width: 10.w,),
                    TextButton(onPressed: (){
                      profileWatch.qualificationChangeDoneButton(userDetailDataModel);
                    }, child: Text("Done",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                  ],
                ).paddingOnly(top: 10.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}