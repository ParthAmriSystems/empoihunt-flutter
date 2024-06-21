
import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/model/privacy_and_terms/pricacy_terns.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../../repository/services/shared_pref_services.dart';

final termsPrivacyPolicyController = ChangeNotifierProvider((ref) => TermsPrivacyPolicyController());

class TermsPrivacyPolicyController extends ChangeNotifier{


   String termHtmlString = "<p>Loading</p>";
  Future termsApiRequest()async{
    try {
      // Assume DioClient.client.getData() makes the API request
      Response response = await DioClient.client.getData(
          APIEndPoint.termsAndCondition);
      PrivacyTermsConditionModel privacyTermsCondition = PrivacyTermsConditionModel.fromJson(response.data);
      if (privacyTermsCondition.status == 200) {
        termHtmlString = privacyTermsCondition.data!.content.toString();
        await SharedPrefServices.services.setString(termsAndConditionStringKey,termHtmlString);
        notifyListeners(); // Notify any listeners that the data has changed
      }
    }catch(e){
      Future.error(e);
    }
  }


   String privacyPolicyHtmlString = "<p>Loading</p>";

   Future privacyPolicyApiRequest() async {
     try {
       // Assume DioClient.client.getData() makes the API request
       Response response = await DioClient.client.getData(
           APIEndPoint.privacyPolicy);
       PrivacyTermsConditionModel privacyTermsCondition = PrivacyTermsConditionModel.fromJson(response.data);
       if (privacyTermsCondition.status == 200) {
           privacyPolicyHtmlString = privacyTermsCondition.data!.content.toString();
         await SharedPrefServices.services.setString(privacyPolicyStringKey,privacyPolicyHtmlString);
         notifyListeners(); // Notify any listeners that the data has changed
       }
     } catch (e) {
       // Handle the error appropriately (e.g., logging, showing error messages)
       // print('Error: $e');
       return Future.error(e);
     }
   }

}