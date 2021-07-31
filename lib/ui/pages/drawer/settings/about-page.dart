
import 'package:cyberneom/ui/pages/drawer/settings/widgets/headerWidget.dart';
import 'package:cyberneom/ui/pages/drawer/settings/widgets/settingsRowWidget.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeomAppBarChild(NeomTranslationConstants.aboutCyberneom.tr),
      body: Container(
      decoration: NeomAppTheme.neomBoxDecoration,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          HeaderWidget(NeomTranslationConstants.legal.tr),
          SettingRowWidget(
            NeomTranslationConstants.termsOfService.tr,
            showDivider: true,
            onPressed: (){
              NeomUtilities.showAlert(context, NeomTranslationConstants.aboutCyberneom.tr, NeomTranslationConstants.underConstruction.tr);
            },
          ),
          SettingRowWidget(
            NeomTranslationConstants.legalNotices.tr,
            showDivider: true,
            onPressed: () async {
              showLicensePage(
                context: context,
                applicationName: NeomConstants.cyberneom_title,
                applicationVersion: NeomConstants.neomVersion,
                useRootNavigator: true,
              );
            },
          ),
          HeaderWidget(NeomTranslationConstants.websites.tr),
          SettingRowWidget(
              NeomConstants.cyberneom_title,
              showDivider: true,
              onPressed: (){
                launch("https://www.cyberneom.io");
              }
          ),
          HeaderWidget(NeomTranslationConstants.developer.tr),
          SettingRowWidget(
            NeomConstants.github,
            showDivider: true,
            onPressed: (){
              launch("https://github.com/emmanuel-montoya/");
            }
          ),
          SettingRowWidget(
            NeomConstants.linkedin,
            showDivider: true,
            onPressed: (){
              launch("https://www.linkedin.com/in/emmanuel-montoyae/");
            }
          ),
          SettingRowWidget(
            NeomConstants.twitter,
            showDivider: true,
            onPressed: (){
              NeomUtilities.showAlert(context, NeomTranslationConstants.aboutCyberneom.tr, NeomTranslationConstants.underConstruction.tr);
            }
          ),
          SettingRowWidget(
            NeomConstants.blog,
            showDivider: true,
            onPressed: (){
              launch("https://cyberneom.io/blog");
            }
          ),
        ],
      ),
      ),
    );
  }
}
