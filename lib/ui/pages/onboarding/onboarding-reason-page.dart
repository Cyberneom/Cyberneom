import 'package:cyberneom/ui/pages/onboarding/onboarding-controller.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/onboarding-widgets.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/header-intro.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/enum/neom-reason.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingReasonPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
        id: NeomPageIdConstants.onBoardingNeomReason,
        init: OnBoardingController(),
        builder: (_) => Scaffold(
          body: Container(
            decoration: NeomAppTheme.neomBoxDecoration,
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HeaderIntro(subtitle: NeomTranslationConstants.introNeomReason.tr),
                SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    buildActionChip(neomEnum: NeomReason.Curiosity,
                        controllerFunction: _.setNeomReason),
                    SizedBox(height: 10),
                    buildActionChip(neomEnum: NeomReason.Professional,
                        controllerFunction: _.setNeomReason),
                    SizedBox(height: 10),
                    buildActionChip(neomEnum: NeomReason.Research,
                        controllerFunction: _.setNeomReason),
                    SizedBox(height: 10),
                    buildActionChip(neomEnum: NeomReason.Other,
                        controllerFunction: _.setNeomReason),
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