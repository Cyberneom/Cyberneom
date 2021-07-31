import 'dart:async';
import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/domain/model/neom-user.dart';
import 'package:cyberneom/domain/repository/neom-mate-repository.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:logger/logger.dart';

class NeommateFirestore implements NeommateRepository {

  var logger = Logger();
  final neomUsersReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_neomUsers);

 @override
  Future<Map<String, NeomProfile>> getNeommates(String neomProfileId) async {
    logger.d("start getNeommates for $neomProfileId");
    Map<String, NeomProfile> neomProfilesMap = Map();
    try {
      QuerySnapshot querySnapshot = await neomUsersReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        logger.d("Snapshot is not empty");
        for(int i = 0; i < querySnapshot.docs.length; i++) {
          NeomUser neomUser = NeomUser.fromDocumentSnapshot(documentSnapshot: querySnapshot.docs.elementAt(i));
          if(neomUser.id != neomProfileId) {
            List<NeomProfile> neomProfiles = await NeomProfileFirestore().retrieveNeomProfiles(neomUser.id);
            neomProfiles.isNotEmpty ? neomUser.neomProfiles = neomProfiles : logger.d("NeomProfile not found");
            logger.d(neomUser.neomProfiles!.first.name.toString());
            neomProfilesMap[neomUser.neomProfiles!.first.name] = neomUser.neomProfiles!.first;
          }
        }

        logger.d("${neomProfilesMap.length} Neommates found");

      }
    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }
    return neomProfilesMap;
  }

  @override
  Future<bool> addNeommate(String neomProfileId, String neommateUserId) {
    // TODO: implement addNeommate
    throw UnimplementedError();
  }

  @override
  Future<NeomProfile>? getNeommateDetails(NeomProfile neomProfile) {
    // TODO: implement getNeommateDetails
    throw UnimplementedError();
  }

  @override
  Future<bool> removeNeommate(String neomProfileId, String neommateUserId) {
    // TODO: implement removeNeommate
    throw UnimplementedError();
  }

  @override
  void sendNeommateRequest() {
    // TODO: implement sendNeommateRequest
  }

}


