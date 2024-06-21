import 'package:emploiflutter/frame_work/controller/messenger_modul_controller/Personal_chat_controller/personal_chat_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/messenger_model/message_data_model.dart';
import 'package:emploiflutter/ui/messenger_modul/personal_chat/helper/chat_bottom_sheet.dart';
import 'package:emploiflutter/ui/messenger_modul/personal_chat/helper/pesonal_chat_search_dialog.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:flutter/scheduler.dart';
import 'chat_bubble.dart';

class PersonalChatBackWidget extends ConsumerStatefulWidget {

  final String personName;
  final String chatPersonFId;
  final String chatPersonDeviceToken;
  const PersonalChatBackWidget({super.key,required this.chatPersonDeviceToken,required this.personName,required this.chatPersonFId});

  @override
  ConsumerState<PersonalChatBackWidget> createState() => _PersonalChatBackWidgetState();
}

class _PersonalChatBackWidgetState extends ConsumerState<PersonalChatBackWidget> {



  @override
  void initState() {
    super.initState();
   SchedulerBinding.instance.addPostFrameCallback((timeStamp)async {
     await Future.delayed(const Duration(milliseconds: 600));
     ref.read(personalChatController).scrollController.animateTo(
       ref.read(personalChatController).scrollController.position.maxScrollExtent,
       duration: const Duration(milliseconds: 200),
       curve: Curves.easeOut,
     );
   });
  }



  @override
  Widget build(BuildContext context) {
    final personalChatWatch = ref.watch(personalChatController);
    final size = MediaQuery.of(context).size;
    final currentUserFId = BoxService.boxService.userGetDetailBox.get(userDetailKey)!.user.vFirebaseId;

    return Column(children: [
      Expanded(
        child: FirebaseAnimatedList(
          controller: personalChatWatch.scrollController,
          query: FirebaseDatabase.instance.ref('Messenger').child("userMessages").child(currentUserFId).child(widget.chatPersonFId),
          itemBuilder: (context, snapshot, animation, index) {
            final messageData = MessageDataModel.fromSnapshot(snapshot);
            return ChatBubble(chat: messageData, chatPersonFId: widget.chatPersonFId,);
          },
        )
      ),


      Row(children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r)),
            elevation: 20,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.colors.whiteColors,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  personalChatWatch.isFileUploadProgressVisible?
                  Container(
                    padding: EdgeInsets.only(left: 16.w,top: 2.h,right: 16.w),
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.colors.whiteColors,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(100.r),topRight: Radius.circular(100.r))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(personalChatWatch.uploadFileName,style: TextStyles.w400.copyWith(fontSize: 12.sp,color: Colors.black),overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 3.h,),
                        LinearProgressIndicator(
                          color: AppColors.colors.clayColors,value: personalChatWatch.progressValue,),
                        SizedBox(height: 3.h,),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Text("Wait while uploading...",style: TextStyles.w400.copyWith(fontSize: 8.sp,color: Colors.black))
                          ],
                        )
                      ],
                    ),
                  ) :
                  const SizedBox(),
                  TextFormField(
                    controller: personalChatWatch.inputController,
                    onChanged: (value){
                      personalChatWatch.updateIsSendButtonOn(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Message",
                      border: InputBorder.none,
                      prefixIcon:IconButton(
                        onPressed:(){
                          showBottomSheet(context: context, builder: (context) {
                            return  ChatBottomSheet(chatPersonId: widget.chatPersonFId,);
                          },);
                        },
                        icon: Icon(
                          Icons.add,
                          size: 30.sp,
                          color: AppColors.colors.blueColors,
                        ),) ,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),


        SizedBox(width: 3.w),
        IconButton(
          onPressed: ()async {
            if(personalChatWatch.isSendButtonOn){
                personalChatWatch.sendDataToDatabase(chatPersonFId: widget.chatPersonFId, message: personalChatWatch.inputController.text);
               personalChatWatch.scrollToBottom();
               personalChatWatch.sendNotification(personalChatWatch.inputController.text,widget.chatPersonDeviceToken);
            }else{
              personalChatWatch.listeningVoice(context, chatPersonFId: widget.chatPersonFId);
              showDialog(context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Dialog(
                    child: PersonalChatSearchDialog(),
                  );
                },);
            }
          },
          icon: Icon(
            personalChatWatch.isSendButtonOn?Icons.send: Icons.mic,
            size: 22.sp,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.grey,
              elevation: 20,
              backgroundColor: AppColors.colors.blueColors,
              padding: EdgeInsets.all(12.sp)),
        )
      ]).paddingOnly(left: 6.w,right: 6.w,bottom: 6.h)
    ]);
  }
}
