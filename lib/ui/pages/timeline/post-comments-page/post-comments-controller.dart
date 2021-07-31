import 'dart:async';
import 'package:cyberneom/data/api-services/firestore/neom-comment-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-post-firestore.dart';
import 'package:cyberneom/domain/model/neom-comment.dart';
import 'package:cyberneom/domain/model/neom-post.dart';

import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/ui/pages/add/neom-upload-controller.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/timeline/post-comments-page/post-comments-page.dart';
import 'package:cyberneom/ui/pages/timeline/timeline-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/enum/neom-from.dart';
import 'package:cyberneom/utils/enum/neom-media-type.dart';
import 'package:cyberneom/utils/enum/neom-upload-image-type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';


class PostCommentsController extends GetxController  {

  var logger = Logger();
  final neomUserController = Get.find<NeomUserController>();
  final timelineController = Get.find<TimelineController>();
  final neomUploadController = Get.put(NeomUploadController());

  NeomPostFirestore neomPostFirestore = NeomPostFirestore();
  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  TextEditingController commentController = TextEditingController();
  bool isUploading = false;

  PickedFile _imageFile = PickedFile("");
  PickedFile get imageFile => _imageFile;

  late NeomProfile _neomProfile;
  NeomProfile get neomProfile => _neomProfile;


  NeomPost _neomPost = NeomPost();
  NeomPost get neomPost => _neomPost;
  set neomPost(NeomPost post) => this._neomPost = post;

  RxList<NeomComment> _neomComments = <NeomComment>[].obs;
  List<NeomComment> get neomComments => _neomComments;
  set neomComments(List<NeomComment> comments) => this._neomComments.value = comments;

  late Map likes;
  int likesCount = 0;
  bool isLiked = false;
  bool showHeart = false;


  @override
  void onInit() async {
    super.onInit();
    logger.d("Post Controller Init");

    _neomProfile = neomUserController.neomProfile!;

    // _scrollController = ScrollController();
    //_scrollController.addListener(_scrollListener());

    //TODO VERIFY THIS
    neomPost = Get.arguments ?? NeomPost();
    neomComments = neomPost.neomComments;

    print("");

  }


  @override
  void onReady() async {
    super.onReady();
    logger.d("Timeline Controller Ready");
  }




  @override
  FutureOr onClose() {
    super.onClose();
    //videoPlayerController.dispose();
  }

  showComments(NeomPost neomPost) {
    Get.to(PostCommentsPage(), transition: Transition.downToUp, arguments: neomPost);
  }

  Future<void> addComment()async {


    NeomComment newComment = NeomComment(
        neomPostOwnerId: neomPost.ownerId,
        text: commentController.text,
        neomProfileId: neomProfile.id,
        neomProfileImgUrl: neomProfile.photoUrl,
        neomProfileName: neomProfile.name,
        createdTime: DateTime.now().millisecondsSinceEpoch,
    );

    if(neomUploadController.imageFile.path.isNotEmpty) {
      newComment.mediaUrl = await neomUploadController.handleUploadImage(NeomUploadImageType.Comment);
      newComment.type = NeomMediaType.Image;

    }

    newComment.id = await NeomCommentFirestore().addComment(neomProfile.id, neomPost.id, newComment);

    timelineController.neomPosts[neomPost.id]!.neomComments.add(newComment);
    commentController.clear();
    clearImage();
    update([NeomPageIdConstants.postComments, NeomPageIdConstants.timeline]);

  }

  handleImage(NeomFileFrom neomFileFrom) async {
    await neomUploadController.handleImage(neomFileFrom, isProfilePicture: true);
    update([NeomPageIdConstants.postComments]);
  }

  clearImage()  {
    neomUploadController.clearImage();
    update([NeomPageIdConstants.postComments]);
  }

}