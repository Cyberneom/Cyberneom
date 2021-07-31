import 'dart:async';
import 'package:cyberneom/data/api-services/firestore/neom-post-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/implementations/geolocator-service-impl.dart';
import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/use-cases/neom-post-detail-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';

import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class NeomPostDetailController extends GetxController implements NeomPostDetailService {

  var logger = NeomUtilities.logger;
  final neomUserController = Get.find<NeomUserController>();
  
  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  TextEditingController locationController =TextEditingController();
  TextEditingController captionController =TextEditingController();
  bool isUploading = false;

  NeomProfile _neomProfile = NeomProfile();
  NeomProfile get neomProfile => _neomProfile;

  String _location = "";
  String get location => _location;

  NeomPost _neomPost = NeomPost();
  NeomPost get neomPost => _neomPost;

  Map likes = Map();
  int likesCount = 0;
  bool isLiked = false;
  bool showHeart = false;


  @override
  void onInit() async {
    super.onInit();

    _neomPost = Get.arguments;
    _neomProfile = neomUserController.neomProfile!;

    isLiked = neomPost.likedProfiles.contains(neomProfile.id);
    await loadInitialInfo();

  }

  Future<void> loadInitialInfo() async {
    if(neomPost.position != null) _location = await GeoLocatorServiceImpl().getAddressSimple(neomPost.position!);
    isLoading = false;
  }

  buildPostHeader(context) {
    return FutureBuilder(
      future: NeomProfileFirestore().retrieveNeomProfile(neomProfile.id),
      builder: (BuildContext context, AsyncSnapshot<NeomProfile> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        NeomProfile neommate = snapshot.data!;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(neommate.photoUrl),
            backgroundColor: Colors.teal,
          ),
          title: Text(
            neommate.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () => Get.toNamed(NeomRouteConstants.NEOMMATE_DETAILS, arguments: neomProfile.id),
          subtitle: Text(location),
          trailing: neomProfile.id == neommate.id ? IconButton(
            onPressed: () => handleDeletePost(context),
            icon: Icon(Icons.more_vert),
          ) : Text(""),
        );
      },
    );
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post..?!"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  NeomTranslationConstants.remove.tr,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Get.toNamed(NeomRouteConstants.HOME);
                  NeomPostFirestore().deletePost(neomProfile.id, neomPost.id);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  NeomTranslationConstants.cancel.tr,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
  }
}