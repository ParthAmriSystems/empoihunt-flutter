import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/register_controller.dart';
import 'package:emploiflutter/ui/authentication/register/helper/register_background.dart';
import 'package:flutter/services.dart';
import '../../utils/theme/theme.dart';

class Register extends ConsumerWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: AppColors.colors.clayColors,
    ));
    return  PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        ref.read(registerController).clearForms();
      },
      child: Scaffold(
        backgroundColor:  Colors.white,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  RegisterBackGround()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
