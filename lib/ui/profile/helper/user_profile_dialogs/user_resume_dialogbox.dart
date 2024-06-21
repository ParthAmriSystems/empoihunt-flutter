import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:lottie/lottie.dart';

import '../../../../frame_work/repository/model/user_model/user_detail_data_model.dart';
import '../../../utils/common_service/helper.dart';

class UserResumeDialogBox extends ConsumerStatefulWidget {
  final UserDetailDataModel userDetailDataModel;
  const UserResumeDialogBox({super.key,required this.userDetailDataModel});

  @override
  ConsumerState<UserResumeDialogBox> createState() => _UserResumeDialogBoxState();
}

class _UserResumeDialogBoxState extends ConsumerState<UserResumeDialogBox> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    ref.read(profileController).resumeLottieController = AnimationController(vsync: this,duration: const Duration(seconds: 2));
    super.initState();
  }
  @override
  void deactivate() {
    super.deactivate();
    ref.read(profileController).resumeLottieController.dispose();
  }

  @override
  Widget build(BuildContext context,) {
    final profileWatch = ref.watch(profileController);
    return SafeArea(
      child: Container(
        width: 340.w,
        height:profileWatch.resumeName !="" ? 480.h : 380.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(4.r)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Change Info",style: TextStyles.w600.copyWith(fontSize: 22.sp,color: AppColors.colors.blueColors),).paddingVertical(10.h),
             Expanded(
              child:Column(
                children: [
                  GestureDetector(
                    onTap:(){
                      profileWatch.pickResumeFile();
                    },
                    child: Lottie.asset(
                      height: 200.h,
                      width:200.w,
                      AppAssets.resumeLottie,
                      controller: profileWatch.resumeLottieController,
                    ),
                  ),
                  Text("Upload your resume",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),)
                ],
              ).paddingOnly(left: 60.w),
            ),
            profileWatch.resumeName !="" ?
            Text(profileWatch.resumeName,style: TextStyles.w600.copyWith(fontSize: 20.sp,color: AppColors.colors.blueColors),softWrap: true,overflow: TextOverflow.ellipsis,):const SizedBox(),
            profileWatch.resumeUploading?
            Text("Wait your video is uploading...",style: TextStyles.w600.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors)).paddingVertical(8.h):
            Row(
              children: [
                const Spacer(),
                TextButton(onPressed: (){
                  profileWatch.updateIsDialogShow();
                }, child: Text("CANCEL",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                SizedBox(width: 10.w,),
                TextButton(onPressed: (){
                  if(profileWatch.resumeName != "" && profileWatch.resumeUrl != null){
                    if(!profileWatch.resumeUploading){kPrint(profileWatch.resumeName);
                      profileWatch.resumeApiCall(profileWatch.resumeName, profileWatch.resumeUrl!,widget.userDetailDataModel,context);
                    }
                  }else{
                    profileWatch.updateIsDialogShow();
                  }
                }, child: Text("Done",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
              ],
            ).paddingOnly(top: 10.h,)
          ],
        ),
      ),
    );
  }
}