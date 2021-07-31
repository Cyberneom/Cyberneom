import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';

abstract class NeomProfileRepository {

  Future<String> insertNeomProfile(String neomUserId, NeomProfile neomProfile);
  Future<NeomProfile> retrieveNeomProfile(String neomProfileId);

  Future<bool> removeNeomProfile({required String neomUserId, required String neomProfileId});

  Future<NeomProfile> retrieveNeomProfileSimple(String neomProfileId);

  Future<List<NeomProfile>> retrieveNeomProfiles(String neomUserId);

  Future<bool> followNeomProfile(String neomUserId, String followedNeomUserId);
  Future<bool> unfollowNeomProfile(String neomUserId, String unfollowNeomUserId);

  Future<bool> updateGpsPosition(String neomUserId, String neomProfileId, Position newPositionO);

  Future<bool> addPost(String neomProfileId, String neomPostId);

  Future<bool> removePost(String neomProfileId, String neomPostId);

  Future<bool> updateNeomProfileInfo(String neomProfileId, String neomProfileName, String neomDescription);

  Future<bool> addEvent(String neomProfileId, String neomEventId);

  Future<bool> removeEvent(String neomProfileId, String neomEventId);

  Future<QuerySnapshot> handleSearch(String query);

}
