
import 'package:cyberneom/domain/model/neom-activity-feed.dart';
import 'package:cyberneom/domain/repository/neom-ctivity-feed-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:logger/logger.dart';

class NeomActivityFeedFirestore implements NeomActivityFeedRepository {

  var logger = Logger();

  final activityFeedReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_activityFeed);
  final feedItemsReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_activityFeedItems);


  removeLikeFromActivityFeed(String neomUserId, String neomOwnerId, NeomActivityFeed neomActivityFeed){
    logger.d("");
    bool isNotPostOwner = neomUserId != neomOwnerId;

    if(isNotPostOwner) {
      activityFeedReference
          .doc(neomOwnerId)
          .collection(NeomFirestoreConstants.fs_activityFeedItems)
          .doc(neomActivityFeed.id)
          .get().then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }


  Future<bool> addActivityFeed(NeomActivityFeed neomActivityFeed) async {
    //add only activity my by other user (to avoid getting notification for our own like)
    logger.d("");
    bool isNotPostOwner = neomActivityFeed.neomProfileId != neomActivityFeed.neomOwnerId;
    try {
      if(isNotPostOwner) {
        await activityFeedReference.doc(neomActivityFeed.neomOwnerId)
            .collection(NeomFirestoreConstants.fs_activityFeedItems).doc(neomActivityFeed.id).set(neomActivityFeed.toJSON());
      }
    } catch (e) {
      logger.d(e.toString());
      return false;
    }

    return true;
  }


  Future<List<NeomActivityFeed>> retrieveActivityFeed(String neomProfileId) async {
    //add only activity my by other user (to avoid getting notification for our own like)
    logger.d("");
    List<NeomActivityFeed> feedItems=[];

    try {
      QuerySnapshot querySnapshot = await activityFeedReference.doc(neomProfileId)
          .collection(NeomFirestoreConstants.fs_activityFeedItems).orderBy('createdTime',descending: true).limit(50)
          .get();

      querySnapshot.docs.forEach((doc){
        feedItems.add(NeomActivityFeed.fromDocumentSnapshot(documentSnapshot: doc));
      });
    } catch (e) {
      logger.d(e.toString());
    }

    return feedItems;
  }


  Future<bool> removePostActivityFeed(String neomPostId) async {
    logger.d("");
    bool postActivityFeedRemoved = false;
    QuerySnapshot querySnapshot = await feedItemsReference.where("activityFeedId", isEqualTo: neomPostId).get();

    int activityFeedCounter = 0;
    if (querySnapshot.docs.isNotEmpty) {
      logger.d("Snapshot is not empty ${querySnapshot.docs.length} results found");
      querySnapshot.docs.forEach((snapshot) {
        snapshot.reference.delete();
        activityFeedCounter++;
      });

      postActivityFeedRemoved = true;
      logger.d("$activityFeedCounter were removed from feed Collection");
    }

    return postActivityFeedRemoved;

  }


  Future<bool> removeEventActivityFeed(String neomEventId) async {
    logger.d("");
    bool eventActivityFeedRemoved = false;
    QuerySnapshot querySnapshot = await feedItemsReference.where("activityFeedId", isEqualTo: neomEventId).get();

    int activityFeedCounter = 0;
    if (querySnapshot.docs.isNotEmpty) {
      logger.d("Snapshot is not empty ${querySnapshot.docs.length} results found");
      querySnapshot.docs.forEach((snapshot) {
        snapshot.reference.delete();
        activityFeedCounter++;
      });

      eventActivityFeedRemoved = true;
      logger.d("$activityFeedCounter were removed from feed Collection");
    }

    return eventActivityFeedRemoved;
  }

  @override
  Future<bool> addFollowToActivityFeed(String neomProfileId, NeomActivityFeed neomActivityFeed) {
    // TODO: implement addFollowToActivityFeed
    throw UnimplementedError();
  }

  @override
  removeLikeFromFeed() {
    // TODO: implement removeLikeFromFeed
    throw UnimplementedError();
  }

}

