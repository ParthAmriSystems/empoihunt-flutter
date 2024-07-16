import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_typ_ahead_form_field.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';


class UserDetailsDialogBox extends ConsumerWidget {
  final UserDetailDataModel userDetailDataModel;
  const UserDetailsDialogBox({super.key,required this.userDetailDataModel});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return SafeArea(
      child: Container(
        width: 340.w,
        height: 570.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom> 0? 230 : 0),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(4.r)
        ),
        child: Form(
          key: profileWatch.userDetailFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Change Info",style: TextStyles.w600.copyWith(fontSize: 22.sp,color: AppColors.colors.blueColors),).paddingVertical(10.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: CommonFormField(
                            controller: profileWatch.firstNameController,
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                            validator: (val)=>requiredFieldValidator(input: val, errorMgs: "Please enter first name"),
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                            hintText: "First Name",labelText: "First Name",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),)),
                          SizedBox(width: 8.w,),
                          Expanded(child: CommonFormField(
                            controller: profileWatch.lastNameController,
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                            validator: (val)=>requiredFieldValidator(input: val, errorMgs: "Please enter last name"),
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                            hintText: "Last Name",labelText: "Last Name",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: CommonFormField(
                            maxLength: 25,
                            buildCounter: (p0, {required currentLength, required isFocused, maxLength}) =>const SizedBox() ,
                            controller: profileWatch.expertiseController,
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                            hintText: "Expertise",labelText: "Expertise",prefixIcon: Icon(Icons.person,color: AppColors.colors.blueColors,),)),
                          SizedBox(width: 10.w,),
                          IconButton(
                            onPressed: (){
                              profileWatch.addExpertise();
                            }, icon: Icon(Icons.add,size: 30.sp,),style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: AppColors.colors.greyRegent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                              elevation: 1.5,
                              padding: EdgeInsets.symmetric(horizontal: 6.w,vertical: 8.h)
                          ),)
                        ],
                      ).paddingOnly(top: 15.h,),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        width: double.infinity,
                        height: 140.h,
                        color: AppColors.colors.whiteCatskill,
                        child: SingleChildScrollView(
                          child:profileWatch.expertiseList.isEmpty? const SizedBox(): Wrap(
                            children: List.generate(profileWatch.expertiseList.length, (index){
                              final expertise = profileWatch.expertiseList[index];
                              return Container(
                                margin: EdgeInsets.all(10.sp),
                                padding: EdgeInsets.all(4.sp),
                                decoration: BoxDecoration(
                                    color: AppColors.colors.whiteColors,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: AppColors.colors.blueColors,width: 0.5.w)
                                ),
                                child: Text(expertise,style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),),
                              );
                            }),
                          ),
                        ),
                      ),
                      profileWatch.isExpertiseAdded?Text("Please add expertise",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),).paddingVertical(5.h):const SizedBox(),

                      CommonTypeAheadFormField(
                        initialSelection: profileWatch.userDetailSelectedJobLocation,
                          width: context.screenWidth * 0.85,
                          controller: profileWatch.jobLocationSearchController,
                          hintText: "Residential City",
                          labelText: "Residential City",
                          dropdownMenuEntries: SharedPrefServices.services.getList(locationListKey)!
                              .map((element) => DropdownMenuEntry(
                              value: element,
                              label: element))
                              .toList(),
                          onSelected: (value)  {
                            profileWatch.updateSelectedJobLocation(value);
                            profileWatch.userDetailSelectedJobLocation = value?? profileWatch.jobLocationSearchController.text;
                          }),
                      /*CommonDropDownFormField(
                        items: SharedPrefServices.services.getList(locationListKey)!,
                        searchController: profileWatch.jobLocationSearchController,
                        onChanged: (value) {
                          profileWatch.updateSelectedJobLocation(value);
                        },
                        hintTextForDropdown: "Residential City",
                        hintTextForField: "Residential City",
                        selectedValue: profileWatch.userDetailSelectedJobLocation,
                      ).paddingOnly(top: 10.h),*/
                      profileWatch.isUserDetailsJobSelect?Text("Please select job location",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),).paddingOnly(bottom: 5.h):const SizedBox(),

                      CommonFormField(
                      controller: profileWatch.emailController,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                       keyboardType: TextInputType.emailAddress,
                       validator: (val)=>emailValidator(val),
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        hintText: "Email",labelText: "Email",prefixIcon: Icon(Icons.mail,color: AppColors.colors.blueColors,),).paddingVertical(10.h),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(onPressed: (){
                    profileWatch.userDetailChangeCancelButton();
                  }, child: Text("CANCEL",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                  SizedBox(width: 10.w,),
                  TextButton(onPressed: (){
                    profileWatch.userDetailChangeDoneButton(userDetailDataModel);
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


/*

  width: size.width* 0.90.w,
      height: size.height * 0.70.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
      decoration: BoxDecoration(
          color: AppColors.colors.whiteColors,
          borderRadius: BorderRadius.circular(4.r)
      ),
 */