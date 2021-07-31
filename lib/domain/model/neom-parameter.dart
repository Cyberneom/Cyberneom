import 'package:cloud_firestore/cloud_firestore.dart';

class NeomParameter {

  double x;
  double y;
  double z;
  double volume;


  NeomParameter({
    this.x = 0,
    this.y = 0,
    this.z = 0,
    this.volume = 0.5,
  });


  @override
  String toString() {
    return 'NeomParameter{x: $x, y: $y, z: $z, volume: $volume}';
  }


  NeomParameter.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) :
    x = documentSnapshot.get("x"),
    y = documentSnapshot.get("y"),
    z = documentSnapshot.get("z"),
    volume = documentSnapshot.get("volume");


  NeomParameter.fromMap(Map<dynamic, dynamic> data) :
    x = data["x"],
    y = data["y"],
    z = data["z"],
    volume = data["volume"];


  NeomParameter.forNeomChambersCollection(NeomParameter neomParameter) :
    x = neomParameter.x,
    y = neomParameter.y,
    z = neomParameter.z,
    volume = neomParameter.volume;


  Map<String, dynamic>  toJSON()=>{
    'x': x,
    'y': y,
    'z': z,
    'volume': volume
  };

}