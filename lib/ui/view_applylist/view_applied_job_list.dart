import 'package:emploiflutter/frame_work/controller/setting_controller/view_apply_list/view_apply_list_controller.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../frame_work/controller/job_details_controller/job_details_controller.dart';
import '../job_details/job_details.dart';
import '../save_job/helper/save_job_list_card.dart';
import '../utils/common_widget/common_appbar.dart';
import '../utils/common_widget/common_no_data_found_layout.dart';
import '../utils/theme/app_assets.dart';
import '../utils/theme/text_styles.dart';

class ViewAppliedJobList extends ConsumerStatefulWidget {
  const ViewAppliedJobList({super.key});

  @override
  ConsumerState<ViewAppliedJobList> createState() => _ViewAppliedJobListState();
}

class _ViewAppliedJobListState extends ConsumerState<ViewAppliedJobList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(viewApplyListController).appliedListApiCall();
    });
    debugPrint("Job seeker Home init call");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        // Fetch more items when reaching the end of the list
        ref.read(viewApplyListController).fetchItems();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.colors.clayColors,
    ));

    final applyListWatch = ref.watch(viewApplyListController);
    return Scaffold(
      appBar: const CommonAppBar(title: "View Applied Job",isLeadingShow: true,),
      body: RefreshIndicator(
        onRefresh:()async{
          await Future.delayed(const Duration(microseconds: 200));
          applyListWatch.appliedListApiCall();
        },
        child: Stack(
          children: [
            applyListWatch.isLoading? const Center(child: CircularProgressIndicator(),) :
            applyListWatch.appliedJobList.isEmpty? const Center(child: CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'Opps sorry! jobs not availble at moment',)):
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
                child: Column(
                    children:
                    List.generate(
                        applyListWatch.loadMoreData?
                        applyListWatch.appliedJobList.length +1:
                        applyListWatch.appliedJobList.length, (index) {
                      if(index < applyListWatch.appliedJobList.length){
                        final jobList = applyListWatch.appliedJobList[index];
                        return SaveJobListCard(
                          saveJobModel: jobList.job!,
                          onTap: () async{
                            if(jobList.job!.iIsApplied != 1){
                              ref.watch(jobDetailsController).intAppliedValue();
                            }
                            if(jobList.job!.iIsSaved != 1){
                              ref.watch(jobDetailsController).provideFavoriteValue(false);
                            }else {
                              ref.watch(jobDetailsController).provideFavoriteValue(true);
                            }
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (_) =>  JobDetails(jobDetail: jobList.job!,)));
                          },
                        ).animate().fadeIn(duration: Duration(milliseconds: 300));}else{
                        return  const Center(child: CircularProgressIndicator());
                      }
                    })
                ) ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}