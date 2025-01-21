import 'package:emploiflutter/frame_work/controller/home_controller/job_seeker_home_controller/job_seeker_home_controller.dart';
import 'package:emploiflutter/frame_work/controller/job_details_controller/job_details_controller.dart';
import 'package:emploiflutter/frame_work/controller/setting_controller/save_job/save_job_controller.dart';
import 'package:emploiflutter/frame_work/controller/setting_controller/view_apply_list/view_apply_list_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/ui/job_details/helper/job_details_above_part.dart';
import 'package:emploiflutter/ui/job_details/helper/job_details_appbar.dart';
import 'package:emploiflutter/ui/job_details/helper/job_details_below_part.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class JobDetails extends ConsumerStatefulWidget {
  final JobPostModel jobDetail;
  const JobDetails({super.key,required this.jobDetail});

  @override
  ConsumerState<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends ConsumerState<JobDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Is applied ${widget.jobDetail.iIsApplied}");
    print("Is Saved ${widget.jobDetail.iIsSaved}");
  }
  @override
  Widget build(BuildContext context) {
    final jobDetailsWatch = ref.watch(jobDetailsController);
    jobDetailsWatch.scrollController.addListener(() {
      jobDetailsWatch.updateOffSetValue(jobDetailsWatch.scrollController.offset);
    });
    return PopScope(
      canPop: true,
      onPopInvoked: (value){
        if(value == jobDetailsWatch.isAnythingUpdated){
          ref.watch(jobSeekerHomeController).getJobsPostApiCall();
          ref.watch(saveJobController).saveListApiCall();
          ref.watch(viewApplyListController).appliedListApiCall();
        }
        jobDetailsWatch.updateIsAnythingUpdated();
      },
      child: Scaffold(
        appBar:  JobDetailsAppBar(jobDetailModel: widget.jobDetail,),
        body: Column(
          children: [
             Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: jobDetailsWatch.scrollController,
                child:  Column(
                  children: [ JobDetailsAbovePart(jobPostModel: widget.jobDetail,),  JobDetailsBelowPart(jobPostModel: widget.jobDetail,),Container(height: 100,)],
                ),
              ),
            ),


            CommonButton(
              btnText:
              widget.jobDetail.iStatus == 2? "Not available":
              widget.jobDetail.iIsApplied == 1 || jobDetailsWatch.isApplied?
              "Already Applied" : "Apply",
              fontSize: 16.sp,
              onPressed:widget.jobDetail.iIsApplied == 1 || jobDetailsWatch.isApplied || widget.jobDetail.iStatus == 2?
              null:
                  () {
                print(widget.jobDetail.id);
                jobDetailsWatch.appliedApi(widget.jobDetail.id.toString(), context, widget.jobDetail.vCompanyName!);
              },
              txtPadding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
              backgroundColor: const Color(0xff85AFA6),
            ).paddingOnly(bottom: 8.h)
          ],
        ),
      ),
    );
  }
}
