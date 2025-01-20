import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import '../utils/theme/theme.dart';
import 'controller/on_boarding_controller.dart';
import 'helper/intro_appbar.dart';
import 'helper/on_boarding_next_button.dart';
import 'helper/pages/intro_pages.dart';

class OnBoardingJobSeeker extends ConsumerStatefulWidget {
  const OnBoardingJobSeeker({super.key});

  @override
  ConsumerState<OnBoardingJobSeeker> createState() => _OnBoardingJobSeekerState();
}

class _OnBoardingJobSeekerState extends ConsumerState<OnBoardingJobSeeker> {
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

    final double fabGlowRadius = 88.r;
    final double fabCenterOffset = fabGlowRadius;
    return Scaffold(
      backgroundColor: AppColors.colors.blueColors,
      appBar: const IntroAppbar(onBoarding: OnBoardingEnum.jobSeeker),
      floatingActionButton: AvatarGlow(
        animate: true,
        repeat: true,
        curve: Curves.fastOutSlowIn,
        glowColor: AppColors.colors.clayColors,
        startDelay: const Duration(milliseconds: 200),
        endRadius: fabGlowRadius,
        child: const IntroNextButton(onBoarding: OnBoardingEnum.jobSeeker,).animate().scale(duration: Duration(milliseconds: 500)),
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
                  controller: introViewWatch.jobSeekerPageController,
                  onPageChanged: (val) {
                    introViewWatch.onPageChange(val);
                  },
                  children: [
                    IntroLottiePageView(
                      model: (filePath: AppAssets.onBoardingSearchingLottie, title: "Smart Job Search Made Easy", subtile: "Searching for jobs is now easier than ever! Use advanced filters and voice search to discover the perfect opportunities effortlessly."),
                      imgEffects: [
                        ScaleEffect(
                          duration: Duration(milliseconds: 450),
                        ),
                      ],
                    ),
                    IntroLottiePageView(
                      width: 380.w,
                      model: (filePath: AppAssets.onBoardingApplyingLottie, title: "Jobs That Fits you", subtile: "Say goodbye to irrelevant listings! Browse through job recommendations tailored to your skills and experience"),
                      imgEffects: [
                        SlideEffect(
                          begin: Offset(-1.0, 0.0),
                          end: Offset(0.0, 0.0),
                          duration: Duration(milliseconds: 500),
                        )
                      ],
                    ),
                    IntroLottiePageView(
                      width: 350.w,
                      model: (filePath: AppAssets.onBoardingChattingLottie, title: "Connect Directly with Recruiters", subtile: "No more waiting endlessly for responses. Our in-app chat feature allows you to contact recruiters directly, ensuring quick communication and personalized interaction."),
                      imgEffects: [
                        ScaleEffect(
                          duration: Duration(milliseconds: 700),
                        )
                      ],
                    ),
                    IntroLottiePageView(
                      width: 420.w,
                      model: (filePath: AppAssets.onBoardingAILottie, title: "AI-Driven Interview Preparation", subtile: "AI-Powered Preparation for Interview Success!"),
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
