import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cyberneom/data/api-services/firestore/neom-user-firestore.dart';
import 'package:cyberneom/domain/model/neom-user.dart';
import 'package:cyberneom/domain/use-cases/signup-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';
import 'package:cyberneom/utils/enum/auth-status.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/validator.dart';


class SignUpController extends GetxController implements SignUpService {

  final logger = NeomUtilities.logger;
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController get firstNameController => _firstNameController;

  TextEditingController _lastNameController = TextEditingController();
  TextEditingController get lastNameController => _lastNameController;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  TextEditingController _confirmController = TextEditingController();
  TextEditingController get confirmController => _confirmController;

  Rxn<NeomUser> _neomUser = Rxn<NeomUser>();
  NeomUser? get neomUser => _neomUser.value;
  set neomUser(NeomUser? neomUser) => this._neomUser.value = neomUser;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  RxBool _isButtonDisabled = false.obs;
  bool get isButtonDisabled => _isButtonDisabled.value;
  set isButtonDisabled(bool isButtonDisabled) => this._isButtonDisabled.value = isButtonDisabled;

  RxString _email = "".obs;
  String get email => _email.value;
  set email(String email) => this._email.value = email;

  RxString _password = "".obs;
  String get password => _password.value;
  set password(String password) => this._password.value = password;

  @override
  void onInit() async {
    super.onInit();
    logger.d("");
  }

  @override
  void onReady() async {
    super.onReady();
    logger.d("");
    isLoading = false;
  }


  @override
  FutureOr onClose() {
    super.onClose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }


  Future<bool> submit(BuildContext context) async {

    try {
      if(await validateInfo()) {
        User? fbaUser = (await loginController.auth
            .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text)
        ).user;

        loginController.signedInWith = SignedInWith.signUp;
        loginController.fbaUser = fbaUser;
        neomUserController.getNeomUserFromSignUp();
        Get.offAllNamed(NeomRouteConstants.INTRO_CREATING, arguments: [NeomRouteConstants.SIGNUP]);

      }
    } on FirebaseAuthException catch (e) {
      String fbAuthExceptionMsg = "";
      switch(e.code) {
        case NeomFirestoreConstants.emailInUse:
          fbAuthExceptionMsg = MessageTranslationConstants.emailUsed;
          break;
        case "":
          break;
      }

      Get.snackbar(
          MessageTranslationConstants.accountSignUp.tr,
          fbAuthExceptionMsg.tr,
          snackPosition: SnackPosition.BOTTOM);

      return false;
    } catch(e) {
      Get.snackbar(
          MessageTranslationConstants.accountSignUp.tr,
          e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }


  Future<bool> validateInfo() async {

    Validator validator = Validator();

    String validatorMsg = validator.validateName(_firstNameController.text);

    if (validatorMsg.isEmpty) {

      validatorMsg = validator.validateName(_lastNameController.text);

      if (validatorMsg.isEmpty) {
        validatorMsg = validator.validateUsername(_usernameController.text);

        if (validatorMsg.isEmpty && _emailController.text.isEmpty
            && _passwordController.text.isEmpty)
          validatorMsg = MessageTranslationConstants.pleaseFillForm;

        if (validatorMsg.isEmpty)
          validatorMsg = validator.validateEmail(_emailController.text);
        if (validatorMsg.isEmpty) validatorMsg = validator.validatePassword(
            _passwordController.text, _confirmController.text);
      }
    }

    if(validatorMsg.isEmpty && !await NeomUserFirestore().isAvailableEmail(_emailController.text))
      validatorMsg = MessageTranslationConstants.emailUsed;

    if (validatorMsg.isNotEmpty) {
      Get.snackbar(
          MessageTranslationConstants.accountSignUp.tr,
          validatorMsg.tr,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

}

