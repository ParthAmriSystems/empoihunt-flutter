// ignore_for_file: deprecated_member_use

import 'package:emploiflutter/frame_work/controller/create_post_job_controller/create_post_job_controller.dart';
import 'package:emploiflutter/ui/create_post_job/helper/create_post_job_bottom_button.dart';
import 'package:emploiflutter/ui/create_post_job/helper/create_post_job_dropdown_forms.dart';
import 'package:emploiflutter/ui/create_post_job/helper/create_post_job_skills_widget.dart';
import 'package:emploiflutter/ui/create_post_job/helper/create_post_job_working_mode.dart';
import 'package:emploiflutter/ui/utils/constant/app_string_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_typ_ahead_form_field.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme/text_styles.dart';

class CreatePostJob extends ConsumerStatefulWidget {
  const CreatePostJob({super.key});

  @override
  ConsumerState<CreatePostJob> createState() => _CreatePostJobState();
}

class _CreatePostJobState extends ConsumerState<CreatePostJob> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPostJobController).clearForm();
    });
  }
  @override
  Widget build(BuildContext context,) {
    final size = MediaQuery.of(context).size;
    final createPostJobWatch = ref.watch(createPostJobController);
    return  Scaffold(
      appBar: const CommonAppBar(title: "Create Job Post",),
      body: SingleChildScrollView(
        controller: createPostJobWatch.scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 15.h),
        child: Form(
          key: createPostJobWatch.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CommonTypeAheadFormField(
                  leadingIcon: SvgPicture.asset(AppAssets.jobTitleSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),
                  focusNode: createPostJobWatch.jobTitleFocusNode,
                  width: size.width * 0.93,
                  controller: createPostJobWatch.jobTitleFieldController,
                  hintText: "Job title",
                  labelText: "Job Title",
                  dropdownMenuEntries: designationList
                      .map((element) => DropdownMenuEntry(
                      value: element,
                      label: element))
                      .toList(),
                  onSelected: (value)  {
                    createPostJobWatch.jobTitleFieldController.text = value?? createPostJobWatch.jobTitleFieldController.text;
                  }),
              /*CommonTypeAheadFormField(
                  direction: VerticalDirection.down,
                  onChanged: (value)=>notAllowSpecialChar_withSpace(createPostJobWatch.jobTitleFieldController, value),
                  controller: createPostJobWatch.jobTitleFieldController,
                  hintText: "Job Title",
                  labelText: "Job Title",
                  suggestionsCallback: (pattern)async{
                    print("========================================>$pattern");
                    if (pattern.isEmpty) return ["fdk","fdg"];
                    final suggestions = await createPostJobWatch.checkJobTitle(pattern);
                    return suggestions;
                   return await createPostJobWatch.checkJobTitle(pattern);

                  },
                  onSelected: (value) =>
                  createPostJobWatch.jobTitleFieldController.text = value),*/
              createPostJobWatch.isJobTitleEmpty?Text("Please fill the job title",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),).paddingVertical(4):const SizedBox(),
              SizedBox(height: 10.h,),
              CommonFormField(
                controller: createPostJobWatch.companyNameFieldController,
                textInputAction: TextInputAction.none,
                keyboardType: TextInputType.text,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>requiredFieldValidator(input:value,errorMgs: "Please Enter company name"),
                hintText: "Tellva Still Texus",labelText: "Company name",prefixIcon: SvgPicture.asset(AppAssets.companyBuildingSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w),),

              /// Company Logo ///
          GestureDetector(
            onTap: createPostJobWatch.imagePicker,
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
                  createPostJobWatch.imageFile !=null? Container(
                    height: 80.h,
                    width: 80.w,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: Image.file(createPostJobWatch.imageFile!,fit: BoxFit.fill,),
                  ):
                  Icon(Icons.cloud_upload,color: AppColors.colors.blueColors,size: 25.sp,),
                  SizedBox(width: 10.w,),
                  Expanded(child: Text(createPostJobWatch.imageName !=""? createPostJobWatch.imageName.toString(): "Select your Organization logo",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.blackColors),overflow: TextOverflow.ellipsis,))
                ],
              ),
            ),
          ).paddingVertical(10.h),
              createPostJobWatch.isFileSelected?Text("Please Select organization logo",style: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400,),):const SizedBox(),

              CommonFormField(
                controller: createPostJobWatch.jobDescriptionFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter job description"),
                hintText: "Job Description Here", prefixIcon: SvgPicture.asset(AppAssets.bioGraphSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w), maxLine: 4, contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10.w),).paddingVertical(10.h),
              CommonFormField(
                controller: createPostJobWatch.jobRoleRespFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter job role & Responsibility"),
                hintText: "Job Role & Responsibility", prefixIcon: SvgPicture.asset(AppAssets.baselinePlaylistAddCheckCircleSvg,color: AppColors.colors.blueColors,).paddingSymmetric(vertical: 10.h,horizontal: 10.w), maxLine: 4, contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10.w),),
              CommonFormField(
                controller: createPostJobWatch.experienceFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value)=>notAllowSpecialChar(createPostJobWatch.experienceFieldController, value),
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter experience in year"),
                hintText: "2 years",labelText: "Required Experience",prefixIcon: Icon(Icons.star,color: AppColors.colors.blueColors,),).paddingOnly(top: 10.h),

              /// Job Skills Forms ///
              const CreatePostJobSkillsWidget(),

              /// Job DropDown Forms ///
              const CreatePostJobDropDownForms(),

              SizedBox(height: 10.h,),
              CommonFormField(
                controller: createPostJobWatch.salaryFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value){notAllowSpecialCharSal(createPostJobWatch.salaryFieldController, value);},
                validator:(val) =>requiredFieldValidator(input: val, errorMgs: "Please enter salary in LPA"),
                hintText: "12 LPA",labelText: "Salary Package",prefixIcon: Icon(Icons.currency_rupee,color: AppColors.colors.blueColors,),),

              /// Working Mode
              const CreatePostJobWorkingMode(),

              CommonFormField(
                controller: createPostJobWatch.numberOfEmpFieldController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value)=>notAllowSpecialChar(createPostJobWatch.numberOfEmpFieldController, value),
                validator: (value)=>requiredFieldValidator(input:value , errorMgs: "Please enter number of employee"),
                hintText: "Need of Employees",labelText: "Number of Employees",prefixIcon: Icon(Icons.people,color: AppColors.colors.blueColors,),),
               SizedBox(height: 10.h,),
              /// Bottom Button ///
              const CreatePostJobBottomButton()

            ],
          ),
        ),
      ),
    );
  }
}
