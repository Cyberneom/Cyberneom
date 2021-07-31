import 'package:cyberneom/data/api-services/firestore/neom-activity-feed-firestore.dart';
import 'package:cyberneom/domain/model/neom-activity-feed.dart';
import 'package:cyberneom/domain/model/neom-comment.dart';
import 'package:cyberneom/domain/repository/neom-comment-repository.dart';
import 'package:cyberneom/utils/enum/neom-activity-feed-type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';


 class NeomCommentFirestore implements NeomCommentRepository {

  var logger = NeomUtilities.logger;  
  final neomPostsReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_posts);

  Future<List<NeomComment>> retrieveNeomComments(String neomPostId) async {
    logger.d("RetrievingComments");
    List<NeomComment> neomPosts = [];

    try {
      QuerySnapshot querySnapshot = await neomPostsReference.doc(neomPostId)
          .collection(NeomFirestoreConstants.fs_comments).get();

      if (querySnapshot.docs.isNotEmpty) {
        logger.d("Snapshot is not empty");
        querySnapshot.docs.forEach((commentSnapshot) {
          NeomComment neomComment = NeomComment.fromDocumentSnapshot(documentSnapshot:commentSnapshot);
          logger.d(neomComment.toString());
          neomPosts.add(neomComment);
        });
        logger.d("${neomPosts .length} neomComments found");
      }
    } catch (e){
      logger.d(e.toString());
    }
    return neomPosts;
  }

  Future<Stream<QuerySnapshot>?> streamNeomComments(String neomPostId) async {
    logger.d("RetrievingProfiles");

    try {
      return neomPostsReference.doc(neomPostId).collection(NeomFirestoreConstants.fs_comments)
          .orderBy('createdTime',descending: true).snapshots();

    } catch (e){
      logger.d(e.toString());
    }

    logger.d("No neomComments Found");
    return null;
  }

  Future<String> addComment(String neomProfileId, String neomPostId, NeomComment neomComment) async {

    String neomCommentId = "";

    try {
      DocumentReference documentReference = await neomPostsReference.doc(neomPostId)
          .collection(NeomFirestoreConstants.fs_comments).add(neomComment.toJSON());
      neomCommentId = documentReference.id;
      if (neomProfileId != neomComment.neomPostOwnerId) {

        NeomActivityFeed neomActivityFeed = NeomActivityFeed(
            id: neomPostId,
            neomOwnerId: neomComment.neomPostOwnerId,
            neomProfileId: neomComment.neomProfileId,
            createdTime: neomComment.createdTime,
            neomActivityFeedType: NeomActivityFeedType.Comment,
            neomMessage: neomComment.text,
            neomProfileName: neomComment.neomProfileName,
            neomProfileImgUrl: neomComment.neomProfileImgUrl,
            mediaUrl: neomComment.mediaUrl);

        NeomActivityFeedFirestore().addActivityFeed(neomActivityFeed);

      }
    } catch (e) {
      logger.e(e.toString());
    }

    return neomCommentId;

  }

}


