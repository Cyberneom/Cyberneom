import 'dart:async';
import 'package:cyberneom/domain/model/neom-post.dart';

abstract class NeomPostService {

  Future<void> addPost(NeomPost neomPost);
  Future<void> removePost(NeomPost neomPost);
  Future<void> updatePost(NeomPost neomPost);

}