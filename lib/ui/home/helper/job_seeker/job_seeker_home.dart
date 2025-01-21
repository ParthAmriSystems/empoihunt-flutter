import 'package:emploiflutter/ui/messenger_modul/messenger/messanger.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emploiflutter/frame_work/controller/home_controller/job_seeker_home_controller/job_seeker_home_controller.dart';
import 'package:emploiflutter/frame_work/controller/job_details_controller/job_details_controller.dart';
import 'package:emploiflutter/ui/home/helper/job_seeker/helper/job_seeker_appbar.dart';
import 'package:emploiflutter/ui/job_details/job_details.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_no_data_found_layout.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

import '../../../utils/common_widget/recruiter_list_tile/recruiter_list_card.dart';
import '../../../utils/common_widget/recruiter_list_tile/recruiter_list_card_shimmer.dart';
import 'helper/ads_dialog_campus.dart';


class JobSeekerHome extends ConsumerStatefulWidget {
  const JobSeekerHome({super.key});

  @override
  ConsumerState<JobSeekerHome> createState() => _JobSeekerHomeState();
}

class _JobSeekerHomeState extends ConsumerState<JobSeekerHome> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      await ref.read(jobSeekerHomeController).getJobPrefApiCall();
      await ref.read(jobSeekerHomeController).getJobsPostApiCall();
      SharedPrefServices.services.getBool(chatBalloonIsFirstTime)? updateHeigthWidth():null;
      await ref.read(jobSeekerHomeController).checkCampusFound();

      /// this api is call for to check the new campus is added or not
      ref.read(jobSeekerHomeController).campusShowStatus == 1?Future.delayed(Duration(seconds: 2),(){
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {return Dialog(elevation: 0, backgroundColor: Colors.transparent, clipBehavior: Clip.hardEdge, child: AdsDialogCampus(),);},);}):
      null;});


    debugPrint("Job seeker Home init call");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        // Fetch more items when reaching the end of the list
        ref.read(jobSeekerHomeController).fetchItems();
      }
    });




  }

  double boxHeigth = 130.h, boxWidth = 200.w;

  updateHeigthWidth(){
    // print(boxWidth);
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        boxHeigth = 100.h;
        boxWidth = 16.w;
      });
      // print(boxWidth);
    });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.colors.clayColors,
    ));
    final jobSeekerHomeWatch = ref.watch(jobSeekerHomeController);
    return Scaffold(
      key: _scaffoldKey,
      appBar: const JobSeekerAppbar(),
     endDrawer:  GestureDetector(
       onTap: (){
         _scaffoldKey.currentState!.closeEndDrawer();
       },
       child: Drawer(
         width: MediaQuery.of(context).size.width,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                  right: 30.w,
                  top: 130.h,
                  child: IconButton(onPressed: (){
                    _scaffoldKey.currentState!.closeEndDrawer();
                    Navigator.push(context, PageTransition(child: Messenger(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                  },icon: Icon(Icons.message),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r))),)),
            ],
          ),
        ),
     ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 200));
          jobSeekerHomeWatch.getJobsPostApiCall();
        },
        child: Stack(
          children: [
            ///----------------------- above list widget -----------------///
            Padding(
              padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
              child: Column(
                children: [
                  ///================================= Preference Menu tile ==================///
                  jobSeekerHomeWatch.jobPreferenceList.isNotEmpty?
                  PopupMenuButton(
                    onSelected: (value){
                      jobSeekerHomeWatch.updateSelectedPostJob(value);
                    },
                    surfaceTintColor: AppColors.colors.whiteColors,
                    color: AppColors.colors.whiteColors,
                    child: Card(
                      shadowColor: Colors.grey.withOpacity(0.5),
                      elevation: 6,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(jobSeekerHomeWatch.selectedPostJob.keys.first,style: TextStyles.w400.copyWith(fontSize: 14.sp, color: AppColors.colors.blueColors),),
                      ),
                    ),
                    itemBuilder: (context) {
                      return List.generate(jobSeekerHomeWatch.jobPreferenceList.length, (index){
                        final list = jobSeekerHomeWatch.jobPreferenceList[index];
                        return  PopupMenuItem(
                          padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
                          value: list,
                          child: Container(
                            width: context.size!.width,
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(list.keys.first,style: TextStyles.w400.copyWith(fontSize: 14.sp, color: AppColors.colors.blueColors),),
                          ),
                        );
                      });
                    },).paddingOnly(left: 3.w,right: 3.w):const SizedBox(),

                  ///=================================== main body ==========================///
                  Expanded(
                    ///================Shimmer effect=====================///
                    child: jobSeekerHomeWatch.isLoading
                        ?  ListView.builder(
                      physics:  const BouncingScrollPhysics(),
                      itemCount:  4,
                      itemBuilder: (context, index) {
                        return RecruiterListCardShimmer();
                      },)

                    ///===================Data not found==================///
                        : jobSeekerHomeWatch.jobPostList.isEmpty ?
                    const Center(child:  CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'Opps sorry! jobs not availble at moment',))
                        :
                    ListView.builder(
                      controller: jobSeekerHomeWatch.jobPostList.length >= 20? _scrollController:null,
                      physics: jobSeekerHomeWatch.jobPostList.length >= 20? const BouncingScrollPhysics():null,
                      itemCount:  jobSeekerHomeWatch.loadMoreData ?
                      jobSeekerHomeWatch.jobPostList.length + 1
                          : jobSeekerHomeWatch.jobPostList.length,
                      itemBuilder: (context, index) {
                        if (index < jobSeekerHomeWatch.jobPostList.length) {
                          final jobList = jobSeekerHomeWatch.jobPostList[index];
                          return RecruiterListCard(
                            jobPostModel: jobList,
                            onTap: () async{
                              if(jobList.iIsApplied != 1){
                                ref.watch(jobDetailsController).intAppliedValue();
                              }
                              if(jobList.iIsSaved != 1){
                                ref.watch(jobDetailsController).provideFavoriteValue(false);
                              }else {
                                ref.watch(jobDetailsController).provideFavoriteValue(true);
                              }
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>  JobDetails(jobDetail: jobList,)));
                            },
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },),
                  ),
                ],
              ),
            ),

            Positioned(
                right: 0,
                top: 35.h,
                child: Card(
                  margin: EdgeInsets.only(right: 0),
                  elevation: 50,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r))                ),
                  child:SharedPrefServices.services.getBool(chatBalloonIsFirstTime)?
                  AnimatedContainer(
                    onEnd: () {
                      SharedPrefServices.services.setBool(chatBalloonIsFirstTime,false);
                    },
                    duration: Duration(milliseconds: 700),
                    height: boxHeigth,
                    width: boxWidth,
                    decoration: BoxDecoration(
                      color:boxWidth <= 100? AppColors.colors.clayColors: AppColors.colors.whiteColors,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r)),
                    ),
                    child:boxWidth <= 100? GestureDetector(
                      onTap: boxWidth <= 100? (){
                        _scaffoldKey.currentState!.openEndDrawer();
                      }:null,
                    ) : Column(
                      children: [
                        Expanded(child: Lottie.asset(AppAssets.chatLottie,height: 130.h,width: 120.w)),
                        Text("Chat",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)
                      ],
                    ),
                  ):
                  GestureDetector(
                      onTap: (){
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Container(
                        height:100.h,width: 14.w,
                        decoration: BoxDecoration(
                          color: AppColors.colors.clayColors,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              bottomLeft: Radius.circular(16.r)),
                        ),)),
                ))
          ],
        ),
      ),
    );
  }
}
