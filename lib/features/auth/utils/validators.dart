
import 'package:form_validator/form_validator.dart';

class AuthValidators {
  static String? validateEmail(String? value) {
    final validator = ValidationBuilder()
        .required('Vui lòng nhập email')
        .email('Email không hợp lệ')
        .build();
    return validator(value);
  }

  static String? validatePassword(String? value) {
    final validator = ValidationBuilder()
        .required('Vui lòng nhập mật khẩu')
        .minLength(6, 'Mật khẩu phải có ít nhất 6 ký tự')
        .build();
    return validator(value);
  }
}
