import 'package:cyberneom/utils/enum/scale-degree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class NeomFrequency {

  String id;
  String name;
  String description;
  double frequency;
  ScaleDegree scaleDegree;
  bool isRoot;
  bool isMain;
  bool isFav;


  NeomFrequency({
    this.id = "",
    this.name = "",
    this.description = "",
    this.frequency = 215,
    this.scaleDegree = ScaleDegree.Tonic,
    this.isRoot = false,
    this.isMain = false,
    this.isFav = false
  });


  @override
  String toString() {
    return 'NeomFrequency{id: $id, name: $name, description: $description, frequency: $frequency, scaleDegree: $scaleDegree, isRoot: $isRoot, isMain: $isMain, isFav: $isFav}';
  }


  static NeomFrequency fromJson(Map<String, dynamic> json) {
    return NeomFrequency(
      id: json["id"],
      name: json["name"],
      scaleDegree: json["scaleDegree"],
      isRoot: json["isRoot"],
      isMain: json["isMAin"],
      isFav: json["isFav"],
      description: json["description"],
      frequency: json["frequency"]
    );
  }


  static NeomFrequency fromJsonDefault(Map<String, dynamic> json) {
    return NeomFrequency(
      id: json["name"],
      name: json["name"],
      scaleDegree: ScaleDegree.Tonic,
      isRoot: false,
      isMain: false,
      isFav: false,
      description: json["description"],
      frequency: double.parse(json["frequency"])
    );
  }


  NeomFrequency.fromQueryDocumentSnapshot({required QueryDocumentSnapshot queryDocumentSnapshot}) :
    id = queryDocumentSnapshot.id,
    name = queryDocumentSnapshot.get("name"),
    scaleDegree = EnumToString.fromString(ScaleDegree.values, queryDocumentSnapshot.get("scaleDegree"))!,
    isRoot = queryDocumentSnapshot.get("isRoot"),
    isMain = queryDocumentSnapshot.get("isMain"),
    frequency = queryDocumentSnapshot.get("frequency"),
    isFav = queryDocumentSnapshot.get("isFav"),
    description = queryDocumentSnapshot.get("description");


  Map<String, dynamic> toJsonNoId() {
    return <String, dynamic>{
      //'userId': userId, //not needed at firebase
      'name': name,
      'scaleDegree': EnumToString.convertToString(scaleDegree),
      'isRoot': isRoot,
      'isMain': isMain,
      'frequency': frequency,
      'isFav': isFav,
      'description': description,
    };
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'scaleDegree': EnumToString.convertToString(scaleDegree),
      'isRoot': isRoot,
      'isMain': isMain,
      'frequency': frequency,
      'isFav': isFav,
      'description': description,
    };
  }


  NeomFrequency.addBasic(name) :
    id = "",
    name = name,
    description = "",
    frequency = 215,
    scaleDegree = ScaleDegree.Tonic,
    isRoot = false,
    isMain = false,
    isFav = true;


  NeomFrequency.fromMap(Map<dynamic, dynamic> data) :
    id = data["id"] ?? "",
    name = data["name"],
    description = data["description"],
    frequency = 215,
    scaleDegree = EnumToString.fromString(ScaleDegree.values, data["scaleDegree"])!,
    isRoot = data["isRoot"],
    isMain = data["isMain"],
    isFav = data["isFav"];

}