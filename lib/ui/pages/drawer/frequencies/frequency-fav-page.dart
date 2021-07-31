import 'package:cyberneom/ui/pages/drawer/frequencies/frequency-controller.dart';
import 'package:cyberneom/ui/pages/drawer/frequencies/widgets/frequency-widgets.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';

class FrequencyFavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FrequencyController>(
      id: NeomPageIdConstants.frequencies,
      init: FrequencyController(),
      builder: (_) => Scaffold(
        appBar: NeomAppBarChild(""),
        body: _.isLoading ? Center(child: CircularProgressIndicator())
            : Container(
          decoration: NeomAppTheme.neomBoxDecoration,
          height: 800,
          child: Column(
              children: <Widget>[
                Expanded(
                  child: buildFrequencyFavList(context, _),
                ),
              ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: NeomTranslationConstants.addFrequency.tr,
          onPressed: ()=>{
            Get.toNamed(NeomRouteConstants.FREQUENCIES)
          },
        ),
      ),
    );
  }
}