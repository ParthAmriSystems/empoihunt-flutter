// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

class JobDetailsBelowPart extends StatelessWidget {
  final JobPostModel jobPostModel;
  const JobDetailsBelowPart({required this.jobPostModel,super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            color: AppColors.colors.whiteColors,
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 14.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(color: AppColors.colors.blueColors,AppAssets.skillsSvg),
                    // Icon(Icons.file_copy_rounded,color: AppColors.colors.blueColors,size: 20,),
                    SizedBox(width: 5.w,),
                    Text("Skills",style: TextStyles.w500.copyWith(fontSize: 18.sp,color: AppColors.colors.blackColors))
                  ],
                ),
                Text("Techinical Skills",style: TextStyles.w500.copyWith(fontSize: 16.sp,color: AppColors.colors.blueColors),),
                Text(jobPostModel.tTechnicalSkill!,style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors),),
                Text("Soft Skills",style: TextStyles.w500.copyWith(fontSize: 16.sp,color: AppColors.colors.blueColors),),
                Text(jobPostModel.tSoftSkill!,style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors),),
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            color: AppColors.colors.whiteColors,
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 14.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppAssets.qualificationSvg,color: AppColors.colors.blueColors),
                    SizedBox(width: 5.w,),
                    Text("Qualification",style: TextStyles.w500.copyWith(fontSize: 18.sp,color: AppColors.colors.blackColors))
                  ],
                ),
                RichText(text:TextSpan(
                  text: "Experience - ",
                  style: TextStyles.w400.copyWith(fontSize: 16.sp,color: AppColors.colors.blueColors),
                  children: [
                    TextSpan(
                      text: "${jobPostModel.vExperience}+ Years",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors)
                    )
                  ]
                ) ),
                RichText(text:TextSpan(
                    text: "Education - ",
                    style: TextStyles.w400.copyWith(fontSize: 16.sp,color: AppColors.colors.blueColors),
                    children: [
                      TextSpan(
                          text: jobPostModel.vEducation!,style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors)
                      )
                    ]
                ) )

              ],
            ),
          ),
        )

      ],
    );
  }
}
