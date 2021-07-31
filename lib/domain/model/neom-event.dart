import 'package:cyberneom/domain/model/neom-event-place.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/utils/enum/neom-event-type.dart';
import 'package:cyberneom/utils/enum/neom-reason.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class NeomEvent {

  String id;
  String name;
  String description;
  NeomProfile? owner;
  String imgUrl;
  bool public;
  int createdTime;
  int eventDate;
  NeomReason? neomReason;
  List<NeomChamberPreset> neomChambers;
  NeomEventType? neomEventType;
  NeomEventPlace? neomEventPlace;
  List<String> watchingProfiles;
  List<String> goingProfiles;


  NeomEvent({
      this.id = "",
      this.name = "",
      this.description = "",
      this.imgUrl = "",
      this.public = true,
      this.createdTime = 0,
      this.eventDate = 0,
      this.neomReason = NeomReason.Other,
      this.neomChambers = const [],
      this.neomEventType,
      this.neomEventPlace,
      this.watchingProfiles = const [],
      this.goingProfiles = const []
  });


  @override
  String toString() {
    return 'NeomEvent{id: $id, name: $name, description: $description, owner: $owner, imgUrl: $imgUrl, public: $public, createdTime: $createdTime, eventDate: $eventDate, neomReason: $neomReason, neomChambers: $neomChambers, neomEventType: $neomEventType, neomEventPlace: $neomEventPlace, watchingProfiles: $watchingProfiles, goingProfiles: $goingProfiles}';
  }


  NeomEvent.createBasic(name, desc):
    id = "",
    name = name,
    description = desc,
    imgUrl = "",
    public = true,
    neomChambers = [],
    eventDate =  0,
    createdTime = 0,
    goingProfiles = [],
    watchingProfiles = [];


  NeomEvent.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) :
    id = documentSnapshot.id,
    name = documentSnapshot.get("name"),
    description = documentSnapshot.get("description"),
    owner = NeomProfile.simpleFromMap(documentSnapshot.get("owner")),
    imgUrl = documentSnapshot.get("imgUrl"),
    public = documentSnapshot.get("public"),
    createdTime = documentSnapshot.get("createdTime"),
    eventDate = documentSnapshot.get("eventDate"),
    neomReason = EnumToString.fromString(NeomReason.values, documentSnapshot.get("neomReason")),
    neomChambers = documentSnapshot.get("neomChambers").map<NeomChamberPreset>((item) {
      return NeomChamberPreset.fromMap(item);
    }).toList(),
    neomEventType = EnumToString.fromString(NeomEventType.values, documentSnapshot.get("neomEventType")),
    neomEventPlace = NeomEventPlace.fromMap(documentSnapshot.get("neomEventPlace")),
    watchingProfiles = List.from(documentSnapshot.get("watchingProfiles")),
    goingProfiles = List.from(documentSnapshot.get("goingProfiles"));


  NeomEvent.fromQueryDocumentSnapshot({required QueryDocumentSnapshot documentSnapshot}):
    id = documentSnapshot.id,
    name = documentSnapshot.get("name"),
    description = documentSnapshot.get("description"),
    owner = NeomProfile.simpleFromMap(documentSnapshot.get("owner")),
    imgUrl = documentSnapshot.get("imgUrl"),
    public = documentSnapshot.get("public"),
    createdTime = documentSnapshot.get("createdTime"),
    eventDate = documentSnapshot.get("eventDate") ?? 0,
    neomReason = EnumToString.fromString(NeomReason.values, documentSnapshot.get("neomChambers")),
    neomChambers = documentSnapshot.get("neomChambers").map<NeomChamberPreset>((item) {
              return NeomChamberPreset.fromMap(item);
            }).toList(),
    neomEventType = EnumToString.fromString(NeomEventType.values, documentSnapshot.get("neomEventType")),
    neomEventPlace = NeomEventPlace.fromMap(documentSnapshot.get("neomEventPlace")),
    watchingProfiles = List.from(documentSnapshot.get("watchingProfiles")),
    goingProfiles = List.from(documentSnapshot.get("goingProfiles"));


  NeomEvent.fromMap(Map<dynamic, dynamic> data):
      id = data["id"],
      name = data["name"],
      description = data["description"],
      owner = NeomProfile.simpleFromMap(data["owner"]),
      imgUrl = data["imgUrl"],
      public = data["public"],
      createdTime = data["createdTime"],
      eventDate = data["eventDate"],
      neomReason = EnumToString.fromString(NeomReason.values, data["neomReason"]),
      neomChambers = data["neomChambers"].map<NeomChamberPreset>((item) {
        return NeomChamberPreset.fromMap(item);
      }).toList(),
      neomEventType = EnumToString.fromString(NeomEventType.values, data["neomEventType"]),
      neomEventPlace =  NeomEventPlace.fromMap(data["neomEventPlace"]),
      watchingProfiles = List.from(data["watchingProfiles"] ?? []),
      goingProfiles = List.from(data["goingProfiles"] ?? []);



  Map<String, dynamic> toJSON()=>{
    //'id': id, generated in firebase
    'name': name,
    'description': description,
    'owner': owner!.toSimpleJSON(),
    'imgUrl': imgUrl,
    'public': public,
    'createdTime': createdTime,
    'eventDate': eventDate,
    'neomReason': EnumToString.convertToString(neomReason),
    'neomChambers': neomChambers.map((neomChamber) => neomChamber.toJSON()).toList(),
    'neomEventType': EnumToString.convertToString(neomEventType),
    'neomEventPlace': neomEventPlace!.toJSON(),
    'watchingProfiles': [],
    'goingProfiles': [],
  };

  Map<String, dynamic> toSimpleJSON()=>{
    'id': id,
    'name': name,
    'description': description,
    'owner': owner!.toSimpleJSON(),
    'imgUrl': imgUrl,
    'public': public,
    'createdTime': createdTime,
    'eventDate': eventDate,
    'neomReason': EnumToString.convertToString(neomReason),
    'neomEventType': EnumToString.convertToString(neomEventType),
    'neomEventPlace': neomEventPlace!.toJSON(),
  };

}
