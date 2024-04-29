import 'package:emploiflutter/frame_work/controller/home_controller/recruiter_home_controller/recruiter_home_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/shared_pref_services.dart';
import 'package:emploiflutter/ui/home/helper/recruiter/helper/recruiter_appbar.dart';
import 'package:emploiflutter/ui/home/helper/recruiter/helper/recruiter_list_tile.dart';
import 'package:emploiflutter/ui/messenger_modul/messenger/messanger.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_no_data_found_layout.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

class RecruiterHome extends ConsumerStatefulWidget {
  const RecruiterHome({super.key});

  @override
  ConsumerState<RecruiterHome> createState() => _RecruiterHomeState();
}

class _RecruiterHomeState extends ConsumerState<RecruiterHome> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp)async {
      ref.read(recruiterHomeController).getJobSeekerApiCall();
      SharedPrefServices.services.getBool(chatBalloonIsFirstTime)? updateHeigthWidth():null;
    });
    debugPrint("Recruiter Home init call");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Fetch more items when reaching the end of the list
        ref.read(recruiterHomeController).fetchItems();
      }
    });
  }


  double boxHeigth = 130.h, boxWidth = 200.w;

  updateHeigthWidth(){
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        boxHeigth = 100.h;
        boxWidth = 14.w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.colors.clayColors,
    ));
    final recruiterHomeWatch = ref.watch(recruiterHomeController);
    return Scaffold(
      key: _scaffoldKey,
      appBar: const RecruiterAppbar(),
        endDrawer:  GestureDetector(
          onTap: (){
            _scaffoldKey.currentState!.closeEndDrawer();
          },
          child: Drawer(
            width: MediaQuery.of(context).size.width,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                    right: 30.w,
                    top: 130.h,
                    child: IconButton(onPressed: (){
                      _scaffoldKey.currentState!.closeEndDrawer();
                      Navigator.push(context, PageTransition(child: Messenger(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                    },icon: Icon(Icons.message),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r))),)),
              ],
            ),
          ),
        ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              recruiterHomeWatch.getJobSeekerApiCall();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
              child: recruiterHomeWatch.isLoading
                  ? const Center(child: CircularProgressIndicator(),)
                  : recruiterHomeWatch.jobSeekerList.isEmpty ?
             const Center(child:  CommonNoDataFoundLayout(img: AppAssets.jobSearch, errorTxt: 'Opps sorry! jobs not availble at moment',))
                  :
              ListView.builder(
                controller: recruiterHomeWatch.jobSeekerList.length >=20? _scrollController:null,
                physics:recruiterHomeWatch.jobSeekerList.length >=20? const BouncingScrollPhysics():null,
                itemCount:  recruiterHomeWatch.loadMoreData ?
                recruiterHomeWatch.jobSeekerList.length + 1
                    : recruiterHomeWatch.jobSeekerList.length,
                itemBuilder: (context, index) {
                if (index < recruiterHomeWatch.jobSeekerList.length) {
                  final jobSeeker = recruiterHomeWatch.jobSeekerList[index];
                  return RecruiterListTile(user: jobSeeker).animate().fadeIn(duration: Duration(milliseconds: 400));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },),
            ),
          ),


          Positioned(
              right: 0,
              top: 35.h,
              child: Card(
                margin: EdgeInsets.only(right: 0),
                elevation: 50,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r))                ),
                child:SharedPrefServices.services.getBool(chatBalloonIsFirstTime)?
                AnimatedContainer(
                  onEnd: () {
                    SharedPrefServices.services.setBool(chatBalloonIsFirstTime,false);
                  },
                  duration: Duration(milliseconds: 700),
                  height: boxHeigth,
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color:boxWidth <= 100? AppColors.colors.clayColors: AppColors.colors.whiteColors,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r)),
                  ),
                  child:boxWidth <= 100? GestureDetector(
                    onTap: boxWidth <= 100? (){
                      print("elo");
                      _scaffoldKey.currentState!.openEndDrawer();
                      // Navigator.push(context, PageTransition(child: Messenger(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 300)));
                    }:null,
                  ) : Column(
                    children: [
                      Expanded(child: Lottie.asset(AppAssets.chatLottie,height: 130.h,width: 120.w)),
                      Text("Chat with your friends",style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),)
                    ],
                  ),
                ):
                GestureDetector(
                  onTap: (){
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                    child: Container(
                      height:100.h,width: 14.w,
                      decoration: BoxDecoration(
                        color: AppColors.colors.clayColors,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            bottomLeft: Radius.circular(16.r)),
                      ),)),
              ))
        ],
      ),
    );
  }
}