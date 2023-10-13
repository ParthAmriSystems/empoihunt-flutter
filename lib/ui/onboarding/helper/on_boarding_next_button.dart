import '../../utils/theme/app_color.dart';
import '../../utils/theme/theme.dart';
import '../controller/on_boarding_controller.dart';

class IntroNextButton extends ConsumerWidget {
  const IntroNextButton({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final introViewWatch = ref.watch(onBoardingController);
    return GestureDetector(
      onTap: (){
        introViewWatch.nextButton(context);
      },
      child: Container(
        height: 60.h,
        width: 60.w,
        alignment:  Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.colors.blueColors..withOpacity(1),
        ),
        child: Container(
          height: 56.h,
          width: 56.w,
          alignment:  Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.colors.clayColors.withOpacity(1),
          ),
          child: const Icon(Icons.arrow_forward_ios,size: 20,color: Colors.white,),
        ),
      ),
    );
  }
}
