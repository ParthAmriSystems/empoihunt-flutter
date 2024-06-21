import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:emploiflutter/ui/utils/common_widget/helper.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../../../ui/utils/constant/app_constant.dart';
import '../../../repository/api_end_point.dart';
import '../../../repository/dio_client.dart';
import '../../../repository/services/hive_service/box_service.dart';

final contactUsController = ChangeNotifierProvider((ref) => ContactUsController());

class ContactUsController extends ChangeNotifier{

  final GlobalKey<FormState> formKey = GlobalKey();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

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


  ///---------------------------- contact us Api ---------------------------///


  Future contactUsApi(BuildContext context) async{
    try{
      final data = BoxService.boxService.userGetDetailBox.get(userDetailKey);
      Response response = await DioClient.client.postDataWithJson(APIEndPoint.contactUsApi,
          {
            "name": nameController.text,
            "email": emailController.text,
            "mobile": "+${selectedCountry.phoneCode}${phoneController.text}",
            "message": messageController.text,
            "iUserId": data !=null? data.user.id:0
          });
      if(response.statusCode == 200){
        if(context.mounted){
          context.pop();
          showSnackBar(context: context, error: "You've Successfully Submitted");
        }
      }
    }catch (e){
      Future.error(e);
      if(context.mounted){showSnackBar(context: context, error: "Something went wrong");}
    }
  }

  ///---------------------------- contact us Api ---------------------------///

  clearForm(){
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    messageController.clear();
    notifyListeners();
  }
  submitButton(BuildContext context)async{
    if(formKey.currentState!.validate()){
      await contactUsApi(context);
      clearForm();
    }
  }
}