import 'package:cloud_firestore/cloud_firestore.dart';

class NeomApp {

  String id;
  String version;


  NeomApp({
    this.id = "",
    this.version = ""
  });


  @override
  String toString() {
    return 'NeomApp{id: $id, version: $version}';
  }


  NeomApp.fromDocumentSnapshot(DocumentSnapshot documentSnapshot):
    this.id = documentSnapshot.id,
    this.version = documentSnapshot.get("neomAppVersion") ?? "";


  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'neomAppVersion': version,
    };
  }

}