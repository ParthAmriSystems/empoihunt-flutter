import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZeGoCloudService{


  ZeGoCloudService._();
  static final ZeGoCloudService service = ZeGoCloudService._();



  /// on App's user login
  void onUserLogin(UserDetailDataModel userModel) {
    /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged in or re-logged in
    /// We recommend calling this method as soon as the user logs in to your app.
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID:  245569911 /*input your AppID*/,
      appSign: "b4db76c5d33367291b7e0f5636c43cfba6e47f667dad5e0d79b447f6988d1c53" /*input your AppSign*/,
      userID: userModel.user.vFirebaseId.toString(),
      userName: userModel.user.vFirstName.replaceFirst(" ", "_"),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
    print("Cloud called");
  }

  /// on App's user logout
  void onUserLogout() {
    /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }



}