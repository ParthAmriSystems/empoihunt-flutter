import 'package:dio/dio.dart';
import 'package:emploiflutter/frame_work/repository/api_end_point.dart';
import 'package:emploiflutter/frame_work/repository/dio_client.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_with_device_token_model.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:firebase_database/firebase_database.dart';

final messengerController = ChangeNotifierProvider((ref) => MessengerController());

class MessengerController extends ChangeNotifier{


  bool isSearchFiledVisible = false;
  final currentUser = BoxService.boxService.userGetDetailBox.get(userDetailKey)!;

  updateIsSearchFiledVisible(){
    isSearchFiledVisible = !isSearchFiledVisible;
    notifyListeners();
  }

  bool isLoading = true;

  final databaseReference = FirebaseDatabase.instance.ref('Mess').child("LatestMessage");




  ///============================= Firebase get user Chats =====================///

  Future<void> getInitialUserChats()async{
    final data = FirebaseDatabase.instance.ref('Messenger').child("LatestMessage").child(currentUser.user.vFirebaseId);
    makeListOfPersonEmpty();
    final snapShot = await  data.get();
    if(snapShot.exists){
      data.onChildChanged.listen((event) {
      updateChatPersonValue(event);
      });
      data.onChildAdded.listen((event) {
        Map<dynamic,dynamic> database = event.snapshot.value as Map<dynamic,dynamic>;
        getUserByFirebaseId(firebaseId: event.snapshot.key.toString(), recentText: database["message"], dateStamp: database["dateStamp"], timeStamp: database["timeStamp"],);
      });
    }else{
      isLoading = false;
      notifyListeners();
    }
  }
  ///============================= Firebase get user Chats =====================///

  List<ChatAllModel> testList = [];
 Future<void> getUserByFirebaseId(
     {required String firebaseId,
      required String recentText,
      required String dateStamp,
      required String timeStamp}) async{
   print("child added");
    try{
     // testList=[];
      isLoading =true;
      notifyListeners();
      Options options = Options(
        headers: {
          "Accept":"application/json",
          'Authorization': 'Bearer ${currentUser.tAuthToken}',
        }
      );
      Response response =await DioClient.client.getDataWithBearerToken("${APIEndPoint.getUserByFirebaseId}?vFirebaseId=$firebaseId", options);
      if(response.statusCode == 200){
        // print(response.data["data"]);
        isLoading= false;
        testList.add(ChatAllModel(timeStamp, dateStamp, recentText: recentText, userChat: UserWithDeviceTokenModel.fromJson(response.data["data"])));
        notifyListeners();
        // chatUserList.add(ChatUserModel.fromJson(response.data["data"]));
      }
    }catch(e){
      isLoading= false;
      notifyListeners();
      Future.error("get recent user error------->$e");
    }
    notifyListeners();
  }


  updateChatPersonValue(DatabaseEvent event)async{
    Map<dynamic,dynamic> database = event.snapshot.value as Map<dynamic,dynamic>;

    for(var i in testList){
      if(i.userChat.vFirebaseId == event.snapshot.key){
        i.recentText = database["message"];
      }
    }
   notifyListeners();
  }
  makeListOfPersonEmpty(){
   testList = [];
   notifyListeners();
  }
}


class ChatAllModel{

  final UserWithDeviceTokenModel userChat;
   String recentText;
   String timeStamp;
   String dateStamp;

  ChatAllModel(this.timeStamp, this.dateStamp, {required this.recentText,required this.userChat});
}