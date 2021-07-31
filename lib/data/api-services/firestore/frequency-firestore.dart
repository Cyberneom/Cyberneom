import 'dart:async';

import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/repository/frequency-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:logger/logger.dart';

class FrequencyFirestore implements FrequencyRepository {

  var logger = Logger();

  final neomProfileReference = FirebaseFirestore.instance.collectionGroup(NeomFirestoreConstants.fs_profiles);

  Future<Map<String,NeomFrequency>> retrieveFrequencies(neomProfileId) async {
    logger.d("Retrieving frequency by $neomProfileId");
    Map<String, NeomFrequency> frequencies = Map<String, NeomFrequency>();

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
            querySnapshot.docs.forEach((document) {
            if(document.id == neomProfileId) {
              document.reference.collection(
                NeomFirestoreConstants.fs_frequencies).get()
                  .then((querySnapshot) {
                    querySnapshot.docs.forEach((queryDocumentSnapshot) {
                      var freq = NeomFrequency.fromQueryDocumentSnapshot(queryDocumentSnapshot: queryDocumentSnapshot);
                      frequencies[freq.name] = freq;
                    });
                  });
              }
            });
          });
    } catch(e) {
      logger.e("No frequencys found");
    }

    logger.d("No frequencys found");
    return frequencies;
  }

  Future<bool> removeFrequency({required String neomProfileId, required String frequencyId}) async {
    logger.d("Removing $frequencyId for by $neomProfileId");
    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.collection(
                NeomFirestoreConstants.fs_frequencies)
                .doc(frequencyId).delete();
          }
        });
      });
    logger.d("frequency $frequencyId removed");
    return true;
    } catch (e) {
      logger.d(e.toString());
      return false;
    }
  }

  Future<String> addBasicFrequency({required String neomProfileId, required String frequencyName}) async {
    logger.d("Adding $frequencyName for $neomProfileId");

    String frequencyId = "";
    NeomFrequency frequencyBasic = NeomFrequency.addBasic(frequencyId);

    try {
      DocumentReference? documentReference = await neomProfileReference.get()
          .then((querySnapshot) {
            querySnapshot.docs.forEach((document) {
              if (document.id == neomProfileId) {
                document.reference.collection(NeomFirestoreConstants.fs_frequencies)
                .add(frequencyBasic.toJsonNoId());
              }
            });
          });

      if(documentReference != null) frequencyId = documentReference.id;

      logger.d("Frequency $frequencyId added");

    } catch (e) {
      logger.d(e.toString());

    }
    return frequencyId;
  }

  Future<bool> updateRootFrequency({required String neomProfileId,
      required String frequencyId, required String prevFreqId}) async {

    logger.d("Updating $frequencyId as main for $neomProfileId");

    try {
      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.collection(
                NeomFirestoreConstants.fs_frequencies).doc(frequencyId).update(
                {"isMainFrequency": true});
            logger.i(
                "frequency $frequencyId as main frequency at frequencies collection");
          }
        });
      });

      await neomProfileReference.get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          if (document.id == neomProfileId) {
            document.reference.update({"rootFrequency": frequencyId});
          }
        });
      });

      logger.d("frequency $frequencyId as main frequency at profile level");

      if(prevFreqId.isNotEmpty) {
        await neomProfileReference.get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((document) {
            if (document.id == neomProfileId) {
              document.reference.collection(
                  NeomFirestoreConstants.fs_frequencies)
                  .doc(prevFreqId).update({"isRootFrequency": false});
              logger.d("frequency $prevFreqId unset from root frequency");
            }
          });
        });
      }
      return true;
    } catch (e) {
      logger.d(e.toString());
      return false;
    }
  }
}

