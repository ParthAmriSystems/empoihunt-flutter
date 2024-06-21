import 'package:emploiflutter/frame_work/controller/messenger_modul_controller/make_new_chat_controller/make_new_chat_controller.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_search_appbar.dart';
import 'package:emploiflutter/ui/utils/extension/context_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';

import 'make_new_chat_search_dialog.dart';

class MakeNewChatAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const MakeNewChatAppbar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = BoxService.boxService.userGetDetailBox.get(userDetailKey);
    final makeNewChatWatch = ref.watch(makeNewChatController);
    return makeNewChatWatch.isSearchFiledVisible
        ? CommonSearchAppBar(
      controller: makeNewChatWatch.searchController,
      onFieldSubmitted: (value){
        user!.user.iRole == 0? makeNewChatWatch.searchedDataOfRecruiter(): makeNewChatWatch.searchedDataOfJobSeeker();
      },
      action: [
        IconButton(
            onPressed: () {
              makeNewChatWatch.listeningVoice(context);
              showDialog(context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Dialog(
                    child: MakeNewChatSearchDialog(),
                  );
                },);
            },
            icon: Icon(Icons.mic, color: AppColors.colors.blackColors)),

      ], searchSuffixClick: () {
      makeNewChatWatch.searchController.clear();
    }, onBackArrowTap: (){
      makeNewChatWatch.searchController.clear();
     user!.user.iRole == 0?makeNewChatWatch.getRecruiterApiCall(): makeNewChatWatch.getJobSeekerApiCall();
      makeNewChatWatch.updateIsSearchFiledVisible();
    },)
        : Theme(
      data: ThemeData(useMaterial3: false),
      child: AppBar(
        leading: IconButton(onPressed: (){context.pop();},icon: const Icon(Icons.arrow_back,color: Colors.black,),),
        backgroundColor: AppColors.colors.whiteColors,
        elevation: 4,
        shadowColor: Colors.grey.shade300,
        title: Text(
            "Find Best Employees",
            style: TextStyles.w500.copyWith(
                fontSize: 16.sp, color: AppColors.colors.blackColors)),
        actions: [
          IconButton(
              onPressed: () {
                makeNewChatWatch.updateIsSearchFiledVisible();
              },
              icon: Icon(
                Icons.search,
                color: AppColors.colors.blackColors,
              )),
          IconButton(
              onPressed: () {
                makeNewChatWatch.listeningVoice(context);
                showDialog(context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Dialog(
                      child: MakeNewChatSearchDialog(),
                    );
                  },);
              },
              icon: Icon(
                Icons.mic,
                color: AppColors.colors.blackColors,
              )),
        ],
      ),
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.h);
}

/*
AppBar(
        leading: makeNewChatWatch.isSearchFiledVisible ?const SizedBox():IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.colors.greyRegent,),onPressed: (){
          context.pop();
        },),
        backgroundColor: AppColors.colors.whiteColors,
        elevation: 2.5,
        shadowColor: Colors.grey.shade300,
        title: makeNewChatWatch.isSearchFiledVisible?
            Row(
              children: [
                IconButton(onPressed: (){
                  makeNewChatWatch.updateIsSearchFiledVisible();
                }, icon: Icon(Icons.arrow_back,color: AppColors.colors.greyRegent,)),
                Expanded(child: CommonFormField(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.h,horizontal: 10.w),
                  fillColor: Colors.transparent,
                  border: const UnderlineInputBorder(),
                  hintText: "Search here",suffixIcon: IconButton(onPressed: (){},icon: const Icon(Icons.cancel_outlined),),))
              ],
            ):
        Text("Make New Chat",style: TextStyles.w500.copyWith(fontSize: 16.sp,color: AppColors.colors.blackColors),),
        actions: [
         makeNewChatWatch.isSearchFiledVisible? const SizedBox(): IconButton(onPressed: (){
            makeNewChatWatch.updateIsSearchFiledVisible();
          }, icon:  Icon(Icons.search,color: AppColors.colors.greyRegent,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.mic,color: AppColors.colors.greyRegent,)),
        ],
      )
 */
