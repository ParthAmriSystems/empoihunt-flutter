// ignore_for_file: deprecated_member_use
import 'package:emploiflutter/frame_work/controller/authentication_controller/auth_intro_controller/auth_intro_controller.dart';
import 'package:emploiflutter/frame_work/controller/setting_controller/terms_privacy_policy_controller/terms_privacy_policy_controller.dart';
import 'package:emploiflutter/ui/authentication/login/login.dart';
import 'package:emploiflutter/ui/authentication/register/helper/choose_register_type/choose_register_type.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import '../../frame_work/repository/services/hive_service/box_service.dart';
import '../utils/constant/app_constant.dart';
import '../utils/theme/app_assets.dart';
import '../utils/theme/theme.dart';

class AuthIntro extends ConsumerStatefulWidget {
  const AuthIntro({super.key});

  @override
  ConsumerState<AuthIntro> createState() => _AuthIntroState();
}

class _AuthIntroState extends ConsumerState<AuthIntro> {

  @override
  void initState() {
    final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
    if(user != null){
      print(user.user.vFirstName);
    }else{
      print("no data");
    }
    // TODO: implement initState
    super.initState();
    ///------------- calling Location api and Store in Shared Preference ----------------///
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(authIntroController).getLocationList();
      ref.read(termsPrivacyPolicyController).termsApiRequest();
      ref.read(termsPrivacyPolicyController).privacyPolicyApiRequest();
      // print("AuthIntro Device Details  ${BoxService.boxService.nativeDeviceBox.get(deviceDetailKey)!.deviceVersion}");
    });
    ///----------------------------------------------------------------------------------///

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: AppColors.colors.clayColors,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              ClipPath(
                clipper: CustomCurve(),
                child: Container(
                  height: size.height * 0.56,
                  width: size.width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Image.asset(AppAssets.titleLog,)),
                      SizedBox(height: 8.h,),
                      Expanded(
                          flex: 8,
                          child: Image.asset(AppAssets.welcome,)),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  color: AppColors.colors.clayColors,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 50.h,),
                    CommonButton(btnText: "Login",
                        onPrimary: AppColors.colors.blueDark,
                        backgroundColor: AppColors.colors.blueColors,
                        txtPadding: EdgeInsets.symmetric(horizontal: 120.w,vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r),side: BorderSide(width: 1.5.w,color: AppColors.colors.whiteColors)),
                        onPressed: (){
                          Navigator.push(context, PageTransition(child: const Login(),type: PageTransitionType.scale,duration: const Duration(milliseconds: 600),alignment: Alignment.center));
                        }),
                    SizedBox(height: 15.h,),
                    CommonButton(btnText: "Register",
                        backgroundColor: AppColors.colors.clayColors,
                        txtPadding: EdgeInsets.symmetric(horizontal: 105.w,vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r),side: BorderSide(width: 1.5.w,color: AppColors.colors.whiteColors)),
                        onPressed: (){
                          Navigator.push(context, PageTransition(child: const ChooseRegisterType(),type: PageTransitionType.scale,duration: const Duration(milliseconds: 600),alignment: Alignment.center));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomCurve  extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double w =  size.width;
    double h = size.height;

    final path = Path();

    path.lineTo(0, h); // 2. point
    path.quadraticBezierTo(w * 0.5, h - 100, w, h);
    path.lineTo(w,0); // 5. point
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}