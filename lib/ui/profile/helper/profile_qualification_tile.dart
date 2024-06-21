import 'package:emploiflutter/frame_work/controller/profile_controller/profile_controller.dart';
import 'package:emploiflutter/frame_work/repository/model/user_model/user_detail_data_model.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import '../../utils/constant/app_string_constant.dart';

class ProfileQualificationTile extends ConsumerWidget {
  final UserModel user;
  const ProfileQualificationTile({super.key,required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return  Card(
      elevation: 6,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
        decoration: BoxDecoration(
            color: AppColors.colors.whiteColors,
            borderRadius: BorderRadius.circular(6.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Qualification",
                  style: TextStyles.w500.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.colors.blackColors),
                ),
                IconButton(onPressed: (){
                  print(qualificationsList);
                  profileWatch.addQualificationToDialog( user.vQualification!);
                  profileWatch.setDialogValue(4);
                  profileWatch.updateIsDialogShow();
                },icon: Icon(Icons.edit,size: 18,color: AppColors.colors.blueColors,),)                          ],
            ),
            SizedBox(height: 4.h,),
            Text(
              user.vQualification!=""? user.vQualification!:"",
              style: TextStyles.w500.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.colors.greyRegent),
            )
          ],
        ),
      ),
    );
  }
}
