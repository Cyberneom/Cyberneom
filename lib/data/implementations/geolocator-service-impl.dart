import 'dart:async';

import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/domain/use-cases/geolocator-service.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class GeoLocatorServiceImpl implements GeoLocatorService {

  var logger = NeomUtilities.logger;

  double distanceBetweenPositions(Position mainUserPos, Position refUserPos){

    double mainLatitude = mainUserPos.latitude;
    double mainLongitude = mainUserPos.longitude;
    double refLatitude = refUserPos.latitude;
    double refLongitude = refUserPos.longitude;

    double distanceInMeters = Geolocator.distanceBetween(mainLatitude, mainLongitude, refLatitude, refLongitude);
    logger.d("distance between users $distanceInMeters");

    double distanceInKms = distanceInMeters / 1000;

    return distanceInKms.roundToDouble();
  }

  Future<Placemark> getPlaceMark(Position currentPos) async {

    List<Placemark> placeMarks = await placemarkFromCoordinates(currentPos.latitude, currentPos.longitude);

    Placemark placeMark  = placeMarks[0];
    String name = placeMark.name!;
    String subLocality = placeMark.subLocality!;
    String locality = placeMark.locality!;
    String administrativeArea = placeMark.administrativeArea!;
    String postalCode = placeMark.postalCode!;
    String country = placeMark.country!;
    String address = "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";

    logger.d(address);

    return placeMark;
  }

  Future<String> getAddressSimple(Position currentPos) async {
    logger.d(currentPos.toString());
    String address = "";

    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(currentPos.latitude, currentPos.longitude);
      Placemark placeMark  = placeMarks[0];
      String locality = placeMark.locality!;
      String administrativeArea = placeMark.administrativeArea!;
      String country = placeMark.country!;

      locality.isNotEmpty ?
        address = "$locality, $country"
          : address = "$administrativeArea, $country" ;
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d(address);
    return address;
  }

  Future<Position> getCurrentGpsPosition() async {
    Position position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(),
        accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      logger.d("Position: ${position.toString()}");
    } catch (e) {
      logger.d(e.toString());
    }

    return position;
  }

  Future<Position> updateLocation(String neomUserId, String neomProfileId, Position? currentPosition) async {
    logger.d("");
    Position newPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(),
        accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);

    try {
      newPosition =  (await GeoLocatorServiceImpl().getCurrentGpsPosition());
      if(currentPosition != null) {
        double distance = distanceBetweenPositions(currentPosition, newPosition);
        if(distance > NeomConstants.significantDistanceKM){
          logger.d("GpsLocation would be updated as distance difference is significant");
          if(await NeomProfileFirestore().updateGpsPosition(neomUserId, neomProfileId, newPosition)){
            logger.i("GpsLocation was updated as distance was significant " + distance.toString() + "Kms");
          }
        } else {
          return currentPosition;
        }
      } else {
        if(await NeomProfileFirestore().updateGpsPosition(neomUserId, neomProfileId, newPosition)){
          logger.i("GpsLocation was updated as there was no data for it");
        }
      }

    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("updateLocation method Exit");
    return newPosition;
  }

}