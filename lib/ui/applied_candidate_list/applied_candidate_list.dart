import 'package:emploiflutter/frame_work/controller/applied_candidate_list_controller/applied_candidate_list_controller.dart';
import 'package:emploiflutter/ui/applied_candidate_list/helper/applied_candidate_list_tile.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../utils/common_widget/common_no_data_found_layout.dart';
import '../utils/theme/app_assets.dart';

class AppliedCandidateList extends ConsumerStatefulWidget {
  const AppliedCandidateList({super.key});

  @override
  ConsumerState<AppliedCandidateList> createState() => _AppliedCandidateListState();
}

class _AppliedCandidateListState extends ConsumerState<AppliedCandidateList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(appliedCandidateListController).jobsByHRIdWithoutPaginationApi();

    });
  }


  @override
  Widget build(BuildContext context) {
    final appliedCandidateWatch = ref.watch(appliedCandidateListController);
    return Scaffold(
      appBar: const CommonAppBar(title: "Applied Candidate List",isLeadingShow: true),
      body:appliedCandidateWatch.isLoading? const Center(child: CircularProgressIndicator(),) :
      appliedCandidateWatch.jobPreferenceList.isEmpty? const CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'Please Post the job first',):
      Column(
        children: [
          PopupMenuButton(
            onSelected: (value){
              appliedCandidateWatch.updateSelectedPostJob(value);
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
                child: Text(appliedCandidateWatch.selectedPostJob.keys.first,style: TextStyles.w400.copyWith(fontSize: 14.sp, color: AppColors.colors.blueColors),),
              ),
            ),
            itemBuilder: (context) {
            return List.generate(appliedCandidateWatch.jobPreferenceList.length, (index){
              final job = appliedCandidateWatch.jobPreferenceList[index];
              return  PopupMenuItem(
                value: job,
                child: SizedBox(
                  width: context.size!.width,
                  child: Container( 
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(job.keys.first,style: TextStyles.w400.copyWith(fontSize: 14.sp, color: AppColors.colors.blueColors),),
                  ),
                ),
              );
            });
          },).paddingOnly(top: 12.h,left: 16.w,right: 16.w),
          Expanded(
            child:
            appliedCandidateWatch.isLoading? const Center(child: CircularProgressIndicator(),) :
            appliedCandidateWatch.appliedUserList.isEmpty?  const CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'Opps sorry! jobs not availble at moment',):
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
                child: Column(
                    children:
                    List.generate(appliedCandidateWatch.appliedUserList.length, (index) {
                      final user = appliedCandidateWatch.appliedUserList[index];
                      return  AppliedCandidateListTile(user: user,).animate().fadeIn(duration: Duration(milliseconds: 400));
                    })
                ) ,
              ),
            ),
          )
        ],
      ),
    );
  }
}
