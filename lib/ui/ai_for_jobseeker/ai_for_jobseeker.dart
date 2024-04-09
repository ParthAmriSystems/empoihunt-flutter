import 'package:emploiflutter/frame_work/controller/ai_for_jobseeker_controller/ai_for_jobseeker_controller.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_dropdown_form_field.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:lottie/lottie.dart';
import '../utils/theme/text_styles.dart';

class AIForJobSeeker extends ConsumerWidget {
  const AIForJobSeeker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiForJobSeekerWatch = ref.watch(aiForJobSeekerController);
    return PopScope(
      canPop: true,
       onPopInvoked: (v){
        aiForJobSeekerWatch.clearData();
       },
      child: Scaffold(
        appBar: CommonAppBar(title: "AI your friend", isLeadingShow: false),
        floatingActionButton:aiForJobSeekerWatch.qnaList.isEmpty?null: CommonButton(
            backgroundColor: AppColors.colors.blueDark,
            btnText: "clear",
            fontSize: 16.sp,
            txtPadding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
            onPressed: (){
              aiForJobSeekerWatch.clearData();
            }),
        body:
        aiForJobSeekerWatch.isLoading ?
            Center(child: Row(
              children: [
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(AppAssets.searchingLottie,repeat: true,height: 200.h,width: 220.w,),
                    Text("we are gathering best QNA for you",style: TextStyle(fontSize: 16,color: AppColors.colors.blueColors),),
                  ],
                ),
                const Spacer(),
              ],
            )):
        aiForJobSeekerWatch.qnaList.isEmpty?
            ///------Form to get QNA ---------///
              Center(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\nSelect the below categories and find the best QNA for interview",style: TextStyles.w400.copyWith(fontSize: 18
                    .sp),),
                SizedBox(height: 10.h,),
                Text("Job Department",style: TextStyles.w400.copyWith(fontSize: 16.sp),),
                SizedBox(height: 10.h,),
                CommonDropDownFormField(
                    items: ["IT", "Finance", "Marketing"],
                    searchController: aiForJobSeekerWatch.jobDepartmentController,
                    selectedValue: aiForJobSeekerWatch.selectedJobDepartment,
                    onChanged: (value) {
                      aiForJobSeekerWatch.updateJobDepartmentController(value);
                      aiForJobSeekerWatch.checkJobDepartment();
                    },
                    hintTextForDropdown: "Job Department",
                    hintTextForField: "Job Department"),
                aiForJobSeekerWatch.isJobDepartmentSelect?SizedBox(): Column(
                  children: [
                    SizedBox(height: 8.h,),
                    Text("Select job department",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red),),
                  ],
                ),
                SizedBox(height: 10.h,),
                Text("Expertise",style: TextStyles.w400.copyWith(fontSize: 16.sp),),
                SizedBox(height: 10.h,),
                CommonDropDownFormField(
                    items: aiForJobSeekerWatch.expertiseList,
                    searchController: aiForJobSeekerWatch.expertiseController,
                    selectedValue: aiForJobSeekerWatch.selectedExpertise,
                    onChanged: (value) {
                      aiForJobSeekerWatch.updateExpertiseController(value);
                    },
                    hintTextForDropdown: "select your Expertise",
                    hintTextForField: "select your expertise"),
                aiForJobSeekerWatch.isExpertiseSelect?SizedBox(): Column(
                  children: [
                    SizedBox(height: 8.h,),
                    Text("Select Expertise",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red),),
                  ],
                ),
                SizedBox(height: 10.h,),
                Text("Experience",style: TextStyles.w400.copyWith(fontSize: 16.sp),),
                SizedBox(height: 10.h,),
                CommonDropDownFormField(
                    items: ["Fresher", "Intermidiate", "Experienced"],
                    searchController: aiForJobSeekerWatch.yearlyExperienceController,
                    selectedValue: aiForJobSeekerWatch.selectedYearlyEx,
                    onChanged: (value) {
                      aiForJobSeekerWatch.updateYearlyExperienceController(value);
                    },
                    hintTextForDropdown: "Select experience",
                    hintTextForField: "Select experience"),
                aiForJobSeekerWatch.isYearlyExpSelect?SizedBox(): Column(
                  children: [
                    SizedBox(height: 8.h,),
                    Text("Select experience",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red),),
                  ],
                ),
                SizedBox(height: 20.h,),
                ///=========================== Submit button ============================///
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        backgroundColor: AppColors.colors.blueDark,
                          btnText: "Submit",
                          fontSize: 16.sp,
                          txtPadding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
                          onPressed: (){
                        aiForJobSeekerWatch.submitButton(context);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ):
            ///-------- Loaded Data -------//
              SingleChildScrollView(
          child: ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              aiForJobSeekerWatch.updateIsExpandedTile(panelIndex, isExpanded);
            },
            children: List.generate(aiForJobSeekerWatch.qnaList.length, (index) {
              final qnaData = aiForJobSeekerWatch.qnaList[index];
              return ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(qnaData.question??"",style: TextStyles.w600.copyWith(fontSize: 14.sp)),
                    );
                  }, body: Container(padding: EdgeInsetsDirectional.only(start:20.w,end: 20.w,bottom: 14.h),
                child: Text("Answer:\n\n${qnaData.answer??""}",style: TextStyles.w400.copyWith(fontSize: 12.sp),),
              ),isExpanded: qnaData.isExpanded);
            }),
          ),
        ),
      ),
    );
  }
}
