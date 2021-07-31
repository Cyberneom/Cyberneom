import 'dart:async';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/repository/neom-chamber-preset-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class NeomChamberPresetFirestore implements NeomChamberPresetRepository {

  var logger = NeomUtilities.logger;
  final chamberPresetsReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_chamberPresets);
  final neomUsersReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_neomUsers);

  Future<NeomChamberPreset> fetch({required String presetId}) async {
    logger.d("Getting preset $presetId");
    NeomChamberPreset neomPreset = NeomChamberPreset();
    try {
      await chamberPresetsReference.doc(presetId).get().then((doc) {
        if (doc.exists) {
          neomPreset = NeomChamberPreset.fromDocumentSnapshot(doc);
          logger.d("Preset ${neomPreset.name} was retrieved with details");
        } else {
          logger.d("Preset not found");
        }
      });
    } catch (e) {
      logger.d(e);
      rethrow;
    }
    return neomPreset;
  }


  Future<bool> exists({required String presetId}) async {
    logger.d("Getting preset $presetId");

    try {
      await chamberPresetsReference.doc(presetId).get().then((doc) {
        if (doc.exists) {
          logger.d("Preset found");
          return true;
        }
      });
    } catch (e) {
      print(e);
      rethrow;
    }
    logger.d("Preset not found");
    return false;
  }


  Future<String> insert(NeomChamberPreset preset) async {
    logger.d("Adding Preset to database collection");
    String presetId = "";

    try {
      DocumentReference documentReference = await chamberPresetsReference.add(preset.toJSON());
      presetId = documentReference.id;

      logger.d("Preset inserted into Firestore");
    } catch (e) {
      logger.d(e.toString);
      logger.e("Preset not inserted into Firestore");
    }

    return presetId;
  }


  Future<bool> remove(NeomChamberPreset preset) async {
    print("Removing preset from database collection");
    try {
      await chamberPresetsReference.doc(preset.id).delete();
      return true;
    } catch (e) {
      logger.d(e.toString);
      return false;
    }
  }


  Future<bool> updateAtNeomChamber(String neomUserId, String chamberId, NeomChamberPreset preset) async {
    logger.d("Updating NeomChamberPreset for user $neomUserId");

    try {
      await neomUsersReference.doc(neomUserId)
          .collection(NeomFirestoreConstants.fs_profiles).doc(neomUserId)
          .collection(NeomFirestoreConstants.fs_chambers).doc(chamberId)
          .update({"neomChamberPresets": FieldValue.arrayUnion([preset.toJSON()])});

      print("Preset ${preset.name} was updated");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    print("Preset ${preset.name} was not updated");
    return false;
  }


  Future<bool> removeFromNeomChamber(String neomUserId, String chamberId, NeomChamberPreset preset) async {
    print("Updating NeomChamberPreset for user $neomUserId");

    try {
      await neomUsersReference.doc(neomUserId)
          .collection(NeomFirestoreConstants.fs_profiles).doc(neomUserId)
          .collection(NeomFirestoreConstants.fs_chambers).doc(chamberId)
          .update(preset.toJSON());
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    print("Preset ${preset.name} was not updated");
    return false;
  }


  Future<Map<String, NeomChamberPreset>> getPresetsFromNeomChamber(String userId, NeomChamber chamber) async {
    logger.d("");

    Map<String,NeomChamberPreset> neomPresets = Map();

    String presetId = chamber.neomChamberPresets!.first.id;

    NeomChamberPreset preset;
    DocumentSnapshot? doc = await chamberPresetsReference.doc(presetId).get().then((value) => null);
    if(doc!.exists) {
      preset = NeomChamberPreset.fromDocumentSnapshot(doc);
      neomPresets[preset.id] = preset;
    }

    return neomPresets;
  }

  @override
  Future<bool> addPresetToChamber(NeomChamberPreset preset, String chamberId) {
    // TODO: implement addPresetToChamber
    throw UnimplementedError();
  }

  @override
  Future<void> removePresetFromChamber(String presetId, String chamberId) {
    // TODO: implement removePresetFromChamber
    throw UnimplementedError();
  }


}

