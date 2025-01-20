import '../../utils/theme/app_color.dart';
import '../../utils/theme/theme.dart';
import '../controller/on_boarding_controller.dart';

class IntroNextButton extends ConsumerWidget {
  final OnBoardingEnum onBoarding;
  const IntroNextButton( {super.key,required this.onBoarding});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final introViewWatch = ref.watch(onBoardingController);
    return GestureDetector(
      onTap: (){
        if(onBoarding == OnBoardingEnum.onboarding){
          introViewWatch.nextButton(context);
        }else if(onBoarding == OnBoardingEnum.jobSeeker){
          introViewWatch.jobSeekerNextButton(context);
        }else if(onBoarding == OnBoardingEnum.recruiter){
          introViewWatch.recruiterNextButton(context);
        }
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

enum OnBoardingEnum{
  onboarding,jobSeeker,recruiter
}