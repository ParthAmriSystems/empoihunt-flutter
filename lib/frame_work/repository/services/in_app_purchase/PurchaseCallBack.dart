import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseCallBack {
  void onPurchaseSuccess(PurchaseDetails? item) {}
  void onPurchaseFailed(PurchaseDetails? result) {}
  void onPurchaseComplete() {}
  void onNothingPurchased(){}
}
