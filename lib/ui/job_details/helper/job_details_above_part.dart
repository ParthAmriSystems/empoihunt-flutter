// ignore_for_file: deprecated_member_use
import 'package:emploiflutter/frame_work/controller/job_details_controller/job_details_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class JobDetailsAbovePart extends ConsumerWidget {
  final JobPostModel jobPostModel;

  const JobDetailsAbovePart({required this.jobPostModel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDetailsWatch = ref.watch(jobDetailsController);
    return Column(
      children: [
        Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            color: AppColors.colors.whiteColors,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                jobDetailsWatch.offset <= 0
                    ? Hero(
                        tag: jobPostModel.vJobTitle!,
                        child: Material(
                            color: Colors.transparent,
                            child: Text(
                              jobPostModel.vJobTitle!,
                              style: TextStyles.w500.copyWith(
                                  fontSize: 27.sp,
                                  color: AppColors.colors.blueColors),
                            ))).paddingOnly(bottom: 5.h)
                    : const SizedBox(),
                Row(
                  children: [
                    SizedBox(
                      height: 45.h,
                      width: 70.w,
                      child: jobPostModel.tCompanyLogoUrl != ""
                          ? Image.network(
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return const Center(
                                  child: Text('Error loading image'),
                                );
                              },
                              "https://api.emploihunt.com${jobPostModel.tCompanyLogoUrl!}",
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              AppAssets.appLogo,
                              fit: BoxFit.fill,
                            ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobPostModel.vCompanyName!,
                            style: TextStyles.w500.copyWith(
                                fontSize: 21.sp,
                                color: AppColors.colors.blackColors),
                          ),
                          Text(
                            jobPostModel.vAddress!,
                            style: TextStyles.w500.copyWith(
                                fontSize: 12.sp,
                                color: AppColors.colors.blackColors),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "21 hours ago • ",
                      style: TextStyles.w400.copyWith(
                          fontSize: 14.sp, color: AppColors.colors.blueColors),
                    ),
                    Text(
                      "${jobPostModel.iNumberOfApplied} Applications",
                      style: TextStyles.w400.copyWith(
                          fontSize: 12.sp, color: AppColors.colors.greyRegent),
                    ),
                  ],
                ).paddingVertical(10.h),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(AppAssets.workingModeSvg,
                              color: AppColors.colors.blueColors),
                          // Icon(Icons.shopping_bag_outlined,color: AppColors.colors.blueColors,size: 20.sp,),
                          Text(
                            jobPostModel.vWrokingMode!,
                            style: TextStyles.w400.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.colors.blackColors),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Salary - ${jobPostModel.vSalaryPackage} Lakh LPA",
                        style: TextStyles.w400.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.colors.blackColors),
                        softWrap: true,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            color: AppColors.colors.whiteColors,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppAssets.bioGraphSvg,
                        color: AppColors.colors.blueColors),
                    // Icon(Icons.file_copy_rounded,color: AppColors.colors.blueColors,size: 20,),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text("Job Description",
                        style: TextStyles.w500.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.colors.blackColors))
                  ],
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width.w,
                    child: Text(jobPostModel.tDes!,
                        softWrap: true,
                        style: TextStyles.w400.copyWith(
                            fontSize: 10.sp,
                            color: AppColors.colors.greyRegent)))
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            color: AppColors.colors.whiteColors,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.bioGraphSvg,
                      color: AppColors.colors.blueColors,
                    ),
                    // Icon(Icons.file_copy_rounded,color: AppColors.colors.blueColors,size: 20.sp,),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text("Role & Responsibility",
                        style: TextStyles.w500.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.colors.blackColors))
                  ],
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width.w,
                    child: Text(jobPostModel.vJobRoleResponsbility!,
                        softWrap: true,
                        style: TextStyles.w400.copyWith(
                            fontSize: 10.sp,
                            color: AppColors.colors.greyRegent)))
              ],
            ),
          ),
        )
      ],
    );
  }
}
