import 'package:cyberneom/ui/pages/drawer/settings/widgets/customUrlText.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingRowWidget extends StatelessWidget {

  final bool visibleSwitch, showDivider;
  final String navigateTo;
  final String subtitle, title;
  final Color textColor;
  final  Function? onPressed;
  final double vPadding;

  SettingRowWidget(
    this.title, {
    Key? key,
    this.navigateTo = "",
    this.subtitle = "",
    this.textColor = Colors.white70,
    this.onPressed,
    this.vPadding = 0,
    this.showDivider = true,
    this.visibleSwitch = true,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: 18),
          onTap: () {
            if (onPressed != null) {
              onPressed!();
            }
            if (navigateTo.isEmpty) {
              return;
            }

            navigateTo != NeomRouteConstants.UNDER_CONSTRUCTION ?
              Get.toNamed(navigateTo)
                : NeomUtilities.showAlert(context, title, NeomTranslationConstants.underConstruction.tr);
          },
          title: UrlText(
                  text: title,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
          subtitle: UrlText(
                  text: subtitle,
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w400),
                ),
        ),
        !showDivider ? SizedBox() : Divider(height: 0)
      ],
    );
  }
}

