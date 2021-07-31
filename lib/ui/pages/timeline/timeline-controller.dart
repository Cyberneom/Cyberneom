import 'dart:async';
import 'package:cyberneom/data/api-services/firestore/neom-post-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-activity-feed-firestore.dart';
import 'package:cyberneom/domain/model/neom-activity-feed.dart';
import 'package:cyberneom/domain/model/neom-post.dart';

import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/timeline/post-comments-page/post-comments-page.dart';

import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/enum/neom-activity-feed-type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

class TimelineController extends GetxController  {

  var logger = Logger();
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

  NeomPostFirestore neomPostFirestore = NeomPostFirestore();
  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  Rx<VideoPlayerController> _videoPlayerController = VideoPlayerController.network("").obs;
  VideoPlayerController get videoPlayerController => _videoPlayerController.value;
  set videoPlayerController(VideoPlayerController videoPlayerController) => this._videoPlayerController.value = videoPlayerController;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int currentIndex) => this._currentIndex = currentIndex;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  TextEditingController locationController =TextEditingController();
  TextEditingController captionController =TextEditingController();
  bool isUploading = false;

  PickedFile _imageFile = PickedFile("");
  PickedFile get imageFile => _imageFile;

  NeomProfile _neomProfile = NeomProfile();
  NeomProfile get neomProfile => _neomProfile;

  bool isLiked = false;

  RxMap<String, NeomPost> _neomPosts = Map<String, NeomPost>().obs;
  Map<String, NeomPost> get neomPosts => _neomPosts;
  set neomPosts(Map<String, NeomPost> neomPosts) => this._neomPosts.value = neomPosts;



  @override
  void onInit() async {
    super.onInit();
    logger.d("neomPost Controller Init");

    _neomProfile = neomUserController.neomProfile!;

    // _scrollController = ScrollController();
    //_scrollController.addListener(_scrollListener());

    //TODO VERIFY THIS
    try{
      neomPosts = Get.arguments ?? <String, NeomPost>{};
      if(neomPosts.isEmpty) await getTimeline();
    } catch(e) {
      logger.e(e.toString());
    }


  }


  @override
  void onReady() async {
    super.onReady();
    logger.d("Timeline Controller Ready");
  }


  Future<void> getTimeline() async {
    logger.d("Refreshing timeline");
    disposeVideoPlayer();
    neomPosts = await neomPostFirestore.getTimeline();
    isLoading = false;
    update([NeomPageIdConstants.timeline]);
  }

  disposeVideoPlayer() {
    if(videoPlayerController.value.isPlaying) videoPlayerController.pause();
    videoPlayerController = VideoPlayerController.network("");
    videoPlayerController.dispose();
  }

  showComments(NeomPost neomPost) {
    Get.to(PostCommentsPage(), transition: Transition.downToUp, arguments: neomPost);
  }

  bool isLikedPost(NeomPost neomPost) {
    return neomPost.likedProfiles.contains(neomProfile.id);
  }

  Future<void> handleLikePost(NeomPost neomPost) async {
    isLiked = isLikedPost(neomPost);

    if (await neomPostFirestore.handleLikePost(neomProfile.id, neomPost.id, isLiked)) {

      if(neomProfile.id != neomPost.ownerId) {
        NeomActivityFeed neomActivityFeed = NeomActivityFeed(
            id: neomPost.id,
            neomOwnerId: neomPost.ownerId,
            neomProfileId: neomProfile.id,
            createdTime: DateTime.now().millisecondsSinceEpoch);

        neomActivityFeed.neomActivityFeedType = NeomActivityFeedType.Like;
        neomActivityFeed.neomProfileName = neomProfile.name;
        neomActivityFeed.neomProfileImgUrl = neomProfile.photoUrl;
        neomActivityFeed.mediaUrl = neomPost.mediaUrl;

        isLiked ? NeomActivityFeedFirestore().removeLikeFromFeed() :
        NeomActivityFeedFirestore().addActivityFeed(neomActivityFeed);


      }

      isLiked ? neomPost.likedProfiles.remove(neomProfile.id)
          : neomPost.likedProfiles.add(neomProfile.id);

      neomPosts[neomPost.id] = neomPost;
    }

    update([NeomPageIdConstants.timeline]);
  }

}