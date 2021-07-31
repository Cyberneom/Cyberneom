import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class NeomPostRepository {

  Future<List<NeomPost>> retrievePosts(String neomUserId);

  Future<bool> handleLikePost(String neomProfileId, String neomPostId, bool isLiked);
  Future<bool> createPost(NeomPost neomPost);

  Future<bool> deletePost(String neomProfileId, String neomPostId);

  Future<List<NeomPost>> getPosts(String neomProfileId);

  Future<Map<String, NeomPost>> getTimeline();

  Future<Map<String, NeomPost>> getNextTimeline();
  Future<Stream<DocumentSnapshot>?> streamPost(String neomPostId);

}


