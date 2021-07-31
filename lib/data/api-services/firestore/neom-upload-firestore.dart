import 'dart:io';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:cyberneom/domain/repository/neom-upload-repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/enum/neom-upload-image-type.dart';
import 'package:logger/logger.dart';

class NeomUploadFirestore implements NeomUploadRepository {

  var logger = Logger();
  final neomPostsReference = FirebaseFirestore.instance.collection(NeomFirestoreConstants.fs_posts);
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImage(String neomPostId, File file, NeomUploadImageType neomUploadType) async {
    UploadTask uploadTask = storageRef
        .child("${EnumToString.convertToString(neomUploadType).toLowerCase()}"
        "_$neomPostId.jpg").putFile(file);

    TaskSnapshot storageSnap = await uploadTask;
    return await storageSnap.ref.getDownloadURL();
  }

  Future<String> uploadVideo(String neomPostId, File file) async {
    UploadTask uploadTask= storageRef.child('video_$neomPostId.mp4').putFile(file);
    TaskSnapshot storageSnap = await uploadTask;
    return await storageSnap.ref.getDownloadURL();
  }

}


