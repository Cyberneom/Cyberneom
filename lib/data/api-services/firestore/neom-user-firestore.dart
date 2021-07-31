import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/data/api-services/firestore/frequency-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-chamber-firestore.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-user.dart';
import 'package:cyberneom/domain/repository/neom-user-repository.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class NeomUserFirestore implements NeomUserRepository {

  var logger = NeomUtilities.logger;
  final neomUserReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_neomUsers);

  Future<bool> insertUser(NeomUser neomUser) async {

    String neomUserId = neomUser.id;
    logger.i("Inserting user $neomUserId to Firestore");

    Map<String,dynamic> neomUserJSON = neomUser.toJSON();
    logger.d(neomUserJSON.toString());

    DocumentReference documentReferencer = neomUserReference.doc(neomUserId);

    try {
      await documentReferencer.set(neomUserJSON)
          .whenComplete(() => logger.i('User added to the database'))
          .catchError((e) => logger.e(e));

      logger.d("neomUser ${neomUser.toString()} inserted successfully.");
      return true;

    } catch (e) {
      await removeNeomUser(neomUserId) ? logger.i("neomUser rollback") : logger.d(e);
      return false;
    }
  }

  Future<NeomUser> getUserById(neomUserId) async {
    logger.d("Start Id $neomUserId");
    NeomUser neomUser = NeomUser();
    try {
        DocumentSnapshot documentSnapshot = await neomUserReference.doc(neomUserId).get();
        if (documentSnapshot.exists) {
          neomUser = NeomUser.fromDocumentSnapshot(documentSnapshot: documentSnapshot);

          List<NeomProfile> neomProfiles = await NeomProfileFirestore().retrieveNeomProfiles(neomUserId);

          neomProfiles.forEach((neomProfile) async {
            neomProfile.rootFrequencies = await FrequencyFirestore().retrieveFrequencies(neomProfile.id);
            neomProfile.neomChambers = await NeomChamberFirestore().retrieveNeomChambers(neomProfile.id);

            if(neomProfile.rootFrequencies!.isEmpty) logger.d("Frequencies not found");
            if(neomProfile.neomChambers!.isEmpty) logger.d("Chambers not found");

          });

          if(neomProfiles.isEmpty) logger.d("neomProfile not found");
          neomUser.neomProfiles = neomProfiles;
          logger.d("neomUser ${neomUser.toString()}");
        } else {
          logger.i("No neomUser found");
        }
    } catch (e) {
      logger.d(e.toString());
    }

    return neomUser;
  }

  Future<bool> removeNeomUser(String neomUserId) async {
    logger.d("Removing neomUser $neomUserId from Firestore");

    try {
      await neomUserReference.doc(neomUserId).delete();
      logger.d("neomUser $neomUserId removed successfully.");
    } catch (e) {
      logger.d(e);
      return false;
    }

    return true;
  }

  Future<bool> updateAndroidNotificationToken(String neomUserId, String token) async {
    logger.d("Updating Android Notification Token for neomUser $neomUserId");

    try {
      await neomUserReference.doc(neomUserId).update({"androidNotificationToken": token});
      logger.d("neomUser $neomUserId removed successfully.");
      return true;
    } catch (e) {
      logger.d(e);
      return false;
    }
  }

  @override
  Future<bool> isAvailableEmail(String email) async {

    logger.d("Verify if email $email is already in use");

    try {
      QuerySnapshot querySnapshot = await neomUserReference.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        logger.d("Email already in use");
        return false;
      }

      logger.d("No neomUser found");
      return true;

    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }
  }

}