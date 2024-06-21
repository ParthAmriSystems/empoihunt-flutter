import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class UserAboutDialogBox extends ConsumerWidget {
  final UserDetailDataModel userDetailDataModel;
  const UserAboutDialogBox({super.key,required this.userDetailDataModel});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return SafeArea(
      child: Container(
        width: 340.w,
        height: 280.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom> 0? 230 : 0),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(4.r)
        ),
        child: Form(
          key: profileWatch.aboutFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Change Bio",style: TextStyles.w600.copyWith(fontSize: 22.sp,color: AppColors.colors.blueColors),).paddingVertical(10.h),
              Expanded(
                child: CommonFormField(
                  controller: profileWatch.bioController,
                  validator: (value)=>requiredFieldValidator(input: value, errorMgs: "Required field"),
                  maxLength: 2000,
                  hintText: "Bio",
                  labelText: "Bio",
                  prefixIcon: const Icon(Icons.file_copy_rounded),
                  maxLine: 4,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(onPressed: (){
                    profileWatch.bioCancelButton();
                  }, child: Text("CANCEL",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                  SizedBox(width: 10.w,),
                  TextButton(onPressed: (){
                    profileWatch.bioDoneButton(userDetailDataModel);
                  }, child: Text("Done",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                ],
              ).paddingOnly(top: 10.h,)
            ],
          ),
        ),
      ),
    );
  }
}