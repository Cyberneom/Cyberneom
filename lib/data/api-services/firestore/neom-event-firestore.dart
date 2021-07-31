import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-activity-feed-firestore.dart';
import 'package:cyberneom/domain/model/neom-event.dart';
import 'package:cyberneom/domain/repository/neom-event-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:logger/logger.dart';

class NeomEventFirestore implements NeomEventRepository {

  var logger = Logger();
  final neomEventsReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_events);

  Future<NeomEvent> retrieveEvent(String neomEventId) async {
    logger.d("Retrieving NeomEvents");
    DocumentSnapshot documentSnapshot = await neomEventsReference.doc(neomEventId).get();
    var neomEvent;

    if (documentSnapshot.exists) {
      logger.d("Snapshot is not empty");
      neomEvent = NeomEvent.fromDocumentSnapshot(documentSnapshot:documentSnapshot);
      logger.d(neomEvent.toString());
    }

    return neomEvent;
  }

  Future<List<NeomEvent>> retrieveEvents() async {
    logger.d("Retrieving NeomEvents");
    List<NeomEvent> neomEvents = [];
    QuerySnapshot querySnapshot = await neomEventsReference.get();

    if (querySnapshot.docs.isNotEmpty) {
      logger.d("Snapshot is not empty");
      querySnapshot.docs.forEach((postSnapshot) {
        NeomEvent neomEvent = NeomEvent.fromQueryDocumentSnapshot(documentSnapshot:postSnapshot);
        logger.d(neomEvent.toString());
        neomEvents.add(neomEvent);
      });
      logger.d("${neomEvents .length} neomEvents found");
      return neomEvents;
    }
    logger.d("No NeomEvents Found");
    return neomEvents;
  }

  Future<String> createEvent(NeomEvent neomEvent) async {
    logger.d("");
    String neomEventId = "";
    try {
      DocumentReference documentReference = await neomEventsReference.add(neomEvent.toJSON());
      neomEventId = documentReference.id;
      if(await NeomProfileFirestore().addEvent(neomEvent.owner!.id, neomEventId)){
        logger.d("NeomEvent added to NeomProfile");
      }
    } catch (e){
      logger.d(e.toString());
    }

    return neomEventId;
  }

  Future<bool> deleteEvent(String neomProfileId, String neomEventId) async {
    logger.d("");
    bool wasDeleted = false;
    try {
      await neomEventsReference.doc(neomEventId).delete();
      wasDeleted = await NeomProfileFirestore().removeEvent(neomProfileId, neomEventId);
      await NeomActivityFeedFirestore().removeEventActivityFeed(neomEventId);
    } catch (e){
      logger.d(e.toString());
    }

    return wasDeleted;
  }

}


