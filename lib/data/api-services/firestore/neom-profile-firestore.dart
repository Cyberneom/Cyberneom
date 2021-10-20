import 'dart:async';
import 'dart:convert';
import 'package:cyberneom/data/api-services/firestore/frequency-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-chamber-firestore.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/domain/repository/neom-profile-repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:logger/logger.dart';

class NeomProfileFirestore implements NeomProfileRepository {

  var logger = Logger();
  final neomUsersReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_neomUsers);
  final neomProfileReference = FirebaseFirestore.instance.collectionGroup(NeomFirestoreConstants.fs_profiles);

  Future<String> insertNeomProfile(String neomUserId, NeomProfile neomProfile) async {

    logger.i("Inserting neomProfile ${neomProfile.id} to Firestore");
    String neomProfileId = "";
    try {

      Map<String,dynamic> neomProfileJSON = neomProfile.toJSON();
      logger.d(neomProfileJSON.toString());

      DocumentReference documentReference = await neomUsersReference.doc(neomUserId)
          .collection(NeomFirestoreConstants.fs_profiles).add(neomProfileJSON);

      neomProfileId = documentReference.id;

      neomProfile.rootFrequencies!.forEach((name, frequency) async {
        Map<String,dynamic> frequencyJSON = frequency.toJsonNoId();
        logger.d(frequencyJSON.toString());
        frequency.id = await FrequencyFirestore().addBasicFrequency(neomProfileId: neomProfileId, frequencyName:  name);
        neomProfile.neomChambers!.values.first.neomChamberPresets!.first.neomFrequency = frequency;
      });


      NeomChamberFirestore().insert(neomProfileId: neomProfileId,
          neomChamber: neomProfile.neomChambers!.values.first);

      logger.d("neomProfile ${neomProfile.toString()} inserted successfully.");
    } catch (e) {
      await removeNeomProfile(neomUserId: neomUserId, neomProfileId: neomProfileId)
          ? logger.i("neomProfile Rollback") : logger.d(e);

    }

    return neomProfileId;
  }


  Future<NeomProfile> retrieveNeomProfile(String neomProfileId) async {
    logger.d("Retrieving neomProfile $neomProfileId");
    NeomProfile neomProfile = NeomProfile();

    try {

      await neomProfileReference.get()
          .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            if(document.id == neomProfileId) {
              neomProfile = NeomProfile.fromDocumentSnapshot(document);
            }
          });
        });

        if(neomProfile.id.isNotEmpty) {
          Map<String?, NeomFrequency> instruments = await FrequencyFirestore().retrieveFrequencies(neomProfileId);
          instruments.isNotEmpty ? neomProfile.rootFrequencies = instruments.cast<String, NeomFrequency>() : logger.d("Instruments not found");
          logger.d("neomUser ${neomProfile.toString()}");
        } else {
          logger.d("neomProfile not found");
        }

    } catch (e) {
      logger.d(e.toString());
    }

    return neomProfile;
  }


  Future<NeomProfile> retrieveNeomProfileSimple(String neomProfileId) async {
    logger.d("Retrieving neomProfile $neomProfileId");
    NeomProfile neomProfile = NeomProfile();
    try {
      DocumentSnapshot documentSnapshot = await neomUsersReference.doc(neomProfileId)
          .collection(NeomFirestoreConstants.fs_profiles).doc(neomProfileId).get();

      if (documentSnapshot.exists) {
        neomProfile = NeomProfile.fromDocumentSnapshot(documentSnapshot);
      } else {
        logger.d("neomProfile not found");
      }
      logger.d("neomUser ${neomProfile.toString()}");
    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }

    return neomProfile;
  }


  Future<bool> removeNeomProfile({required String neomUserId, required String neomProfileId}) async {
    logger.d("Removing neomProfile $neomProfileId from Firestore");

    try {
      await neomUsersReference.doc(neomUserId).collection(NeomFirestoreConstants.fs_profiles).doc(neomProfileId).delete();
      logger.d("neomProfile $neomProfileId removed successfully from neomUser $neomUserId.");
    } catch (e) {
      logger.d(e);
      return false;
    }

    return true;
  }

  Future<List<NeomProfile>> retrieveNeomProfiles(String neomUserId) async {
    logger.d("RetrievingProfiles");
    List<NeomProfile> neomProfiles = <NeomProfile>[];
    QuerySnapshot querySnapshot = await neomUsersReference.doc(neomUserId)
        .collection(NeomFirestoreConstants.fs_profiles).get();

    if (querySnapshot.docs.isNotEmpty) {
      logger.d("Snapshot is not empty");
      querySnapshot.docs.forEach((profileSnapshot) {
        NeomProfile neomProfile = NeomProfile.fromQueryDocumentSnapshot(queryDocumentSnapshot:profileSnapshot);
        logger.d(neomProfile.toString());
        neomProfiles.add(neomProfile);
      });
    }

    logger.d("${neomProfiles .length} neomProfiles found");
    return neomProfiles;
  }


  Future<NeomProfile>? getNeommateDetails(NeomProfile neomProfile){
    return null;
  }


  Future<bool> followNeomProfile(String neomProfileId, String followedNeomProfileId) async {
    logger.d("$neomProfileId would be following $followedNeomProfileId");

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.update({
              NeomFirestoreConstants.fs_following: FieldValue.arrayUnion(
                  [followedNeomProfileId])
            });
          }
        });
      });
      logger.d("$neomProfileId is now following $followedNeomProfileId");

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == followedNeomProfileId) {
            document.reference
              ..update({
                NeomFirestoreConstants.fs_followers: FieldValue.arrayUnion(
                    [neomProfileId])
              });
          }
        });
      });
      logger.d("$followedNeomProfileId is now followed by $neomProfileId");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }
    return false;
  }


  Future<bool> unfollowNeomProfile(String neomProfileId, String unfollowNeomProfileId) async {
    logger.d("$neomProfileId would be unfollowing $unfollowNeomProfileId");

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.update({
              NeomFirestoreConstants.fs_following: FieldValue.arrayRemove(
                  [unfollowNeomProfileId])
            });
          }
        });
      });
      logger.d("$neomProfileId is now unfollowing $unfollowNeomProfileId");

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == unfollowNeomProfileId) {
            document.reference.update({
              NeomFirestoreConstants.fs_followers: FieldValue.arrayRemove(
                  [neomProfileId])
            });
          }
        });
      });
      logger.d("$unfollowNeomProfileId is now unfollowed by $neomProfileId");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }
    return false;
  }


  Future<bool> removeNeommate(String neomProfileId, String neommateId) async {
    logger.d("$neomProfileId would be neommate with $neommateId");

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.update({
              NeomFirestoreConstants.fs_neommates: FieldValue.arrayRemove(
                  [neommateId])
            });
          }
        });
      });

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neommateId) {
            document.reference.update({
              NeomFirestoreConstants.fs_neommates: FieldValue.arrayRemove(
                  [neomProfileId])
            });
          }
        });
      });

      logger.d("$neomProfileId and $neommateId are not neommates now");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    return false;
  }


  Future<bool> updatePosition(String neomUserId, String neomProfileId, Position newPosition) async {
    logger.d("$neomProfileId updating location");

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.update({
              NeomFirestoreConstants.fs_position: jsonEncode(newPosition)
            });
          }
        });
      });
      logger.d("$neomProfileId location updated");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    return false;
  }


  Future<bool> addPost(String neomProfileId, String neomPostId) async {
    logger.d("$neomProfileId would add $neomPostId");

    try {

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if(document.id == neomProfileId) {
            document.reference.update({NeomFirestoreConstants.fs_posts: FieldValue.arrayUnion([neomPostId])
            });
          }
        });
      });

      logger.d("$neomProfileId has post $neomPostId");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }
    return false;
  }


  Future<bool> removePost(String neomProfileId, String neomPostId) async {
    logger.d("$neomProfileId would remove $neomPostId");

    try {

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if(document.id == neomProfileId) {
            document.reference.update({NeomFirestoreConstants.fs_posts: FieldValue.arrayRemove([neomPostId])
            });
          }
        });
      });

      logger.d("$neomProfileId has removed neompost $neomPostId");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }
    return false;
  }


  Future<bool> updateNeomProfileInfo(String neomProfileId, String neomProfileName, String neomProfileAboutMe) async {
    logger.d("");
    try {

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if(document.id == neomProfileId) {
            document.reference.update({'name': neomProfileName,'aboutMe': neomProfileAboutMe
            });
          }
        });
      });


    } catch (e) {
      logger.d(e.toString());
      return false;
    }

    return true;
  }


  Future<bool> addEvent(String neomProfileId, String neomEventId) async {
    logger.d("$neomProfileId would add $neomEventId");

    try {

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if(document.id == neomProfileId) {
            document.reference.update({NeomFirestoreConstants.fs_events: FieldValue.arrayUnion([neomEventId])
            });
          }
        });
      });

      logger.d("$neomProfileId has post $neomEventId");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }
    return false;
  }


  Future<bool> removeEvent(String neomProfileId, String neomEventId) async {
    logger.d("$neomProfileId would remove $neomEventId");

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if(document.id == neomProfileId) {
            document.reference.update({NeomFirestoreConstants.fs_events: FieldValue.arrayRemove([neomEventId])
            });
          }
        });
      });

      logger.d("$neomProfileId has removed neompost $neomEventId");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }
    return false;
  }


  Future<QuerySnapshot> handleSearch(String query) async {
    logger.d("");
    return neomProfileReference.where('name', isGreaterThanOrEqualTo: query)
        .get();
  }

}

