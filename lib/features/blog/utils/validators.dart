import 'package:form_validator/form_validator.dart';

class BlogValidators {
  static String? validateTitle(String? value) {
    final validator = ValidationBuilder()
        .required('Title is required')
        .build();
    return validator(value);
  }

  static String? validateContent(String? value) {
    final validator = ValidationBuilder()
        .required('Content is required')
        .build();
    return validator(value);
  }
}
