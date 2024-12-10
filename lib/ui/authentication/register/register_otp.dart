import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/choose_user_role_controller/choose_user_role_controller.dart';
import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/register_otp_controller.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_loading.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

class RegisterOTP extends ConsumerStatefulWidget {
  final String phoneNumber;
  const RegisterOTP( {required this.phoneNumber,super.key});

  @override
  ConsumerState<RegisterOTP> createState() => _RegisterOTPState();
}

class _RegisterOTPState extends ConsumerState<RegisterOTP> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      print("Phone number ${widget.phoneNumber}");
      await ref.read(registerOtpController).verifyPhoneNumber(phoneNumber: widget.phoneNumber, context: context, selectedUserType: ref.read(chooseUserRoleController).userRole,childCurrent: widget);
    });
  }
  @override
  Widget build(BuildContext context) {
    final chooseUserRoleWatch = ref.watch(chooseUserRoleController);
    final registerOtpWatch = ref.watch(registerOtpController);
    return CommonLoading(
      show: registerOtpWatch.isLoading,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.h,),
                Image.asset(AppAssets.otpScreenIcon,height: 300.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Enter the Verification Code",style: TextStyles.w500.copyWith(fontSize: 23.sp,color: AppColors.colors.blueColors),),
                    Text("6 - digit verification code sent to",style: TextStyles.w500.copyWith(fontSize: 12.sp,color: Colors.grey),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${widget.phoneNumber}",style: TextStyles.w500.copyWith(fontSize: 12.sp,color: AppColors.colors.clayColors),),
                        Text("Change phone number?",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors,decoration: TextDecoration.underline,decorationColor: AppColors.colors.blueColors),),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 28.h),
                      margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 15.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.colors.clayColors,width: 1.5.w)
                      ),
                      child: Pinput(
                        controller: registerOtpWatch.otpController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.phone,
                        length: 6,
                        onCompleted: (val){
                          registerOtpWatch.verifyOtp(context: context, selectedUserType: chooseUserRoleWatch.userRole,childCurrent: widget);
                        },
                        errorPinTheme: PinTheme(
                            height: 50.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: Colors.red,width: 2.w)
                            )),
                        defaultPinTheme: PinTheme(
                            height: 50.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppColors.colors.clayColors,width: 2.w)
                            )),
                        focusedPinTheme: PinTheme(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppColors.colors.clayColors)
                            )),
                        disabledPinTheme: PinTheme(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppColors.colors.clayColors)
                            )),
                      ),
                    ),
                    SizedBox(height: 15.h,),
                    CommonButton(
                      backgroundColor: AppColors.colors.blueColors,
                      onPrimary: AppColors.colors.blueDark,
                      btnText: "Verify", onPressed: ()async{
                      await registerOtpWatch.verifyOtp(context: context, selectedUserType:chooseUserRoleWatch.userRole ,childCurrent: widget);
                    },txtPadding: EdgeInsets.symmetric(horizontal: 85.w,vertical: 8.h),fontSize: 18.sp,),
                    SizedBox(height: 10.h,),
                    registerOtpWatch.second == 0?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't receive code? ",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),),
                        InkWell(
                            borderRadius: BorderRadius.circular(6.r),
                            onTap: (){
                              registerOtpWatch.resendVerifyPhoneNumber(phoneNumber: widget.phoneNumber, context: context, selectedUserType: ref.read(chooseUserRoleController).userRole,childCurrent: widget);                          },
                            child: Text("Resend Code",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),))
                      ],
                    ):
                    Text("Resend OTP in ${registerOtpWatch.second} second",style: TextStyles.w500.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),)

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
