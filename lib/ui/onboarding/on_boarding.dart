
import 'package:avatar_glow/avatar_glow.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../utils/theme/app_assets.dart';
import '../utils/theme/app_color.dart';
import '../utils/theme/theme.dart';
import 'controller/on_boarding_controller.dart';
import 'helper/intro_appbar.dart';
import 'helper/on_boarding_next_button.dart';
import 'helper/pages/intro_pages.dart';

class OnBoarding extends ConsumerStatefulWidget {
  const OnBoarding({super.key});

  @override
  ConsumerState<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends ConsumerState<OnBoarding> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      await SharedPrefServices.services.setBool(onBoardingKey, true);
    });

  }
  @override
  Widget build(BuildContext context,) {
    final introViewWatch = ref.watch(onBoardingController);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.colors.blueColors,
      appBar: const IntroAppbar(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment:  Alignment.center,
                height: 620.h,
                width:  size.width.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.r),bottomLeft: Radius.circular(50.r))
                ),
                child: PageView(
                  controller: introViewWatch.pageController,
                  onPageChanged: (val){
                    introViewWatch.onPageChange(val);
                    SharedPrefServices.services.setBool(onBoardingKey, true);
                  },
                  children:  [
                    IntroPageView(model: (img: AppAssets.image1,title: "Welcome to EmploiHunt",subtile: "Discover your ideal job here"),imgEffects: [ScaleEffect(duration: Duration(milliseconds: 700),),SlideEffect()],),
                        // .animate().slideY(),
                    IntroPageView(model: (img: AppAssets.image2,title: "Recruit best employee",subtile: "Employ the best talent more quickly with Emploihunt"),imgEffects: [SlideEffect(begin: Offset(-1.0,0.0),end: Offset(0.0,0.0),duration: Duration(milliseconds: 700))]),
                    IntroPageView(model: (img: AppAssets.image3,title: "Get your Best Job Here",subtile: "Discover your ideal job here"),imgEffects: [ScaleEffect(duration: Duration(milliseconds: 700))],),
                    IntroPageView(model: (img: AppAssets.image4,title: "Campus Placement",subtile: "Emploihunt can help you find your ideal job on campus"),imgEffects: [ShimmerEffect(duration: Duration(milliseconds: 1000))],),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 52.h,
            left: 143.w,
            child: AvatarGlow(
                animate: true,
                repeat: true,
                curve: Curves.fastOutSlowIn,
                glowColor: AppColors.colors.clayColors,
                startDelay: Duration(milliseconds: 200),
                endRadius: 50.r,child: const IntroNextButton().animate().scale(duration: Duration(milliseconds: 500))),),

        ],
      ),
    );
  }
}
