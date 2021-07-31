import 'package:cyberneom/ui/pages/drawer/settings/neom-account-settings-controller.dart';
import 'package:cyberneom/ui/pages/drawer/settings/widgets/headerWidget.dart';
import 'package:cyberneom/ui/pages/drawer/settings/widgets/settingsRowWidget.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomAccountSettingsController>(
      init: NeomAccountSettingsController(),
      builder: (_) => Scaffold(
      appBar: NeomAppBarChild(NeomTranslationConstants.accountSettings.tr),
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: ListView(
        children: <Widget>[
          HeaderWidget(NeomTranslationConstants.loginAndSecurity.tr),
          SettingRowWidget(
            NeomTranslationConstants.username.tr,
            subtitle: _.neomUserController.neomUser!.name,
          ),
          Divider(height: 0),
          SettingRowWidget(
            NeomTranslationConstants.phone.tr,
            subtitle: "${_.neomUserController.neomUser!.countryCode}${_.neomUserController.neomUser!.phoneNumber}",
          ),
          SettingRowWidget(
            NeomTranslationConstants.emailAddress.tr,
            subtitle: _.neomUserController.neomUser!.email,
          ),
          Divider(height: 0),
          SettingRowWidget(NeomTranslationConstants.removeAccount.tr,  textColor:NeomAppColor.ceriseRed,
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text(NeomTranslationConstants.removeThisAccount.tr),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: Text(
                              NeomTranslationConstants.remove.tr,
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Get.toNamed(NeomRouteConstants.ACCOUNT_REMOVE, arguments: [NeomRouteConstants.ACCOUNT_SETTINGS]);
                            },
                          ),
                          SimpleDialogOption(
                            child: Text(
                              NeomTranslationConstants.cancel.tr,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
                //final state = Provider.of<AuthState>(context);
                //state.logoutCallback();
             },
          ),
        ],
      ),
    ),),
    );
  }
}
