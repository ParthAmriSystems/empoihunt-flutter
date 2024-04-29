import 'package:emploiflutter/frame_work/controller/manage_job_post_controller/manage_job_post_controller.dart';
import 'package:emploiflutter/ui/manages_jobs/helper/manage_job_tile.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:emploiflutter/ui/utils/common_widget/common_no_data_found_layout.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';

class ManagesJobs extends ConsumerStatefulWidget {
  const ManagesJobs({super.key});

  @override
  ConsumerState<ManagesJobs> createState() => _ManagesJobsState();
}

class _ManagesJobsState extends ConsumerState<ManagesJobs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      await ref.read(manageJobPostController).getJobPostApi(context);
    });
    debugPrint("Manage Job init call");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        // Fetch more items when reaching the end of the list
        ref.read(manageJobPostController).fetchItems();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final manageJobPostWatch = ref.watch(manageJobPostController);
    return Scaffold(
      appBar: const CommonAppBar(title: "Manages Jobs",isLeadingShow: true),
      body: manageJobPostWatch.isLoading? const Center(child: CircularProgressIndicator(),) :
      manageJobPostWatch.jobPostList.isEmpty?  const Center(child:  CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'Opps sorry! jobs not availble at moment',)):
      SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
          child: Column(
              children:
              List.generate(
                  manageJobPostWatch.loadMoreData?
                  manageJobPostWatch.jobPostList.length +1:
                  manageJobPostWatch.jobPostList.length, (index) {
                if(index < manageJobPostWatch.jobPostList.length){
                  final jobList = manageJobPostWatch.jobPostList[index];
                  return  ManageJobTile(jobPost: jobList,).animate().fadeIn(duration: Duration(milliseconds: 400));
                }else{
                  return  const Center(child: CircularProgressIndicator());
                }
              })
          ) ,
        ),
      ),

        /// show this if the recruiter didn't post any job ///
      // Column(
      //   children: [
      //     const Spacer(),
      //     Image.asset(AppAssets.jobSearch,height: 200.h,color: AppColors.colors.clayColors,),
      //     Text("Ummm... We searched for and wide and couldn't find data matching your search. Let's check with another one",textAlign: TextAlign.center, style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.greyRegent),),
      //     const Spacer(),
      //   ],
      // ).paddingHorizontal(10.h),
    );
  }
}
