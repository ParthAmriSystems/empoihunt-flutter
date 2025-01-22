import 'dart:ui';

import 'package:emploiflutter/frame_work/controller/home_controller/job_seeker_home_controller/job_seeker_home_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecruiterListCard extends ConsumerWidget {
  final JobPostModel jobPostModel;
  final void Function()? onTap;
  const RecruiterListCard({super.key, required this.jobPostModel, this.onTap});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final jobSeekerHomeWatch = ref.watch(jobSeekerHomeController);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.only(bottom: 10.h),
        child: Card(
          elevation: 7,
          color: Colors.grey,
          child: Container(
            width: size.width * 0.96,
            decoration: BoxDecoration(
                color:AppColors.colors.whiteColors,
                borderRadius: BorderRadius.circular(4.r)),
            child: Column(
              children: [
                /// Cart Tile Details
               
               
               
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: BackdropFilter(
                    filter: jobPostModel.iStatus == 2
                        ? ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0)
                        : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                    child: Opacity(
                      opacity: jobPostModel.iStatus == 2 ? 0.3 : 1.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Hero(
                                    tag: jobPostModel.tCompanyLogoUrl!,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        jobPostModel.vJobTitle ?? "",
                                        style: TextStyles.w500.copyWith(
                                            fontSize: 14.sp, color: AppColors.colors.blackColors),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${jobPostModel.vSalaryPackage} LPA+",
                                  style: TextStyles.w500.copyWith(
                                      fontSize: 14.sp, color: AppColors.colors.blackColors),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              children: [
                                Card(
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.r),
                                        color: AppColors.colors.clayColors),
                                    child: Text(
                                      "${jobPostModel.vExperience} Years Ex.",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.w400.copyWith(
                                          fontSize: 12.sp, color: AppColors.colors.whiteColors),
                                    ),
                                  ),
                                ),
                                Expanded(child: Card(child: Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      color: AppColors.colors.clayColors),
                                  child: Text(
                                    jobPostModel.vEducation!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.w400.copyWith(
                                        fontSize: 12.sp, color: AppColors.colors.whiteColors),
                                  ),
                                ),
                                ),
                                ),
                                const Expanded(child: SizedBox())
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text(
                                //   jobPostModel.vCompanyName!,
                                //   style: TextStyles.w500.copyWith(
                                //       fontSize: 12.sp, color: AppColors.colors.blackColors),
                                // ),
                                Expanded(
                                  child: Text(
                                    jobPostModel.tTechnicalSkill!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.w500.copyWith(
                                        fontSize: 12.sp, color: AppColors.colors.blackColors),
                                  ),
                                ),
                                SizedBox(width: 5.w,),
                                Text(
                                  "${jobPostModel.iNumberOfVacancy} Vacancy",
                                  style: TextStyles.w500.copyWith(
                                      fontSize: 12.sp, color: AppColors.colors.blackColors),
                                ),
                              ],
                            ),
                            SizedBox(height: 10..h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 28.h,
                                        width: 28.w,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle
                                        ),
                                        child:jobPostModel.tCompanyLogoUrl !=""?
                                        Image.network(
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                            return const Center(
                                              child: Text('Error loading image'),
                                            );
                                          },
                                          "https://api.emploihunt.com${jobPostModel.tCompanyLogoUrl!}",fit: BoxFit.cover,):
                                        Image.asset(AppAssets.profilePicPng,fit: BoxFit.contain,)
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "${jobPostModel.vCompanyName!}",
                                      // "${jobPostModel.user!.vFirstName} ${jobPostModel.user!.vLastName}",
                                      style: TextStyles.w400.copyWith(
                                          fontSize: 12.sp, color: AppColors.colors.blackColors),
                                    ),
                                  ],
                                ),
                                Text(
                                  jobPostModel.vAddress!,
                                  style: TextStyles.w400
                                      .copyWith(fontSize: 11.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Divider(
                              height: 4.h,
                              color: AppColors.colors.blueColors,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12.h,bottom: 18.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      jobPostModel.tDes!,
                                      maxLines: 1,
                                      style: TextStyles.w400
                                          .copyWith(fontSize: 10.sp, color: Colors.grey),overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  Text(
                                    jobSeekerHomeWatch.getTimeAgo(int.parse(jobPostModel.tCreatedAt!)),
                                    style: TextStyles.w400
                                        .copyWith(fontSize: 10.sp, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// For not available ///
                jobPostModel.iStatus == 2?
                Card(
                  child: Container(
                    width: size.width,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: AppColors.colors.greyRegent),
                    child: Text(
                      "Post is not available",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.w400.copyWith(
                          fontSize: 14.sp, color: AppColors.colors.whiteColors),
                    ),
                  ),
                ):SizedBox(),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: Duration(milliseconds: 600));
  }
}
