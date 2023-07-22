import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';


class Neom360ViewerController extends GetxController  {

  var logger = AppUtilities.logger;
  final neomUserController = Get.find<UserController>();

  // late Video360Controller controller;
  // late Video360Controller controller2;

  RxString _durationText = "".obs;
  String get durationText => _durationText.value;
  set durationText(String durationText) => this._durationText.value = durationText;

  RxString _totalText = "".obs;
  String get totalText => _totalText.value;
  set totalText(String totalText) => this._totalText.value = totalText;


  RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool isPlaying) => this._isPlaying.value = isPlaying;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  @override
  void onInit() async {
    super.onInit();


  }

  // onVideo360ViewCreated(Video360Controller controller) {
  //   this.controller = controller;
  //   this.controller2 = controller;
  // }

  @override
  FutureOr onClose() {
    super.onClose();
  }


  Future<void> launchChromeVRView(BuildContext context, {String url = 'https://sbis04.github.io/demo360'}) async {
    try {
      await launch(
        // NOTE: Replace this URL with your GitHub Pages URL.
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: false,
          animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref.
            'https://play.google.com/store/apps/details?id=org.mozilla.firefox',
            'org.mozilla.firefox',
            // ref.
            'https://play.google.com/store/apps/details?id=com.microsoft.emmx',
            'com.microsoft.emmx',
          ],
        ),
      );
    }catch (e) {
// An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }



}

