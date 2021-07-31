import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UnderConstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (_) => Scaffold(
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: Center(
          child: Text(NeomTranslationConstants.underConstruction.tr, style: TextStyle(fontSize: 20),),
          ),
        ),
      ),
    );
  }

}
