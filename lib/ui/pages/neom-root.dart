import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-page.dart';
import 'package:cyberneom/ui/pages/home/neom-home-page.dart';
import 'package:cyberneom/ui/pages/static/splash-page.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/enum/auth-status.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeomRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      id: NeomPageIdConstants.loginPage,
      init: LoginController(),
      builder: (_) => _.isLoading || _.authStatus == AuthStatus.WAITING ? SplashPage()
          : _.authStatus == AuthStatus.LOGGED_IN && _.neomApp.version ==
          NeomConstants.neomVersion && _.neomUserController.neomUser!.id.isNotEmpty ? NeomHomePage()
          : LoginPage()
    );
  }
}