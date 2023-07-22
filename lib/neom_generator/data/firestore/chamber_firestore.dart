// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cyberneom/neom_generator/domain/repository/chamber_repository.dart';
// import 'package:neom_commons/core/data/firestore/constants/app_firestore_collection_constants.dart';
// import 'package:neom_commons/core/data/firestore/constants/app_firestore_constants.dart';
// import 'package:neom_commons/core/domain/model/item_list.dart';
// import 'package:neom_commons/core/domain/model/neom/neom_chamber.dart';
// import 'package:neom_commons/core/domain/model/neom/neom_chamber_preset.dart';
// import 'package:neom_commons/core/utils/app_utilities.dart';
//
// class ChamberFirestore implements ChamberRepository {
//
//   var logger = AppUtilities.logger;
//   final profileReference = FirebaseFirestore.instance.collectionGroup(AppFirestoreCollectionConstants.profiles);
//
//   @override
//   Future<bool> addPreset(String profileId, NeomChamberPreset preset, String chamberId) async {
//     logger.d("Adding preset for profileId $profileId");
//     logger.d("Adding preset to chamber $chamberId");
//     bool addedItem = false;
//
//     try {
//
//        QuerySnapshot querySnapshot = await profileReference.get();
//
//        for (var document in querySnapshot.docs) {
//          if(document.id == profileId) {
//            await document.reference.collection(AppFirestoreCollectionConstants.chambers)
//             .doc(chamberId)
//             .update({
//               AppFirestoreConstants.presets: FieldValue.arrayUnion([preset.toJSON()])
//             });
//
//            addedItem = true;
//          }
//       }
//     } catch (e) {
//       logger.e(e.toString());
//     }
//
//     //TODO Verify if needed of if was just because async shit not well implemented
//     //await Future.delayed(const Duration(seconds: 1));
//     addedItem ? logger.d("Preset was added to chamber $chamberId") :
//     logger.d("Preset was not added to chamber $chamberId");
//     return addedItem;
//   }
//
//
//   @override
//   Future<bool> removePreset(String profileId, NeomChamberPreset preset, String chamberId) async {
//     logger.d("Removing preset from chamber $chamberId");
//
//     try {
//       await profileReference.get()
//           .then((querySnapshot) async {
//         for (var document in querySnapshot.docs) {
//           if(document.id == profileId) {
//             await document.reference
//                 .collection(AppFirestoreCollectionConstants.itemlists)
//                 .doc(chamberId)
//                 .update({
//                   AppFirestoreConstants.presets: FieldValue.arrayRemove([preset.toJSON()])
//                 });
//           }
//         }
//       });
//
//       logger.d("Preset was removed from chamber $chamberId");
//       return true;
//     } catch (e) {
//       logger.e(e.toString());
//     }
//
//     logger.d("Preset was not  removed from chamber $chamberId");
//     return false;
//   }
//
//   @override
//   Future<bool> updatePreset(String profileId, String chamberId, NeomChamberPreset preset) async {
//     logger.d("Updating preset for profile $profileId");
//
//     try {
//
//       await profileReference.get()
//           .then((querySnapshot) async {
//         for (var document in querySnapshot.docs) {
//           if(document.id == profileId) {
//             await document.reference.collection(AppFirestoreCollectionConstants.itemlists)
//                 .doc(chamberId).update({
//               AppFirestoreConstants.presets: FieldValue.arrayUnion([preset.toJSON()])
//             });
//           }}
//       });
//
//       logger.d("Preset ${preset.name} was updated to ${preset.state}");
//       return true;
//     } catch (e) {
//       logger.e(e.toString());
//     }
//
//     logger.d("Preset ${preset.name} was not updated");
//     return false;
//   }
//
// }
