import 'package:cyberneom/domain/model/neom-tribe-private-data.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/utils/enum/neom-reason.dart';
import 'package:geolocator/geolocator.dart';
import 'neom-profile.dart';

class NeomTribe {

  String id;
  String name;
  String description;
  String imgUrl;

  List<NeomProfile> tribeMembers;
  List<String> genres;

  Position? position;
  NeomReason neomReason;
  NeomChamber? mainNeomCluster;
  NeomTribePrivateData? neomTribePrivateData;

  NeomTribe({
    this.id = "",
    this.name = "",
    this.description = "",
    this.imgUrl = "",
    this.tribeMembers = const [],
    this.genres = const [],
    this.position,
    this.neomReason = NeomReason.Other,
    this.mainNeomCluster,
    this.neomTribePrivateData});


}