import 'package:cached_network_image/cached_network_image.dart';
import 'package:emploiflutter/frame_work/repository/model/messenger_model/message_data_model.dart';
import 'package:emploiflutter/frame_work/repository/services/hive_service/box_service.dart';
import 'package:emploiflutter/ui/messenger_modul/personal_chat/helper/chat_pdf_viewer.dart';
import 'package:emploiflutter/ui/utils/constant/app_constant.dart';
import 'package:emploiflutter/ui/utils/common_widget/common_profile_image_viewer.dart';
import 'package:emploiflutter/ui/utils/extension/widget_extension.dart';
import 'package:emploiflutter/ui/utils/theme/app_assets.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/theme/text_styles.dart';

class ChatBubble extends ConsumerStatefulWidget {
  final String chatPersonFId;
  final MessageDataModel chat;

  const ChatBubble({super.key, required this.chat,required this.chatPersonFId});

  @override
  ConsumerState<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends ConsumerState<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = BoxService.boxService.userGetDetailBox.get(userDetailKey)!.user.vFirebaseId;
    return Column(
      children: [
        ///------ chat bubble ------///
       widget.chat.message != ""?
       widget.chat.msgType == 2?const SizedBox():
       Row(
          mainAxisAlignment:
          widget.chat.fromId ==  currentUserId ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 275),
              margin: EdgeInsets.only(top: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: widget.chat.fromId ==  currentUserId ? AppColors.colors.clayColors : AppColors.colors.blueColors,
                  borderRadius: BorderRadius.only(
                    topRight:
                    widget.chat.fromId ==  currentUserId ?  Radius.circular(0.r) : Radius.circular(16.r),
                    topLeft:
                    widget.chat.fromId ==  currentUserId ?  Radius.circular(16..r) : Radius.circular(0.r),
                    bottomRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  )),
              child: Column(
                crossAxisAlignment:
                widget.chat.fromId ==  currentUserId ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.message,
                      style: TextStyles.w400.copyWith(
                          fontSize: 12.sp,
                          color:Colors.white
                      )),
                  Text(widget.chat.timeStamp,
                      style: TextStyles.w400.copyWith(
                          fontSize: 8.sp,
                          color: AppColors.colors.greyRegent
                      ))
                ],
              ),
            ),
          ],
        ):
       const SizedBox(),
        ///------ chat bubble ------///


        ///------Image------///
        widget.chat.docUri !="" && widget.chat.msgType == 1?
        Row(
          mainAxisAlignment:
          widget.chat.fromId ==  currentUserId ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>CommonImageViewer(imageUrl: widget.chat.docUri)));
              },
              child: Container(
                height: 180.h,
                width: 150.w,
                clipBehavior: Clip.hardEdge,
                constraints: const BoxConstraints(maxWidth: 275),
                margin: EdgeInsets.only(top: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(
                    color: widget.chat.fromId ==  currentUserId ? AppColors.colors.clayColors : AppColors.colors.blueColors,
                    borderRadius: BorderRadius.only(
                      topRight:
                      widget.chat.fromId ==  currentUserId ?  Radius.circular(0.r) : Radius.circular(16.r),
                      topLeft:
                      widget.chat.fromId ==  currentUserId ?  Radius.circular(16..r) : Radius.circular(0.r),
                      bottomRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    )),
                child:  Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r)
                  ),
                  child: CachedNetworkImage(imageUrl: widget.chat.docUri,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),fit: BoxFit.cover),
                ),
              ),
            )
          ],
        ).paddingOnly(top: 4.h): const SizedBox(),
        ///------Image------///


        ///----------File View --------------///
        widget.chat.docUri !="" && widget.chat.msgType == 2?
        Row(
          mainAxisAlignment:
          widget.chat.fromId ==  currentUserId ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPDFViewer(pdfUrl: widget.chat.docUri)));
              },
              child: Container(
                constraints: const BoxConstraints(maxWidth: 275),
                margin: EdgeInsets.only(top: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                    color: widget.chat.fromId ==  currentUserId ? AppColors.colors.clayColors : AppColors.colors.blueColors,
                    borderRadius: BorderRadius.only(
                      topRight:
                      widget.chat.fromId ==  currentUserId ?  Radius.circular(0.r) : Radius.circular(16.r),
                      topLeft:
                      widget.chat.fromId ==  currentUserId ?  Radius.circular(16..r) : Radius.circular(0.r),
                      bottomRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    )),
                child: Column(
                  crossAxisAlignment:
                  widget.chat.fromId ==  currentUserId ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150.w,
                      child: Row(
                        children: [
                         SvgPicture.asset(AppAssets.pdfViewIconSvg,height: 30.h,color: Colors.white,),
                          SizedBox(width: 10.w,),
                          Expanded(child: Text(widget.chat.message, style: TextStyles.w400.copyWith( fontSize: 12.sp, color: AppColors.colors.whiteColors,overflow: TextOverflow.ellipsis)))
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h,),
                    Text(widget.chat.timeStamp,
                        style: TextStyles.w400.copyWith(
                            fontSize: 8.sp,
                            color: AppColors.colors.greyRegent
                        ))
                  ],
                ),
              ),
            ),
          ],
        ) :const SizedBox()
        ///----------File View --------------///

      ],
    ).paddingHorizontal(4.w);
  }
}
