import 'package:emploiflutter/ui/utils/common_widget/common_appbar.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_form_field.dart';
import 'package:emploiflutter/ui/utils/common_service/form_validation.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:flutter/services.dart';
import '../../frame_work/controller/setting_controller/contact_us/contact_us_controller.dart';

class ContactUs extends ConsumerWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final contactUsWatch = ref.watch(contactUsController);
    return Scaffold(
      appBar: const CommonAppBar(title: "Contact Us",isLeadingShow: true,),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
        child: SingleChildScrollView(
          child: Form(
            key: contactUsWatch.formKey,
            child: Column(
              children: [
                  Image.asset(AppAssets.contactUs,height: 130.h,),
                  Text("Please let us  know is you have any query",style: TextStyles.w500.copyWith(fontSize: 12.sp,color: AppColors.colors.blueColors),),
                  SizedBox(height: 15.h,),
                  CommonFormField(
                    maxLength: 15,
                    buildCounter: (p0, {required currentLength, required isFocused, maxLength}) => const SizedBox(),
                    textInputAction: TextInputAction.next,
                  controller: contactUsWatch.nameController,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val)=>requiredFieldValidator(input: val!,errorMgs:"Please provide a name" ),
                  prefixIcon: Icon(Icons.person,size: 18.sp,color: AppColors.colors.blueColors,),
                  hintText: "Name",labelText: "Name",
                  labelStyle: TextStyles.w400.copyWith(color: Colors.black,fontSize: 12.sp),
                ),
                  Padding(
                  padding: EdgeInsets.symmetric(vertical: 22.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          contactUsWatch.selectCountry(context);
                        },
                        child: Row(
                          children: [
                            Text(contactUsWatch.selectedCountry.countryCode,style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),),
                            SizedBox(width: 5.w,),
                            Text("+${contactUsWatch.selectedCountry.phoneCode}",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: Colors.black),),
                            const Icon(Icons.arrow_drop_down_outlined,color: Colors.black,),
                            SizedBox(width: 5.w,),
                          ],
                        ),
                      ),
                      Expanded(child: CommonFormField(
                        buildCounter: (p0, {required currentLength, required isFocused, maxLength}) => const SizedBox(),
                        maxLength: 10,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val)=>phoneValidator(val),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        controller: contactUsWatch.phoneController,
                        prefixIcon: Icon(Icons.phone,size: 18.sp,color: AppColors.colors.blueColors,),
                        hintText: "9876....",labelText: "Phone Number",
                        labelStyle: TextStyles.w400.copyWith(color: Colors.black,fontSize: 12.sp),
                      )),
                    ],
                  ),
                ),
                  CommonFormField(
                  textInputAction: TextInputAction.next,
                  controller: contactUsWatch.emailController,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                    validator: (val)=>emailValidator(val),
                  prefixIcon: Icon(Icons.email,size: 18.sp,color: AppColors.colors.blueColors,),
                  hintText: "Email",labelText: "Email",
                  labelStyle: TextStyles.w400.copyWith(color: Colors.black,fontSize: 12.sp),
                ),
                  SizedBox(height: 15.h,),
                  CommonFormField(
                    maxLength: 5000,
                    controller: contactUsWatch.messageController,
                    hintText: "Message",
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val)=>requiredFieldValidator(input: val!, errorMgs: "Description is required"),
                    prefixIcon:  Icon(Icons.file_copy_rounded,color: AppColors.colors.blueColors,),
                    maxLine: 4,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 30, horizontal: 10.w),
                  ),
                SizedBox(height: 20.h,),
                CommonButton(
                  backgroundColor: AppColors.colors.blueColors,
                    onPrimary:AppColors.colors.blueDark,
                    btnText: "Submit",onPressed: (){
                  contactUsWatch.submitButton(context);
                },fontSize: 16.sp,txtPadding: EdgeInsets.symmetric(horizontal: 47.w,vertical: 6.h))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
