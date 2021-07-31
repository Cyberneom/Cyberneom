import 'package:cyberneom/utils/enum/neom-media-type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';


class NeomReply {

  String id;
  String text;
  int likeCount;
  NeomMediaType? neomMediaType;
  bool isHidden;
  String neomProfileId;
  int createdTime;
  int modifiedTime;

  NeomReply({
    this.id = "",
    this.neomProfileId = "",
    this.text = "",
    this.likeCount = 0,
    this.neomMediaType,
    this.isHidden = false,
    this.createdTime = 0,
    this.modifiedTime = 0
  });


  @override
  String toString() {
    return 'NeomReply{id: $id, text: $text, likeCount: $likeCount, neomMediaType: $neomMediaType, isHidden: $isHidden, neomProfileId: $neomProfileId, createdTime: $createdTime, modifiedTime: $modifiedTime}';
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      //'userId': userId, //not needed at firebase
      'id': id,
      'text': text,
      'likeCount': likeCount,
      'neomMediaType': EnumToString.convertToString(neomMediaType),
      'isHidden': isHidden,
      'neomProfileId': neomProfileId,
      'createdTime': createdTime,
      'modifiedTime': modifiedTime,
    };
  }

  NeomReply.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) :
    id = documentSnapshot.id,
    text = documentSnapshot.get("text"),
    likeCount = documentSnapshot.get("likeCount"),
    neomMediaType = EnumToString.fromString(NeomMediaType.values, documentSnapshot.get("neomMediaType")),
    isHidden = documentSnapshot.get("isHidden"),
    neomProfileId = documentSnapshot.get("neomProfileId"),
    createdTime = documentSnapshot.get("createdTime"),
    modifiedTime = documentSnapshot.get("modifiedTime");


  NeomReply.fromMap(Map<dynamic, dynamic> data) :
    id = data["id"],
    text = data["text"],
    likeCount = data["likeCount"],
    neomMediaType = EnumToString.fromString(NeomMediaType.values, data["neomMediaType"]),
    isHidden = data["isHidden"],
    neomProfileId = data["neomProfileId"],
    createdTime = data["createdTime"],
    modifiedTime = data["modifiedTime"];

}