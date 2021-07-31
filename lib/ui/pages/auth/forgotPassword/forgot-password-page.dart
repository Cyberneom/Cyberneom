import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:cyberneom/ui/pages/auth/forgotPassword/forgot-password-controller.dart';
import 'package:cyberneom/ui/pages/auth/widgets/signup-widgets.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {

 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
        id: NeomPageIdConstants.forgotPassword,
        init: ForgotPasswordController(),
    builder: (_) => Scaffold(
      key: _scaffoldKey,
      appBar: NeomAppBarChild(""),
      body: Container(
          height: NeomAppTheme.fullHeight(context),
          padding: EdgeInsets.symmetric(horizontal: 30),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildLabel(context, NeomTranslationConstants.forgotPassword.tr,
                  NeomTranslationConstants.passwordResetInstruction.tr),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: NeomAppColor.bottomNavigationBar,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: TextField(
                  focusNode: _.focusNode,
                  controller: _.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      hintText: NeomTranslationConstants.enterEmail.tr,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      contentPadding:EdgeInsets.symmetric(vertical: 15,horizontal: 10)
                  ),
                ),
              ),
              // SizedBox(height: 10,),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () {
                      Get.snackbar(
                          NeomTranslationConstants.aboutCyberneom.tr,
                          NeomTranslationConstants.underConstruction.tr,
                          snackPosition: SnackPosition.BOTTOM);
                      //TODO
                      //_.submitForm(context);
                    },
                      style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      backgroundColor: NeomAppColor.dodgetBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(NeomTranslationConstants.send.tr, style: TextStyle(color: Colors.white)),
                  )
              )
            ],)
      ),
    ),);
  }
  
}