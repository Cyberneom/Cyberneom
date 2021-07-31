
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-parameter.dart';

class NeomChamberPreset {

  String id;
  String name;
  String description;
  String imgUrl;
  String creatorId;
  NeomParameter? neomParameter;
  NeomFrequency? neomFrequency;

  NeomChamberPreset({
    this.id = "",
    this.name = "",
    this.description = "",
    this.imgUrl = "",
    this.creatorId = "",
  });


  @override
  String toString() {
    return 'NeomChamberPreset{id: $id, name: $name, description: $description, imgUrl: $imgUrl, creatorId: $creatorId, neomParameter: $neomParameter, neomFrequencies: $neomFrequency}';
  }

  NeomChamberPreset.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) :
    id = documentSnapshot.get("id"),
    name = documentSnapshot.get("name"),
    description = documentSnapshot.get("description"),
    creatorId = documentSnapshot.get("creatorId"),
    imgUrl = documentSnapshot.get("imgUrl"),
    neomParameter =  NeomParameter.fromMap(documentSnapshot.get("neomParameter")),
    neomFrequency =  NeomFrequency.fromMap(documentSnapshot.get("neomFrequency"));

  NeomChamberPreset.fromMap(Map<dynamic, dynamic> data) :
    id = data["id"],
    name = data["name"],
    description = data["description"],
    creatorId = data["creatorId"],
    imgUrl = data["imgUrl"],
    neomParameter = NeomParameter.fromMap(data["neomParameter"]),
    neomFrequency = NeomFrequency.fromMap(data["neomFrequency"]);


  Map<String, dynamic>  toJSON()=>{
    'id': id,
    'name': name,
    'description': description,
    'creatorId': creatorId,
    'imgUrl': imgUrl,
    'neomParameter': neomParameter!.toJSON(),
    'neomFrequency': neomFrequency!.toJsonNoId(),
  };

  Map<String, dynamic>  toJsonNoId()=>{
    'name': name,
    'description': description,
    'creatorId': creatorId,
    'imgUrl': imgUrl,
    'neomParameter': neomParameter!.toJSON(),
    'neomFrequency': neomFrequency!.toJsonNoId(),
  };

  NeomChamberPreset.myFirstNeomChamberPreset() :
    id = "",
    name = "Deep Deep Deep",
    description = "Deep Binaural Beats",
    creatorId = "Binauroboros",
    imgUrl = "https://post.healthline.com/wp-content/uploads/2020/10/7576-This_Is_Your_Brain_on_Binaural_Beats-color-update-1296x1692-Infographic-1.jpg",
    neomParameter = NeomParameter(),
    neomFrequency = NeomFrequency();


}