import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/job_seeker_register_profile_details_controller.dart';
import 'package:emploiflutter/frame_work/controller/authentication_controller/register_controller/recruiter_register_profile_details_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/check_user_exist_model/check_user_exist_model.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/authentication/login/login.dart';
import 'package:emploiflutter/ui/authentication/register/register_otp.dart';
import 'package:emploiflutter/ui/utils/common_service/helper.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/helper.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../repository/api_end_point.dart';
import '../../../repository/dio_client.dart';

final registerController = ChangeNotifierProvider((ref) => RegisterController(ref));

class RegisterController extends ChangeNotifier{
    final Ref ref;
    RegisterController(this.ref);
  final GlobalKey<FormState> registerKey = GlobalKey();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();


  bool isCheck = false;
  updateIsCheck(bool val){
    isCheck = val;
    notifyListeners();
  }

  /// ----------------------------Country Picker--------------------------------///
  Country selectedCountry = Country(phoneCode: "91", countryCode: "IN", e164Sc: 0, geographic: true, level: 1, name: "India", example: "9123456789", displayName: "India (IN) [+91]", displayNameNoCountryCode: "India (IN)", e164Key: "91-IN-0");
  selectCountry(BuildContext context){
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
            textStyle: TextStyle(fontSize: 14.sp),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            inputDecoration: const InputDecoration(
                hintText: "Start typing to sear", labelText: "Search")),
        favorite: ['IN'],
        onSelect: (value) {
          selectedCountry = value;
          notifyListeners();
        });
    notifyListeners();
  }
  /// ----------------------------Country Picker--------------------------------///

    int userDeleted = 0;

  registerButton(BuildContext context) async{
    if(registerKey.currentState!.validate()){
      if(cityController.text !=""){
        if(isCheck){
            final status = await checkUserRegistered(phoneNumberController.text);
            if(status.status == 404 || status.status == 303){
              if(status.status == 303){
                userDeleted = 1;
              }else{
                userDeleted = 0;
              }
              /// assign data for register api call ///
              ref.read(recruiterRegisterProfileDetailsController).assignRegisterData(phone: "${selectedCountry.phoneCode}${phoneNumberController.text}", firstName: firstNameController.text, lastName: lastNameController.text, city: cityController.text, email: emailController.text);
              ref.read(jobSeekerRegisterProfileDetailsController).assignRegisterData(phone: "${selectedCountry.phoneCode}${phoneNumberController.text}", firstName: firstNameController.text, lastName: lastNameController.text, city: cityController.text, email: emailController.text);
              /// assign data for register api call ///
              if(context.mounted) {
                Navigator.push(context, PageTransition(
                    child:  RegisterOTP(phoneNumber: "+${selectedCountry.phoneCode}${phoneNumberController.text}",),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300)));
                clearForms();
              }
            }else if(status.status == 200 ){
              if(context.mounted){
                appCommonShowToast(context: context, msg: 'Opps! sorry you\'ve already register',action: SnackBarAction(label: "Login", onPressed: (){
                  context.pop();
                  clearForms();
                  context.pop();
                  Navigator.push(context, PageTransition(
                      child: const Login(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 300)));
                }));
              }
            }
        }else{
          showSnackBar(context: context, error: "Please Select Terms & Condition");
        }
      }else{
        showSnackBar(context: context, error: "Please select city");
      }
    }
    notifyListeners();
  }

  clearForms(){
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberController.clear();
    emailController.clear();
    cityController.clear();
    notifyListeners();
  }
  ///------------- get location List from the Shared Preference -----------////
  ///------------- btw i called api on authIntro screen and Stored in share preference -----///
  List<String> checkCity(String query){
    query = query.toUpperCase().trim();
    return SharedPrefServices.services.getList(locationListKey)!.where((city) => city.toUpperCase().trim().contains(query)).toList();
  }


  ///----------------------------- Check for user exist or not ----------------------------------------///


  Future<CheckUserExistModel> checkUserRegistered(String number) async{
    try{
      debugPrint(number);
      debugPrint(selectedCountry.phoneCode);
      Response response = await DioClient.client.getData("${APIEndPoint.checkUserExisting}${selectedCountry.phoneCode}$number");
      if(response.statusCode == 200){
        CheckUserExistModel checkUserExistModel = CheckUserExistModel.fromJson(response.data);
        print(checkUserExistModel.status);
        return CheckUserExistModel(status: checkUserExistModel.status);
      }else{
        debugPrint(response.statusCode.toString());
        return CheckUserExistModel(status: response.statusCode);
      }
    }catch(e){
      // print(e.toString());
      return CheckUserExistModel(status: 404);
    }
  }

  ///----------------------------- Check for user exist or not ----------------------------------------///

}