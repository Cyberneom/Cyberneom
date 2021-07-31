import 'package:cyberneom/ui/pages/onboarding/onboarding-controller.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/onboarding-frequency-list.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/header-intro.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingFrequencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      id: NeomPageIdConstants.onBoardingFrequencies,
      init: OnBoardingController(),
      builder: (_) => Scaffold(
          body: Container(
            decoration: NeomAppTheme.neomBoxDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                SizedBox(height: 100),
                HeaderIntro(subtitle: NeomTranslationConstants.introFrequency.tr),
                Expanded(child: OnBoardingFrequencyList(),),
                ]
              ),
            ),
      floatingActionButton: _.frequencyController.favFrequencies.values.length == 0 ? Container()
          : FloatingActionButton(
              tooltip: NeomTranslationConstants.next.tr,
              elevation: NeomAppTheme.elevationFAB,
              child: Icon(Icons.navigate_next),
              onPressed: ()=>{
                _.addFrequenciesToNeomProfile()
            },
          ),
      ),
    );
  }
}