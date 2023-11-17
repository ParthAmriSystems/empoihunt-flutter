
import 'package:emploiflutter/ui/MessengerModul/Messenger/helper/messenger_appbar.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';


class Messenger extends StatelessWidget {
  const Messenger({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const MessengerAppbar(),
      floatingActionButton: IconButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.colors.blueDark,
          padding: EdgeInsets.all(20.sp)
        ),
        onPressed: (){},icon: Icon(Icons.people,color: AppColors.colors.whiteColors,size: 22,),),
      body:
        // Column(
        //   children: [
        //     const Expanded(child: SizedBox(),),
        //     Image.asset(AppAssets.jobSearch,color: AppColors.colors.clayColors,),
        //     Text("Sorry you have no any chats, Please add chat user using below Add People",style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.greyRegent),textAlign: TextAlign.center,),
        //     const Expanded(child: SizedBox(),),
        //   ],
        // ).paddingHorizontal(10.w),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: List.generate(10, (index) => Card(
              elevation: 6,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: AppColors.colors.whiteColors
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.r,
                    child: Image.asset(AppAssets.profilePicPng),
                  ),
                  title: Text("Chintan Patel",style: TextStyles.w400.copyWith(fontSize: 18.sp,color: AppColors.colors.blueColors),),
                  subtitle: Text("Recent Message",style: TextStyles.w400.copyWith(fontSize: 14.sp,color: AppColors.colors.greyRegent)),
                ),
              ),
            ).paddingOnly(top: 6.h,left: 6.w,right: 6.w))
          ),
        )
    );
  }
}