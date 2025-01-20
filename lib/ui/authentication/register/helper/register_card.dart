import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/register_controller.dart';
import 'package:emploiflutter/ui/terms_and_condition/terns_and_condition.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_typ_ahead_form_field.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:flutter/services.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../frame_work/repository/services/shared_pref_services.dart';
import '../../../utils/constant/app_constant.dart';

class RegisterCard extends ConsumerWidget {
  const RegisterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerWatch = ref.watch(registerController);
    return Form(
      key: registerWatch.registerKey,
      child: Card(
        margin: EdgeInsets.only(top: 100.h),
        elevation: 4,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.93,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 35.h, bottom: 20.h, left: 20.w, right: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: CommonFormField(
                            maxLength: 15,
                            buildCounter: (p0, {required currentLength, required isFocused, maxLength}) =>const SizedBox() ,
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                            validator: (val) => requiredFieldValidator(input: val!,errorMgs:"First name is required" ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            controller: registerWatch.firstNameController,
                            onChanged: (value){
                              // notAllowSpecialChar(registerWatch.firstNameController, value);
                              // print(registerWatch.firstNameController.text);
                              },
                        prefixIcon: Icon(
                          Icons.person,
                          size: 18.sp,
                          color: AppColors.colors.blueColors,
                        ),
                        hintText: "First name",
                        labelText: "First name",
                        labelStyle: TextStyles.w400
                            .copyWith(color: Colors.black, fontSize: 12.sp),
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: CommonFormField(
                          maxLength: 15,
                          buildCounter: (p0, {required currentLength, required isFocused, maxLength}) =>const SizedBox(),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) => requiredFieldValidator(input: val!,errorMgs:"Last name is required" ),
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.name,
                          controller: registerWatch.lastNameController,
                          onChanged: (value){
                            // notAllowSpecialChar(registerWatch.lastNameController, value);
                          },
                          prefixIcon: Icon(
                            Icons.person,
                            size: 18.sp,
                            color: AppColors.colors.blueColors,
                          ),
                          hintText: "Last name",
                          labelText: "Last name",
                          labelStyle: TextStyles.w400
                              .copyWith(color: Colors.black, fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 22.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            registerWatch.selectCountry(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                registerWatch.selectedCountry.countryCode,
                                style: TextStyles.w400.copyWith(
                                    fontSize: 14.sp, color: Colors.black),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "+${registerWatch.selectedCountry.phoneCode}",
                                style: TextStyles.w400.copyWith(
                                    fontSize: 14.sp, color: Colors.black),
                              ),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: CommonFormField(
                          maxLength: 10,
                          buildCounter: (p0,
                                  {required currentLength,
                                  required isFocused,
                                  maxLength}) =>
                              const SizedBox(),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) => phoneValidator(val),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.phone,
                          controller: registerWatch.phoneNumberController,
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 18.sp,
                            color: AppColors.colors.blueColors,
                          ),
                          onChanged: (value)=>notAllowSpecialChar(registerWatch.phoneNumberController, value),
                          hintText: "9876....",
                          labelText: "Phone Number",
                          labelStyle: TextStyles.w400
                              .copyWith(color: Colors.black, fontSize: 12.sp),
                        )),
                      ],
                    ),
                  ),
                  CommonFormField(
                    textInputAction: TextInputAction.newline,
                    controller: registerWatch.emailController,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => emailValidator(val),
                    prefixIcon: Icon(
                      Icons.email,
                      size: 18.sp,
                      color: AppColors.colors.blueColors,
                    ),
                    hintText: "Email",
                    labelText: "Email",
                    labelStyle: TextStyles.w400
                        .copyWith(color: Colors.black, fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CommonTypeAheadFormField(
                      leadingIcon: Icon(Icons.location_city_outlined,size: 18.sp,color: AppColors.colors.blueColors,),
                      width: context.screenWidth * 0.82,
                      controller: registerWatch.cityController,
                      hintText: "City",
                      labelText: "City",
                      dropdownMenuEntries: SharedPrefServices.services.getList(locationListKey)!
                          .map((element) => DropdownMenuEntry(
                          value: element,
                          label: element))
                          .toList(),
                      onSelected: (value)  {
                        registerWatch.cityController.text = value?? registerWatch.cityController.text;
                      }),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: registerWatch.isCheck,
                          onChanged: (val) {
                            registerWatch.updateIsCheck(val!);
                          }),
                      Expanded(
                        child: TextButton(onPressed: (){
                            Navigator.push(context, PageTransition(child: const TermsAndCondition(), type: PageTransitionType.rightToLeft,childCurrent: this,duration: const Duration(milliseconds: 200)));
                        }, child: Text(
                          "I have read and agreed to the terms & conditions",
                          style: TextStyles.w400
                              .copyWith(fontSize: 12.sp, color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.colors.blueColors,
                            decorationThickness: 2.0,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        )),
                      )
                    ],
                  ),
                  CommonButton(
                      backgroundColor: AppColors.colors.blueColors,
                      onPrimary: AppColors.colors.blueDark,
                      btnText: "Register",
                      onPressed: () {
                        registerWatch.registerButton(context);
                      },
                      fontSize: 20.sp,
                      txtPadding: EdgeInsets.symmetric(
                          horizontal: 40.w, vertical: 6.h)),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
