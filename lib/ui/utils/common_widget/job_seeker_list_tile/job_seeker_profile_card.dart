import 'package:cached_network_image/cached_network_image.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_with_device_token_model.dart';
import 'package:shimmer/shimmer.dart';

class JobSeekerProfileCard extends StatelessWidget {
  final UserWithDeviceTokenModel user;
  const JobSeekerProfileCard({required this.user,super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 170.h,
          width: 8.w,
          color: AppColors.colors.clayColors,
        ),
        Card(
          elevation: 5,
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration:  BoxDecoration(
                color: AppColors.colors.whiteColors,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.black12,width: 0.5)
            ),
            height: 174.h,
            width: 112.w,
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                Container(
                  height: 80.h,
                  width: 80.w,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: CachedNetworkImage(imageUrl: "https://api.emploihunt.com${user.tProfileUrl}",
                    placeholder: (context, url) =>Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child:Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.5),
                              shape: BoxShape.circle
                          ),
                        )),
                    errorWidget: (context, url, error) => Image.asset(AppAssets.profilePicPng,fit: BoxFit.fill,),fit: BoxFit.cover,),
                ),
                SizedBox(height: 15.h,),
                Text("${user.vFirstName} ${user.vLastName}",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: AppColors.colors.blueColors),softWrap: true,)
              ],
            ),
          ),
        )
      ],
    );

  }
}


class RecruiterProfileCardShimmer extends StatelessWidget {
  const RecruiterProfileCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 170.h,
          width: 8.w,
          color: AppColors.colors.clayColors,
        ),
        Card(
          elevation: 5,
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration:  BoxDecoration(
                color: AppColors.colors.whiteColors,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.black12,width: 0.5)
            ),
            height: 174.h,
            width: 112.w,
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                child:Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.5),
                      shape: BoxShape.circle
                  ),
                )),
                SizedBox(height: 15.h,),
                Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Container(
                    height: 16.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.3),
                        borderRadius: BorderRadius.circular(8.r)
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
