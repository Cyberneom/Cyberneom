import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-details-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NeomChamberPresetDetailsPage extends StatelessWidget {

  final textColor = Color.fromRGBO(250, 250, 250, 0.95);

  @override
  Widget build(BuildContext context) {

    var textStyle = TextStyle(fontFamily: NeomAppTheme.fontFamily, color: textColor);

    return GetBuilder<NeomChamberPresetDetailsController>(
        id: NeomPageIdConstants.neomChamberPresetDetails,
        init: NeomChamberPresetDetailsController(),
        builder: (_) => Scaffold(
        body: Stack(children: [ Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: NeomAppTheme.neomBoxDecoration,
          child: _.isLoading ? Center(child: CircularProgressIndicator())
              : Center(
            child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                SizedBox(width: 200, child: _.neomChamberPreset.imgUrl.isEmpty ? Text("") : Image.network(_.neomChamberPreset.imgUrl)),
                SizedBox(height: 20),
                Text(_.neomChamberPreset.name.isEmpty ? ""
                    : _.neomChamberPreset.name.length > NeomConstants.maxNeomChamberNameLength ?
                "${_.neomChamberPreset.name.substring(0,NeomConstants.maxNeomChamberNameLength)}...": _.neomChamberPreset.name,
                    style: textStyle.merge(TextStyle(fontSize: 24))),
                SizedBox(height: 5),
                Text(_.neomChamberPreset.creatorId,
                    style: textStyle.merge(
                        TextStyle(fontSize: 18, color: Colors.white54))),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Container(
                      width: 144,
                      height: 1.5,
                      color: Colors.white54,
                    ),
                    Flexible(
                      child: Container(
                        height: 1.0,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(NeomTranslationConstants.letsOm.tr,
                    style: textStyle.merge(
                        TextStyle(fontSize: 18, color: Colors.white54))),
                SizedBox(height: 15),
                FloatingActionButton(
                  tooltip: NeomTranslationConstants.neomSession.tr,
                  splashColor: NeomAppColor.mystic,
                  onPressed: () => {
                    Get.toNamed(NeomRouteConstants.NEOM_GENERATOR, arguments: [_.neomChamberPreset])
                  },
                  child: Icon(FontAwesomeIcons.om, size: 30,),
                  elevation: 25,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(NeomAppColor.bondiBlue)),
                      child: Row(
                        children: [
                          Icon(_.existsInNeomChamber ? Icons.remove : Icons.add, color: Colors.grey, size: 30),
                          _.existsInNeomChamber ? Text(NeomTranslationConstants.removeFromChamber.tr) : Text(NeomTranslationConstants.addToYourChamber.tr)],
                        ),
                        onPressed: () =>
                        {
                          if (_.existsInNeomChamber) {
                            _.removeNeomChamber()
                          } else {
                            Alert(
                              context: context,
                              title: NeomTranslationConstants.chamberPrefs.tr,
                              content: Column(
                              children: <Widget>[
                                  _.neomChambers.length > 1 ? Obx(()=> DropdownButton<String>(
                                    items: _.neomChambers.values.map((chamber) =>
                                      DropdownMenuItem<String>(value: chamber.id, child: Text(chamber.name),)
                                    ).toList(),
                                    onChanged: (String? selectedChamber) {
                                      _.setSelectedChamber(selectedChamber!);
                                    },
                                    value: _.neomChamberId,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.white),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                  ),) : Text("")
                                ],
                                ),
                                buttons: [
                                DialogButton(
                                    child: Text(NeomTranslationConstants.add.tr,
                                    style: TextStyle(color: Colors.deepPurple, fontSize: 15),
                                  ),
                                  onPressed: () => {
                                    _.addNeomChamberPreset()
                                  },
                                  ),
                                ],
                            ).show()
                          }
                        },
                      ),
                    ],
                  ),
                  Obx(()=> _.wasAdded ? Padding(
                    padding: EdgeInsets.only(top: 10.0), child: ElevatedButton(
                    child: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.playlist_add_check, color: Colors.grey, size: 30),
                          Text(NeomTranslationConstants.goHome.tr),]
                    ),),
                    onPressed: () => _.gotoSelectedNeomChamber()
                )) : Text("")),
             ],
            ),
            ),
            ),
          ),
          Positioned(
            top: 26.0,
            left: 4.0,
            child: BackButton(color: Colors.white),
          )
        ]),
      ),
    );
  }
}