import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cyberneom/utils/neom-utilities.dart';


class NeomEventPlace {

  String placeId;
  String placeName;
  String address;
  String ownerName;
  String ownerId;
  String imgUrl;
  Position? position;


  NeomEventPlace({
    this.placeId = "",
    this.placeName = "",
    this.address = "",
    this.ownerName = "",
    this.ownerId = "",
    this.imgUrl = "",
    this.position
  });



  @override
  String toString() {
    return 'NeomEventPlace{placeId: $placeId, placeName: $placeName, address: $address, ownerName: $ownerName, ownerId: $ownerId, imgUrl: $imgUrl, position: $position}';
  }


  NeomEventPlace.fromDocumentSnapshot({required QueryDocumentSnapshot documentSnapshot}):
    placeId = documentSnapshot.id,
    placeName = documentSnapshot.get("placeName"),
    address = documentSnapshot.get("address"),
    ownerName = documentSnapshot.get("ownerName"),
    ownerId = documentSnapshot.get("ownerId"),
    imgUrl = documentSnapshot.get("imgUrl"),
    position= NeomUtilities.jsonToPosition(documentSnapshot.get("position"));


  Map<String, dynamic> toJSON()=>{
    //'neomEventId': id, generated in firebase
    'placeName': placeName,
    'address': address,
    'ownerName': ownerName,
    'ownerId': ownerId,
    'imgUrl': imgUrl,
    'position': jsonEncode(position),
  };

  NeomEventPlace.fromMap(Map<dynamic, dynamic> data):
    placeId = data["placeId"] ?? "",
    placeName = data["placeName"],
    address = data["address"],
    ownerName = data["ownerName"],
    ownerId = data["ownerId"],
    imgUrl = data["imgUrl"],
    position = NeomUtilities.jsonToPosition(data["position"]);


}
