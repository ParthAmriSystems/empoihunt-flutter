
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emploiflutter/frame_work/controller/messenger_modul_controller/messenger_controller/messenger_controller.dart';
import 'package:emploiflutter/ui/messenger_modul/Messenger/helper/messenger_appbar.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_no_data_found_layout.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:emploiflutter/ui/messenger_modul/make_new_chat/make_new_chat.dart';
import 'package:emploiflutter/ui/messenger_modul/personal_chat/personal_chat.dart';


class Messenger extends ConsumerStatefulWidget {
  const Messenger({super.key});

  @override
  ConsumerState<Messenger> createState() => _MessengerState();
}

class _MessengerState extends ConsumerState<Messenger> {

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
     ref.read(messengerController).getInitialUserChats();

    });

  }
  @override
  Widget build(BuildContext context) {
    final messengerWatch = ref.watch(messengerController);
    return  Scaffold(
      backgroundColor: AppColors.colors.whiteColors,
      appBar: const MessengerAppbar(),
      floatingActionButton: IconButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colors.blueDark,
          padding: EdgeInsets.all(20.sp)
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>const MakeNewChat())).then((value) {
            messengerWatch.getInitialUserChats();
          },);
        },icon: Icon(Icons.people,color: AppColors.colors.whiteColors,size: 22,),),
      body: messengerWatch.isLoading ? const Center(child: CircularProgressIndicator()):
          messengerWatch.testList.isEmpty ? const CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: "Chat with your frd"):
        ListView.builder(
          itemCount: messengerWatch.testList.length,
          itemBuilder: (context, index) {
          final chatPerson = messengerWatch.testList[index];
          // final recentChat = messengerWatch.recentMsgList[index];
          return Card(
            elevation: 6,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (_)=> 
                        PersonalChat(profileUrl: chatPerson.userChat.tProfileUrl!, personName: '${chatPerson.userChat.vFirstName} ${chatPerson.userChat.vLastName}', chatPersonFId: chatPerson.userChat.vFirebaseId!, chatPersonDeviceToken: chatPerson.userChat.tDeviceToken!, phone: chatPerson.userChat.vMobile??"",)
                    )
                ).then((value) {
                  messengerWatch.getInitialUserChats();
                },);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.colors.whiteColors
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: 60.h,
                        width: 60.w,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle
                        ),
                        child:CachedNetworkImage(imageUrl: "https://api.emploihunt.com${chatPerson.userChat.tProfileUrl}",
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>  Image.asset(AppAssets.profilePicPng),fit: BoxFit.fill)

                    ),
                    SizedBox(width: 10.w,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${chatPerson.userChat.vFirstName} ${chatPerson.userChat.vLastName}",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),),
                          Text(chatPerson.recentText,style: TextStyles.w400.copyWith(fontSize: 12 .sp,color: AppColors.colors.greyRegent),overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: Duration(milliseconds: 500)).paddingOnly(top: 4.h,left: 6.w,right: 6.w);
        },)
    );
  }
}
