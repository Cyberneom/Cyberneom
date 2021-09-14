import 'dart:async';

import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-parameter.dart';
import 'package:cyberneom/io/neom-generator-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-details-controller.dart';
import 'package:cyberneom/ui/pages/neom-generator/vr/neom-360-viewer-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:get/get.dart';
import 'package:surround_sound/surround_sound.dart';

class NeomGeneratorController extends GetxController implements NeomGeneratorService {

  var logger = NeomUtilities.logger;
  final neomUserController = Get.find<NeomUserController>();
  final presetController = Get.put(NeomChamberPresetDetailsController());
  final neom360viewerController = Get.put(Neom360ViewerController());

  final soundController = SoundController();

  NeomChamberPreset _neomChamberPreset = NeomChamberPreset();
  NeomChamberPreset get neomChamberPreset => _neomChamberPreset;
  set neomChamberPreset(NeomChamberPreset preset) => this._neomChamberPreset = preset;

  RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool isPlaying) => this._isPlaying.value = isPlaying;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  @override
  void onInit() async {
    super.onInit();
    List<dynamic> arguments  = Get.arguments ?? [];
    if(arguments.isNotEmpty) neomChamberPreset =  arguments.elementAt(0);

    if(neomChamberPreset.neomFrequency == null) neomChamberPreset.neomFrequency = NeomFrequency();
    if(neomChamberPreset.neomParameter == null) neomChamberPreset.neomParameter = NeomParameter();

    settingChamber();

  }


  @override
  FutureOr onClose() {
    super.onClose();
    soundController.dispose();
  }


  Future<void> settingChamber() async {

    try {

      AudioParam customAudioParam = AudioParam(
          volume: neomChamberPreset.neomParameter!.volume,
          x: neomChamberPreset.neomParameter!.x,
          y: neomChamberPreset.neomParameter!.y,
          z: neomChamberPreset.neomParameter!.z,
          freq:neomChamberPreset.neomFrequency!.frequency);
        soundController.value = customAudioParam;
    } catch (e) {
      logger.e(e.toString());
      Get.back();
    }

    isLoading = false;
    update([NeomPageIdConstants.neomGenerator]);
  }


  void setFrequency(NeomFrequency frequency) async {
    await soundController.setFrequency(frequency.frequency);
    update([NeomPageIdConstants.neomGenerator]);
  }


  void setVolume(double volume) async {
    neomChamberPreset.neomParameter!.volume = volume;
    update([NeomPageIdConstants.neomGenerator]);
  }


  void setPosition(NeomParameter parameter) async {
    await soundController.setPosition(parameter.x, parameter.y, parameter.z);
    update([NeomPageIdConstants.neomGenerator]);
  }


  Future<void> stopPlay() async {

    if(isPlaying && await soundController.isPlaying()) {
      await soundController.stop();
      isPlaying = false;
    } else {
      await soundController.play().whenComplete(() => isPlaying = true);
    }

    logger.i('isPlaying: $isPlaying');
    update([NeomPageIdConstants.neomGenerator]);
  }

  void changeControllerStatus(bool status){
    isPlaying = status;
    update([NeomPageIdConstants.neomGenerator]);
  }


  AudioParam getAudioParam()  {


      return AudioParam(
          volume: neomChamberPreset.neomParameter!.volume,
          x: neomChamberPreset.neomParameter!.x,
          y: neomChamberPreset.neomParameter!.y,
          z: neomChamberPreset.neomParameter!.z,
          freq:neomChamberPreset.neomFrequency!.frequency);


  }

}

