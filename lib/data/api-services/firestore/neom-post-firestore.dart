import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-activity-feed-firestore.dart';
import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cyberneom/domain/repository/neom-post-repository.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/enum/neom-post-type.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import 'neom-comment-firestore.dart';

class NeomPostFirestore implements NeomPostRepository{
  
  var logger = Logger();
  final neomPostsReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_posts);


  Future<List<NeomPost>> retrievePosts(String neomUserId) async {
    logger.d("RetrievingProfiles");
    List<NeomPost> neomPosts = <NeomPost>[];
    QuerySnapshot querySnapshot = await neomPostsReference.get();

    if (querySnapshot.docs.isNotEmpty) {
      logger.d("Snapshot is not empty");
      querySnapshot.docs.forEach((postSnapshot) {
        NeomPost post = NeomPost.fromDocumentSnapshot(documentSnapshot:postSnapshot);
        logger.d(post.toString());
        neomPosts.add(post);
      });
      logger.d("${neomPosts.length} neomPosts found");
      return neomPosts;
    }
    logger.d("No NeomPosts Found");
    return neomPosts;
  }


  Future<bool> handleLikePost(String neomProfileId, String neomPostId, bool isLiked) async {
    logger.d("");
    try {
      if(isLiked){
        await neomPostsReference.doc(neomPostId).update({NeomConstants.likedProfiles: FieldValue.arrayRemove([neomProfileId])});
      } else {
        await neomPostsReference.doc(neomPostId).update({NeomConstants.likedProfiles: FieldValue.arrayUnion([neomProfileId])});
      }
      return true;
    } catch (e) {
      logger.d(e.toString());
      return false;
    }
  }


  Future<bool> createPost(NeomPost neomPost) async {
    logger.d("");
    try {
      DocumentReference documentReference = await neomPostsReference.add(neomPost.toJSON());
      String neomPostId = documentReference.id;

      return neomPost.type != NeomPostType.Event ?
          await NeomProfileFirestore().addPost(neomPost.ownerId, neomPostId)
          : true;
    } catch (e){
      logger.d(e.toString());
      return false;
    }
  }


  Future<bool> deletePost(String neomProfileId, String neomPostId) async {
    logger.d("");
    bool wasDeleted = false;
    try {
      await neomPostsReference.doc(neomPostId).delete();
      wasDeleted = await NeomProfileFirestore().removePost(neomProfileId, neomPostId);
      await NeomActivityFeedFirestore().removePostActivityFeed(neomPostId);
    } catch (e){
      logger.d(e.toString());
    }

    return wasDeleted;
  }


  Future<List<NeomPost>> getPosts(String neomProfileId) async {
    logger.d("");

    List<NeomPost> neomPosts = [];

    QuerySnapshot querySnapshot = await neomPostsReference.where(NeomConstants.ownerId, isEqualTo: neomProfileId).get();

    if (querySnapshot.docs.isNotEmpty) {
      logger.d("Snapshot is not empty");
      for(int queryIndex = 0; queryIndex < querySnapshot.docs.length; queryIndex++)  {

        NeomPost post = NeomPost.fromQueryDocumentSnapshot(queryDocumentSnapshot: querySnapshot.docs.elementAt(queryIndex));

        logger.d(post.toString());
        if(post.type != NeomPostType.Event){
          neomPosts.add(post);
        }
      }
    }
    return neomPosts;
  }


  Future<Map<String, NeomPost>> getTimeline() async {
    logger.d("");
    Map<String, NeomPost> posts = Map();

    QuerySnapshot snapshot = await neomPostsReference
        .orderBy("createdTime", descending: true).limit(NeomConstants.timelineLimit)
        .get();

    List<QueryDocumentSnapshot> _documentTimeline = snapshot.docs;
    for(int i=0; i < _documentTimeline.length; i++) {
      NeomPost neomPost = NeomPost.fromDocumentSnapshot(documentSnapshot: _documentTimeline.elementAt(i));
      neomPost.neomComments = await NeomCommentFirestore().retrieveNeomComments(neomPost.id);
      posts[neomPost.id] = neomPost;
    }

    return posts;
  }


  @override
  Future<Map<String, NeomPost>> getNextTimeline() {
    // TODO: implement getNextTimeline
    throw UnimplementedError();
  }


  @override
  Future<Stream<DocumentSnapshot<Object?>>?> streamPost(String neomPostId) {
    // TODO: implement streamPost
    throw UnimplementedError();
  }

}

