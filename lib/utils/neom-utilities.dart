import 'dart:convert';
import 'package:cyberneom/data/implementations/geolocator-service-impl.dart';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';


class NeomUtilities {

  static final logger = Logger(printer: PrettyPrinter(
    methodCount: 5,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ));

  static final kAnalytics = FirebaseAnalytics();

  static void showAlert(context, title,  message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(NeomTranslationConstants.close.tr),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }


  static Position jsonToPosition(positionSnapshot){
    Position position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    try {
      dynamic positionJSON = jsonDecode(positionSnapshot);
      double longitude = positionJSON['longitude'];
      double latitude = positionJSON['latitude'];
      DateTime timestamp = DateTime.now();
      double accuracy = positionJSON['accuracy'];
      double altitude = positionJSON['altitude'];
      double heading = positionJSON['heading'];
      double speed = positionJSON['speed'];
      double speedAccuracy = positionJSON['speed_accuracy'];
      bool isMocked = positionJSON['is_mocked'];

      position =  Position(longitude: longitude, latitude: latitude, timestamp: timestamp,
          accuracy: accuracy, altitude: altitude, heading: heading, speed: speed,
          speedAccuracy: speedAccuracy, isMocked: isMocked);
    } catch (e) {
      logger.d(e.toString());
    }

    return position;
  }


  static Future<String> getPlaceMarkAddress(Position position) async {
    logger.d("");

    Placemark placeMark = await GeoLocatorServiceImpl().getPlaceMark(position);
    String? country = placeMark.country;
    String? locality = placeMark.locality;
    String address = "$locality, $country";
    logger.d(address);

    return address;
  }


  static String getFrequencies(NeomProfile neomProfile){
    logger.d("start");
    String frequencies = "";
    String rootFrequency = "";

    int index = 1;
    neomProfile.rootFrequencies!.forEach((key, value) {
      if (index < neomProfile.rootFrequencies!.length) {
        index++;
      }
    });

    if(frequencies.length > NeomConstants.maxFrequencyNameLength) {
      frequencies = "${frequencies.substring(0,NeomConstants.maxFrequencyNameLength)}...";

    }
    logger.d("closed");
    return rootFrequency.isEmpty ? frequencies
        : rootFrequency;
  }

  static String createCompositeNeomInboxId(List<String> neomProfileIds){
    StringBuffer compositeKeyBuffer = StringBuffer();
    neomProfileIds.forEach((element) {
      compositeKeyBuffer.write("${element}_");
    });
    logger.d(compositeKeyBuffer.toString());
    return compositeKeyBuffer.toString();
  }


  static List<DateTime> getTwoWeeksFromNow(){

    List<DateTime> dates = [];
    DateTime dateTimeNow = DateTime.now();
    dates.add(dateTimeNow);
    dates.add(dateTimeNow.add(Duration(days: 1)));
    dates.add(dateTimeNow.add(Duration(days: 2)));
    dates.add(dateTimeNow.add(Duration(days: 3)));
    dates.add(dateTimeNow.add(Duration(days: 4)));
    dates.add(dateTimeNow.add(Duration(days: 5)));
    dates.add(dateTimeNow.add(Duration(days: 6)));
    dates.add(dateTimeNow.add(Duration(days: 7)));
    dates.add(dateTimeNow.add(Duration(days: 8)));
    dates.add(dateTimeNow.add(Duration(days: 9)));
    dates.add(dateTimeNow.add(Duration(days: 10)));
    dates.add(dateTimeNow.add(Duration(days: 11)));
    dates.add(dateTimeNow.add(Duration(days: 12)));
    dates.add(dateTimeNow.add(Duration(days: 13)));
    dates.add(dateTimeNow.add(Duration(days: 14)));

    return dates;
  }


  String getRootFrequency(Map<String, NeomFrequency> frequencies){

    NeomFrequency rootFrequency = NeomFrequency();
    frequencies.values.forEach((frequency) {
      if(frequency.isRoot) rootFrequency = frequency;
    });

    return rootFrequency.name;
  }

  static Map<String, NeomChamberPreset> getTotalNeomChamberPresets(Map<String, NeomChamber> neomChambers){
    Map<String, NeomChamberPreset> totalNeomChambers = Map();

    neomChambers.forEach((key, chamber) {
      chamber.neomChamberPresets!.forEach((preset) {
        totalNeomChambers[preset.id] = preset;
      });
    });

    return totalNeomChambers;
  }




}