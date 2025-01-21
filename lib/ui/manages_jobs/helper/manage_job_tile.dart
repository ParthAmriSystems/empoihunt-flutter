import 'package:emploiflutter/frame_work/controller/manage_job_post_controller/manage_job_post_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/ui/update_post/update_post.dart';
import 'package:emploiflutter/ui/utils/common_widget/helper.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

class ManageJobTile extends ConsumerWidget {
  final JobPostModel jobPost;
  const ManageJobTile({super.key,required this.jobPost});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manageJobPostWatch = ref.watch(manageJobPostController);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.h,bottom: 5.h),
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: AppColors.colors.blueColors,width: 1.5),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              jobPost.iStatus == 2?
              Text("Disabled Post !",style: TextStyles.w800.copyWith(
                fontSize: 25.sp,color: AppColors.colors.greyRegent
              ),):SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(jobPost.vJobTitle??"",style: TextStyles.w500.copyWith(fontSize: 16.sp,color: AppColors.colors.blueColors),)),
                  Text("${jobPost.vSalaryPackage} LPA +",style: TextStyles.w500.copyWith(fontSize: 16.sp,color: AppColors.colors.clayColors),)
                ],
              ),
              SizedBox(height: 10.h,),

              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Card(
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.colors.clayColors),
                      child: Text(
                        "${jobPost.vExperience} Years",
                        style: TextStyles.w400.copyWith(
                            fontSize: 14.sp, color: AppColors.colors.whiteColors),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.colors.clayColors),
                      child: Text(
                        jobPost.vEducation??"",
                        style: TextStyles.w400.copyWith(
                            fontSize: 14.sp, color: AppColors.colors.whiteColors),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),

              Row(
                children: [
                  Text("${jobPost.vCompanyName} • ",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),),
                  SizedBox(width: 8.w,),
                  Text("${jobPost.iNumberOfVacancy} Vacancy",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),)
                ],
              ),
              SizedBox(height: 8.h,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(jobPost.vAddress??"",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.greyRegent),),
                  Text(manageJobPostWatch.getTimeAgo(int.parse(jobPost.tCreatedAt!)),style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.greyRegent),)
                ],
              )
            ],
          ).paddingSymmetric(vertical: 17.h,horizontal: 10.w),
        ),
        ///------------------ edit and delete Icons ----------///
        Positioned(
          top: 0,
          right: 5.w,
          child: Row(
            children: [
              SizedBox(
                height: 40.h,
                child: FittedBox(
                  child: IconButton(onPressed:
                  jobPost.iStatus == 2? ()=>appCommonShowToast(context: context, msg: "Post is Disabled"):
                      (){
                    manageJobPostWatch.addJobDetailToField(jobPost);
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> UpdatePost(jobPostModel: jobPost,)));
                  }, icon: Icon(Icons.edit,color:
                  jobPost.iStatus == 2? AppColors.colors.greyRegent:
                  AppColors.colors.whiteColors,size: 20.sp,),style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(3.sp),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r),side: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      elevation: 8,
                      backgroundColor: AppColors.colors.blueColors
                  ),),
                ),
              ),
              SizedBox(
                height: 40.h,
                child: FittedBox(
                  child: IconButton(onPressed:
                  jobPost.iStatus == 2? ()=>appCommonShowToast(context: context, msg: "Post is Disabled"):
                      (){
                    manageJobPostWatch.deleteJobAPi(jobPost.id!, context);
                  }, icon: Icon(Icons.delete,color:
                  jobPost.iStatus == 2? AppColors.colors.greyRegent:
                  AppColors.colors.whiteColors,size: 20.sp,),style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(3.sp),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r),side: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      elevation: 8,
                      backgroundColor: AppColors.colors.blueColors
                  ),),
                ),
              ),
              jobPost.iStatus != 2?
              Container(
                padding: EdgeInsets.only(left: 15.w),
                height: 35.h,
                child: FittedBox(
                  child: ElevatedButton(onPressed: (){
                    manageJobPostWatch.disableJobAPi(jobPost.id!, context);
                  }, child: Text("  Disable  ",style: TextStyles.w400.copyWith(
                    fontSize: 12.sp,color: AppColors.colors.whiteColors
                  ),),style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(6.sp),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r),side: BorderSide(color: Colors.grey.withOpacity(0.3))),
                      elevation: 8,
                      backgroundColor: AppColors.colors.blueColors
                  ),),
                ),
              ):SizedBox()
            ],
          ),
        )
      ],
    );
  }
}
