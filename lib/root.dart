import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_commons/auth/ui/login/login_controller.dart';
import 'package:neom_commons/core/ui/static/splash_page.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_constants.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/auth_status.dart';
import 'package:neom_home/home/ui/home_controller.dart';
import 'package:neom_home/home/ui/home_page.dart';
import 'package:neom_home/home/utils/constants/home_constants.dart';
import 'package:upgrader/upgrader.dart';

import 'neom_constants.dart';

class Root extends StatelessWidget {

  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        HomeController homeController;
        try {
          homeController = Get.find<HomeController>();
        } catch (e) {
          homeController = Get.put(HomeController());
          AppUtilities.logger.e(e.toString());
        }

        try {
          if((homeController.currentIndex != HomeConstants.firstTabIndex)
          || (homeController.timelineController.timelineScrollController.offset != 0.0)) {
            homeController.selectPageView(HomeConstants.firstTabIndex);
            return false;
          }
        } catch (e) {
          AppUtilities.logger.e(e.toString());
        }

        return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColor.getMain(),
            title: const Text(AppConstants.appTitle),
            content:  Text(AppTranslationConstants.wantToCloseApp.tr),
            actions: <Widget>[
              TextButton(
                child: Text(AppTranslationConstants.no.tr,
                  style: const TextStyle(color: AppColor.white),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text(AppTranslationConstants.yes.tr,
                  style: const TextStyle(color: AppColor.white),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          ),
        )) ?? false;
      },
      child: GetBuilder<LoginController>(
        id: AppPageIdConstants.login,
        init: LoginController(),
        builder: (_) => UpgradeAlert(
            upgrader: Upgrader(
              minAppVersion: NeomConstants.lastStableVersion,
            ),
            child: (_.authStatus == AuthStatus.waiting) ?
            const SplashPage() : _.selectRootPage(homePage: const HomePage(), appLastStableBuild: NeomConstants.lastStableBuild)
        )
      )
    );
  }
}
