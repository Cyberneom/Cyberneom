import 'dart:convert';
import 'package:cyberneom/domain/model/neom-comment.dart';
import 'package:cyberneom/domain/model/neom-event.dart';
import 'package:cyberneom/utils/enum/neom-post-type.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:geolocator/geolocator.dart';

class NeomPost {

  String id;
  String ownerId;
  String neomProfileName;
  String neomProfileImgUrl;
  String caption;

  NeomPostType type; //image/video/neom Event
  String mediaUrl ;
  String? thumbnailUrl; //Only used if mediatype is video otherwise empty
  int createdTime;
  int modifiedTime;
  Position? position;
  String location;

  List<String> likedProfiles;
  List<String> sharedProfiles;
  List<String> mentionedProfiles;
  List<NeomComment> neomComments; //includes commment and commentCount
  List<String> hashtags;

  bool isCommentEnabled;
  bool isPrivate;
  NeomEvent? neomEvent;

  String? mediaOwner;  //For future copyright references

  NeomPost({
    this.id = "",
    this.ownerId = "",
    this.neomProfileName = "",
    this.neomProfileImgUrl = "",
    this.caption = "",
    this.type = NeomPostType.Caption,
    this.mediaUrl = "",
    this.thumbnailUrl = "",
    this.createdTime = 0,
    this.modifiedTime = 0,
    this.position,
    this.location = "",
    this.likedProfiles = const [],
    this.sharedProfiles = const [],
    this.neomComments = const [],
    this.hashtags = const [],
    this.mentionedProfiles = const [],
    this.isCommentEnabled = true,
    this.isPrivate = false,
    this.neomEvent,
    this.mediaOwner = ""});


  @override
  String toString() {
    return 'NeomPost{id: $id, ownerId: $ownerId, neomProfileName: $neomProfileName, neomProfileImgUrl: $neomProfileImgUrl, caption: $caption, type: $type, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, createdTime: $createdTime, modifiedTime: $modifiedTime, position: $position, location: $location, likedProfiles: $likedProfiles, sharedProfiles: $sharedProfiles, mentionedProfiles: $mentionedProfiles, neomComments: $neomComments, hashtags: $hashtags, isCommentEnabled: $isCommentEnabled, isPrivate: $isPrivate, neomEvent: $neomEvent, mediaOwner: $mediaOwner}';
  }


  NeomPost.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) :
    id = documentSnapshot.id,
    ownerId = documentSnapshot.get("ownerId"),
    neomProfileName = documentSnapshot.get("neomProfileName"),
    neomProfileImgUrl = documentSnapshot.get("neomProfileImgUrl"),
    caption = documentSnapshot.get("caption"),
    type = EnumToString.fromString(NeomPostType.values, documentSnapshot.get("type")) ?? NeomPostType.Caption,
    mediaUrl = documentSnapshot.get("mediaUrl"),
    thumbnailUrl = documentSnapshot.get("thumbnailUrl"),
    createdTime = documentSnapshot.get("createdTime"),
    modifiedTime = documentSnapshot.get("modifiedTime"),
    position = NeomUtilities.jsonToPosition(documentSnapshot.get("position")),
    location = documentSnapshot.get("location"),
    likedProfiles = List.from(documentSnapshot.get("likedProfiles") ?? []),
    sharedProfiles = List.from(documentSnapshot.get("sharedProfiles") ?? []),
    mentionedProfiles = List.from(documentSnapshot.get("mentionedProfiles") ?? []),
    neomComments = [],
    hashtags = List.from(documentSnapshot.get("hashtags") ?? []),
    isCommentEnabled = documentSnapshot.get("isCommentEnabled") ?? true,
    isPrivate = documentSnapshot.get("isPrivate") ?? false,
    mediaOwner = documentSnapshot.get("mediaOwner"),
    neomEvent = documentSnapshot.get("neomEvent") == null ? null :
      NeomEvent.fromMap(documentSnapshot.get("neomEvent"));


  NeomPost.fromQueryDocumentSnapshot({required QueryDocumentSnapshot queryDocumentSnapshot}) :
    id = queryDocumentSnapshot.id,
    ownerId = queryDocumentSnapshot.get("ownerId"),
    neomProfileName = queryDocumentSnapshot.get("neomProfileName"),
    neomProfileImgUrl = queryDocumentSnapshot.get("neomProfileImgUrl"),
    caption = queryDocumentSnapshot.get("caption"),
    type = EnumToString.fromString(NeomPostType.values, queryDocumentSnapshot.get("type")) ?? NeomPostType.Caption,
    mediaUrl = queryDocumentSnapshot.get("mediaUrl"),
    thumbnailUrl = queryDocumentSnapshot.get("thumbnailUrl"),
    createdTime = queryDocumentSnapshot.get("createdTime"),
    modifiedTime = queryDocumentSnapshot.get("modifiedTime"),
    position = NeomUtilities.jsonToPosition(queryDocumentSnapshot.get("position")),
    location = queryDocumentSnapshot.get("location"),
    likedProfiles = List.from(queryDocumentSnapshot.get("likedProfiles") ?? []),
    sharedProfiles = List.from(queryDocumentSnapshot.get("sharedProfiles") ?? []),
    mentionedProfiles = List.from(queryDocumentSnapshot.get("mentionedProfiles") ?? []),
    neomComments = [],
    hashtags = List.from(queryDocumentSnapshot.get("hashtags") ?? []),
    isCommentEnabled = queryDocumentSnapshot.get("isCommentEnabled") ?? true,
    isPrivate = queryDocumentSnapshot.get("isPrivate") ?? false,
    mediaOwner = queryDocumentSnapshot.get("mediaOwner"),
    neomEvent = queryDocumentSnapshot.get("neomEvent") == null ? null :
    NeomEvent.fromMap(queryDocumentSnapshot.get("neomEvent"));


  Map<String, dynamic> toJSON()=>{
    //'postId': postId, //generated by firebase
    'ownerId': ownerId,
    'neomProfileName': neomProfileName,
    'neomProfileImgUrl': neomProfileImgUrl,
    'caption': caption,
    'type': EnumToString.convertToString(type),
    'mediaUrl': mediaUrl,
    'thumbnailUrl': thumbnailUrl,
    'createdTime': createdTime,
    'modifiedTime': modifiedTime,
    'position': jsonEncode(position),
    'location': location,
    'likedProfiles': likedProfiles,
    'sharedProfiles': sharedProfiles,
    'mentionedProfiles': mentionedProfiles,
    'hashtags': hashtags,
    'isCommentEnabled': isCommentEnabled,
    'isPrivate': isPrivate,
    'mediaOwner': mediaOwner,
    'neomEvent': neomEvent?.toSimpleJSON(),
  };

}