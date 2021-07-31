import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-controller.dart';
import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-search-controller.dart';
import 'package:cyberneom/ui/pages/chamber/neom-chamber-controller.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:transparent_image/transparent_image.dart';

Widget buildNeomChamberList(BuildContext context, NeomChamberController _) {
  return ListView.builder(
    itemCount: _.neomChambers.length,
    itemBuilder: (__, index) {
      NeomChamber neomChamber = _.neomChambers.values.elementAt(index);
      return GestureDetector(
        child: ListTile(
          title: Row(children: <Widget>[Text(neomChamber.name + " "), neomChamber.isFav ? Icon(Icons.favorite, size: 10,) : Text("")]),
          subtitle: Text(neomChamber.description),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ActionChip(
                  backgroundColor: NeomAppColor.bottomNavigationBar,
                  avatar: CircleAvatar(
                    backgroundColor: NeomAppColor.darkViolet,
                    child: Text(neomChamber.neomChamberPresets!.length.toString()),
                  ),
                  label: Icon(Icons.add),
                  onPressed: () {
                    Get.toNamed(NeomRouteConstants.PRESET_SEARCH, arguments: neomChamber);
                  },
                ),
              ]
          ),
        ),
        onTap: () {
          _.goToNeomChamberPresets(neomChamber);
        },
        onLongPress: () {
          Alert(
              context: context,
              title: NeomTranslationConstants.chamberPrefs.tr,
              content: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (text) {
                      _.setUpdateChamberName(text);
                    },
                    decoration: InputDecoration(
                      labelText: NeomTranslationConstants.changeName.tr +': ',
                      hintText: neomChamber.name,
                    ),
                  ),
                  TextField(
                    onChanged: (text) {
                      _.setUpdateChamberDesc(text);
                    },
                    decoration: InputDecoration(
                      labelText: NeomTranslationConstants.changeDesc.tr +': ',
                      hintText: neomChamber.description,
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () => {
                    _.updateChamber(neomChamber.id, neomChamber)
                  },
                  child: Text(
                    NeomTranslationConstants.update.tr,
                    style: TextStyle(color: Colors.deepPurple, fontSize: 15),
                  ),
                ),
                DialogButton(
                  onPressed: () => {
                    neomChamber.isFav ?
                    NeomUtilities.showAlert(context,
                        NeomTranslationConstants.chamberPrefs.tr,
                        NeomTranslationConstants.cantRemoveMainChamber.tr)
                        : _.deleteChamber(neomChamber)
                  },
                  child: Text(NeomTranslationConstants.remove.tr,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                if(!neomChamber.isFav) DialogButton(
                  onPressed: () => {
                    _.setAsFavorite(neomChamber)
                  },
                  child: Text(NeomTranslationConstants.setFav.tr,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ]
          ).show();
        },
      );
    },
  );
}

Widget buildNeomChamberPresetList(BuildContext context, NeomChamberPresetController _) {
  return ListView.builder(
    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
    itemCount: _.neomChamberPresets.length,
    itemBuilder: (context, index) {
      NeomChamberPreset neomChamberPreset = _.neomChamberPresets.values.elementAt(index);
      return ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        title: Text(neomChamberPreset.name),
        subtitle: Text(neomChamberPreset.creatorId.isEmpty ? ""
            : neomChamberPreset.creatorId.length > NeomConstants.maxCreatorNameLength
            ? "${neomChamberPreset.creatorId.substring(0,NeomConstants.maxCreatorNameLength)}..."
            : neomChamberPreset.creatorId),
        onTap: () => _.getNeomChamberPresetDetails(neomChamberPreset),
        leading: Hero(
          tag: NeomAppTheme.getLeadingHeroTag(index),
          child: neomChamberPreset.imgUrl.isEmpty? Text("") : FadeInImage.memoryNetwork(
              width: 56.0,
              placeholder: kTransparentImage,
              image: neomChamberPreset.imgUrl,
              fadeInDuration: Duration(milliseconds: 500)
          ),
        ),
      );
    },
  );
}

Widget buildNeomChamberPresetSearchList(BuildContext context, NeomChamberPresetSearchController _) {
  return ListView.builder(
    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
    itemCount: _.neomChamberPresets.length,
    itemBuilder: (context, index) {
      NeomChamberPreset neomChamberPreset = _.neomChamberPresets.values.elementAt(index);
      return ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        title: Text(neomChamberPreset.name),
        subtitle: Text(neomChamberPreset.creatorId.isEmpty ? ""
            : neomChamberPreset.creatorId.length > NeomConstants.maxCreatorNameLength
            ? "${neomChamberPreset.creatorId.substring(0,NeomConstants.maxCreatorNameLength)}..."
            : neomChamberPreset.creatorId),
        onTap: () => _.getNeomChamberPresetDetails(neomChamberPreset),
        leading: Hero(
          tag: NeomAppTheme.getLeadingHeroTag(index),
          child: neomChamberPreset.imgUrl.isEmpty? Text("") : FadeInImage.memoryNetwork(
              width: 56.0,
              placeholder: kTransparentImage,
              image: neomChamberPreset.imgUrl,
              fadeInDuration: Duration(milliseconds: 500)
          ),
        ),
      );
    },
  );
}