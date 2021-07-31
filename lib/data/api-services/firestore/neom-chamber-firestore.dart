import 'dart:async';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/repository/neom-chamber-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class NeomChamberFirestore implements NeomChamberRepository {

  var logger = NeomUtilities.logger;

  final neomUsersReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_neomUsers);
  final chambersReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_chamberPresets);
  final neomProfileReference = FirebaseFirestore.instance.collectionGroup(NeomFirestoreConstants.fs_profiles);


  Future<bool> addPresetToChamber(String neomProfileId, NeomChamberPreset preset, String chamberId) async {
    logger.d("Adding preset for user $neomProfileId");
    logger.d("Adding preset to chamber $chamberId");

    List<dynamic> presetsJSON = [];
    presetsJSON.add(preset.toJSON());

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.collection(
                NeomFirestoreConstants.fs_chambers).doc(chamberId)
          .update({"neomChamberPresets": FieldValue.arrayUnion(presetsJSON)});
          }
        });
      });
      logger.d("Preset was added to chamber $chamberId");
    } catch (e) {
      logger.d(e.toString());
      logger.d("Preset was not added to chamber $chamberId");
      return false;
    }

    return true;
  }


  Future<bool> removePresetFromChamber(String neomProfileId, NeomChamberPreset preset, String chamberId) async {
    logger.d("Removing preset from Chamber $chamberId");

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.collection(
                NeomFirestoreConstants.fs_chambers).doc(chamberId)
                  .update({
                "neomChamberPresets": FieldValue.arrayRemove([preset.toJSON()])
              });
          }
        });
      });


      logger.d("Preset was removed from chamber $chamberId");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("Preset was not  removed from chamber $chamberId");
    return false;
  }


  Future<String> insert({required String neomProfileId, required NeomChamber neomChamber}) async {
    logger.d("Retrieving chamber for $neomProfileId");
    String neomChamberId = "";
    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.collection(
                NeomFirestoreConstants.fs_chambers).add(neomChamber.toJSON())
                .then((doc) => neomChamberId = doc.id);
          }
          });
        });
      logger.d("Chamber inserted to profile $neomProfileId");
    } catch (e) {
      logger.d(e);
    }

    return neomChamberId;
  }


  Future<Map<String, NeomChamber>> retrieveNeomChambers(String neomProfileId) async {
    logger.d("Retrieving chambers for $neomProfileId");

    Map<String, NeomChamber> neomChambers = Map<String,NeomChamber>();

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if(document.id == neomProfileId) {
            document.reference.collection(
                NeomFirestoreConstants.fs_chambers).get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((queryDocumentSnapshot) {
                var chamber = NeomChamber.fromQueryDocumentSnapshot(queryDocumentSnapshot: queryDocumentSnapshot);
                neomChambers[chamber.id] = chamber;
              });
            });
          }
        });
      });

      logger.d("No Chamber Found");

    } catch (e) {
      logger.d(e);
    }
    return neomChambers;
  }


  Future<bool> remove(neomProfileId, chamberId) async {
    logger.d("Removing $chamberId for by $neomProfileId");
    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.collection(
                NeomFirestoreConstants.fs_chambers)
              .doc(chamberId).delete();
          }
        });
      });
      logger.d("Chamber $chamberId removed");
      return true;
    } catch (e) {
      logger.d(e.toString());
      return false;
    }
  }


  Future<bool> update(String neomUserId, NeomChamber chamber) async {
    logger.d("Updating Chamber for user " + neomUserId);

    try {
      await neomUsersReference.doc(neomUserId).collection(NeomFirestoreConstants.fs_profiles)
          .doc(neomUserId).collection(NeomFirestoreConstants.fs_chambers)
          .doc(chamber.id).update({
            "name": chamber.name,
            "description": chamber.description});

      logger.d("Chamber ${chamber.id} was updated");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("Chamber ${chamber.id} was not updated");
    return false;
  }


  Future<bool> setAsFavorite(String neomUserId, NeomChamber chamber) async {
    logger.d("Updating to favorite Chamber for user " + neomUserId);

    try {
      await neomUsersReference.doc(neomUserId).collection(NeomFirestoreConstants.fs_profiles)
          .doc(neomUserId).collection(NeomFirestoreConstants.fs_chambers)
          .doc(chamber.id).update({"isFav": true});

      logger.d("Chamber ${chamber.id} was set as favorite");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("Chamber ${chamber.id} was not updated");
    return false;
  }


  Future<bool> unsetOfFavorite(String neomUserId, NeomChamber chamber) async {
    logger.d("Updating to unFavorite Neom Chamber for user " + neomUserId);
    chamber.isFav = false;

    try {
      await neomUsersReference.doc(neomUserId).collection(NeomFirestoreConstants.fs_profiles)
          .doc(neomUserId).collection(NeomFirestoreConstants.fs_chambers)
          .doc(chamber.id).update({"isFav": false});

      logger.d("Chamber ${chamber.id} was unset of favorite");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("Chamber ${chamber.id} was not updated");
    return false;
  }


}