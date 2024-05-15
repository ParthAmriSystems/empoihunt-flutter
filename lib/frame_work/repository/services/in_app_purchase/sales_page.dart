// import 'dart:convert';
// import 'dart:io';
//
// import 'package:animator/animator.dart';
// // import 'package:chat_ai_helper/config/extensions.dart';
// // import 'package:chat_ai_helper/providers/sales_page_provider.dart';
// // import 'package:chat_ai_helper/utils/LoadingWidget.dart';
// // import 'package:fbroadcast/fbroadcast.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:myapp/framework/sales_page_data_model.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
//
// // import '../../utils/PreferenceUtils.dart';
// import 'InAppPurchase.dart';
// import 'PurchaseCallBack.dart';
//
// class SalesPage extends StatefulWidget {
//   final SalesPageSource salesPageSource;
//
//   const SalesPage({Key? key, required this.salesPageSource}) : super(key: key);
//
//   @override
//   State<SalesPage> createState() => _SalesPageState();
// }
//
// class _SalesPageState extends State<SalesPage> implements PurchaseCallBack {
//   List<ProductDetails> productDetailsList = <ProductDetails>[];
//   late SalesPageProvider _salesPageProvider;
//
//   // Price for Android
//   var monthlyPrice = "\$5.99";
//   var yearlyPrice = "\$19.99";
//   var monthlyPriceInDoubleValue = 0.0;
//   var freeDaysMonthly = "";
//   var freeDaysYearly = "";
//   var discountInPercentage = "72.18%";
//
//   final _remoteConfig = FirebaseRemoteConfig.instance;
//   final RoundedLoadingButtonController continueButtonController = RoundedLoadingButtonController();
//
//   @override
//   void initState() {
//     super.initState();
//     _salesPageProvider = Provider.of<SalesPageProvider>(context, listen: false);
//     _getFirebaseData();
//   }
//
//   _getFirebaseData() async {
//     var subscriptionList = InAppPurchaseModule.inApp.getSubscriptionProductDetailsList();
//     print("Subscription List Length : ${subscriptionList.length}");
//     if (subscriptionList.isNotEmpty) {
//       productDetailsList.addAll(subscriptionList);
//       setInAppData();
//     }
//     _fetchConfig();
//   }
//
//   _fetchConfig() async {
//     if (await NetworkConnection.isConnected()) {
//       await _remoteConfig.fetchAndActivate();
//       var salesDataString = _remoteConfig.getString(SALES_REMOTE_KEY);
//       var salesPageDataModel = SalesPageDataModel.fromJson(jsonDecode(salesDataString));
//
//       print("Sales Data From Remote Config : ${salesPageDataModel.salesTitle!.text.toString()}");
//     } else {
//       String introScreenJsonString = await rootBundle.loadString(Texts.salesPageJsonFile);
//       var salesPageDataModel = SalesPageDataModel.fromJson(jsonDecode(introScreenJsonString));
//
//       monthlyPrice = salesPageDataModel.monthlyPlan!.price.toString();
//       yearlyPrice = salesPageDataModel.yearlyPlan!.price.toString();
//       _salesPageProvider.refreshProvider();
//     }
//   }
//
//   @override
//   void dispose() {
//     _salesPageProvider.setIsRestoreLoading = false;
//     _salesPageProvider.setIsContinueLoading = false;
//     _salesPageProvider.setIsAnimate = false;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       left: false,
//       right: false,
//       bottom: true,
//       child: Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             leading: SalesCloseIcon(salesPageSource: widget.salesPageSource),
//             automaticallyImplyLeading: false,
//             leadingWidth: 50,
//             actions: const [RestoreButton()],
//           ),
//           body: SizedBox(
//             width: double.infinity,
//             child: Stack(
//               alignment: AlignmentDirectional.topCenter,
//               children: [
//                 // Background Image
//                 // SizedBox(
//                 //   width: double.infinity,
//                 //   child: Image.asset(
//                 //     Theme.of(context).brightness == Brightness.light ? ImagePath.salesBackgroundLight : ImagePath.salesBackgroundDark,
//                 //     fit: BoxFit.contain,
//                 //   ),
//                 // ),
//
//                 // Main Content
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Spacer(
//                       flex: 8,
//                     ),
//
//                     // Chat Picture
//                     // SvgPicture.asset(
//                     //   Theme.of(context).brightness == Brightness.light ? ImagePath.salesPageChatLight : ImagePath.salesPageChatDark,
//                     //   width: screenWidth / 2 - 20,
//                     // ),
//
//                     // 10.h,
//
//                     // Title
//                     Align(
//                         alignment: Alignment.center,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             // Regular Text
//                             // Text(
//                             //   salesPageDataModel.salesTitle!.text.toString(),
//                             //   style: TextStyle(
//                             //     color: Theme.of(context).brightness == Brightness.light
//                             //         ? hexToColor(salesPageDataModel.salesTitle!.lightColor!)
//                             //         : hexToColor(salesPageDataModel.salesTitle!.darkColor!),
//                             //     fontFamily: Texts.fontBold,
//                             //     fontSize: salesPageDataModel.salesTitle!.fontSize!.toDouble().sp,
//                             //   ),
//                             // ),
//
//                             // Unlimited Text
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                   color: Theme.of(context).brightness == Brightness.light
//                                       ? hexToColor(salesPageDataModel.salesTitle!.unlimitedBackgroundColorLight!)
//                                       : hexToColor(salesPageDataModel.salesTitle!.unlimitedBackgroundColorDark!),
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: Text(
//                                 salesPageDataModel.salesTitle!.textUnlimited.toString(),
//                                 style: TextStyle(
//                                   color: Theme.of(context).brightness == Brightness.light
//                                       ? hexToColor(salesPageDataModel.salesTitle!.unlimitedLightColor!)
//                                       : hexToColor(salesPageDataModel.salesTitle!.unlimitedDarkColor!),
//                                   fontFamily: Texts.fontBold,
//                                   fontSize: salesPageDataModel.salesTitle!.fontSize!.toDouble().sp,
//                                 ),
//                               ),
//                             )
//                           ],
//                         )),
//
//                     const Spacer(),
//
//                     // List Of Sales Items
//                     Container(
//                       height: screenHeight * 0.3,
//                       decoration: BoxDecoration(
//                           color: Theme.of(context).brightness == Brightness.light
//                               ? hexToColor(salesPageDataModel.getAccessTo!.backgroundLightColor!)
//                               : hexToColor(salesPageDataModel.getAccessTo!.backgroundDarkColor!),
//                           borderRadius: BorderRadius.circular(16)),
//                       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         children: [
//                           // GetAccessTo Text
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               salesPageDataModel.getAccessTo!.text.toString(),
//                               textAlign: TextAlign.left,
//                               style: TextStyle(
//                                 color: hexToColor(salesPageDataModel.getAccessTo!.color!),
//                                 fontSize: salesPageDataModel.getAccessTo!.fontSize!.toDouble().sp,
//                               ),
//                             ),
//                           ),
//
//                           15.h,
//
//                           // List of Sales Items
//                           Flexible(
//                             child: ListView.builder(
//                                 padding: EdgeInsets.zero,
//                                 itemCount: salesPageDataModel.salesItems!.length,
//                                 itemBuilder: (context, index) {
//                                   String salesItem = salesPageDataModel.salesItems![index].text.toString();
//                                   return Container(
//                                     padding: const EdgeInsets.symmetric(vertical: 9),
//                                     child: Row(
//                                       children: [
//                                         SvgPicture.asset(ImagePath.salesPageCheckMark),
//                                         10.w,
//                                         Text(
//                                           salesItem,
//                                           style: TextStyle(
//                                               color: Theme.of(context).brightness == Brightness.light
//                                                   ? hexToColor(salesPageDataModel.salesItemsStyle!.lightColor!)
//                                                   : hexToColor(salesPageDataModel.salesItemsStyle!.darkColor!),
//                                               fontSize: salesPageDataModel.salesItemsStyle!.fontSize!.toDouble().sp),
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 }),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const Spacer(),
//
//                     // Plans
//                     Consumer<SalesPageProvider>(builder: (context, salesProvider, _) {
//                       return Column(
//                         children: [
//                           // Monthly
//                           GestureDetector(
//                             onTap: () async {
//                               hapticTouch(context);
//
//                               AnalyticsUtils.logEvent(salesPagePurchaseEvent, <String, dynamic>{purchaseClick: monthlyTap});
//
//                               if (await NetworkConnection.isConnected()) {
//                                 salesProvider.setIsContinueLoading = true;
//                                 salesProvider.refreshProvider();
//
//                                 salesProvider.setIsMonthlySelected = true;
//                                 if (Platform.isAndroid) {
//                                   openPurchaseScreen(SKU_MONTHLY);
//                                 } else {
//                                   openPurchaseScreen(SKU_MONTHLY_IOS);
//                                 }
//                               } else {
//                                 if (context.mounted) showSnackBar(context, Texts.noInternetSnackBarMessage);
//                               }
//                             },
//                             child: Container(
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                   color: salesProvider.getIsMonthlySelected
//                                       ? Theme.of(context).brightness == Brightness.light
//                                           ? hexToColor(salesPageDataModel.selectedPlan!.backgroundColorLight!)
//                                           : hexToColor(salesPageDataModel.selectedPlan!.backgroundColorDark!)
//                                       : Theme.of(context).brightness == Brightness.light
//                                           ? hexToColor(salesPageDataModel.unselectedPlan!.backgroundColorLight!)
//                                           : hexToColor(salesPageDataModel.unselectedPlan!.backgroundColorDark!),
//                                   border: Border.all(
//                                     color: salesProvider.getIsMonthlySelected
//                                         ? hexToColor(salesPageDataModel.selectedPlan!.borderColor!)
//                                         : Theme.of(context).brightness == Brightness.light
//                                             ? hexToColor(salesPageDataModel.unselectedPlan!.borderColorLight!)
//                                             : hexToColor(salesPageDataModel.unselectedPlan!.borderColorDark!),
//                                     width: 2,
//                                   ),
//                                   borderRadius: BorderRadius.circular(16)),
//                               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     freeDaysMonthly.isNotEmpty
//                                         ? "$freeDaysMonthly ${salesPageDataModel.monthlyPlan!.text.toString()}"
//                                         : salesPageDataModel.monthlyPlan!.offerText.toString(),
//                                     style: TextStyle(
//                                         color: salesProvider.getIsMonthlySelected
//                                             ? Theme.of(context).brightness == Brightness.light
//                                                 ? hexToColor(salesPageDataModel.selectedPlan!.textColorLight!)
//                                                 : hexToColor(salesPageDataModel.selectedPlan!.textColorDark!)
//                                             : Theme.of(context).brightness == Brightness.light
//                                                 ? hexToColor(salesPageDataModel.unselectedPlan!.textColorLight!)
//                                                 : hexToColor(salesPageDataModel.unselectedPlan!.textColorDark!),
//                                         fontSize: freeDaysMonthly.isNotEmpty
//                                             ? salesPageDataModel.monthlyPlan!.textFontSize!.toDouble().sp
//                                             : salesPageDataModel.monthlyPlan!.offerTextSize!.toDouble().sp),
//                                   ),
//                                   5.h,
//                                   Text(
//                                     "$monthlyPrice${salesPageDataModel.monthlyPlan!.perMonthText}",
//                                     style: TextStyle(
//                                         color: salesProvider.getIsMonthlySelected
//                                             ? hexToColor(salesPageDataModel.selectedPlan!.priceColor!)
//                                             : Theme.of(context).brightness == Brightness.light
//                                                 ? hexToColor(salesPageDataModel.unselectedPlan!.priceColorLight!)
//                                                 : hexToColor(salesPageDataModel.unselectedPlan!.priceColorDark!),
//                                         fontSize: salesPageDataModel.monthlyPlan!.priceFontSize!.toDouble().sp),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           // Yearly
//                           GestureDetector(
//                             onTap: () async {
//                               hapticTouch(context);
//
//                               AnalyticsUtils.logEvent(salesPagePurchaseEvent, <String, dynamic>{purchaseClick: yearlyTap});
//
//                               if (await NetworkConnection.isConnected()) {
//                                 salesProvider.setIsContinueLoading = true;
//                                 salesProvider.refreshProvider();
//
//                                 salesProvider.setIsMonthlySelected = false;
//                                 if (Platform.isAndroid) {
//                                   openPurchaseScreen(SKU_YEARLY);
//                                 } else {
//                                   openPurchaseScreen(SKU_YEARLY_IOS);
//                                 }
//                               } else {
//                                 if (context.mounted) showSnackBar(context, Texts.noInternetSnackBarMessage);
//                               }
//                             },
//                             child: Container(
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                   color: salesProvider.getIsMonthlySelected
//                                       ? Theme.of(context).brightness == Brightness.light
//                                           ? hexToColor(salesPageDataModel.unselectedPlan!.backgroundColorLight!)
//                                           : hexToColor(salesPageDataModel.unselectedPlan!.backgroundColorDark!)
//                                       : Theme.of(context).brightness == Brightness.light
//                                           ? hexToColor(salesPageDataModel.selectedPlan!.backgroundColorLight!)
//                                           : hexToColor(salesPageDataModel.selectedPlan!.backgroundColorDark!),
//                                   border: Border.all(
//                                       color: salesProvider.getIsMonthlySelected
//                                           ? Theme.of(context).brightness == Brightness.light
//                                               ? hexToColor(salesPageDataModel.unselectedPlan!.borderColorLight!)
//                                               : hexToColor(salesPageDataModel.unselectedPlan!.borderColorDark!)
//                                           : hexToColor(salesPageDataModel.selectedPlan!.borderColor!),
//                                       width: 2),
//                                   borderRadius: BorderRadius.circular(16)),
//                               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         freeDaysYearly.isNotEmpty
//                                             ? "$freeDaysYearly ${salesPageDataModel.yearlyPlan!.text}"
//                                             : "${salesPageDataModel.yearlyPlan!.offerText}",
//                                         style: TextStyle(
//                                             color: salesProvider.getIsMonthlySelected
//                                                 ? Theme.of(context).brightness == Brightness.light
//                                                     ? hexToColor(salesPageDataModel.unselectedPlan!.textColorLight!)
//                                                     : hexToColor(salesPageDataModel.unselectedPlan!.textColorDark!)
//                                                 : Theme.of(context).brightness == Brightness.light
//                                                     ? hexToColor(salesPageDataModel.selectedPlan!.textColorLight!)
//                                                     : hexToColor(salesPageDataModel.selectedPlan!.textColorDark!),
//                                             fontSize: freeDaysYearly.isNotEmpty
//                                                 ? salesPageDataModel.yearlyPlan!.textFontSize!.toDouble().sp
//                                                 : salesPageDataModel.yearlyPlan!.offerTextSize!.toDouble().sp),
//                                       ),
//                                       5.h,
//                                       Text(
//                                         "$yearlyPrice${salesPageDataModel.yearlyPlan!.perYearText}",
//                                         style: TextStyle(
//                                             color: salesProvider.getIsMonthlySelected
//                                                 ? Theme.of(context).brightness == Brightness.light
//                                                     ? hexToColor(salesPageDataModel.unselectedPlan!.priceColorLight!)
//                                                     : hexToColor(salesPageDataModel.unselectedPlan!.priceColorDark!)
//                                                 : hexToColor(salesPageDataModel.selectedPlan!.priceColor!),
//                                             fontSize: salesPageDataModel.yearlyPlan!.priceFontSize!.toDouble().sp),
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                                     decoration: BoxDecoration(
//                                         color: salesProvider.getIsMonthlySelected
//                                             ? Theme.of(context).brightness == Brightness.light
//                                                 ? hexToColor(salesPageDataModel.save70!.backgroundColorLight!)
//                                                 : hexToColor(salesPageDataModel.save70!.backgroundColorDark!)
//                                             : hexToColor(salesPageDataModel.save70!.selectedBackgroundColor!),
//                                         borderRadius: BorderRadius.circular(6)),
//                                     child: Text(
//                                       "${salesPageDataModel.save70!.text} $discountInPercentage",
//                                       style: TextStyle(
//                                           color: Theme.of(context).brightness == Brightness.light
//                                               ? hexToColor(salesPageDataModel.save70!.textColorLight!)
//                                               : hexToColor(salesPageDataModel.save70!.textColorDark!),
//                                           fontSize: salesPageDataModel.save70!.fontSize!.toDouble().sp),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//
//                     5.h,
//
//                     // Continue Button
//                     Selector<SalesPageProvider, bool>(
//                         selector: (_, provider) => provider.getIsContinueLoading,
//                         builder: (context, isLoading, _) {
//                           return Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 16),
//                             child: RoundedLoadingButton(
//                               controller: continueButtonController,
//                               loaderStrokeWidth: 2,
//                               width: isLoading ? 300 : screenWidth * 0.9,
//                               height: screenHeight * 0.07,
//                               borderRadius: isLoading ? 35 : 10,
//                               color: hexToColor(salesPageDataModel.continueButton!.buttonColor!),
//                               animateOnTap: false,
//                               onPressed: () async {
//                                 // Continue Purchase
//                                 hapticTouch(context);
//                                 AnalyticsUtils.logEvent(salesPagePurchaseEvent, <String, dynamic>{purchaseClick: continueTap});
//
//                                 if (await NetworkConnection.isConnected()) {
//                                   _salesPageProvider.setIsContinueLoading = true;
//                                   _salesPageProvider.refreshProvider();
//
//                                   if (_salesPageProvider.getIsMonthlySelected) {
//                                     if (Platform.isAndroid) {
//                                       openPurchaseScreen(SKU_MONTHLY);
//                                     } else {
//                                       openPurchaseScreen(SKU_MONTHLY_IOS);
//                                     }
//                                   } else {
//                                     if (Platform.isAndroid) {
//                                       openPurchaseScreen(SKU_YEARLY);
//                                     } else {
//                                       openPurchaseScreen(SKU_YEARLY_IOS);
//                                     }
//                                   }
//                                 } else {
//                                   _salesPageProvider.setIsContinueLoading = false;
//                                   _salesPageProvider.refreshProvider();
//                                   if (context.mounted) showSnackBar(context, Texts.noInternetSnackBarMessage);
//                                 }
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const SizedBox(
//                                       width: 35,
//                                       height: 35,
//                                     ),
//                                     const Spacer(),
//                                     FittedBox(
//                                       child: Text(salesPageDataModel.continueButton!.text.toString(),
//                                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                               fontSize: salesPageDataModel.continueButton!.fontSize!.toDouble().sp,
//                                               color: hexToColor(salesPageDataModel.continueButton!.textColor!))),
//                                     ),
//                                     const Spacer(),
//                                     FittedBox(
//                                       child: Animator(
//                                         tween: Tween<Offset>(begin: const Offset(-0.3, 0), end: const Offset(0.1, 0)),
//                                         duration: const Duration(milliseconds: 600),
//                                         cycles: 0,
//                                         builder: (context, animation, child) {
//                                           return FractionalTranslation(
//                                             translation: animation.value,
//                                             child: Container(
//                                               margin: const EdgeInsets.only(right: 5),
//                                               width: 35,
//                                               height: 35,
//                                               child: SvgPicture.asset(ImagePath.nextIcon),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//
//                     5.h,
//
//                     // Privacy | Terms | Cancel Anytime
//                     Container(
//                       margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
//                       child: Platform.isAndroid
//                           ? // Auto-renews, Cancel Anytime
//                           Text(
//                               salesPageDataModel.cancelAnytimeButton!.text.toString(),
//                               style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                                   fontSize: salesPageDataModel.cancelAnytimeButton!.fontSize!.toDouble().sp,
//                                   color: Theme.of(context).brightness == Brightness.light
//                                       ? hexToColor(salesPageDataModel.cancelAnytimeButton!.lightColor!)
//                                       : hexToColor(salesPageDataModel.cancelAnytimeButton!.darkColor!)),
//                             )
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Privacy
//                                 Text.rich(
//                                   textAlign: TextAlign.center,
//                                   TextSpan(
//                                     text: salesPageDataModel.privacyButton!.text.toString(),
//                                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                                         fontSize: salesPageDataModel.privacyButton!.fontSize!.toDouble().sp,
//                                         color: Theme.of(context).brightness == Brightness.light
//                                             ? hexToColor(salesPageDataModel.privacyButton!.lightColor!)
//                                             : hexToColor(salesPageDataModel.privacyButton!.darkColor!)),
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () {
//                                         // On Tap Privacy policy
//                                         _launchPrivacyPolicy();
//                                       },
//                                     children: [
//                                       // "|" Separator
//                                       TextSpan(
//                                         text: " | ",
//                                         style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                                             fontSize: salesPageDataModel.termsButton!.fontSize!.toDouble().sp,
//                                             color: Theme.of(context).brightness == Brightness.light
//                                                 ? hexToColor(salesPageDataModel.privacyButton!.lightColor!)
//                                                 : hexToColor(salesPageDataModel.privacyButton!.darkColor!)),
//                                       ),
//
//                                       // Terms
//                                       TextSpan(
//                                         text: salesPageDataModel.termsButton!.text.toString(),
//                                         style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                                             fontSize: salesPageDataModel.termsButton!.fontSize!.toDouble().sp,
//                                             color: Theme.of(context).brightness == Brightness.light
//                                                 ? hexToColor(salesPageDataModel.termsButton!.lightColor!)
//                                                 : hexToColor(salesPageDataModel.termsButton!.darkColor!)),
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = () {
//                                             // On Tap Terms
//                                             _launchTerms();
//                                           },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//
//                                 // Cancel Anytime
//                                 Text(
//                                   salesPageDataModel.cancelAnytimeButton!.text.toString(),
//                                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                                       fontSize: salesPageDataModel.cancelAnytimeButton!.fontSize!.toDouble().sp,
//                                       color: Theme.of(context).brightness == Brightness.light
//                                           ? hexToColor(salesPageDataModel.cancelAnytimeButton!.lightColor!)
//                                           : hexToColor(salesPageDataModel.cancelAnytimeButton!.darkColor!)),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ],
//                 ),
//
//                 // Container To Make Screen UnTappable while Continue is Loading
//                 Selector<SalesPageProvider, bool>(
//                   selector: (_, provider) => provider.getIsContinueLoading,
//                   builder: (context, isContinueLoading, _) {
//                     return isContinueLoading
//                         ? Container(
//                             height: double.infinity,
//                             width: double.infinity,
//                             color: ColorConstants.black.withOpacity(0.01),
//                           )
//                         : Container();
//                   },
//                 ),
//
//                 // Loading Animation while Restore Purchase
//                 Selector<SalesPageProvider, bool>(
//                   selector: (_, provider) => provider.getIsRestoreLoading,
//                   builder: (context, isRestoreLoading, _) {
//                     return isRestoreLoading ? const LoadingWidget() : Container();
//                   },
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
//
//   /// ********** InApp Purchase module ****************
//
//
//   void openPurchaseScreen(sku) {
//     // printLogs("sku ==> $sku");
//     // printLogs("sku ==> ${InAppPurchaseModule.inApp.subscriptionProductDetails.length}");
//     _salesPageProvider.setIsContinueLoading = true;
//     _salesPageProvider.refreshProvider();
//     continueButtonController.start();
//
//     var productDetails = InAppPurchaseModule.inApp.subscriptionProductDetails.firstWhere((element) => element.id == sku);
//     if (productDetails != null) {
//       InAppPurchaseModule.inApp.requestPurchase(productDetails, this);
//     }
//   }
//
//   /// * Setup In-app Data ***
//   void setInAppData() {
//     productDetailsList.forEach((element) {
//       if (element is GooglePlayProductDetails) {
//         switch (element.id) {
//           case SKU_MONTHLY:
//             {
//               monthlyPrice = element.price;
//               monthlyPriceInDoubleValue = element.rawPrice;
//
//               freeDaysMonthly = element.skuDetails.freeTrialPeriod.replaceAll('P', '');
//               freeDaysMonthly = freeDaysMonthly.replaceAll('D', '');
//               printLogs("monthlyPrice ==>> $monthlyPrice");
//               printLogs("monthly freeDays ==>> $freeDaysMonthly");
//             }
//             break;
//           case SKU_YEARLY:
//             {
//               yearlyPrice = element.price;
//               var yearlyPriceTemp = element.rawPrice;
//
//               freeDaysYearly = element.skuDetails.freeTrialPeriod.replaceAll('P', '');
//               freeDaysYearly = freeDaysYearly.replaceAll('D', '');
//               printLogs("Yearly Free Days : $freeDaysYearly");
//               var totalYearlyPrice = monthlyPriceInDoubleValue * 12;
//               var yrPrice = yearlyPriceTemp;
//               var discountPrice = totalYearlyPrice - yrPrice;
//               var discount = ((discountPrice * 100) / totalYearlyPrice);
//               discountInPercentage = "${discount.toStringAsFixed(2)}%";
//               printLogs("yearlyPrice ==>> $yearlyPrice");
//               printLogs("discountInPercentage ==>> $discountInPercentage");
//               printLogs("yearly freeDays ==>> $freeDaysYearly");
//             }
//             break;
//           default:
//             {
//               /* printLogs("Invalid choice"); */
//             }
//             break;
//         }
//       } else if (element is AppStoreProductDetails) {
//         switch (element.id) {
//           case SKU_MONTHLY_IOS:
//             {
//               monthlyPrice = element.price;
//               monthlyPriceInDoubleValue = element.rawPrice;
//               printLogs("introductoryPrice ==>>> ${element.skProduct.introductoryPrice}");
//
//               if (element.skProduct.introductoryPrice != null) {
//                 printLogs("numberOfUnits free days ==>>> ${element.skProduct.introductoryPrice!.subscriptionPeriod.numberOfUnits}");
//                 freeDaysMonthly = element.skProduct.introductoryPrice!.subscriptionPeriod.numberOfUnits.toString();
//               }
//
//               printLogs("monthlyPrice ==>> $monthlyPrice");
//               printLogs("monthlyPriceInDoubleValue ==>> $monthlyPriceInDoubleValue");
//               printLogs("freeDays Monthly ==>> $freeDaysMonthly");
//             }
//             break;
//
//           case SKU_YEARLY_IOS:
//             {
//               yearlyPrice = element.price;
//               var yearlyPriceTemp = element.rawPrice;
//
//               var totalYearlyPrice = monthlyPriceInDoubleValue * 12;
//               var yrPrice = yearlyPriceTemp;
//               var discountPrice = totalYearlyPrice - yrPrice;
//               var discount = ((discountPrice * 100) / totalYearlyPrice);
//               discountInPercentage = "${discount.toStringAsFixed(2)}%";
//
//               if (element.skProduct.introductoryPrice != null) {
//                 //printLogs("numberOfUnits free days ==>>> ${element.skProduct.introductoryPrice!.subscriptionPeriod.numberOfUnits}");
//                 freeDaysYearly = element.skProduct.introductoryPrice!.subscriptionPeriod.numberOfUnits.toString();
//               }
//               printLogs("yearlyPrice ==>> $yearlyPrice");
//               printLogs("discountInPercentage ==>> $discountInPercentage");
//               printLogs("yearlyPrice ==>> $yearlyPrice");
//               printLogs("freeDays Yearly ==>> $freeDaysYearly");
//             }
//             break;
//           default:
//             {
//               /* printLogs("Invalid choice"); */
//             }
//             break;
//         }
//       }
//     });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _salesPageProvider.refreshProvider();
//     });
//   }
//
//   /// * Purchase call back method
//
//   @override
//   Future<void> onPurchaseSuccess(PurchaseDetails? item) async {
//     printLogs("kp  onPurchaseSuccess --> ");
//
//     AnalyticsUtils.logEvent(salesPagePurchaseSuccessEvent, <String, dynamic>{planName: item?.productID});
//
//     final variablesProvider = Provider.of<UpdateVariablesProvider>(context, listen: false);
//
//     if (Platform.isIOS) {
//       var transactionID = "${(item as AppStorePurchaseDetails).skPaymentTransaction.originalTransaction?.transactionIdentifier}";
//       var receipt = item.verificationData.serverVerificationData;
//       var productID = item.productID;
//       variablesProvider.setIsPurchased = true;
//
//       PreferenceUtils.setBoolean(IS_PURCHASE, true);
//       PreferenceUtils.setString(PRE_RECEIPT, receipt);
//       PreferenceUtils.setString(PRODUCT_ID, productID);
//       PreferenceUtils.setString(ORIGINAL_TRANSACTION_ID, transactionID);
//
//       printLogs("kp  onPurchaseSuccess receipt --> $receipt");
//       printLogs("kp  onPurchaseSuccess originalTransaction transactionID --> $transactionID");
//       // printLogs("kp originalTransaction ----> ${(item as AppStorePurchaseDetails).skPaymentTransaction.originalTransaction}");
//
//       saveSubscriptionAPICall(receipt, productID, transactionID);
//     } else {
//       await PreferenceUtils.setBoolean(IS_PURCHASE, true);
//       variablesProvider.setIsPurchased = true;
//       var receipt = item?.verificationData.serverVerificationData;
//       var transactionID = item?.purchaseID;
//       var productID = item?.productID;
//
//       printLogs("Receipt : $receipt");
//       printLogs("Transaction ID : $transactionID");
//       printLogs("Product ID : $productID");
//
//       saveSubscriptionAPICall(receipt, productID, transactionID);
//     }
//   }
//
//   @override
//   void onPurchaseComplete() {
//     printLogs("kp  onPurchaseComplete --> ");
//   }
//
//   @override
//   void onPurchaseFailed(PurchaseDetails? result) {
//     printLogs("kp  onPurchaseFailed -->");
//     if (result != null) {
//       printLogs("Failed Product ID --> ${result.productID}");
//       AnalyticsUtils.logEvent(salesPagePurchaseFailedEvent, <String, dynamic>{planName: result.productID});
//     }
//
//     _salesPageProvider.setIsContinueLoading = false;
//     _salesPageProvider.refreshProvider();
//     continueButtonController.reset();
//   }
//
//   @override
//   void onNothingPurchased() async {
//     // TODO: implement onNothingPurchased
//     printLogs("ON NOTHING PURCHASED FROM SALES PAGE");
//     final variablesProvider = Provider.of<UpdateVariablesProvider>(context, listen: false);
//     variablesProvider.setIsPurchased = false;
//     await PreferenceUtils.setBoolean(IS_PURCHASE, false);
//
//     continueButtonController.reset();
//     _salesPageProvider.setIsContinueLoading = false;
//     _salesPageProvider.refreshProvider();
//   }
//
//   /* Call API to Save Subscription after successful purchase */
//   void saveSubscriptionAPICall(String? receipt, String? productID, String? transactionID) async {
//     Map<String, dynamic> storeSubscriptionMap = {"receipt": receipt, "product_id": productID, "type": Platform.isAndroid ? "android" : "apple"};
//
//     var saveSubscriptionResponse = await CallAPIModule.apiModule.postResponse(STORE_SUBSCRIPTION_DETAILS_ROUTE, storeSubscriptionMap, authHeader);
//
//     if (kDebugMode) {
//       printLogs("Store Subscription Response : $saveSubscriptionResponse");
//     }
//
//     final code = saveSubscriptionResponse['code'];
//     printLogs("Store Subscription Response Code: $code");
//
//     if (code == 200) {
//       navigateToHomeScreen();
//     } else {
//       printLogs("FAILED TO GET APPROPRIATE RESPONSE FROM STORE SUBSCRIPTION");
//       navigateToHomeScreen();
//     }
//   }
//
//   navigateToHomeScreen() async {
//     final variablesProvider = Provider.of<UpdateVariablesProvider>(context, listen: false);
//
//     if (Platform.isIOS) {
//       var isPurchase = await InAppPurchaseModule.inApp.checkPurchased();
//       printLogs("kp isPurchase --> $isPurchase");
//
//       if (isPurchase) {
//         PreferenceUtils.setBoolean(IS_PURCHASE, true);
//         variablesProvider.setIsPurchased = true;
//
//         if (widget.salesPageSource == SalesPageSource.story_teller) {
//           _salesPageProvider.setIsContinueLoading = false;
//           _salesPageProvider.refreshProvider();
//           continueButtonController.reset();
//           FBroadcast.instance().broadcast(IS_PURCHASE_BROADCAST, value: true);
//
//           if (context.mounted) Navigator.of(context).pop(true);
//         } else {
//           if (context.mounted) {
//             _salesPageProvider.setIsContinueLoading = false;
//             _salesPageProvider.refreshProvider();
//             continueButtonController.reset();
//             FBroadcast.instance().broadcast(IS_PURCHASE_BROADCAST, value: true);
//
//             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
//           }
//         }
//       }
//     } else {
//       PreferenceUtils.setBoolean(IS_PURCHASE, true);
//       variablesProvider.setIsPurchased = true;
//       FBroadcast.instance().broadcast(IS_PURCHASE_BROADCAST, value: true);
//
//       _salesPageProvider.setIsContinueLoading = false;
//       _salesPageProvider.refreshProvider();
//       continueButtonController.reset();
//
//       if (context.mounted) {
//         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
//       }
//     }
//   }
//
//   /* Open Privacy Policy Web Page */
//   _launchPrivacyPolicy() async {
//     final Uri contactUsURL = Uri.parse(PRIVACY_POLICY_URL);
//
//     if (!await launchUrl(contactUsURL, mode: LaunchMode.inAppWebView)) {
//       throw 'Could not launch $contactUsURL';
//     }
//   }
//
//   /* Open Terms Of Use Web Page */
//   _launchTerms() async {
//     final Uri contactUsURL = Uri.parse(TERMS_OF_SERVICE_URL);
//
//     if (!await launchUrl(contactUsURL, mode: LaunchMode.inAppWebView)) {
//       throw 'Could not launch $contactUsURL';
//     }
//   }
// }
//
// class SalesCloseIcon extends StatelessWidget {
//   final SalesPageSource salesPageSource;
//
//   const SalesCloseIcon({Key? key, required this.salesPageSource}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//
//       // Close Image
//       child: Consumer<SalesPageProvider>(builder: (context, provider, _) {
//         return GestureDetector(
//           onTap: provider.getIsContinueLoading
//               ? null
//               : () {
//                   switch (salesPageSource) {
//                     case SalesPageSource.splash:
//                     case SalesPageSource.intro:
//                       Navigator.pushReplacement(context,
//                           PageTransition(type: PageTransitionType.fade, duration: const Duration(milliseconds: 500), child: const HomeScreen()));
//                       break;
//                     case SalesPageSource.home:
//                     case SalesPageSource.chat:
//                     case SalesPageSource.settings:
//                     case SalesPageSource.story_teller:
//                       Navigator.of(context).pop(false);
//                       break;
//                     case SalesPageSource.other:
//                       Navigator.of(context).pop();
//                       break;
//                     default:
//                       break;
//                   }
//                 },
//           child: SvgPicture.asset(
//             (Theme.of(context).brightness == Brightness.light) ? ImagePath.salesPageCloseLight : ImagePath.salesPageCloseDark,
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class RestoreButton extends StatelessWidget {
//   const RestoreButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final salesProvider = Provider.of<SalesPageProvider>(context, listen: false);
//     final variablesProvider = Provider.of<UpdateVariablesProvider>(context, listen: false);
//
//     return Selector<SalesPageProvider, bool>(
//         selector: (_, provider) => provider.getIsContinueLoading,
//         builder: (context, isContinueLoading, _) {
//           return Container(
//             margin: const EdgeInsets.only(right: 3),
//             child: TextButton(
//                 onPressed: isContinueLoading
//                     ? null
//                     : () async {
//                         AnalyticsUtils.logEvent(salesPageRestoreClickEvent, null);
//
//                         if (await NetworkConnection.isConnected()) {
//                           salesProvider.setIsRestoreLoading = true;
//                           salesProvider.refreshProvider();
//                           // Restore Purchase
//                           bool isPurchased = await InAppPurchaseModule.inApp.checkPurchased();
//
//                           if (isPurchased) {
//                             AnalyticsUtils.logEvent(salesPageRestoreSuccessEvent, null);
//
//                             await PreferenceUtils.setBoolean(IS_PURCHASE, true);
//                             variablesProvider.setIsPurchased = true;
//                             salesProvider.setIsRestoreLoading = false;
//                             salesProvider.refreshProvider();
//
//                             if (context.mounted) {
//                               Navigator.of(context)
//                                   .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
//                             }
//                           } else {
//                             AnalyticsUtils.logEvent(salesPageRestoreFailedEvent, null);
//
//                             salesProvider.setIsRestoreLoading = false;
//                             salesProvider.refreshProvider();
//                             await PreferenceUtils.setBoolean(IS_PURCHASE, false);
//                             variablesProvider.setIsPurchased = false;
//                             if (context.mounted) {
//                               showSnackBar(context, Texts.salesRestoreDialog);
//                             }
//                           }
//                         } else {
//                           if (context.mounted) showSnackBar(context, Texts.noInternetSnackBarMessage);
//                         }
//                       },
//                 style: Theme.of(context).textButtonTheme.style,
//                 child: Text(
//                   salesPageDataModel.restoreButton!.text.toString(),
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       fontSize: salesPageDataModel.restoreButton!.fontSize!.toDouble().sp,
//                       color: Theme.of(context).brightness == Brightness.light
//                           ? hexToColor(salesPageDataModel.cancelAnytimeButton!.lightColor!)
//                           : hexToColor(salesPageDataModel.cancelAnytimeButton!.darkColor!)),
//                 )),
//           );
//         });
//   }
// }
