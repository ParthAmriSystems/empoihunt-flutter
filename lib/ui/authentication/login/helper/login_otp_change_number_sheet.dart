import 'package:emploiflutter/frame_work/controller/authentication_controller/login_controller/login_otp_controller.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

import '../../../utils/common_widget/common_form_field.dart';
import '../../../utils/common_service/form_validation.dart';


class LoginOtpChangeNumberSheet extends ConsumerWidget{
  final BuildContext scaffoldContext;
  const LoginOtpChangeNumberSheet({super.key,required this.scaffoldContext});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final loginOtpWatch = ref.watch(loginOtpController);
    return Form(
      key: loginOtpWatch.bottomSheetState,
      child: Container(
        height: 250.h,
        width: double.infinity,
        color: AppColors.colors.whiteCatskill,
        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Change your number here ",style: TextStyles.w400.copyWith(fontSize: 18.sp,color: AppColors.colors.blackColors),),
            SizedBox(height: 20.h,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 22.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      loginOtpWatch.selectCountry(context);
                    },
                    child: Row(
                      children: [
                        Text(loginOtpWatch.selectedCountry.countryCode,style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),),
                        SizedBox(width: 5.w,),
                        Text("+${loginOtpWatch.selectedCountry.phoneCode}",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),),
                        const Icon(Icons.arrow_drop_down_outlined,color: Colors.black,),
                        SizedBox(width: 5.w,),
                      ],
                    ),
                  ),
                  Expanded(child: CommonFormField(
                    buildCounter: (p0, {required currentLength, required isFocused, maxLength}) => const SizedBox(),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    maxLength: 10,
                    validator: (val)=>phoneValidator(val),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    controller: loginOtpWatch.phoneNumberController,
                    onChanged: (value)=>notAllowSpecialChar(loginOtpWatch.phoneNumberController, value),
                    prefixIcon: Icon(Icons.phone,size: 18.sp,color: AppColors.colors.blueColors,),
                    hintText: "9876....",labelText: "Phone Number",)),
                ],
              ),
            ).paddingHorizontal(35.w),
            SizedBox(height: 20.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonButton(btnText: "Yes", onPressed: ()async{
                  if(loginOtpWatch.bottomSheetState.currentState!.validate()){
                    context.pop();
                    await loginOtpWatch.verifyPhoneNumber(phoneNumber: "+${loginOtpWatch.selectedCountry.phoneCode}${loginOtpWatch.phoneNumberController.text}", context: scaffoldContext);
                    loginOtpWatch.phoneNumberController.clear();
                  }
                },backgroundColor: AppColors.colors.blueColors,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),fontSize: 14.sp,txtPadding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h)),
                CommonButton(btnText: "No", onPressed: (){
                  context.pop();
                  loginOtpWatch.phoneNumberController.clear();
                },backgroundColor: AppColors.colors.whiteColors,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r),side: BorderSide(color: AppColors.colors.blueColors)),textColor: AppColors.colors.blueColors,fontSize: 14.sp,txtPadding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h),onPrimary: Colors.grey,),
              ],
            )
          ],
        ),
      ),
    );
  }
}
