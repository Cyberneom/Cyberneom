import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//TODO
class NeomCluster {

  String id;
  String name;
  String description;
  String href;
  String imgUrl;
  bool public;

  List<NeomChamber>? neomChambers;
  List<NeomProfile>? neomProfiles;

  NeomCluster({
    this.id = "",
    this.name = "",
    this.description = "",
    this.href = "",
    this.imgUrl = "",
    this.public = true,
  });


  @override
  String toString() {
    return 'NeomCluster{id: $id, name: $name, description: $description, href: $href, imgUrl: $imgUrl, public: $public, neomChambers: $neomChambers, neomProfiles: $neomProfiles}';
  }


  NeomCluster.createBasic(name, desc) :
    id = "",
    name = name,
    description = desc,
    href = "",
    imgUrl = "",
    public = true,
    neomChambers = [];

  NeomCluster.fromQueryDocumentSnapshot({required QueryDocumentSnapshot queryDocumentSnapshot}) :
    id = queryDocumentSnapshot.id,
    name = queryDocumentSnapshot.get("name"),
    description = queryDocumentSnapshot.get("description"),
    href = queryDocumentSnapshot.get("href"),
    imgUrl = queryDocumentSnapshot.get("imgUrl"),
    public = queryDocumentSnapshot.get("public"),
    neomChambers = queryDocumentSnapshot.get("neomChambers").map<NeomChamber>((item) {
              return NeomChamber.fromMap(item);
            }).toList() ?? [];


  Map<String, dynamic>  toJSON()=>{
    //'id': id, generated in firebase
    'name': name,
    'description': description,
    'href': href,
    'imgUrl': imgUrl,
    'public': public,
    'neomChambers': neomChambers!.map((neomChamber) => neomChamber.toJSON()).toList(),
  };

   Map<String, dynamic>  toJsonDefault()=>{
    'name': "My First Neom Cluster",
    'description': "This is your first Neom Cluster. Start adding some NeomChambers and Inviting Neommates",
    'href': "",
    'imgUrl': "",
    'public': true,
    'uri': "",
    'isFavNeomCluster': true,
    'neomChambers': []
  };
}