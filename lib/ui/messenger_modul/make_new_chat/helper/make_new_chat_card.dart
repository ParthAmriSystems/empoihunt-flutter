import 'package:cached_network_image/cached_network_image.dart';
import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';

class MakeNewChatCard extends StatelessWidget {
  final void Function()? onTap;
  final String personName;
  final String profileUrl;
  const MakeNewChatCard({super.key,required this.onTap,required this.profileUrl,required this.personName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: GestureDetector(
        onTap: onTap,
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
                child: CachedNetworkImage(
                    imageUrl: "https://api.emploihunt.com$profileUrl",
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),fit: BoxFit.fill
                )
                ,
              ),
              SizedBox(width: 10.w,),
              Text(personName,style: TextStyles.w500.copyWith(fontSize: 14.sp,color: AppColors.colors.blueColors),overflow: TextOverflow.ellipsis,)
            ],
          ),
        ),
      ),
    );
  }
}
