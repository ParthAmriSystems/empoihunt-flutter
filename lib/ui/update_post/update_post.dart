// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/frame_work/controller/manage_job_post_controller/manage_job_post_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/job_seeker_model/job_post_model/job_post_model.dart';
import 'package:emploiflutter/ui/update_post/helper/update_post_bottom_button.dart';
import 'package:emploiflutter/ui/update_post/helper/update_post_dropdown_forms.dart';
import 'package:emploiflutter/ui/update_post/helper/update_post_skills_widget.dart';
import 'package:emploiflutter/ui/update_post/helper/update_post_working_mode.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/common_service/form_validation.dart';
import '../utils/theme/app_assets.dart';
import '../utils/theme/text_styles.dart';

class UpdatePost extends ConsumerStatefulWidget {
  final JobPostModel jobPostModel;
  const UpdatePost({super.key,required this.jobPostModel});

  @override
  ConsumerState<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends ConsumerState<UpdatePost> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(manageJobPostController).saveNetworkImageToFile(widget.jobPostModel);
    });
  }
  @override
  Widget build(BuildContext context) {
    final manageJobPost = ref.watch(manageJobPostController);
    return  Scaffold(
      appBar: const CommonAppBar(title: "Update post",isLeadingShow: true),
      body: SingleChildScrollView(
        controller: manageJobPost.scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 15.h),
        child: Form(
          key: manageJobPost.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonFormField(
                focusNode: manageJobPost.jobTitleFocusNode,
                controller: manageJobPost.jobTitleFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>requiredFieldValidator(input: value, errorMgs: "Please enter job title"),
                hintText: "Android Developer",labelText: "job Title",prefixIcon: SvgPicture.asset(AppAssets.jobTitleSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),),
              SizedBox(height: 10.h,),
              CommonFormField(
                controller: manageJobPost.companyNameFieldController,
                textInputAction: TextInputAction.none,
                keyboardType: TextInputType.text,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>requiredFieldValidator(input:value,errorMgs: "Please Enter company name"),
                hintText: "Tellva Still Texus",labelText: "Company name",prefixIcon: SvgPicture.asset(AppAssets.companyBuildingSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),),

              /// Company Logo ///
              GestureDetector(
                onTap: manageJobPost.imagePicker,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colors.greyRegent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Row(
                    children: [
                      widget.jobPostModel.tCompanyLogoUrl!=""?
                      Container(
                        height: 80.h,
                        width: 80.w,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle
                        ),
                      child:manageJobPost.imageFile == null? const Center(child: CircularProgressIndicator(),):
                      Image.file(manageJobPost.imageFile!,fit: BoxFit.fill,),) :

                      Icon(Icons.cloud_upload,color: AppColors.colors.blueColors,size: 25.sp,),
                      SizedBox(width: 10.w,),
                      Expanded(child: Text(widget.jobPostModel.tCompanyLogoUrl!=""? "${widget.jobPostModel.vCompanyName}": "Select your Organization logo",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors),))
                    ],
                  ),
                ),
              ).paddingVertical(10.h),
              manageJobPost.isFileSelected?Text("Please Select organization logo",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

              CommonFormField(
                controller: manageJobPost.jobDescriptionFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter job description"),
                hintText: "Job Description Here", prefixIcon: SvgPicture.asset(AppAssets.bioGraphSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w), maxLine: 4, contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10.w),).paddingVertical(10.h),
              CommonFormField(
                controller: manageJobPost.jobRoleRespFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter job role & Responsibility"),
                hintText: "Job Role & Responsibility", prefixIcon: SvgPicture.asset(AppAssets.baselinePlaylistAddCheckCircleSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w), maxLine: 4, contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10.w),),
              CommonFormField(
                controller: manageJobPost.experienceFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value)=>notAllowSpecialChar(manageJobPost.experienceFieldController, value),
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter experience in year"),
                hintText: "2 years",labelText: "Required Experience",prefixIcon: Icon(Icons.star,color: AppColors.colors.blueColors,),).paddingOnly(top: 10.h),

              /// Job Skills Forms ///
              const UpdatePostSkillsWidget(),

              /// Job DropDown Forms ///
              const UpdatePostDropDownForms(),

              SizedBox(height: 10.h,),
              CommonFormField(
                controller: manageJobPost.salaryFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value){notAllowSpecialChar(manageJobPost.salaryFieldController, value);},
                validator:(val) =>requiredFieldValidator(input: val, errorMgs: "Please enter salary in LPA"),
                hintText: "12 LPA",labelText: "Salary Package",prefixIcon: Icon(Icons.currency_rupee,color: AppColors.colors.blueColors,),),

              /// Working Mode
              const UpdatePostWorkingMode(),

              CommonFormField(
                controller: manageJobPost.numberOfEmpFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value)=>notAllowSpecialChar(manageJobPost.numberOfEmpFieldController, value),
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter number of employee"),
                hintText: "Need of Employees",labelText: "Number of Employees",prefixIcon: Icon(Icons.people,color: AppColors.colors.blueColors,),),
              SizedBox(height: 10.h,),
              /// Bottom Button ///
              const UpdatePostBottomButton()

            ],
          ),
        ),
      ),
    );
  }
}
