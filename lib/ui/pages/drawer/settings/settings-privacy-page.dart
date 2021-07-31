import 'package:cyberneom/ui/pages/drawer/settings/neom-settings-controller.dart';
import 'package:cyberneom/ui/pages/drawer/settings/widgets/headerWidget.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/settingsRowWidget.dart';

class SettingsPrivacyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomSettingsController>(
      init: NeomSettingsController(),
      builder: (_) => Scaffold(
        appBar: NeomAppBarChild(NeomConstants.settingsPrivacy.tr),
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: ListView(
        children: <Widget>[
          HeaderWidget(_.neomUserController.neomUser!.name),
          SettingRowWidget(NeomTranslationConstants.account.tr, navigateTo: NeomRouteConstants.SETTINGS_ACCOUNT),
          SettingRowWidget(NeomTranslationConstants.privacyAndPolicy.tr, navigateTo: NeomRouteConstants.PRIVACY_POLICY),
          HeaderWidget(NeomTranslationConstants.general, secondHeader: true,),
          SettingRowWidget(NeomTranslationConstants.aboutCyberneom.tr, navigateTo: NeomRouteConstants.ABOUT),
          HeaderWidget(NeomTranslationConstants.legal.tr),
          SettingRowWidget(NeomTranslationConstants.termsOfService.tr, showDivider: true),
          SettingRowWidget(NeomTranslationConstants.legalNotices.tr, showDivider: true,),
          SettingRowWidget("", showDivider: false, vPadding: 10, subtitle: NeomTranslationConstants.settingPrivacyMsg.tr),
        ],
      ),),
    ),);
  }
}
