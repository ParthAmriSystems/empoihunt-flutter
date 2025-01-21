import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

class JobDetailsBottomSheet extends ConsumerStatefulWidget{
  final String companyName;
  const JobDetailsBottomSheet({required this.companyName,super.key});
  @override
  ConsumerState<JobDetailsBottomSheet> createState() => _SettingBottomSheetState();
}

class _SettingBottomSheetState extends ConsumerState<JobDetailsBottomSheet> with SingleTickerProviderStateMixin {

  late AnimationController logoutController;

  @override
  void initState() {
    super.initState();
    logoutController = AnimationController(vsync: this,duration: const Duration(seconds: 2));
    // logoutController.repeat();
  }
  @override
  void deactivate() {
    super.deactivate();
    logoutController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Thank you dear Candidate. Please wait ${widget.companyName} HR will contact soon",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors),),
          Expanded(
            child: Align(
              alignment: Alignment.center,
                child: Lottie.asset(
                  controller: logoutController,
                  AppAssets.applyLottie,
                  height: 140.h,
                  onLoaded: (_){
                    logoutController.repeat();
                  },
                  fit: BoxFit.fill,)),
          ),
          Align(
            alignment: Alignment.center,
            child: CommonButton(btnText: "No", onPressed: (){
              context.pop();
            },backgroundColor: AppColors.colors.whiteColors,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r),side: BorderSide(color: AppColors.colors.blueColors)),textColor: AppColors.colors.blueColors,fontSize: 16.sp,txtPadding: EdgeInsets.symmetric(horizontal: 50.w,vertical: 3.h),onPrimary: Colors.grey,).paddingOnly(bottom: 8.h),
          )
        ],
      ),
    );
  }
}
