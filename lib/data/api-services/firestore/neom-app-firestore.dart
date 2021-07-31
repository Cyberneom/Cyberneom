import 'dart:async';
import 'package:cyberneom/domain/model/neom-app.dart';
import 'package:cyberneom/domain/repository/neom-app-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class NeomAppFirestore implements NeomAppRepository {

  final logger = NeomUtilities.logger;
  final fsInstance = FirebaseFirestore.instance;

  Future<NeomApp> retrieveNeomApp() async {
    logger.i("Retrieving NeomApp Info");
    NeomApp neomApp = NeomApp(id: "", version: "");

    try {
      DocumentSnapshot documentSnapshot = await fsInstance.collection(NeomFirestoreConstants.fs_neomApp)
          .doc(NeomFirestoreConstants.fs_neomApp).get();

      if (documentSnapshot.exists) {
        neomApp = NeomApp.fromDocumentSnapshot(documentSnapshot);
        logger.i("NeomApp found with AppVersion ${neomApp.version}");
      }
    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }

    logger.d("");
    return neomApp;
  }
}
