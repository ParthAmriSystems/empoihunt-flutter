import 'package:emploiflutter/frame_work/controller/setting_controller/save_job/save_job_controller.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/common_widget/recruiter_list_tile/recruiter_list_card_shimmer.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../frame_work/controller/job_details_controller/job_details_controller.dart';
import '../utils/common_widget/recruiter_list_tile/recruiter_list_card.dart';
import '../job_details/job_details.dart';
import '../utils/common_widget/common_no_data_found_layout.dart';

class SaveJob extends ConsumerStatefulWidget {
  const SaveJob({super.key});

  @override
  ConsumerState<SaveJob> createState() => _SaveJobState();
}

class _SaveJobState extends ConsumerState<SaveJob> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(saveJobController).saveListApiCall();
    });
    debugPrint("Job seeker Home init call");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        // Fetch more items when reaching the end of the list
        ref.read(saveJobController).fetchItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.colors.clayColors,
  ));

    final saveJobWatch = ref.watch(saveJobController);

    return Scaffold(
      appBar: const CommonAppBar(title: "Save Jobs",isLeadingShow: true,),
      body: RefreshIndicator(
        onRefresh:()async{
          await Future.delayed(const Duration(microseconds: 200));
          saveJobWatch.saveListApiCall();
        },
        child: Stack(
          children: [
            saveJobWatch.isLoading? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
                child: Column(
                    children:
                    List.generate(5, (index) {
                      return RecruiterListCardShimmer();
                    })
                ) ,
              ),
            ):
            saveJobWatch.saveJobList.isEmpty?  const CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'Opps sorry! jobs not availble at moment',):
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
                child: Column(
                    children:
                    List.generate(
                        saveJobWatch.loadMoreData?
                        saveJobWatch.saveJobList.length +1:
                        saveJobWatch.saveJobList.length, (index) {
                      if(index < saveJobWatch.saveJobList.length){
                        final jobList = saveJobWatch.saveJobList[index];
                        return RecruiterListCard(
                          jobPostModel: jobList.job!,
                          onTap: () async{
                            if(jobList.job!.iIsApplied != 1){
                              ref.watch(jobDetailsController).intAppliedValue();
                            }
                            if(jobList.job!.iIsApplied != 1){
                              ref.watch(jobDetailsController).provideFavoriteValue(false);
                            }else {
                              ref.watch(jobDetailsController).provideFavoriteValue(true);
                            }
                            await Navigator.push(context,
                                MaterialPageRoute(builder: (_) =>  JobDetails(jobDetail: jobList.job!,)));
                          },
                        );}else{
                        return  const Center(child: CircularProgressIndicator());
                      }
                    })
                ) ,
              ),
            ),
          ],
        ),
      )
    );
  }
}
