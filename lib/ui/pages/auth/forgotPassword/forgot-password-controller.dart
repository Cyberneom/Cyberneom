import 'package:cyberneom/domain/model/neom-user.dart';
import 'package:cyberneom/domain/use-cases/forgot-password-service.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/validator.dart';


class ForgotPasswordController extends GetxController implements ForgotPasswordService {

  final logger = NeomUtilities.logger;
  final loginController = Get.find<LoginController>();

  late FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;

  TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;


  fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  fba.FirebaseAuth get auth => _auth;
  set auth(fba.FirebaseAuth auth) => this._auth = auth;

  Rxn<fba.User> _fbaUser = Rxn<fba.User>();
  fba.User get fbaUser => _fbaUser.value!;
  set fbaUser(fba.User? fbaUser) => this._fbaUser.value = fbaUser;

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

  void setEmail(text) {
    email = text;
  }

  void setPassword(text) {
    password = text;
  }

  @override
  void onInit() async {
    super.onInit();
    logger.d("");
    _focusNode = FocusNode();
    _emailController.text = '';
    _focusNode.requestFocus();

  }

  @override
  void onReady() async {
    super.onReady();
    logger.d("");

    isLoading = false;
  }

  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<bool> submitForm(BuildContext context) async {

    String validateEmailMsg = Validator().validateEmail(_emailController.text);

    if(validateEmailMsg.isNotEmpty){
      Get.snackbar(
        MessageTranslationConstants.passwordReset.tr,
        validateEmailMsg.tr,
        snackPosition: SnackPosition.BOTTOM,);
      return false;
    }

    _focusNode.unfocus();

    Get.toNamed(NeomRouteConstants.FORGOT_PASSWORD_SENDING, arguments: [NeomRouteConstants.FORGOT_PASSWORD]);

    await Future.delayed(Duration(seconds: 2));
    Get.toNamed(NeomRouteConstants.LOGIN);


    return true;
  }


}




