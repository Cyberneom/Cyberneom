import 'package:cyberneom/data/api-services/firestore/neom-activity-feed-firestore.dart';
import 'package:cyberneom/domain/model/neom-activity-feed.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyberneom/utils/enum/neom-activity-feed-type.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ActivityFeedController extends GetxController {

  var logger = Logger();
  final neomUserController = Get.find<NeomUserController>();

  late Widget mediaPreview;
  String activityItemText = "";

  NeomProfile _neomProfile = NeomProfile();
  NeomProfile get neomProfile => _neomProfile;

  RxList<NeomActivityFeed> _neomActivityFeedItems = <NeomActivityFeed>[].obs;
  List<NeomActivityFeed> get neomActivityFeedItems => _neomActivityFeedItems;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  @override
  void onInit() async {
    super.onInit();
    logger.d("ActivityFeed Init");
    _neomProfile = neomUserController.neomProfile!;
    await getActivityFeed();
  }

  Future<void> getActivityFeed () async {
    logger.d("");
    _neomActivityFeedItems.value = await NeomActivityFeedFirestore().retrieveActivityFeed(neomProfile.id);
    logger.d("${neomActivityFeedItems.length} activities retrieved");
    _isLoading.value = false;
    update([NeomPageIdConstants.neomActivityFeed]);
  }

  showPost(context){
  }

  configureMediaPreview(BuildContext context, NeomActivityFeed neomActivityFeed)
  {
    if (neomActivityFeed.neomActivityFeedType == NeomActivityFeedType.Like
        || neomActivityFeed.neomActivityFeedType == NeomActivityFeedType.Comment) {
      mediaPreview = GestureDetector(
        onTap: ()=>showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: NeomAppTheme.aspectRatio,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(neomActivityFeed.mediaUrl.isEmpty ? NeomConstants.noImageUrl : neomActivityFeed.mediaUrl),
                ),
              ),
            ),
          ),
        ),
      );
    } else{
      mediaPreview=Text("");
    }

    if(neomActivityFeed.neomActivityFeedType == NeomActivityFeedType.Like)
      activityItemText = "liked your post";
    else if(neomActivityFeed.neomActivityFeedType == NeomActivityFeedType.Comment)
      activityItemText = "commented: '${neomActivityFeed.neomMessage}'";
    else if(neomActivityFeed.neomActivityFeedType == NeomActivityFeedType.Follow)
      activityItemText = "start following you";
    else
      activityItemText = "Error: Unknown NeomActivityFeedType";
  }

  showProfile(String neomProfileId) {
    Get.toNamed(NeomRouteConstants.NEOMMATE_DETAILS, arguments: [neomProfileId]);
  }




}