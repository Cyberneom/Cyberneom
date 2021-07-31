

import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';

class Validator {

  String validateEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(email.isEmpty) {
      return MessageTranslationConstants.pleaseEnterEmail;
    } else if (!regex.hasMatch(email)) {
      return MessageTranslationConstants.invalidEmailFormat;
    }

    return "";

  }

  String validateName(String name) {
    if (name.isEmpty) {
      return MessageTranslationConstants.pleaseEnterFullName;
    } else if (_isNumeric(name)) {
      return MessageTranslationConstants.invalidName;
    } else if (name.length < NeomConstants.nameMinimumLength) {
      return MessageTranslationConstants.usernameAtLeast;
    } else if (name.length > NeomConstants.usernameMaximumLength) {
      return MessageTranslationConstants.usernameCantExceed;
    }

    return "";

  }

  String validateUsername(String username) {
    if (username.isEmpty) {
      return MessageTranslationConstants.pleaseEnterUsername;
    } else if (_isNumericOnly(username)) {
      return MessageTranslationConstants.invalidUsername;
    } else if (username.length < NeomConstants.usernameMinimumLength) {
      return MessageTranslationConstants.usernameAtLeast;
    } else if (username.length > NeomConstants.usernameMaximumLength) {
      return MessageTranslationConstants.usernameCantExceed;
    }

    return "";

  }

  bool _isNumericOnly(String s) {

    int count = 0;
    for (int i = 0; i < s.length; i++) {
      if (double.tryParse(s[i]) != null) count++;
    }

    return (s.length == count)
        ? true : false;
  }

  bool _isNumeric(String s) {
    for (int i = 0; i < s.length; i++) {
      if (double.tryParse(s[i]) != null) {
        return true;
      }
    }
    return false;
  }

  String validatePassword(String password, String confirmation) {
    if (password.isEmpty) {
      return MessageTranslationConstants.pleaseEnterPassword;
    } else if (password.length < 6) {
      return MessageTranslationConstants.passwordAtLeast;
    } else if (password.length > 15) {
      return MessageTranslationConstants.passwordCantExceed;
    } else if (password != confirmation) {
      return MessageTranslationConstants.passwordConfirmNotMatch;
    }

    return "";

  }

}
