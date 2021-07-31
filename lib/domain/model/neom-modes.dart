import 'package:cloud_firestore/cloud_firestore.dart';

class NeomMode {

  String id;
  String name;
  String description;

  NeomMode({
    this.id = "",
    this.name = "",
    this.description = "",
  });


  @override
  String toString() {
    return 'NeomMode{id: $id, name: $name, description: $description}';
  }


  static NeomMode fromJson(Map<String, dynamic> json) {
    return NeomMode(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }


  NeomMode.fromQueryDocumentSnapshot({required QueryDocumentSnapshot queryDocumentSnapshot}) :
    id = queryDocumentSnapshot.id,
    name = queryDocumentSnapshot.get("name"),
    description = queryDocumentSnapshot.get("description");


  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }


  NeomMode.fromMap(Map<dynamic, dynamic> data) :
    id = data["name"],
    name = data["name"],
    description = data["description"];

}