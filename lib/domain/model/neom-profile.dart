import 'dart:convert';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/utils/enum/neom-reason.dart';
import 'package:cyberneom/utils/enum/neom-profile-type.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class NeomProfile {

  String id;
  String name;
  Position? position;
  String photoUrl;
  String coverImgUrl;
  String aboutMe;
  String rootFrequency;
  bool isActive;

  NeomProfileType? type;
  NeomReason? neomReason;

  List<String>? favGenres;
  List<String>? bannedGenres;
  List<String> neommates;
  List<String> followers;
  List<String> following;
  List<String> neomPosts;
  List<String>? neomTribes;
  List<String>? neomEvents;
  List<String>? neomClusterIds;
  Map<String,NeomChamber>? neomChambers;
  Map<String,NeomFrequency>? rootFrequencies;

  NeomProfile({
      this.id = "",
      this.name = "",
      this.position,
      this.photoUrl = "",
      this.coverImgUrl = "",
      this.type,
      this.aboutMe = "",
      this.neomReason,
      this.rootFrequency = "",
      this.isActive = false,
      this.neommates = const [],
      this.followers = const [],
      this.following = const [],
      this.neomPosts = const [],
      });


  @override
  String toString() {
    return 'NeomProfile{id: $id, name: $name, position: $position, photoUrl: $photoUrl, coverImgUrl: $coverImgUrl, aboutMe: $aboutMe, rootFrequency: $rootFrequency, isActive: $isActive, type: $type, neomReason: $neomReason, favGenres: $favGenres, bannedGenres: $bannedGenres, neommates: $neommates, followers: $followers, following: $following, neomPosts: $neomPosts, neomTribes: $neomTribes, neomEvents: $neomEvents, neomClusterIds: $neomClusterIds, neomChambers: $neomChambers, rootFrequencies: $rootFrequencies}';
  }


  Map<String, dynamic> toJSON() {
    Get.log("NeomProfile toJSON");
    return <String, dynamic>{
      'name': name,
      'position': jsonEncode(position),
      'photoUrl': photoUrl,
      'coverImgUrl': coverImgUrl,
      'aboutMe': aboutMe,
      'rootFrequency': rootFrequency,
      'isActive': isActive,
      'type': EnumToString.convertToString(type),
      'neomReason': EnumToString.convertToString(neomReason),
      'favGenres': favGenres,
      'bannedGenres': bannedGenres,
      'neommates': neommates,
      'following': following,
      'followers': followers,
      'neomPosts': neomPosts,
      'neomTribes': neomTribes,
      'neomEvents': neomEvents,
      'neomClusterIds': neomClusterIds,
    };
  }

  NeomProfile.fromQueryDocumentSnapshot({required QueryDocumentSnapshot queryDocumentSnapshot}) :
    id = queryDocumentSnapshot.id,
    name = queryDocumentSnapshot.get("name"),
    position = NeomUtilities.jsonToPosition(queryDocumentSnapshot.get("position")),
    photoUrl = queryDocumentSnapshot.get("photoUrl"),
    coverImgUrl = queryDocumentSnapshot.get("coverImgUrl"),
    type = EnumToString.fromString(NeomProfileType.values, queryDocumentSnapshot.get("type")),
    aboutMe = queryDocumentSnapshot.get("aboutMe"),
    neomReason = EnumToString.fromString(NeomReason.values, queryDocumentSnapshot.get("neomReason")),
    rootFrequency = queryDocumentSnapshot.get("rootFrequency"),
    isActive = queryDocumentSnapshot.get("isActive"),
    favGenres =  List.from(queryDocumentSnapshot.get("favGenres") ?? []),
    bannedGenres =  List.from(queryDocumentSnapshot.get("bannedGenres")?? []),
    neommates = List.from(queryDocumentSnapshot.get("neommates")?? []),
    following = List.from(queryDocumentSnapshot.get("following")?? []),
    followers = List.from(queryDocumentSnapshot.get("followers")?? []),
    neomPosts = List.from(queryDocumentSnapshot.get("neomPosts")),
    neomTribes = List.from(queryDocumentSnapshot.get("neomTribes")?? []),
    neomEvents = List.from(queryDocumentSnapshot.get("neomEvents")?? []),
    neomClusterIds = List.from(queryDocumentSnapshot.get("neomClusterIds")?? []);


  NeomProfile.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) :
    id = documentSnapshot.id,
    name = documentSnapshot.get("name"),
    position = NeomUtilities.jsonToPosition(documentSnapshot.get("position")),
    photoUrl = documentSnapshot.get("photoUrl"),
    coverImgUrl = documentSnapshot.get("coverImgUrl"),
    type = EnumToString.fromString(NeomProfileType.values, documentSnapshot.get("type")),
    aboutMe = documentSnapshot.get("aboutMe"),
    neomReason = EnumToString.fromString(NeomReason.values, documentSnapshot.get("neomReason")),
    rootFrequency = documentSnapshot.get("rootFrequency"),
    isActive = documentSnapshot.get("isActive"),
    favGenres =  List.from(documentSnapshot.get("favGenres")),
    bannedGenres =  List.from(documentSnapshot.get("bannedGenres")),
    neommates = List.from(documentSnapshot.get("neommates")),
    following = List.from(documentSnapshot.get("following")),
    followers = List.from(documentSnapshot.get("followers")),
    neomPosts = List.from(documentSnapshot.get("neomPosts")),
    neomTribes = List.from(documentSnapshot.get("neomTribes")),
    neomEvents = List.from(documentSnapshot.get("neomEvents")),
    neomClusterIds = List.from(documentSnapshot.get("neomClusterIds") ?? []);

  Map<String, dynamic> toSimpleJSON() {
    return <String, dynamic>{
      'id': id, //not needed at firebase
      'name': name,
      'photoUrl': photoUrl,
      'type': EnumToString.convertToString(type),
      'neomReason': EnumToString.convertToString(neomReason),
      'rootFrequency': rootFrequency,
    };
  }


  NeomProfile.simpleFromMap(Map<dynamic, dynamic> data) :
    id = data["id"],
    name = data["name"],
    photoUrl = data["photoUrl"],
    coverImgUrl = data["coverImgUrl"],
    type = EnumToString.fromString(NeomProfileType.values, data["type"]),
    neomReason = EnumToString.fromString(NeomReason.values, data["neomReason"]),
    aboutMe = data["aboutMe"],
    neomEvents = data["neomEvents"],
    rootFrequency = data["rootFrequency"],
    isActive = data["isActive"],
    following = [],
    neommates = [],
    neomPosts = [],
    neomClusterIds = [],
    followers = [];

}