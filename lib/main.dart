import 'package:emploiflutter/frame_work/repository/model/splash/native_device_model/native_device_model.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_model.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/splash/splash.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'firebase_options.dart';
import 'frame_work/repository/services/hive_service/hive_adapter.dart';


Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ///--------- initialize Share preference --------///
  await SharedPrefServices.services.init();

  /// ------- Hive open Box Service ---------///
  registerHiveAdapters();
  await Hive.initFlutter();
  BoxService.boxService.nativeDeviceBox = await Hive.openBox<NativeDeviceDetailModel>(nativeDeviceDetailsBox);
  BoxService.boxService.userGetDetailBox = await Hive.openBox<UserGetDetailModel>(userDetailsBox);
  runApp(const ProviderScope(child: MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.colors.clayColors,
    ));
    return  ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colors.blueColors),
        ),
        home: const Splash(),
      ),
    );
  }
}
