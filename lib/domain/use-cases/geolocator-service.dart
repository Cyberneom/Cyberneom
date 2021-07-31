import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeoLocatorService {

  double distanceBetweenPositions(Position mainUserPos, Position refUserPos);

  Future<Placemark> getPlaceMark(Position currentPos);

  Future<String> getAddressSimple(Position currentPos);

  Future<Position> getCurrentGpsPosition();

  Future<Position> updateLocation(String neomUserId, String neomProfileId,
      Position currentPosition);

}