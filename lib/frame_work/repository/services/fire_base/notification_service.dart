import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../../../ui/utils/common_service/helper.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message received: ${message.messageId} ${message.data}");
  print("Additional details: ${message.notification}");
  print("Additional data: ${message.data}");
  print("A Background Message was received: ${message.messageId} ${message.data} ");
}


class NotService{

  NotService._();

  static final NotService service = NotService._();

  Future<void> init()async{
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true,);

    await FirebaseMessaging.instance.requestPermission(alert: true, sound: true);

    // FirebaseMessaging.onMessage.listen((event) {
    //   kPrint(event.data["id"]);
    //   kPrint(event.data["screen"]);
    //   // navigationHandler(event.data);
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.data.containsKey("screen")) {
    //   }
    // });
    //
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null && message.data.containsKey("screen")) {
    //   }
    // });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }


   Future<String> getFCMId() async {
    String token ="";
    await FirebaseMessaging.instance.getToken().then((value) {
      print("Your FCM Token:  $value");
      token= value??"";
    });
    return token;
  }

   Future<String> getAPNS() async {
    String token ="";
    await FirebaseMessaging.instance.getAPNSToken().then((value) {
      print("Your APNS Token:  $value");
      token= value??"";
    });
    return token;
  }
}