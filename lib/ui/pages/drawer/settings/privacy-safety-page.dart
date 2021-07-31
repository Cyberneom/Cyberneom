import 'package:cyberneom/ui/pages/drawer/settings/widgets/headerWidget.dart';
import 'package:cyberneom/ui/pages/drawer/settings/widgets/settingsRowWidget.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:flutter/material.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySafetyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeomAppBarChild('Privacy and Safety'),
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          HeaderWidget('Posts'),
          SettingRowWidget(
            "We protect what you share",
            subtitle:
                'Only people you approve to be your Neommate in future after a Neom Session will be able to see your posts, chambers, presets, etc.',
            vPadding: 15,
            showDivider: false,
            visibleSwitch: true,
          ),
          HeaderWidget(
            'Discoverability',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Navigate and entrain",
            subtitle:
            'You will be able to discover people through our feed and joining to our Neom Clusters once available.',
            vPadding: 15,
            showDivider: false,
          ),
          HeaderWidget(
            'Connectivity',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Cyberneom Way",
            subtitle:
                'Learn more about how this data is used to connect you with people through your root frequencies',
            vPadding: 15,
            showDivider: false,
          ),
          HeaderWidget(
            'Location',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Precise location",
            subtitle:
                'If enabled, cyberneom will collect, store, and use your device\'s precise location, such as your GPS information.'
                    ' This lets us improve your experience - For example, showing you more local neommates, content and recommendations.',
          ),
          SettingRowWidget(
              NeomTranslationConstants.privacyAndPolicy.tr,
              showDivider: true,
              onPressed: (){
                launch("https://cyberneom.io/politica-de-privacidad/");
              }
          ),
        ],
      ),),
    );
  }
}
