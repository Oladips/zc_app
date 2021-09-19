import 'extensions/string_extension.dart';

class Validator {
  Validator._();
  static Validator validate = Validator._();

  String? notEmptyField(String input, [String? label]) {
    if (input.isEmpty)
      return label == null ? 'This field cannot be empty' : 'Enter a $label';
    else
      return null;
  }

  String? emailField(String input) {
    if (input.validateEmail())
      return null;
    else if (input.isEmpty)
      return 'Enter your email';
    else
      return 'Enter a valid email address';
  }

  String? passwordField(input) {
    if (input.isNotEmpty)
      return null;
    else
      return 'Enter your password';
  }

  String? confirmPasswordField(String input, String password) {
    if (input != password)
      return 'Passwords do not match';
    else
      return null;
  }

  bool validateNewChannelName(String input) {
    final reg = RegExp(".*?[A-Z\\s\.].*");
    if (reg.hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  bool emailValidation(String input) {
    if (input.isEmpty) {
      return false;
    } else if (input.isNotEmpty) {
      return true;
    } else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_"
            r"`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }
}
