import 'package:cached_network_image/cached_network_image.dart';
import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:lottie/lottie.dart';

class UserBannerImageDialogBox extends ConsumerStatefulWidget {
  final UserDetailDataModel userDetailDataModel;
  const UserBannerImageDialogBox({required this.userDetailDataModel,super.key});

  @override
  ConsumerState<UserBannerImageDialogBox> createState() => _UserBannerImageDialogBoxState();
}

class _UserBannerImageDialogBoxState extends ConsumerState<UserBannerImageDialogBox>  with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    ref.read(profileController).uploadBannerLottieController = AnimationController(vsync: this,duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    ref.read(profileController).uploadBannerLottieController.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context,) {
    final profileWatch = ref.watch(profileController);
    return SafeArea(
      child: Container(
        width: 340.w,
        height: 300.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom> 0? 230 : 0),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(4.r)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Change Banner Image",style: TextStyles.w500.copyWith(fontSize: 22.sp,color: AppColors.colors.blueColors),).paddingVertical(10.h),
            Expanded(
              child: Stack(
                children: [
                  ///------------- Banner --------------///
                  Container(
                    height: 130.h,
                    width:  double.infinity.w,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border:profileWatch.isBannerAnimationRun? Border.all(color: AppColors.colors.blueDark,width: 5.w):null,
                      borderRadius: BorderRadius.circular(4.r)
                    ),
                    child:
                    profileWatch.isBannerAnimationRun?
                     Center(child: Lottie.asset(AppAssets.bannerLoadingLottie),) :
                   profileWatch.bannerImg != null? Image.file(profileWatch.bannerImg!,fit: BoxFit.fitWidth,): widget.userDetailDataModel.user.tProfileBannerUrl !=""?
                   CachedNetworkImage(imageUrl: "https://api.emploihunt.com${widget.userDetailDataModel.user.tProfileBannerUrl}",
                       placeholder: (context, url) => const CircularProgressIndicator(),
                       errorWidget: (context, url, error) => Image.asset(AppAssets.defaultBannerImage,fit: BoxFit.fitWidth,),fit: BoxFit.fitWidth)
                        : Image.asset(AppAssets.defaultBannerImage,fit: BoxFit.fitWidth,),
                  ),
                  ///---------- Image Picker Icon --------///
                  profileWatch.isBannerAnimationRun? SizedBox():Positioned(
                    left: 130.w,
                    bottom: 0,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: AppColors.colors.clayColors,width: 5.w)
                      ),
                      child: IconButton(onPressed: (){
                                profileWatch.pickBannerImg();
                      },icon: Image.asset(AppAssets.uploadImgIcon,height: 50.h,),),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(onPressed: (){
                  profileWatch.updateIsDialogShow();
                }, child: Text("CANCEL",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
                SizedBox(width: 10.w,),
                TextButton(onPressed: (){
                  profileWatch.updateIsDialogShow();
                  profileWatch.bannerImgName!=""?
                  profileWatch.bannerImgApiCall(profileWatch.bannerImgName, profileWatch.bannerImgUrl!,widget.userDetailDataModel):null;
                }, child: Text("Done",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)),
              ],
            ).paddingOnly(top: 10.h,)
          ],
        ),
      ),
    );
  }
}
