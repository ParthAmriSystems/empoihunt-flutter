import 'package:emploiflutter/frame_work/controller/messenger_modul_controller/make_new_chat_controller/make_new_chat_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/messenger_modul/make_new_chat/helper/make_new_chat_appbar.dart';
import 'package:emploiflutter/ui/messenger_modul/make_new_chat/helper/make_new_chat_card.dart';
import 'package:emploiflutter/ui/messenger_modul/personal_chat/personal_chat.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_no_data_found_layout.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';

class MakeNewChat extends ConsumerStatefulWidget {
  const MakeNewChat({super.key});

  @override
  ConsumerState<MakeNewChat> createState() => _MakeNewChatState();
}

class _MakeNewChatState extends ConsumerState<MakeNewChat> {
  final ScrollController _scrollController = ScrollController();
  final user= BoxService.boxService.userGetDetailBox.get(userDetailKey);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      user!.user.iRole == 0? ref.read(makeNewChatController).getRecruiterApiCall(): ref.read(makeNewChatController).getJobSeekerApiCall();
    });
    debugPrint("Recruiter Home init call");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Fetch more items when reaching the end of the list
       user!.user.iRole == 0? ref.read(makeNewChatController).fetchMoreRecruiter(): ref.read(makeNewChatController).fetchItemsOfJobSeeker();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final makeNewChatWatch = ref.watch(makeNewChatController);
    return Scaffold(
      backgroundColor: AppColors.colors.whiteColors,
        appBar:  const MakeNewChatAppbar(),
        body:
        Padding(
          padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
          child: makeNewChatWatch.isLoading
              ? const Center(child: CircularProgressIndicator(),)
              :
          user!.user.iRole == 0?
          makeNewChatWatch.jobPostList.isEmpty ?
          const CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'There is no data ',)
              :
          ListView.builder(
            controller: _scrollController,
            physics:const BouncingScrollPhysics(),
            itemCount:  makeNewChatWatch.loadMoreData ?
            makeNewChatWatch.jobPostList.length + 1
                : makeNewChatWatch.jobPostList.length,
            itemBuilder: (context, index) {
              if (index < makeNewChatWatch.jobPostList.length) {
                final recruiter = makeNewChatWatch.jobPostList[index];
                return MakeNewChatCard(
                  onTap: (){
                    context.pop();
                  Navigator.push(context, PageTransition(child:   PersonalChat(profileUrl: recruiter.tProfileUrl!, personName: "${recruiter.vFirstName} ${recruiter.vLastName}", chatPersonFId: recruiter.vFirebaseId!, phone: recruiter.vMobile??"", ), type: PageTransitionType.rightToLeft,childCurrent: widget));
                },
                  profileUrl: recruiter.tProfileUrl!,
                  personName: "${recruiter.vFirstName} ${recruiter.vLastName}", ).animate().fadeIn(duration: Duration(milliseconds: 500));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },)
              :
          makeNewChatWatch.jobSeekerList.isEmpty ?
          const CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'There is no data ',)
              :
          ListView.builder(
            controller: _scrollController,
            physics:const BouncingScrollPhysics(),
            itemCount:  makeNewChatWatch.loadMoreData ?
            makeNewChatWatch.jobSeekerList.length + 1
                : makeNewChatWatch.jobSeekerList.length,
            itemBuilder: (context, index) {
              if (index < makeNewChatWatch.jobSeekerList.length) {
                final jobSeeker = makeNewChatWatch.jobSeekerList[index];
                return MakeNewChatCard(
                  onTap: (){
                    // print(jobSeeker.tDeviceToken);
                  Navigator.push(context, PageTransition(child: PersonalChat(profileUrl: jobSeeker.tProfileUrl!, personName: "${jobSeeker.vFirstName} ${jobSeeker.vLastName}", chatPersonFId: jobSeeker.vFirebaseId??"", phone: jobSeeker.vMobile??"",), type: PageTransitionType.rightToLeft,childCurrent: widget));
                },
                  profileUrl: jobSeeker.tProfileUrl!,
                  personName: '${jobSeeker.vFirstName} ${jobSeeker.vLastName}',).animate().fadeIn(duration: Duration(milliseconds: 500));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },),
        )    );
  }
}
