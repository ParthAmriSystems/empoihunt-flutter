import 'package:avatar_glow/avatar_glow.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../utils/theme/app_assets.dart';
import 'controller/on_boarding_controller.dart';
import 'helper/intro_appbar.dart';
import 'helper/on_boarding_next_button.dart';
import 'helper/pages/intro_pages.dart';

class OnBoardingRecruiter extends ConsumerStatefulWidget {
  const OnBoardingRecruiter({super.key});

  @override
  ConsumerState createState() => _OnBoardingRecruiterState();
}

class _OnBoardingRecruiterState extends ConsumerState<OnBoardingRecruiter> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => buildMobileLayout(context),
      tablet: (BuildContext context) => buildTabletLayout(context),
      desktop: (BuildContext context) => buildDesktopLayout(context),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return buildLayout(context);
  }
  Widget buildTabletLayout(BuildContext context) {
    return buildLayout(context);
  }
  Widget buildDesktopLayout(BuildContext context) {
    return buildLayout(context);
  }

  Widget buildLayout(BuildContext context) {
    final introViewWatch = ref.watch(onBoardingController);
    final size = MediaQuery.of(context).size;

    final double fabGlowRadius = 85.r;
    final double fabCenterOffset = fabGlowRadius;

    return Scaffold(
      backgroundColor: AppColors.colors.blueColors,
      appBar: const IntroAppbar(onBoarding: OnBoardingEnum.recruiter),
      floatingActionButton: AvatarGlow(
        animate: true,
        repeat: true,
        curve: Curves.fastOutSlowIn,
        glowColor: AppColors.colors.clayColors,
        startDelay: const Duration(milliseconds: 200),
        endRadius: fabGlowRadius,
        child: const IntroNextButton(onBoarding: OnBoardingEnum.recruiter,).animate().scale(duration: Duration(milliseconds: 500)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableHeight = constraints.maxHeight;
          final double containerHeight = availableHeight - fabCenterOffset - 9.5;
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: containerHeight,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.r),
                    bottomLeft: Radius.circular(50.r),
                  ),
                ),
                child: PageView(
                  controller: introViewWatch.recruiterPageController,
                  onPageChanged: (val) {
                    introViewWatch.onPageChange(val);
                  },
                  children: [
                    IntroLottiePageView(
                      model: (filePath: AppAssets.onBoardingSearchingLottie, title: "Find Top Talent Instantly", subtile: "Find the best candidates effortlessly by using advanced filters or with the convenient voice search feature"),
                      imgEffects: [
                        ScaleEffect(
                          duration: Duration(milliseconds: 450),
                        ),
                      ],
                    ),
                    IntroLottiePageView(
                      width: 380.w,
                      model: (filePath: AppAssets.onBoardingChattingLottie, title: "Connect Instantly via Chat", subtile: " Communicate directly with candidates in real-time to streamline the hiring process."),
                      imgEffects: [
                        SlideEffect(
                          begin: Offset(-1.0, 0.0),
                          end: Offset(0.0, 0.0),
                          duration: Duration(milliseconds: 500),
                        )
                      ],
                    ),
                    IntroLottiePageView(
                      width: 420.w,
                      model: (filePath: AppAssets.onBoardingAILottie, title: "Post Jobs and Review Applicants", subtile: " Create job posts, view profiles of applied candidates, and hire the perfect match for your company’s needs."),
                      imgEffects: [
                        ShimmerEffect(
                          duration: Duration(milliseconds: 1000),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
