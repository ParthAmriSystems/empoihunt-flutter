import 'package:emploiflutter/frame_work/controller/splash_controller/splash_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import '../utils/theme/app_assets.dart';


class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
     await ref.read(splashController).getSplashData(context);
     await ref.read(splashController).getDeviceDetails();
     // await ref.read(splashController).getAppVersion();
    });
    SharedPrefServices.services.setBool(chatBalloonIsFirstTime, true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset(AppAssets.appLogo,)),
    );
  }
}
