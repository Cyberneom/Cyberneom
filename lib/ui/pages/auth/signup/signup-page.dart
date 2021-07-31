import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/auth/signup/signup-controller.dart';
import 'package:cyberneom/ui/pages/auth/widgets/signup-widgets.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';


class SignupPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      id: NeomPageIdConstants.signUp,
      init: SignUpController(),
      builder: (_) => Scaffold(
      appBar: NeomAppBarChild(""),
      body: SingleChildScrollView(
        child: Container(
          height: NeomAppTheme.fullHeight(context),
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildLabel(context, NeomTranslationConstants.welcomeToCyberneom.tr, NeomTranslationConstants.youWillFindMsg.tr),
                buildTwoEntryFields(NeomTranslationConstants.firstName.tr, NeomTranslationConstants.lastName.tr,
                    firstController: _.firstNameController, secondController: _.lastNameController, context: context),
                buildEntryField(NeomTranslationConstants.username.tr, controller: _.usernameController),
                buildEntryField(NeomTranslationConstants.enterEmail.tr,
                    controller: _.emailController, isEmail: true),
                buildEntryField(NeomTranslationConstants.enterPassword.tr,
                    controller: _.passwordController, isPassword: true),
                buildEntryField(NeomTranslationConstants.confirmPassword.tr,
                    controller: _.confirmController, isPassword: true),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () => _.submit(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      backgroundColor: NeomAppColor.dodgetBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),),
                    child: Text(NeomTranslationConstants.signUp.tr, style: TextStyle(color: Colors.white,fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
                  ),
                ),
                Divider(height: 30),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }



}
