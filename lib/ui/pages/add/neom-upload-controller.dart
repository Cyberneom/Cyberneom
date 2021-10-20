import 'dart:async';
import 'dart:io';

import 'package:cyberneom/data/api-services/firestore/neom-post-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-upload-firestore.dart';
import 'package:cyberneom/data/implementations/geolocator-service-impl.dart';
import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/use-cases/neom-upload-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';

import 'package:cyberneom/utils/enum/neom-post-type.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/enum/neom-from.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/enum/neom-upload-image-type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class NeomUploadController extends GetxController implements NeomUploadService {

  var logger = Logger();
  final neomUserController = Get.find<NeomUserController>();

  RxBool _isButtonDisabled = false.obs;
  bool get isButtonDisabled => _isButtonDisabled.value;
  set isButtonDisabled(bool isButtonDisabled) => this._isButtonDisabled.value = isButtonDisabled;

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  RxBool _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  set isUploading(bool isLoading) => this._isUploading.value = isUploading;

  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  VideoPlayerController _videoPlayerController = VideoPlayerController.network("");
  VideoPlayerController get videoPlayerController => _videoPlayerController;
  set videoPlayerController(VideoPlayerController videoPlayerController) => this._videoPlayerController = videoPlayerController;

  Rx<PickedFile> _imageFile = PickedFile("").obs;
  PickedFile get imageFile => _imageFile.value;
  set imageFile(PickedFile imageFile) => this._imageFile.value = imageFile;

  File _file = File("");
  String postId = Uuid().v4();

  NeomProfile _neomProfile = NeomProfile();

  late Position _position;

  NeomPostType _neomPostType = NeomPostType.Pending;
  NeomPostType get neomPostType => _neomPostType;

  @override
  void onInit() async {
    super.onInit();
    logger.d("NeomUpload Controller Init");

    _neomProfile = neomUserController.neomProfile!;

    clearImage();
  }

  disposeVideoPlayer() {
    if(videoPlayerController.value.isPlaying) videoPlayerController.pause();
    videoPlayerController = VideoPlayerController.network("");
    videoPlayerController.dispose();
  }


  Future<void> handleImage(NeomFileFrom neomFileFrom, {isProfilePicture = false}) async {

    if(imageFile.path.isNotEmpty) clearImage();

    switch (neomFileFrom) {
      case NeomFileFrom.Camera:
        imageFile = (await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 50))!;
        break;
      case NeomFileFrom.Gallery:
        imageFile = (await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50))!;
        break;
    }

    _neomPostType = NeomPostType.Image;
    if(imageFile.path.isNotEmpty) {
      isProfilePicture ? Get.back()
          :  Get.toNamed(NeomRouteConstants.NEOM_UPLOAD_2);
    }

    update([NeomPageIdConstants.neomUpload, NeomPageIdConstants.onBoardingAddImage]);
  }

  File _thumbnailFile = File("");
  File get thumbnailFile => _thumbnailFile;

  handleVideo(NeomFileFrom neomFileFrom) async {
    PickedFile file;

    try {
      switch (neomFileFrom) {
        case NeomFileFrom.Camera:
          file = (await ImagePicker().getVideo(source: ImageSource.camera))!;
          break;
        case NeomFileFrom.Gallery:
          file = (await ImagePicker().getVideo(source: ImageSource.gallery))!;
          break;
      }

      Get.back();

      if(imageFile.path.isNotEmpty) clearImage();
      _imageFile.value = file;
      _neomPostType = NeomPostType.Video;

      File videoFile = File(imageFile.path);
      _videoPlayerController = VideoPlayerController.file(videoFile);
      videoPlayerController.initialize();
      videoPlayerController.setLooping(true);

      _thumbnailFile = await VideoCompress.getFileThumbnail(
          imageFile.path,
          quality: 50, // default(100)
          position: -1 // default(-1)
      );
    } catch (e){
      logger.d(e.toString());
    }

    if(imageFile.path.isNotEmpty) Get.toNamed(NeomRouteConstants.NEOM_UPLOAD_2);
    update([NeomPageIdConstants.neomUpload]);
  }

  clearImage(){
    _imageFile.value =  PickedFile("");
    _neomPostType = NeomPostType.Pending;
    if(_videoPlayerController.value.isInitialized) disposeVideoPlayer();
    update([NeomPageIdConstants.neomUpload, NeomPageIdConstants.postComments, NeomPageIdConstants.timeline]);
  }

  compressImage() async{
    _file = File(imageFile.path);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imFile = Im.decodeImage(_file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(imFile!,quality: 85));
    _file=compressedImageFile;
  }

  NeomPost _neomPost = NeomPost();

  String _mediaUrl = "";
  String get mediaUrl => _mediaUrl;

  String _thumbnailUrl = "";

  Future<void> handleSubmit() async {
    _isUploading.value = true;
    _isButtonDisabled.value = true;
    update([NeomPageIdConstants.neomUpload]);

    try {
      if (_neomPostType == NeomPostType.Image) {
        await compressImage();
        _mediaUrl = await NeomUploadFirestore().uploadImage(postId, _file, NeomUploadImageType.Post);
      } else {
        disposeVideoPlayer();
        _file = File(imageFile.path);
        _thumbnailUrl = await NeomUploadFirestore().uploadImage(postId, _thumbnailFile, NeomUploadImageType.Thumbnail);
        _mediaUrl = await NeomUploadFirestore().uploadVideo(postId, _file);
      }
    } catch (e){
      logger.d(e.toString());
    }

    logger.d("File uploaded to $_mediaUrl");
    await handlePostUpload();
  }

  Future<void> handlePostUpload() async {
    logger.d("");
    if (_position.latitude == 0) await getUserLocation();
    if (_position.latitude == 0) _position = _neomProfile.position!;
    _neomPost = NeomPost(caption: captionController.text,
        type: _neomPostType,
        neomProfileName: _neomProfile.name,
        neomProfileImgUrl: _neomProfile.photoUrl,
        ownerId: _neomProfile.id.isEmpty ? neomUserController.neomUser!.id : _neomProfile.id,
        thumbnailUrl: _thumbnailUrl,
        mediaUrl: _mediaUrl,
        position: _position,
        location: await GeoLocatorServiceImpl().getAddressSimple(_position),
        isCommentEnabled: true,
        createdTime: DateTime.now().millisecondsSinceEpoch);

    if(await NeomPostFirestore().createPost(_neomPost)){
      locationController.clear();
      captionController.clear();
      _isUploading.value = false;
      _imageFile.value =  PickedFile("");
      _neomProfile.neomPosts.add(_neomPost.id);
      NeomProfileFirestore().addPost(_neomProfile.id, _neomPost.id);
    }

    Get.offAllNamed(NeomRouteConstants.HOME);
  }

  Future<void> getUserLocation() async{
    Position position = await GeoLocatorServiceImpl().getCurrentPosition();
    locationController.text = await GeoLocatorServiceImpl().getAddressSimple(position);
    _position = position;
  }

  //TODO REMOVE IT
  //bool get wantKeepAlive=>true;

  Future<void> verifyLocation() async {
    logger.d("");
    neomUserController.neomUser!.neomProfiles!.first.position = await GeoLocatorServiceImpl().updateLocation(
        neomUserController.neomUser!.id,
        neomUserController.neomUser!.neomProfiles!.first.id,
        neomUserController.neomUser!.neomProfiles!.first.position!);
  }

  Future<void> playPauseVideo() async {
    logger.d("");
    videoPlayerController.value.isPlaying ?
      videoPlayerController.pause()
        : videoPlayerController.play();
    update([NeomPageIdConstants.neomUpload]);
  }


  handleEventImage() async{
    logger.d("");

    PickedFile? file = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50);

    if(file != null) {
      if(imageFile.path.isNotEmpty) clearImage();
      _imageFile.value = file;
      logger.d("");
    }
  }

  Future<String> handleUploadImage(NeomUploadImageType neomUploadType) async {
    logger.d("");
    String imageUrl = "";

    try {
      await compressImage();
      imageUrl = await NeomUploadFirestore().uploadImage(postId, _file, neomUploadType);
      logger.d("File uploaded to $_mediaUrl");
    } catch(e) {
      logger.d(e.toString());
    }

    return imageUrl;
  }

}