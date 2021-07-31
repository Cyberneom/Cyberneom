import 'package:cyberneom/domain/model/neom-comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class NeomCommentRepository {

  Future<List<NeomComment>> retrieveNeomComments(String neomPostId);
  Future<Stream<QuerySnapshot>?> streamNeomComments(String neomPostId);
  Future<String> addComment(String neomProfileId, String neomPostId, NeomComment neomComment);

}


