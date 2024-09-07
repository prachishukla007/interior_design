import 'package:flutter/cupertino.dart';

class Validator {
  Validator._();


  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value, TextEditingController password, TextEditingController cPassword) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (password.text != cPassword.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}