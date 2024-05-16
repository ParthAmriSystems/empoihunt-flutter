import 'dart:io';

import 'package:emploiflutter/frame_work/repository/services/in_app_purchase/in_app_purchase_service.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import '../../../../ui/utils/app_constant.dart';
import '../../../../ui/utils/theme/theme.dart';
import 'PurchaseCallBack.dart';
import 'package:in_app_purchase_storekit/src/types/app_store_purchase_details.dart';

class InAppPurchaseUI extends ConsumerStatefulWidget {
  const InAppPurchaseUI({super.key});

  @override
  ConsumerState createState() => _InAppPurchaseUIState();
}

class _InAppPurchaseUIState extends ConsumerState<InAppPurchaseUI> implements PurchaseCallBack {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   print( InAppPurchaseModule.inApp.getProductId());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UI"),),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            var productDetails = InAppPurchaseModule.inApp.subscriptionProductDetails.firstWhere((element) => element.id == SKU_MONTHLY);
            InAppPurchaseModule.inApp.requestPurchase(productDetails, this);
            }, child: Text("Monthly")),
          ElevatedButton(onPressed: (){
            var productDetails = InAppPurchaseModule.inApp.subscriptionProductDetails.firstWhere((element) => element.id == SKU_YEARLY);
            InAppPurchaseModule.inApp.requestPurchase(productDetails, this);
          }, child: Text("Yearly"))
        ],
      ),
    );
  }

  @override
  void onNothingPurchased() {
    // TODO: implement onNothingPurchased
    // TODO: implement onNothingPurchased
    print("ON NOTHING PURCHASED FROM SALES PAGE");
  }

  @override
  void onPurchaseComplete() {
    // TODO: implement onPurchaseComplete
    print("kp  onPurchaseComplete --> ");
  }

  @override
  void onPurchaseFailed(PurchaseDetails? result) {
    // TODO: implement onPurchaseFailed
    print("kp  onPurchaseFailed -->");
    if (result != null) {
      print("Failed Product ID --> ${result.productID}");
      // AnalyticsUtils.logEvent(salesPagePurchaseFailedEvent, <String, dynamic>{planName: result.productID});
    }
  }

  @override
  void onPurchaseSuccess(PurchaseDetails? item) {
    // TODO: implement onPurchaseSuccess
    print("kp  onPurchaseSuccess --> ");

    // AnalyticsUtils.logEvent(salesPagePurchaseSuccessEvent, <String, dynamic>{planName: item?.productID});

    // final variablesProvider = Provider.of<UpdateVariablesProvider>(context, listen: false);

    if (Platform.isIOS) {
      var transactionID = "${(item as AppStorePurchaseDetails).skPaymentTransaction.originalTransaction?.transactionIdentifier}";
      var receipt = item.verificationData.serverVerificationData;
      var productID = item.productID;
      // variablesProvider.setIsPurchased = true;

      SharedPrefServices.services.setBool(IS_PURCHASE, true);
      SharedPrefServices.services.setString(PRE_RECEIPT, receipt);
      SharedPrefServices.services.setString(PRODUCT_ID, productID);
      SharedPrefServices.services.setString(ORIGINAL_TRANSACTION_ID, transactionID);

      print("kp  onPurchaseSuccess receipt --> $receipt");
      print("kp  onPurchaseSuccess originalTransaction transactionID --> $transactionID");
      // printLogs("kp originalTransaction ----> ${(item as AppStorePurchaseDetails).skPaymentTransaction.originalTransaction}");

      // saveSubscriptionAPICall(receipt, productID, transactionID);
    } else {
       SharedPrefServices.services.setBool(IS_PURCHASE, true);
      // variablesProvider.setIsPurchased = true;
      var receipt = item?.verificationData.serverVerificationData;
      var transactionID = item?.purchaseID;
      var productID = item?.productID;

      print("Receipt : $receipt");
      print("Transaction ID : $transactionID");
      print("Product ID : $productID");

      // saveSubscriptionAPICall(receipt, productID, transactionID);
    }
  }
}
