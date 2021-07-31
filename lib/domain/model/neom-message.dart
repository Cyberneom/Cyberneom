import 'package:cloud_firestore/cloud_firestore.dart';

class NeomMessage {

  String text;
  String sender;
  int createdTime;


  NeomMessage({
    required this.text,
    required this.sender,
    required this.createdTime});


  @override
  String toString() {
    return 'NeomMessage{text: $text, sender: $sender, createdTime: $createdTime}';
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'text': text,
      'sender': sender,
      'createdTime': DateTime.now().millisecondsSinceEpoch,
    };
  }

  NeomMessage.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) :
    text = documentSnapshot.get("text"),
    sender = documentSnapshot.get("sender"),
    createdTime = documentSnapshot.get("createdTime");


  NeomMessage.fromQueryDocumentSnapshot({required QueryDocumentSnapshot queryDocumentSnapshot}) :
    text = queryDocumentSnapshot.get("text"),
    sender = queryDocumentSnapshot.get("sender"),
    createdTime = queryDocumentSnapshot.get("createdTime");


  NeomMessage.fromMap(data) :
    text = data["text"] ?? "",
    sender = data["sender"] ?? "",
    createdTime = data["createdTime"] ?? 0;

}