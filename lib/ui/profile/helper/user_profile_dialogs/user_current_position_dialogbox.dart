import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';

class UserCurrentPositionDialogBox extends ConsumerWidget {
  final UserDetailDataModel userDetailDataModel;
  const UserCurrentPositionDialogBox({super.key,required this.userDetailDataModel});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileWatch = ref.watch(profileController);

    return SafeArea(
      child: Container(
        width: 340.w,
        height: 420.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom> 0? 230 : 0),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(4.r)
        ),
        child: Form(
          key: profileWatch.currentPositionFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Change Info",style: TextStyles.w600.copyWith(fontSize: 22.sp,color: AppColors.colors.blueColors),).paddingVertical(10.h),
              SizedBox(height: 10.h,),
               Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonFormField(
                        controller: profileWatch.userCurrentPosDesignFieldController,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val)=>requiredFieldValidator(input: val, errorMgs: "Please provide designation"),
                        hintText: "Designation",labelText: "Designation",prefixIcon: Icon(Icons.home_work_outlined,color: AppColors.colors.blueColors,),),
                      SizedBox(height: 10.h,),
                      CommonFormField(
                        controller: profileWatch.userCurrentPosCompanyNameFieldController,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val)=>requiredFieldValidator(input: val , errorMgs: "Please provide company name"),
                        hintText: "Company name",labelText: "Company name",prefixIcon: Icon(Icons.leave_bags_at_home_sharp,color: AppColors.colors.blueColors,),),
                      SizedBox(height: 20.h,),
                      CommonDropDownFormField(
                        items: SharedPrefServices.services.getList(locationListKey)??["No data"],
                        searchController: profileWatch.userCurrentPosSearchJobLocationController,
                        onChanged: (value) {
                          profileWatch.updateUserCurrentPosSearchJobLocationController(value);
                        },
                        hintTextForDropdown: "Job Location",
                        hintTextForField: "Job Location",
                        selectedValue: profileWatch.userCurrentPosSelectedJobLocation,
                      ),
                      profileWatch.isUserCurrentPosJobSelected?Text("Please select job location",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),).paddingVertical(5.h):const SizedBox(),
                      SizedBox(height: 20.h,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select your prefer working mode",
                            style: TextStyles.w400.copyWith(
                                fontSize: 12.sp, color: AppColors.colors.blueColors),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Colors.grey),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(profileWatch.workingModeList.length, (index) {
                                final workingMode = profileWatch.workingModeList[index];
                             return   GestureDetector(
                                  onTap: () {
                                    profileWatch.updateWorkingMode(index);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 45.h,
                                    width: 105.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.r),
                                        color: profileWatch.selectedWorkingMode == index?
                                            AppColors.colors.blueColors
                                            : Colors.grey),
                                    child: Text(
                                      workingMode,
                                      style: TextStyles.w500.copyWith(
                                          fontSize: 14.sp,
                                          color:profileWatch.selectedWorkingMode == index?
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
                      SizedBox(height: 10.h,),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(onPressed: (){
                    profileWatch.currentPositionCancelButton();
                  }, child: Text("CANCEL",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                  SizedBox(width: 10.w,),
                  TextButton(onPressed: (){
                    profileWatch.currentPositionDoneButton(userDetailDataModel);
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
