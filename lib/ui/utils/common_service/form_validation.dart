import 'package:emploiflutter/ui/utils/theme/theme.dart';

String? requiredFieldValidator({required String? input, required String errorMgs}) {
  if (input == null ||  input.trim().isEmpty ) {
    return errorMgs;
  } else {
    return null;
  }
}

String? cityValidator(String? input) {
  if (input == null) {
    return 'Please fill up city name';
  } else {
    return null;
  }
}

String? emailValidator(String? input) {
  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  if (input == null || !emailRegex.hasMatch(input)) {
    return 'Enter valid email Address';
  } else {
    return null;
  }
}

String? phoneValidator(String? input) {
  if (input == null || input.trim().length < 10) {
    return 'Number must be 10 characters long';
  } else {
    return null;
  }
}

String? passValidator(String? input) {
  if (input == null || input.trim().length < 8) {
    return 'Password must be 8 characters long';
  } else {
    return null;
  }
}

String? confirmPassValidator(String? input, String password) {
  if (input == null || input.trim().length < 8) {
    return 'Password must be 8 characters long';
  } else if (input != password) {
    return "password doesn't match";
  }
  return null;
}

String? otpValidator(String? input, String otp) {
  if (input != null && input.isEmpty) {
    return 'Please Enter your Otp Number';
  } else if (input != otp.toString()) {
    return 'Invalid Otp';
  }
  return null;
}

notAllowSpecialChar(TextEditingController controller,String value){
  final filteredValue = value.replaceAll(RegExp(r'\s|[!@#%^&$*(),.?":{}|<>+/;`~=-]'), '');
  if(value != filteredValue){
    final cursorPosition = controller.selection.baseOffset -1;
    controller.value = TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );}
}

notAllowSpecialChar_withSpace(TextEditingController controller,String value){
  final filteredValue = value.replaceAll(RegExp(r'[!@#%^&$*(),.?":{}|<>+/;`~=-]'), '');
  if(value != filteredValue){
    final cursorPosition = controller.selection.baseOffset -1;
    controller.value = TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );}
}