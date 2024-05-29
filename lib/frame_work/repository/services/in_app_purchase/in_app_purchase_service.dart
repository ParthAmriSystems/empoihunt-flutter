

import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:emploiflutter/frame_work/repository/services/in_app_purchase/PurchaseCallBack.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_queue_delegate_wrapper.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_transaction_wrappers.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_storefront_wrapper.dart';
import 'package:in_app_purchase_android/src/types/google_play_product_details.dart';
import 'package:in_app_purchase_android/src/types/google_play_purchase_param.dart';
import 'package:in_app_purchase_storekit/src/store_kit_wrappers/sk_payment_queue_wrapper.dart';
import 'notify_listener.dart';

class InAppPurchaseModule{
  static InAppPurchaseModule? _inApp;


  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> productDetails = [];
  List<ProductDetails> subscriptionProductDetails = [];
  List<ProductDetails> inAppProductDetails = [];
  List<PurchaseDetails> purchaseList = [];
  NotifyListeners? notifyCallback;


  List<PurchaseDetails> purchaseSubscriptionList = [];

  bool isPurchase = false;
  bool isProPurchase = false;

  var transactionId = "";
  var receipt = "";

  var originalTransactionId = "";

  var transactionIdPro = "";
  var receiptPro = "";

  var productID ="";
  var productIDPro ="";


  final List<String> _subscriptionLists = Platform.isAndroid ? [SKU_MONTHLY,SKU_YEARLY] : [SKU_MONTHLY_IOS,SKU_YEARLY_IOS];
  List<String>  productDetailList=[];



  static InAppPurchaseModule get inApp => _inApp!;

  PurchaseCallBack? callBack;


  InAppPurchaseModule.init() {
    if (_inApp == null) _inApp = InAppPurchaseModule._init();
  }

  InAppPurchaseModule._init() {
    initStoreInfo();
  }


  ///====================================================== INIT METHOD ===========================================///
  Future<void> initStoreInfo() async{
    print("initStoreInfo ----- call");
    productDetailList.addAll(_subscriptionLists);

    ///--------Check how many items in there--------///
    print("productDetailList size ----- ${productDetailList.length}");

    ///-----------------Stream that continu ously listen to the user purchases list -------------------------------///
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print("_subscription ----- call");
      _listenToPurchaseUpdated(purchaseDetailsList);
      },onDone: (){
      _subscription.cancel();});

      ///================ If Not available then to the function ===============///
      final bool available = await _inAppPurchase.isAvailable();
      if(!available){
        return;
      }
    ///================ If Not available then to the function ===============///


    if(Platform.isIOS){
      final iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }


    /// for get data from play store ///
    final productDetailResponse  = await _inAppPurchase.queryProductDetails(productDetailList.toSet());
    if(productDetailResponse.error == null){
    productDetails = productDetailResponse.productDetails;
      productDetails.forEach((element) {
      if (element is GooglePlayProductDetails){
        if(_subscriptionLists.contains(element.id)){
          subscriptionProductDetails.add(element);
        }else{
          inAppProductDetails.add(element);
        }
      }else if(element is AppStoreProductDetails){
        subscriptionProductDetails.add(element);
        print("introductoryPrice ==>>> ${element.skProduct.introductoryPrice}");
        print("numberOfUnits free days ==>>> ${element.skProduct.introductoryPrice!.subscriptionPeriod.numberOfUnits}");
      }
      });
      print("Subcription data ${subscriptionProductDetails[0].title}");
      print("Subcription data ${subscriptionProductDetails[0].id}");
      print("Subcription data ${subscriptionProductDetails[0].price}");

      print("Subcription data ${subscriptionProductDetails[1].title}");
      print("Subcription data ${subscriptionProductDetails[1].id}");
      print("Subcription data ${subscriptionProductDetails[1].price}");

    }
  }



  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isEmpty) {
      callBack?.onNothingPurchased();
      isPurchase = false;
      // PreferenceUtils.setBoolean(IS_PURCHASE, false);
      // FBroadcast.instance().broadcast(IS_PURCHASE_BROADCAST, value: false);
    }
    else{

      purchaseDetailsList.forEach((element) {
        print("Product id ======> ${element.productID}");

        if(element.productID == SKU_MONTHLY_IOS || element.productID == SKU_YEARLY_IOS || element.productID == SKU_MONTHLY || element.productID == SKU_YEARLY ){
          isPurchase = true;
          transactionId = element.purchaseID!;
          receipt = element.verificationData.serverVerificationData; /// Serer data is the Receipt
          productID = element.productID;

          ///=================== set pref value ===============///
          if(Platform.isAndroid){
            SharedPrefServices.services.setBool(IS_PURCHASE, true);
          }
          if(Platform.isIOS){
            originalTransactionId = "${(element as AppStorePurchaseDetails).skPaymentTransaction.originalTransaction?.transactionIdentifier}";
            SharedPrefServices.services.setString(ORIGINAL_TRANSACTION_ID, originalTransactionId);
          }
          ///=================== set pref value ===============///
          print("kp receipt -----> $receipt");
          print("kp productID ----> $productID");
          print("kp transactionId ----> $originalTransactionId");
        }
      });

      purchaseList.addAll(purchaseDetailsList);

      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            // _handleError(purchaseDetails.error!);
            print("purchase error ${PurchaseStatus.error}");
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            callBack?.onPurchaseSuccess(purchaseDetails);
            // bool valid = await _verifyPurchase(purchaseDetails);
          } else if(purchaseDetails.status == PurchaseStatus.canceled){
            callBack?.onNothingPurchased();
          }

          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance
                .completePurchase(purchaseDetails);
          }
        }
      });

      if(purchaseList.isNotEmpty){
        final details = purchaseList.firstWhere((element) => _subscriptionLists.contains(element.productID),
            orElse: () => PurchaseDetails(
                purchaseID: "",
                transactionDate: "",
                productID: "",
                verificationData: PurchaseVerificationData(
                  localVerificationData: "",
                  serverVerificationData: "",
                  source: "",
                ),
                status: PurchaseStatus.pending));
        print("Details of purchase ${details.status}");

      }
    }
  }
  ///====================================================== INIT METHOD ===========================================///


  void requestPurchase(ProductDetails? item, PurchaseCallBack listener) async {
    print("item ==> ${item != null}");
    callBack = listener;
    if (item != null) {
      late PurchaseParam purchaseParam;
      if (Platform.isAndroid) {
        purchaseParam = GooglePlayPurchaseParam(productDetails: item, applicationUserName: null, changeSubscriptionParam: null);
      }
      else {
        print("sku else ==> ");
        purchaseParam = PurchaseParam(
          productDetails: item,
          applicationUserName: null,
        );
        print("sku else ==> purchaseParam $purchaseParam ");

      }

      try {

        if (Platform.isIOS) {
          var transactions = await SKPaymentQueueWrapper().transactions();
          transactions.forEach((skPaymentTransactionWrapper) {
            try {
              SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
            } catch (_) {}
          });
        }

        _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      } catch (e) {
        callBack?.onPurchaseFailed(null);
      }

    }
  }




  List<ProductDetails> getSubscriptionProductDetailsList(){
    return subscriptionProductDetails;
  }


  bool isPurchasePlan(){
    return isPurchase;
  }
  bool isPurchaseProPlan(){
    return isProPurchase;
  }
  String getTransactionId() {
    return transactionId;
  }
  String getOriginalTransactionId(){
    return originalTransactionId;
  }
  String purchaseReceipt() {
    return receipt;
  }
  String getProductId() {
    return productID;
  }
  String getTransactionIdPro() {
    return transactionIdPro;
  }
  String purchaseReceiptPro() {
    return receiptPro;
  }
  String getProductIdPro() {
    return productIDPro;
  }
}



class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}