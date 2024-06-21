import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../../frame_work/repository/services/shared_pref_services.dart';
import '../../utils/constant/app_constant.dart';

class ProfileUserDetailTile extends ConsumerWidget {
  final UserModel user;
  const ProfileUserDetailTile({super.key,required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return Card(
      color: AppColors.colors.whiteColors,
      elevation: 4,
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(6.r)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.iRole == 0 ?"Job Seeker":"Recruiter",
                  style: TextStyles.w600.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.colors.blueDark),
                ),
                IconButton(onPressed: (){
                  SharedPrefServices.services.getList(locationListKey);
                  profileWatch.taglineToExpertiseList(user);
                  profileWatch.addUserDetailToDialog(user);
                  profileWatch.setDialogValue(2);
                  profileWatch.updateIsDialogShow();
                }, icon: Icon(
                  Icons.edit,
                  color: AppColors.colors.blueColors,
                  size: 18,
                ))
              ],
            ),
            SizedBox(height: 70.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${user.vFirstName} ${user.vLastName}",
                    style: TextStyles.w600.copyWith(
                        fontSize: 22.sp,
                        color: AppColors.colors.blueDark),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  user.vCity,
                  style: TextStyles.w600.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.colors.blueColors),
                )
              ],
            ),
            user.vCurrentCompany != ""?
            Row(
              children: [
                Icon(Icons.home_work_outlined,size: 20.sp,color: AppColors.colors.blueColors,),
                Text(
                  " ${user.vCurrentCompany}",
                  style: TextStyles.w600.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.colors.blueDark),
                )
              ],
            ).paddingOnly(top: 10.h):const SizedBox(),
            Row(
              children: [
                Tooltip(
                  message:user.vMobile,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.colors.greyRegent.withOpacity(0.8),width: 0.5),
                      borderRadius: BorderRadius.circular(6.r)
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  enableFeedback: true,
                  textStyle: TextStyles.w600.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),
                  onTriggered: (){
                    // Future.delayed(const Duration(milliseconds: 700),()async{
                    //   await launchUrl(Uri(
                    //       scheme: 'tel',
                    //       path: user.vMobile
                    //   ));
                    // });
                  },
                  preferBelow: false,
                  child: Card(
                    elevation: 6,
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: AppColors.colors.whiteColors,
                      ),
                      child: Image.asset(AppAssets.phoneIcon,fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Tooltip(
                  message:user.vEmail,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.colors.greyRegent.withOpacity(0.8),width: 0.5),
                      borderRadius: BorderRadius.circular(6.r)
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  enableFeedback: true,
                  textStyle: TextStyles.w600.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),
                  onTriggered: (){
                    // Future.delayed(const Duration(milliseconds: 700),()async{
                    //   launchUrl(Uri(
                    //     scheme: 'mailto',
                    //     path: user.vEmail,
                    //   ));});
                  },
                  preferBelow: false,
                  child: Card(
                    elevation: 6,
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: AppColors.colors.whiteColors,
                      ),
                      child: Image.asset(AppAssets.emailIcon,fit: BoxFit.cover,),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
