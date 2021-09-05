import 'dart:async';

import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:get/get.dart';
import 'package:video_360/video_360.dart';


class Neom360ViewerController extends GetxController  {

  var logger = NeomUtilities.logger;
  final neomUserController = Get.find<NeomUserController>();

  late Video360Controller controller;
  late Video360Controller controller2;

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

  onVideo360ViewCreated(Video360Controller controller) {
    this.controller = controller;
    this.controller2 = controller;
  }

  @override
  FutureOr onClose() {
    super.onClose();
  }






}

