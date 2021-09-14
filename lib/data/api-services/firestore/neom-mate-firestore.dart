import 'dart:async';
import 'package:cyberneom/data/api-services/firestore/frequency-firestore.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/repository/neom-mate-repository.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NeommateFirestore implements NeommateRepository {

  var logger = NeomUtilities.logger;
  final neomUsersReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_neomUsers);
  final neomProfileReference = FirebaseFirestore.instance.collectionGroup(NeomFirestoreConstants.fs_profiles);

  Future<NeomProfile>? getNeommateSimple(String neommateId) async {
    logger.d("Retrieving Songmate Simple $neommateId");
    NeomProfile neommate = NeomProfile();
    try {
      await neomProfileReference.get().then((querySnapshot) =>
          querySnapshot.docs.forEach((document) {
            if(document.id == neommateId) {
              neommate = NeomProfile.fromDocumentSnapshot(document);
            }
          })
      );

      logger.d("Songmate ${neommate.toString()}");
    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }

    return neommate;
  }


  Future<bool> addNeommate(String neomProfileId, String neommateId) async {
    logger.d("$neomProfileId would be neommate with $neommateId");

    try {

      await neomProfileReference.get().then((querySnapshot) =>
          querySnapshot.docs.forEach((document) {
            if(document.id == neomProfileId) {
              document.reference..update({NeomFirestoreConstants.fs_neommates: FieldValue.arrayUnion([neommateId])});
              logger.d("$neomProfileId is now neomgmate of $neommateId");
            }

            if(document.id == neommateId) {
              document.reference.update({NeomFirestoreConstants.fs_neommates: FieldValue.arrayUnion([neomProfileId])});
              logger.d("$neommateId is now neommate of $neomProfileId");
            }
          })
      );

      logger.d("$neomProfileId and $neommateId are neommates now");
      return true;
    } catch (e) {
      logger.e(e.toString());
    }

    return false;
  }


  Future<bool> removeNeommate(String neomProfileId, String neommateId) async {
    logger.d("$neomProfileId would not be neommate with $neommateId");

    try {
      await neomProfileReference.get().then((querySnapshot) =>
          querySnapshot.docs.forEach((document) {
            if(document.id == neomProfileId) {
              document.reference.update({NeomFirestoreConstants.fs_neommates: FieldValue.arrayRemove([neommateId])});
            }

            if(document.id == neommateId) {
              document.reference.update({NeomFirestoreConstants.fs_neommates: FieldValue.arrayRemove([neomProfileId])});
            }
          })
      );

      logger.d("$neomProfileId and $neommateId are not songmates now");
      return true;
    } catch (e) {
      logger.e(e.toString());
    }

    return false;
  }

  void sendNeommateRequest(){

  }


  @override
  Future<Map<String, NeomProfile>> getNeommatesForProfile(String neomProfileId) async {
    print("start getIfExists for $neomProfileId");

    NeomProfile neomProfile = NeomProfile();
    Map<String, NeomProfile> neommatesMap = Map();
    try {
      await neomProfileReference.get().then((querySnapshot) =>
          querySnapshot.docs.forEach((document) {
            if(document.id == neomProfileId) {
              neomProfile = NeomProfile.fromDocumentSnapshot(document);
            }
          })
      );

      neomProfile.neommates.forEach((neommateId) async {
        NeomProfile neommate = await NeommateFirestore().getNeommateSimple(neommateId)!;
        neommate.rootFrequencies = await FrequencyFirestore().retrieveFrequencies(neommateId);
        neommatesMap[neommateId] = neommate;
      });

      logger.d("${neommatesMap.length} Neommates found");

    } catch (e) {
      logger.e(e.toString());
    }
    
    return neommatesMap;
  }

  @override
  Future<Map<String, NeomProfile>> getNeommates(String neomProfileId) async {
    print("start getIfExists for $neomProfileId");

    NeomProfile neommate = NeomProfile();
    Map<String, NeomProfile> neommatesMap = Map();
    try {
      await neomProfileReference.get().then((querySnapshot) =>
          querySnapshot.docs.forEach((document) async {
            if(document.id != neomProfileId) {
              neommate = NeomProfile.fromDocumentSnapshot(document);
              neommate.rootFrequencies = await FrequencyFirestore().retrieveFrequencies(neommate.id);
              neommatesMap[neommate.id] = neommate;
            }
          })
      );

      logger.d("${neommatesMap.length} Neommates found");

    } catch (e) {
      logger.e(e.toString());
    }

    return neommatesMap;
  }

  @override
  Future<NeomProfile>? getNeommateDetails(NeomProfile neomProfile) {
    // TODO: implement getNeommateDetails
    throw UnimplementedError();
  }

}


