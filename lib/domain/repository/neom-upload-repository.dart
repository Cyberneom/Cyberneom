import 'dart:io';

import 'package:cyberneom/utils/enum/neom-upload-image-type.dart';


abstract class NeomUploadRepository {

  Future<String> uploadImage(String neomPostId, File file, NeomUploadImageType neomUploadImageType);
  Future<String> uploadVideo(String neomPostId, File file);

}


