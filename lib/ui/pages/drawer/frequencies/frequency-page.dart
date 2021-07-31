import 'package:cyberneom/ui/pages/drawer/frequencies/frequency-controller.dart';
import 'package:cyberneom/ui/pages/drawer/frequencies/widgets/frequency-widgets.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FrequencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FrequencyController>(
      id: NeomPageIdConstants.frequencies,
      init: FrequencyController(),
      builder: (_) => Scaffold(
        appBar:  PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: NeomAppBarChild(NeomTranslationConstants.frequencySelection.tr)),
        body: Container(
          decoration: NeomAppTheme.neomBoxDecoration,
          child: Column(
              children: <Widget>[
                Expanded(
                  child: buildFrequencyList(context, _),
                ),
              ]
          ),
        ),
      ),
    );
  }
}