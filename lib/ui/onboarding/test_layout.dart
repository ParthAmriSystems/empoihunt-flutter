import 'package:avatar_glow/avatar_glow.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'helper/intro_appbar.dart';
import 'helper/on_boarding_next_button.dart';

class TestLayout extends StatelessWidget {
  const TestLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double fabGlowRadius = 85.r;
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
        child: const IntroNextButton(onBoarding: OnBoardingEnum.jobSeeker)
            .animate()
            .scale(duration: const Duration(milliseconds: 500)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableHeight = constraints.maxHeight;
          final double containerHeight = availableHeight - fabCenterOffset;
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
                child: const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }
}
