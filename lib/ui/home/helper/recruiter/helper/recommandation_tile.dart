import 'package:emploiflutter/frame_work/repository/model/recommendation_model/recommendatio_model.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommandationTile extends StatelessWidget {
  final List<RecommendationModel> recommendationList;
  const RecommandationTile({super.key, required this.recommendationList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommendation", style: TextStyles.w600.copyWith(fontSize: 16.sp, color: AppColors.colors.blueColors),),
        SizedBox(height: 10.h,),
        Container(
          height: 190.h,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: recommendationList.length,
            itemBuilder: (context, index) {
              final recommendation = recommendationList[index];
              return Padding(
                padding: EdgeInsets.only(right: 8.0.w),
                child: Card(
                  elevation: 5,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.white)),
                  child: Container(
                    height: 200.h,
                    width: 300.w,
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.fullName??"",
                          style: TextStyles.w500.copyWith(
                              fontSize: 18.sp,
                              color: AppColors.colors.blueDark),
                        ),
                        Text(overflow: TextOverflow.ellipsis,
                            style: TextStyles.w500.copyWith(
                                fontSize: 10.sp,
                                color: AppColors.colors.lightGRey),
                            recommendation.companyName !=""?
                              recommendation.companyName!:
                                recommendation.schoolName !=""?
                                  recommendation.schoolName!:
                                    recommendation.companyName !="" && recommendation.schoolName !=""?
                                      "${recommendation.companyName!}\n${recommendation.schoolName!}":
                                      ""
                        ),
                        SizedBox(height: 8.h),
                        Text(maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          recommendation.headline??"",
                          style: TextStyles.w500.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.colors.blueDark),
                        ),
                        SizedBox(height: 5.h),
                        SizedBox(
                          height: 20.h,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:recommendation.skills!.length,
                                  itemBuilder: (context, index) {
                                    final data = recommendation.skills![index];
                                    return Container(
                                      height: 22.h,
                                      margin: EdgeInsetsDirectional.only(end: 5.w),
                                      padding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 16.w),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          color: AppColors.colors.lightGRey
                                              .withOpacity(.3)),
                                      child: Text(data,style: TextStyles.w400.copyWith(
                                          fontSize: 10.sp,
                                          color: AppColors.colors.blackColors)),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recommendation.status??"",
                              style: TextStyles.w500.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.colors.blackColors),
                            ),
                           SizedBox(
                             height: 30.h,
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColors.colors.clayColors,
                                 padding: EdgeInsets.only(left: 8.w,top: 3.h,bottom: 3.h,right: 3.w),
                               ),
                               onPressed: () async{
                                 final url = recommendation.url??"";
                                 if (await canLaunch(url)) {
                                 await launch(url);
                                 } else {
                                 throw 'Could not launch $url';
                                 }
                               },
                               child: Row(
                                 children: [
                                   Text("Linked",style: TextStyles.w600.copyWith(fontSize: 12.sp,color: AppColors.colors.whiteCatskill),),
                                   SizedBox(width: 3.w,),
                                   SvgPicture.asset(AppAssets.linkedInSvg,width: 25.w,),
                                 ],
                               ),
                             ),
                           )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class RecommandationSimmerEffect extends StatelessWidget {
  const RecommandationSimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommendation", style: TextStyles.w600.copyWith(fontSize: 16.sp, color: AppColors.colors.blueColors),),
        SizedBox(height: 10.h,),
        Container(
          height: 180.h,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 8.0.w),
                child: Card(
                  elevation: 5,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.white)),
                  child: Container(
                    height: 200.h,
                    width: 300.w,
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 20.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.3),
                             ),
                          ),
                        ),
                        SizedBox(
                          height: 6.h,),
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 18.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.3),
                                borderRadius: BorderRadius.circular(8.r)
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 30.h,
                            width: 270.w,
                            margin: EdgeInsetsDirectional.symmetric(horizontal: 3.w),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.3),
                                borderRadius: BorderRadius.circular(8.r)
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h,),
                        SizedBox(
                          height: 20.h,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:3,
                                  itemBuilder: (context, index) {
                                    return  Shimmer.fromColors(
                                      baseColor: Colors.grey,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        height: 20.h,
                                        width: 80.w,
                                        margin: EdgeInsetsDirectional.symmetric(horizontal: 3.w),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(.3),
                                            borderRadius: BorderRadius.circular(8.r)
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white,
                              child: Container(
                                height: 20.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(8.r)
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white,
                              child: Container(
                                height: 25.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(8.r)
                                ),
                              ),
                            )                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

