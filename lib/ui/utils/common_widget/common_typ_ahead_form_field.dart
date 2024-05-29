import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CommonTypeAheadFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? outlineInputBorder;
  final VerticalDirection? direction;
  final List<String> Function(String) suggestionsCallback;
  final void Function(String) onSuggestionSelected;
  final void Function(String)? onChanged;
const CommonTypeAheadFormField({super.key, required this.controller, required this.hintText, this.labelText, this.prefixIcon, this.contentPadding, this.outlineInputBorder, required this.suggestionsCallback, required this.onSuggestionSelected, this.onChanged, required this.direction});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      onSelected: onSuggestionSelected,
      direction: direction,
     builder: (context, controller, focusNode) {
       return TextField(
           onChanged: onChanged,
           controller: controller,
           decoration:InputDecoration(
               errorStyle: TextStyles.w400.copyWith(fontSize: 10.sp,color: Colors.red.shade400),
               hintText: hintText,
               prefixIcon:prefixIcon?? null,
               labelText: labelText,
               labelStyle:  TextStyles.w400.copyWith(color: Colors.black,fontSize: 14.sp),
               hintStyle: TextStyles.w400.copyWith(color: Colors.grey,fontSize: 14.sp),
               contentPadding:contentPadding ?? EdgeInsets.symmetric(horizontal: 10.w,vertical: 0),
               disabledBorder:outlineInputBorder?? OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8.r),
                   borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.w)),
               errorBorder: outlineInputBorder ??OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8.r),
                   borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.5.w)),
               focusedErrorBorder: outlineInputBorder ?? OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8.r),
                   borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.5.w)),
               focusedBorder: outlineInputBorder ?? OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8.r),
                   borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.5.w)),
               border: outlineInputBorder ?? OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8.r),
                   borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.w)),
               enabledBorder: outlineInputBorder ?? OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8.r),
                   borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.w)))
       );
     },
      errorBuilder: (context, error) => SizedBox(),
      itemBuilder: (context, itemData){
      return Container(
        height: 50.h,
        alignment: Alignment.centerLeft,
        child: ListTile(
          title: Text(itemData.toString(),style: TextStyles.w400.copyWith(fontSize: 12.sp,color: AppColors.colors.blackColors),),
        ),
      );
    } , suggestionsCallback:suggestionsCallback,);
  }
}
