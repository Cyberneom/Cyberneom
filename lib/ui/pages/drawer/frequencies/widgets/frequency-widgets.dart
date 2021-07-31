import 'package:cyberneom/ui/pages/drawer/frequencies/frequency-controller.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:get/get.dart';

Widget buildFrequencyFavList(BuildContext context, FrequencyController _) {
  return ListView.builder(
    itemBuilder: (__, index) {
      NeomFrequency frequency = _.favFrequencies.values.toList()[index];
      String scaleDegree = EnumToString.convertToString(frequency.scaleDegree);

      return ListTile(
          title: Text(frequency.name.tr),
          subtitle: Text(frequency.isRoot ?
          "${NeomTranslationConstants.rootFrequency.tr} ${scaleDegree != NeomTranslationConstants.defaulScaleDegree.tr ? " - $scaleDegree" : ""}"
              : "${scaleDegree != NeomTranslationConstants.defaulScaleDegree.tr ? scaleDegree : ""}"),
          leading: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text(frequency.frequency.toString()),Text(NeomConstants.HZ),],),
          trailing: IconButton(
              icon: Icon(
                Icons.toc,
              ),
              onPressed: () {
                _.makeRootFrequency(frequency);
                NeomUtilities.showAlert(context, NeomTranslationConstants.frequencyPreferences.tr, "${frequency.name.tr} ${NeomTranslationConstants.selectedAsRootFrequency.tr}");
              })
      );
    },
    itemCount: _.favFrequencies.length,
  );
}

Widget buildFrequencyList(BuildContext context, FrequencyController _) {
  return ListView.separated(
    itemBuilder:  (context, index) => Divider(),
    separatorBuilder: (__, index) {
      NeomFrequency frequency = _.frequencies.values.elementAt(index);
      if (_.favFrequencies[frequency.id] != null) {
        frequency = _.favFrequencies[frequency.id]!;
      }
      return ListTile(
          title: Text(frequency.name.tr),
          trailing: IconButton(
              icon: Icon(
                frequency.isFav? Icons.remove : Icons.add,
              ),
              onPressed: () async {
                //_.onFavorite(index, !frequency.isFavorite);
                if(frequency.isFav){

                  await _.removeFrequency(index);

                  if(_.favFrequencies.containsKey(frequency.id)) {
                    NeomUtilities.showAlert(context, frequency.name.tr, MessageTranslationConstants.frequencyNotRemoved.tr);
                  } else {
                    NeomUtilities.showAlert(context, frequency.name.tr, MessageTranslationConstants.frequencyRemoved.tr);
                  }
                } else {
                  await _.addFrequency(index);
                  if(_.favFrequencies.containsKey(frequency.id)) {
                    NeomUtilities.showAlert(context, frequency.name.tr, MessageTranslationConstants.frequencyAdded.tr);
                  } else {
                    NeomUtilities.showAlert(context, frequency.name.tr, MessageTranslationConstants.frequencyNotAdded.tr);
                  }
                }
              }
          )
      );
    },
    itemCount: _.frequencies.length,
  );
}