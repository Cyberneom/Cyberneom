import 'dart:async';

import 'package:cyberneom/utils/enum/neom-from.dart';
import 'package:cyberneom/utils/enum/neom-upload-image-type.dart';

abstract class NeomUploadService {

  void disposeVideoPlayer();

  Future<void> handleImage(NeomFileFrom neomFrom);
  void clearImage();
  compressImage();

  Future<void> handleSubmit();
  Future<void> handlePostUpload();

  Future<void> getUserLocation();
  Future<void> verifyLocation();
  Future<void> playPauseVideo();
  handleEventImage();
  Future<String> handleUploadImage(NeomUploadImageType neomUploadType);

}