import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/profile/profile_profile_pic.dart';
import 'package:emploiflutter/ui/profile/profile_user_details.dart';
import 'package:emploiflutter/ui/utils/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_show_dialog_layout.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter/scheduler.dart';

import '../utils/theme/text_styles.dart';

class Profile extends ConsumerStatefulWidget{
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(profileController).getUserExperienceApi();
    });
  }
  @override
  Widget build(BuildContext context,) {
    final profileWatch = ref.watch(profileController);
    return CommonShowDialogLayout(
      show: profileWatch.isDialogShow,
      child: Scaffold(
        appBar: AppBar(
          title:   Text("Profile",style: TextStyles.w500.copyWith(fontSize: 16.sp,color: AppColors.colors.blackColors,),),
        ),
        body:  SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                   ProfileUserDetails(userModel: profileWatch.userModelData,),
                  Positioned(
                    left: 120.w,
                      top: 70.h,
                      child: ProfileProfilePic(userModel: profileWatch.userModelData,))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
