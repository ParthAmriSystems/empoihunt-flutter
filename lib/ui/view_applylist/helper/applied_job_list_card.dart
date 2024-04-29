import 'package:emploiflutter/frame_work/controller/home_controller/job_seeker_home_controller/job_seeker_home_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class AppliedJobListCard extends ConsumerWidget {
  final JobPostModel saveJobModel;
  final void Function()? onTap;
  const AppliedJobListCard({super.key, required this.saveJobModel, this.onTap});

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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: AppColors.colors.whiteColors,
                borderRadius: BorderRadius.circular(4.r)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: saveJobModel.vJobTitle!,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            saveJobModel.vJobTitle ?? "",
                            style: TextStyles.w500.copyWith(
                                fontSize: 14.sp, color: AppColors.colors.blackColors),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${saveJobModel.vSalaryPackage} LPA+",
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
                          "${saveJobModel.vExperience} Years",
                          style: TextStyles.w400.copyWith(
                              fontSize: 12.sp, color: AppColors.colors.whiteColors),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: AppColors.colors.clayColors),
                        child: Text(
                          saveJobModel.vEducation!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.w400.copyWith(
                              fontSize: 12.sp, color: AppColors.colors.whiteColors),
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
                    Text(
                      saveJobModel.vCompanyName!,
                      style: TextStyles.w500.copyWith(
                          fontSize: 12.sp, color: AppColors.colors.blackColors),
                    ),
                    Text(
                      "${saveJobModel.iNumberOfVacancy} Vacancy",
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
                          child:saveJobModel.tCompanyLogoUrl !=""?
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
                            "https://api.emploihunt.com${saveJobModel.tCompanyLogoUrl!}",fit: BoxFit.fill,):
                          Image.asset(AppAssets.profilePicPng,fit: BoxFit.fill,)
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "${saveJobModel.user!.vFirstName} ${saveJobModel.user!.vLastName}",
                          style: TextStyles.w400.copyWith(
                              fontSize: 11.sp, color: AppColors.colors.blackColors),
                        ),
                      ],
                    ),
                    Text(
                      saveJobModel.vAddress!,
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
                         saveJobModel.tDes!,
                          maxLines: 1,
                          style: TextStyles.w400
                              .copyWith(fontSize: 10.sp, color: Colors.grey),overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      Text(
                        jobSeekerHomeWatch.getTimeAgo(int.parse(saveJobModel.tCreatedAt!)),
                        style: TextStyles.w400
                            .copyWith(fontSize: 10.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
