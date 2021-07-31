import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/domain/model/neom-message.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';


class NeomInbox {

  String id;
  List<NeomProfile>? neommates;
  List<String>? neomProfileIds;
  List<NeomMessage>? neomMessages;
  NeomMessage? lastMessage;


  NeomInbox({
    this.id = "",
    this.neommates,
    this.neomProfileIds,
    this.neomMessages,
    this.lastMessage});


  @override
  String toString() {
    return 'NeomInbox{id: $id, neommates: $neommates, neomProfileIds: $neomProfileIds, neomMessages: $neomMessages, lastMessage: $lastMessage}';
  }


  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'id': id,
      'neomProfileIds': neomProfileIds,
      'lastMessage': lastMessage
    };
  }


  NeomInbox.fromDocumentSnapshot(DocumentSnapshot documentSnapshot):
    id = documentSnapshot.id,
    neomProfileIds = List.from(documentSnapshot.get("neomProfileIds")),
    lastMessage = NeomMessage.fromMap(documentSnapshot.get("lastMessage") ?? <dynamic, dynamic>{});


  NeomInbox.fromQueryDocumentSnapshot(QueryDocumentSnapshot queryDocumentSnapshot):
    id = queryDocumentSnapshot.id,
    neomProfileIds = List.from(queryDocumentSnapshot.get("neomProfileIds")),
    lastMessage = NeomMessage.fromMap(queryDocumentSnapshot.get("lastMessage") ?? <dynamic, dynamic>{});

}