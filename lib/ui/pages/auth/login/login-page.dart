import 'package:flutter/services.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/ui/pages/auth/widgets/login-widgets.dart';
import 'package:cyberneom/ui/pages/static/previous-version-page.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/header-intro.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        id: NeomPageIdConstants.loginPage,
        init: LoginController(),
        builder: (_) => Scaffold(
          body: Container(
            decoration: NeomAppTheme.neomBoxDecoration,
            child: _.isLoading ? Center(child: CircularProgressIndicator())
              : Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  SizedBox(height: 60),
                  HeaderIntro(subtitle: ""),
                  _.neomApp.version != NeomConstants.neomVersion ? PreviousVersionPage() :
                  AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.light,
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Stack(
                        children: <Widget>[
                            SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(NeomTranslationConstants.signIn.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: NeomAppTheme.fontFamily,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  buildEmailTF(_),
                                  SizedBox(height: 5.0),
                                  buildPasswordTF(_),
                                  buildForgotPasswordBtn(_),
                                  buildLoginBtn(_),
                                  buildSignInWithText(),
                                  buildSocialBtnRow(_),
                                  buildSignupBtn(_),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ),
          ),
        ),
    );
  }

}
