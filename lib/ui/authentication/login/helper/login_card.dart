import 'package:emploiflutter/ui/authentication/register/helper/choose_register_type/choose_register_type.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../frame_work/controller/authentication_controller/login_controller/login_controller.dart';
import '../../../utils/theme/text_styles.dart';
import '../../../utils/theme/theme.dart';

class LoginCard extends ConsumerWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final loginWatch = ref.watch(loginController);
    return Form(
      key: loginWatch.loginKey,
      child: Card(
        margin: EdgeInsets.only(top: 35.h),
        elevation: 4,
        child: Container(
          width: 320.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 40.h,bottom: 25.h,left: 20.w,right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("OTP Verification",style:  TextStyles.w500.copyWith(fontSize: 26.sp,color: Colors.black),),
                Text("we will send you 6-digit one-time password to the number", textAlign: TextAlign.center, style:  TextStyles.w400.copyWith(fontSize: 8.sp,color: Colors.grey),),
                 Padding(
                   padding: EdgeInsets.symmetric(vertical: 22.h),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          loginWatch.selectCountry(context);
                        },
                        child: Row(
                          children: [
                            Text(loginWatch.selectedCountry.countryCode,style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),),
                            SizedBox(width: 5.w,),
                            Text("+${loginWatch.selectedCountry.phoneCode}",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),),
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
                         controller: loginWatch.phoneNumberController,
                        onChanged: (value)=>notAllowSpecialChar(loginWatch.phoneNumberController, value),
                        prefixIcon: Icon(Icons.phone,size: 18.sp,color: AppColors.colors.blueColors,),
                        hintText: "9876....",labelText: "Phone Number",)),
                    ],
                ),
                 ),
                CommonButton(
                  backgroundColor: AppColors.colors.blueColors,
                    onPrimary: AppColors.colors.blueDark,
                    btnText: "Login",onPressed: (){
                    loginWatch.loginButton(context);
                },fontSize: 20.sp,txtPadding: EdgeInsets.symmetric(horizontal: 60.w,vertical: 6.h)),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a Member? ",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: Colors.grey),),
                    TextButton(onPressed: (){
                      Navigator.push(context, PageTransition(child: const ChooseRegisterType(), type: PageTransitionType.leftToRight,duration: const Duration(milliseconds: 300)));
                      // Navigator.push(context, MaterialPageRoute(builder: (_)=>const ChooseRegisterType()));
                    }, child: Text("Register Now",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
