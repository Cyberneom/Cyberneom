import 'package:cyberneom/ui/pages/onboarding/onboarding-controller.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/onboarding-widgets.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/header-intro.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/enum/neom-locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingLocalePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: NeomPageIdConstants.onBoardingNeomProfile,
        init: OnBoardingController(),
        builder: (_) => Scaffold(
          body: Container(
            decoration: NeomAppTheme.neomBoxDecoration,
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderIntro(subtitle: NeomTranslationConstants.introLocale.tr),
                SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildActionChip(neomEnum: NeomLocale.English,
                        controllerFunction: _.setLocale),
                    SizedBox(height: 10),
                    buildActionChip(neomEnum: NeomLocale.Spanish,
                        controllerFunction: _.setLocale),
                    SizedBox(height: 10),
                    buildActionChip(neomEnum: NeomLocale.French,
                        controllerFunction: _.setLocale, isActive: false),
                    SizedBox(height: 10),
                    buildActionChip(neomEnum: NeomLocale.Deutsch,
                        controllerFunction: _.setLocale, isActive: false),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}