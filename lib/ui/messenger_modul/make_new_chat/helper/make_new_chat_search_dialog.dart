import 'package:avatar_glow/avatar_glow.dart';
import 'package:emploiflutter/frame_work/controller/messenger_modul_controller/make_new_chat_controller/make_new_chat_controller.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_button.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';


class MakeNewChatSearchDialog extends ConsumerWidget {
  const MakeNewChatSearchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final makeNewChatWatch = ref.watch(makeNewChatController);
    return Container(
      height: 280.h,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          AvatarGlow(
            endRadius: 75.0.r,
            animate: makeNewChatWatch.isVoiceListening,
            duration: const Duration(seconds: 2),
            glowColor: AppColors.colors.clayColors,
            repeat: true,
            repeatPauseDuration: const Duration(milliseconds: 100),
            showTwoGlows: true,
            child: CircleAvatar(
              backgroundColor: AppColors.colors.clayColors,
              radius: 30.r,
              child: const Icon(Icons.mic,color: Colors.white,),
            ),
          ),
          Expanded(child: Text(makeNewChatWatch.searchController.text,style: TextStyles.w500.copyWith(fontSize: 12.sp,color: Colors.black),)),
          Text("Try saying something",style: TextStyles.w500.copyWith(fontSize: 12.sp,color: Colors.black),),
          SizedBox(height: 6.h,),
          CommonButton(
            fontSize: 12,
            backgroundColor: AppColors.colors.clayColors,
              textColor: Colors.white,
              txtPadding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 30.w),
              btnText: "Cancel", onPressed: (){
              makeNewChatWatch.dialogCancelButton();
            context.pop();
          })
        ],
      ).paddingVertical(10.h),
    );
  }
}
