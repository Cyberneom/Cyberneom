import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-controller.dart';
import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-search-page.dart';
import 'package:cyberneom/ui/pages/chamber/widgets/neom-chamber-widgets.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChamberNeomChamberPresetsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomChamberPresetController>(
      id: NeomPageIdConstants.neomChamberPreset,
      init: NeomChamberPresetController(),
      builder: (_) => Scaffold(
        appBar: NeomAppBarChild(_.neomChamber.name),
        body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: _.isLoading ? Center(child: CircularProgressIndicator())
          :  buildNeomChamberPresetList(context, _)
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.playlist_add),
          tooltip: NeomTranslationConstants.addChamber.tr,
          onPressed: ()=>{
            Get.to(() => NeomChamberPresetSearchPage(), arguments: _.neomChamber)
          },
        ),
      ),
    );
  }
}