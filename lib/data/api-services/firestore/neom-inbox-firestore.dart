import 'dart:async';
import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/domain/model/neom-inbox.dart';
import 'package:cyberneom/domain/model/neom-message.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/repository/neom-inbox-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class NeomInboxFirestore implements NeomInboxRepository {

  var logger = NeomUtilities.logger;
  final neomInboxReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_inbox);

  Future<bool> addMessage(String neomInboxRoomId, NeomMessage neomMessage) async {
    logger.d("RetrievingProfiles");

    try {
      await neomInboxReference.doc(neomInboxRoomId).collection(NeomFirestoreConstants.fs_messages).add(neomMessage.toJSON());
      logger.d("${neomMessage.text} message added");
      await neomInboxReference.doc(neomInboxRoomId).update({"lastMessage": neomMessage.toJSON()});
      logger.d("${neomMessage.text} last Message added");
      return true;
    } catch (e) {
      logger.d("Something occurred.");

    }
    logger.d("Message not send");
    return false;
  }

  Future<bool> neomInboxExists(String neomInboxId) async {
    logger.d("");

    try {
      DocumentSnapshot documentSnapshot = await neomInboxReference.doc(neomInboxId).get();
      if(documentSnapshot.exists){
        return true;
      }
    } catch (e) {
      logger.d(e.toString);
    }

    logger.d("");
    return false;
  }

  Future<List<NeomMessage>> retrieveNeomMessages(String neomInboxId) async {
    logger.d("Retrieving messages for $neomInboxId");
    List<NeomMessage> neomMessages = [];

    try {
      QuerySnapshot querySnapshot = await neomInboxReference.doc(neomInboxId)
          .collection(NeomFirestoreConstants.fs_messages)
          .orderBy(NeomFirestoreConstants.createdTime).get();

      if (querySnapshot.docs.isNotEmpty) {
        logger.d("snapshot is not empty");
        querySnapshot.docs.forEach((messageSnapshot) {
          NeomMessage neomMessage = NeomMessage.fromQueryDocumentSnapshot(queryDocumentSnapshot: messageSnapshot);
          logger.d(neomMessage.toString());
          neomMessages.add(neomMessage);
        });
        logger.d("${neomMessages.length} messages retrieved");
      } else {

      }
      logger.d("No messages found Found");

    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }

    logger.d("Exit");
    return neomMessages;
  }

  searchInboxByName(String searchField) {
    return neomInboxReference.where('userName', isEqualTo: searchField).get();
  }

  Future<bool> addNeomInbox(NeomInbox neomInbox) async {
    logger.d("");

    try {
      await neomInboxReference.doc(neomInbox.id).set(neomInbox.toJSON());
      logger.d("");
      return true;
    } catch (e) {
      logger.d(e.toString());
    }

    return false;
  }

  Future<List<NeomInbox>> getNeomProfileInbox(String neomProfileId) async {
    logger.d("");

    List<NeomInbox> neomInboxs = [];

    try {
      QuerySnapshot querySnapshot = await neomInboxReference.where('neomProfiles', arrayContains: neomProfileId).get();

      if (querySnapshot.docs.isNotEmpty) {
        logger.d("Snapshot is not empty");
        for(int queryIndex = 0; queryIndex < querySnapshot.docs.length; queryIndex++)  {

          NeomInbox neomInbox = NeomInbox.fromQueryDocumentSnapshot(querySnapshot.docs.elementAt(queryIndex));
          neomInbox.neommates = [];
          for(int i = 0; i < neomInbox.neomProfileIds!.length; i++)  {
            String neommateId = neomInbox.neomProfileIds!.elementAt(i);
            if(neommateId != neomProfileId) {
              NeomProfile neommate = await NeomProfileFirestore().retrieveNeomProfileSimple(neommateId);
              neomInbox.neommates!.add(neommate);
            }
          }

            logger.d(neomInbox.toString());
            neomInboxs.add(neomInbox);
          }
        }
      logger.d("${neomInboxs.length} inboxRoom retrieved");
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("");
    return neomInboxs;
  }


  Future<NeomInbox> getOrCreateNeomInboxRoom(NeomProfile neomProfile, NeomProfile neommate) async {
    logger.d("");

    NeomInbox neomInbox = NeomInbox();

    String neomInboxRoomId = "${neomProfile.id}_${neommate.id}";
    String neommateInboxRoomId = "${neommate.id}_${neomProfile.id}";

    try {
      DocumentSnapshot documentSnapshot = await neomInboxReference.doc(neomInboxRoomId).get();
      if(documentSnapshot.exists){
        logger.d("Retrieving neomInbox from main user");
        neomInbox = NeomInbox.fromDocumentSnapshot(documentSnapshot);
      } else {
        DocumentSnapshot neommateDocumentSnapshot = await neomInboxReference.doc(neommateInboxRoomId).get();
        if(neommateDocumentSnapshot.exists){
          logger.d("Retrieving neomInbox from neommate");
          neomInbox = NeomInbox.fromDocumentSnapshot(neommateDocumentSnapshot);
        } else {
          logger.d("Creating neomInbox from main user");
          neomInbox.id = neomInboxRoomId;
          List<String> neomProfileIds = [];
          neomProfileIds.add(neomProfile.id);
          neomProfileIds.add(neommate.id);
          neomInbox.neomProfileIds = neomProfileIds;

          await neomInboxReference.doc(neomInboxRoomId).set(neomInbox.toJSON());
        }
      }

      neomInbox.neommates = [];
      for(int i = 0; i < neomInbox.neomProfileIds!.length; i++)  {
        String neommateId = neomInbox.neomProfileIds!.elementAt(i);
        if(neommateId != neomProfile.id) {
          NeomProfile neommate = await NeomProfileFirestore().retrieveNeomProfileSimple(neommateId);
          neomInbox.neommates!.add(neommate);
        }
      }
    } catch (e) {
      logger.d(e.toString);
      rethrow;
    }

    logger.d(neomInbox.toString());
    return neomInbox;
  }

  @override
  Stream listenToInboxRealTime(neomInboxRoomId) {
    // TODO: implement listenToInboxRealTime
    throw UnimplementedError();
  }


}


