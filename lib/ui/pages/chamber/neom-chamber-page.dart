import 'package:cyberneom/ui/pages/chamber/neom-chamber-controller.dart';
import 'package:cyberneom/ui/pages/chamber/widgets/neom-chamber-widgets.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NeomChamberPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomChamberController>(
      id: NeomPageIdConstants.neomChamber,
      init: NeomChamberController(),
      builder: (_) => Scaffold(
        body: Container(
          decoration: NeomAppTheme.neomBoxDecoration,
          height: 800,
          child: _.isLoading ? Center(child: CircularProgressIndicator())
          : Column(
            children: <Widget>[
              Expanded(
                child: buildNeomChamberList(context, _),
              ),
            ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: NeomPageIdConstants.neomChamber,
          elevation: NeomAppTheme.elevationFAB,
          tooltip: NeomTranslationConstants.createNeomChamber.tr,
          child: Icon(Icons.playlist_add),
            onPressed: () => {
              Alert(
                context: context,
                title: NeomTranslationConstants.addNewNeomChamber.tr,
                content: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (text) {
                      _.setNewChamberName(text);
                    },
                    decoration: InputDecoration(
                      labelText: NeomTranslationConstants.neomChamberName.tr,
                      ),
                    ),
                    TextField(
                      onChanged: (text) {
                        _.setNewChamberDesc(text);
                      },
                      decoration: InputDecoration(
                        labelText: NeomTranslationConstants.description.tr,
                      ),
                    ),
                  ],
                  ),
                  buttons: [
                  DialogButton(
                    onPressed: () => {
                     _.createChamber()
                    },
                    child: Text(
                      NeomTranslationConstants.add.tr,
                      style: TextStyle(color: NeomAppColor.darkViolet, fontSize: 20),
                    ),
                    )
                  ]
                ).show()
              },
            ),
        )
    );
  }
}