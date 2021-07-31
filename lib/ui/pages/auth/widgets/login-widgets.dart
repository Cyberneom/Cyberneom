import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/enum/auth-status.dart';


  bool _rememberMe = false;

  Widget buildEmailTF(LoginController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(NeomTranslationConstants.email.tr, style: NeomAppTheme.kLabelStyle),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: NeomAppTheme.kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _.emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: NeomAppTheme.fontFamily,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: NeomTranslationConstants.enterEmail.tr,
              hintStyle: NeomAppTheme.kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordTF(LoginController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(NeomTranslationConstants.password.tr, style: NeomAppTheme.kLabelStyle),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: NeomAppTheme.kBoxDecorationStyle,
          height: 50.0,
          child: TextField(
            controller: _.passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: NeomAppTheme.fontFamily,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: NeomTranslationConstants.enterPassword.tr,
              hintStyle: NeomAppTheme.kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForgotPasswordBtn(LoginController _) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.toNamed(NeomRouteConstants.FORGOT_PASSWORD),
        style: TextButton.styleFrom(padding: EdgeInsets.only(right: 0.0)),
        child: Text(NeomTranslationConstants.forgotPassword.tr,
          style: NeomAppTheme.kLabelStyle,
        ),
      ),
    );
  }

  Widget buildRememberMeCheckbox(LoginController _) {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                _rememberMe = value!;
                print("rememberMe");
              },
            ),
          ),
          Text(
            'Remember me',
            style: NeomAppTheme.kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget buildLoginBtn(LoginController _) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => {
          if(!_.isButtonDisabled) _.handleLogin(LoginMethod.email)
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.white,),
        child: Text(
          NeomConstants.LOGIN,
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: NeomAppTheme.fontFamily,
          ),
        ),
      ),
    );
  }

  Widget buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- ${NeomTranslationConstants.or.tr} -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          NeomTranslationConstants.signInWith.tr,
          style: NeomAppTheme.kLabelStyle,
        ),
      ],
    );
  }

  Widget buildSocialBtnRow(LoginController _) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () => {
              Get.snackbar(
                  NeomTranslationConstants.aboutCyberneom.tr,
                  NeomTranslationConstants.underConstruction.tr,
                  snackPosition: SnackPosition.BOTTOM)
              //if(!_.isButtonDisabled) _.handleLogin(LoginMethod.facebook)
            },
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(NeomAssets.facebookLogo),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              if(!_.isButtonDisabled) _.handleLogin(LoginMethod.google)
            },
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage(NeomAssets.googleLogo),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignupBtn(LoginController _) {
    return GestureDetector(
      onTap: () => {
        if(!_.isButtonDisabled) Get.toNamed(NeomRouteConstants.SIGNUP)
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: NeomTranslationConstants.dontHaveAnAccount.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: NeomTranslationConstants.signUp.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

