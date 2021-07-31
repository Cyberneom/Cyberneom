import 'package:cyberneom/domain/model/neom-reply.dart';
import 'package:cyberneom/utils/enum/neom-media-type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class NeomComment {

  String? id;
  String neomPostOwnerId;
  String text;
  List<String> likedProfiles;
  NeomMediaType type;
  List<NeomReply> neomReplies;
  bool isHidden;
  String neomProfileId;
  String neomProfileImgUrl;
  String neomProfileName;
  String mediaUrl;
  int createdTime;
  int modifiedTime;


  NeomComment({
      this.id,
      required this.neomPostOwnerId,
      required this.text,
      this.likedProfiles = const [],
      this.type = NeomMediaType.Text,
      this.neomReplies = const [],
      this.isHidden = false,
      required this.neomProfileId,
      required this.neomProfileImgUrl,
      required this.neomProfileName,
      this.mediaUrl = "",
      required this.createdTime,
      this.modifiedTime = 0
  });


  @override
  String toString() {
    return 'neomComment{id: $id, neomPostOwnerId: $neomPostOwnerId, text: $text, likedProfiles: $likedProfiles, type: $type, neomReplies: $neomReplies, isHidden: $isHidden, neomProfileId: $neomProfileId, neomProfileImgUrl: $neomProfileImgUrl, neomProfileName: $neomProfileName, mediaUrl: $mediaUrl, createdTime: $createdTime, modifiedTime: $modifiedTime}';
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'text': text,
      'likedProfiles': likedProfiles,
      'type': EnumToString.convertToString(type),
      'isHidden': isHidden,
      'neomProfileId': neomProfileId,
      'neomProfileImgUrl': neomProfileImgUrl,
      'neomProfileName': neomProfileName,
      'neomPostOwnerId': neomPostOwnerId,
      'mediaUrl': mediaUrl,
      'createdTime': createdTime,
      'modifiedTime': modifiedTime,
      'neomReplies': neomReplies
    };
  }

  NeomComment.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}):
    id = documentSnapshot.id,
    text = documentSnapshot.get("text"),
    likedProfiles = List.from(documentSnapshot.get("likedProfiles")),
    type = EnumToString.fromString(NeomMediaType.values, documentSnapshot.get("type")) ?? NeomMediaType.Text,
    isHidden = documentSnapshot.get("isHidden"),
    neomProfileId = documentSnapshot.get("neomProfileId"),
    neomProfileImgUrl = documentSnapshot.get("neomProfileImgUrl"),
    neomProfileName = documentSnapshot.get("neomProfileName"),
    neomPostOwnerId = documentSnapshot.get("neomPostOwnerId"),
    mediaUrl = documentSnapshot.get("mediaUrl"),
    createdTime = documentSnapshot.get("createdTime"),
    modifiedTime = documentSnapshot.get("modifiedTime"),
    neomReplies = documentSnapshot.get("neomReplies").map<NeomReply>((item) {
      return NeomReply.fromMap(item);
    }).toList();

}