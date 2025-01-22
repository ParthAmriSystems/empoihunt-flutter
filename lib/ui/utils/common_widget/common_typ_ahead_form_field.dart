import 'package:emploiflutter/ui/utils/theme/app_color.dart';
import 'package:emploiflutter/ui/utils/theme/text_styles.dart';
import 'package:emploiflutter/ui/utils/theme/theme.dart';


class CommonTypeAheadFormField extends StatelessWidget {
  final TextEditingController controller;
  final double? width;
  final String? hintText;
  final String? labelText;
  final Widget? leadingIcon;
  final FocusNode? focusNode;
  final String? initialSelection;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecorationTheme? inputDecorationTheme;
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  final void Function(String?)? onSelected;
  final void Function()? onTap;
  const CommonTypeAheadFormField({super.key, required this.controller, this.hintText, this.labelText, this.contentPadding, required this.dropdownMenuEntries, required this.onSelected, this.width, this.leadingIcon, this.inputDecorationTheme, this.focusNode, this.initialSelection, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: DropdownMenu(
        initialSelection: initialSelection,
        focusNode: focusNode,
          enableFilter: false,enableSearch: true,
          requestFocusOnTap: true,
          leadingIcon: leadingIcon??null,
          trailingIcon: SizedBox(),
          selectedTrailingIcon: SizedBox(),
          controller:  controller,
          textStyle: TextStyles.w400.copyWith(color: Colors.black,fontSize: 14.sp),
          width: width??size.width * 0.93,
          menuHeight: 350,
          inputDecorationTheme:inputDecorationTheme?? InputDecorationTheme(
            filled: true,
            fillColor: AppColors.colors.whiteColors,
            hintStyle: TextStyles.w400.copyWith(color: Colors.grey,fontSize: 14.sp),
            labelStyle:  TextStyles.w400.copyWith(color: Colors.black,fontSize: 14.sp),
            contentPadding:contentPadding??
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.w)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide:  BorderSide(color: AppColors.colors.blueColors,width: 1.w)),
          ),
          onSelected: onSelected,
          hintText: hintText??"",
          label: labelText!=null ? Text(labelText!,):null,
          dropdownMenuEntries: dropdownMenuEntries),
    );
  }
}

/*
class CommonTypeAheadFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? outlineInputBorder;
  final VerticalDirection? direction;
  final Future<List<String>?> Function(String)  suggestionsCallback;
  final void Function(String)?  onSelected;
  final void Function(String)? onChanged;
const CommonTypeAheadFormField({super.key, required this.controller, required this.hintText, this.labelText, this.prefixIcon, this.contentPadding, this.outlineInputBorder, required this.suggestionsCallback, required this.onSelected, this.onChanged, required this.direction});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      controller: controller,
      onSelected: onSelected,
      direction: direction,
     builder: (context, controller, focusNode) {
       return TextField(
           onChanged: onChanged,
           controller:controller,
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
    } , suggestionsCallback:suggestionsCallback);
  }
}
*/
