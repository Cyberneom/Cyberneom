import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-search-controller.dart';
import 'package:cyberneom/ui/pages/chamber/widgets/neom-chamber-widgets.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeomChamberPresetSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomChamberPresetSearchController>(
        id: NeomPageIdConstants.neomChamberPreset,
        init: NeomChamberPresetSearchController(),
        builder: (_) => Scaffold(
          appBar: NeomAppBarChild(NeomTranslationConstants.presetSearch.tr),
          body: Container(
              decoration: NeomAppTheme.neomBoxDecoration,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: NeomTranslationConstants.search.tr,
                          hintText: NeomTranslationConstants.search.tr,
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0))
                          ),
                      ),
                      onChanged: (text) {
                        //TODO
                        NeomUtilities.showAlert(context, NeomTranslationConstants.aboutCyberneom.tr, NeomTranslationConstants.underConstruction.tr);
                      },
                    ),
                  ),
                  Expanded(child: buildNeomChamberPresetSearchList(context, _))
                ],
              ),
            ),
        )
    );
  }
}