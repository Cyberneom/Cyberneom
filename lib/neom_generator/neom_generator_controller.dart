import 'dart:async';

import 'package:cyberneom/neom_frequencies/frequencies/ui/frequency_controller.dart';
import 'package:cyberneom/neom_generator/domain/use_cases/neom_generator_service.dart';
import 'package:cyberneom/neom_generator/chamber_preset_details_controller.dart';
import 'package:cyberneom/neom_generator/vr/neom-360-viewer-controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/data/firestore/itemlist_firestore.dart';
import 'package:neom_commons/core/data/firestore/profile_firestore.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/domain/model/app_profile.dart';
import 'package:neom_commons/core/domain/model/item_list.dart';
import 'package:neom_commons/core/domain/model/neom/chamber_preset.dart';
import 'package:neom_commons/core/domain/model/neom/neom_frequency.dart';
import 'package:neom_commons/core/domain/model/neom/neom_parameter.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_commons/core/utils/enums/app_item_state.dart';
import 'package:surround_sound/surround_sound.dart';

class NeomGeneratorController extends GetxController implements NeomGeneratorService {

  var logger = AppUtilities.logger;
  final userController = Get.find<UserController>();
  final neom360viewerController = Get.put(Neom360ViewerController());
  final frequencyController = Get.put(FrequencyController());


  late SoundController soundController;

  AppProfile profile = AppProfile();

  ChamberPreset _chamberPreset = ChamberPreset();
  ChamberPreset get chamberPreset => _chamberPreset;
  set chamberPreset(ChamberPreset chamberPreset) => this._chamberPreset = chamberPreset;

  RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool isPlaying) => this._isPlaying.value = isPlaying;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  final RxInt _frequencyState = 0.obs;
  int get frequencyState => _frequencyState.value;
  set frequencyState(int frequencyState) => _frequencyState.value = frequencyState;

  final RxMap<String, Itemlist> _chambers = <String, Itemlist>{}.obs;
  Map<String, Itemlist> get chambers => _chambers;
  set chambers(Map<String, Itemlist> chambers) => _chambers.value = chambers;

  final Rx<Itemlist> _chamber = Itemlist().obs;
  Itemlist get chamber => _chamber.value;
  set chamber(Itemlist chamber) => _chamber.value = chamber;

  final RxBool _existsInItemlist = false.obs;
  bool get existsInChamber => _existsInItemlist.value;
  set existsInChamber(bool existsInItemlist) => _existsInItemlist.value = existsInItemlist;

  final RxBool _isUpdate = false.obs;
  bool get isUpdate => _isUpdate.value;
  set isUpdate(bool isUpdate) => _isUpdate.value = isUpdate;

  final RxBool _isButtonDisabled = false.obs;
  bool get isButtonDisabled => _isButtonDisabled.value;
  set isButtonDisabled(bool isButtonDisabled) => _isButtonDisabled.value = isButtonDisabled;

  RxString frequencyDescription = "".obs;

  bool noItemlists = false;

  @override
  void onInit() async {
    super.onInit();
    List<dynamic> arguments  = Get.arguments ?? [];

    try {
      if(arguments.isNotEmpty) {
        if(arguments.elementAt(0) is ChamberPreset) {
          chamberPreset =  arguments.elementAt(0);
        } else if(arguments.elementAt(0) is NeomFrequency) {
          chamberPreset.neomFrequency = arguments.elementAt(0);
        }
      }

      profile = userController.profile;
      chambers = profile.itemlists ?? {};
      soundController = SoundController();

      if(chamberPreset.neomFrequency == null) chamberPreset.neomFrequency = NeomFrequency();
      if(chamberPreset.neomParameter == null) chamberPreset.neomParameter = NeomParameter();

      settingChamber();
    } catch(e) {
      AppUtilities.logger.e(e.toString());
    }

  }

  @override
  void onReady() async {
    super.onReady();
    try {

      await soundController.init();
      if(chambers.isEmpty) {
        noItemlists = true;
      } else {
        existsInChamber = frequencyAlreadyInItemlist();
        if(chamber.id.isEmpty) {
          chamber = chambers.values.first;
        }
      }

      frequencyDescription.value = chamberPreset.description.isNotEmpty
          ? chamberPreset.description : chamberPreset.neomFrequency!.description.isNotEmpty ? chamberPreset.neomFrequency!.description : "";

    } catch (e) {
      logger.e(e.toString());
    }

    isLoading = false;
    update([AppPageIdConstants.generator]);
  }

  @override
  void dispose() {
    super.dispose();
    soundController.removeListener(() { });
    soundController.dispose();
    soundController = SoundController();
    isPlaying = false;
  }

  @override
  void onDelete() {
    super.onDelete();
    soundController.removeListener(() { });
    soundController.dispose();
    isPlaying = false;
  }

  Future<void> settingChamber() async {

    try {
      AudioParam customAudioParam = AudioParam(
          volume: chamberPreset.neomParameter!.volume,
          x: chamberPreset.neomParameter!.x,
          y: chamberPreset.neomParameter!.y,
          z: chamberPreset.neomParameter!.z,
          freq:chamberPreset.neomFrequency!.frequency);
        soundController.value = customAudioParam;
    } catch (e) {
      logger.e(e.toString());
      Get.back();
    }

    isLoading = false;
    update([AppPageIdConstants.generator]);
  }


  void setFrequency(double frequency) async {
    chamberPreset.neomFrequency!.frequency = frequency.ceilToDouble();
    frequencyDescription.value = "";
    frequencyController.frequencies.values.forEach((element) {
      if(element.frequency.ceilToDouble() == frequency.ceilToDouble()) {
        frequencyDescription.value = element.description;
      }
    });

    if(existsInChamber) {isUpdate = true;}

    await soundController.setFrequency(frequency);
    update([AppPageIdConstants.generator]);
  }


  void setVolume(double volume) async {
    chamberPreset.neomParameter!.volume = volume;
    soundController.setVolume(volume);
    if(existsInChamber) {isUpdate = true;}
    update([AppPageIdConstants.generator]);
  }

  Future<void> stopPlay() async {

    if(isPlaying && await soundController.isPlaying()) {
      await soundController.stop();
      isPlaying = false;
    } else {
      await soundController.play().whenComplete(() => isPlaying = true);
    }

    logger.i('isPlaying: $isPlaying');
    update([AppPageIdConstants.generator]);
  }

  void changeControllerStatus(bool status){
    isPlaying = status;
    update([AppPageIdConstants.generator]);
  }

  AudioParam getAudioParam()  {
    soundController.init();
    return AudioParam(
          volume: chamberPreset.neomParameter!.volume,
          x: chamberPreset.neomParameter!.x,
          y: chamberPreset.neomParameter!.y,
          z: chamberPreset.neomParameter!.z,
          freq:chamberPreset.neomFrequency!.frequency);

  }

  Future<void> playStopPreview() async {

    logger.d("Previewing Chamber Preset ${chamberPreset.name}");

    try {
      if(await soundController.isPlaying()) {
        await soundController.stop();
        await soundController.init();
        changeControllerStatus(false);
      } else {
        settingChamber();
        await soundController.init();
        await soundController.play();
        changeControllerStatus(true);
      }
      // await audioPlayer.play(BytesSource(createSample(240)));
    } catch(e) {
      logger.e(e.toString());
    }

    update([AppPageIdConstants.generator]);
  }


  void setFrequencyState(AppItemState newState){
    logger.d("Setting new appItem $newState");
    frequencyState = newState.value;
    chamberPreset.state = newState.value;
    update([AppPageIdConstants.generator]);
  }

  void setSelectedItemlist(String selectedItemlist){
    logger.d("Setting selectedItemlist $selectedItemlist");
    chamber.id  = selectedItemlist;
    update([AppPageIdConstants.generator]);
  }

  bool frequencyAlreadyInItemlist() {
    logger.d("Verifying if Item already exists in chambers");

    bool alreadyInItemlist = false;
    chambers.values.forEach((nChamber) {
      for (var presets in nChamber.chamberPresets!) {
        if (chamberPreset.id == presets.id) {
          alreadyInItemlist = true;
          chamber = nChamber;
        }
      }
    });

    logger.d("Frequency already exists in chambers: $alreadyInItemlist");
    return alreadyInItemlist;
  }

  Future<void> addPreset(BuildContext context, {int frequencyPracticeState = 0}) async {

    if(!isButtonDisabled) {
      isButtonDisabled = true;
      isLoading = true;
      update([AppPageIdConstants.generator]);

      logger.i("ChamberPreset would be added as $frequencyState for Itemlist ${chamber.id}");

      if(frequencyPracticeState > 0) frequencyState = frequencyPracticeState;

      if(noItemlists) {
        chamber.name = AppTranslationConstants.myFirstItemlistName.tr;
        chamber.description = AppTranslationConstants.myFirstItemlistDesc.tr;
        chamber.imgUrl = AppFlavour.getAppLogoUrl();
        chamber.id = await ItemlistFirestore().insert(profile.id, chamber);
      } else {
        if(chamber.id.isEmpty) chamber.id = chambers.values.first.id;
      }

      if(chamber.id.isNotEmpty) {

        try {
          chamberPreset.id = "${chamberPreset.neomFrequency!.frequency.ceilToDouble().toString()}_${chamberPreset.neomParameter!.volume.toString()}"
              "_${chamberPreset.neomParameter!.x.toString()}_${chamberPreset.neomParameter!.y.toString()}_${chamberPreset.neomParameter!.z.toString()}";
          chamberPreset.name = "${AppTranslationConstants.frequency.tr} ${chamberPreset.neomFrequency!.frequency.ceilToDouble().toString()} Hz";
          chamberPreset.imgUrl = AppFlavour.getAppLogoUrl();
          chamberPreset.ownerId = profile.id;
          chamberPreset.neomFrequency!.description = frequencyDescription.value;
          if(await ItemlistFirestore().addPreset(profileId: profile.id,
              chamberId: chamber.id, preset: chamberPreset)) {

            await ProfileFirestore().addChamberPreset(profileId: profile.id, chamberPresetId: chamberPreset.id);
            await userController.reloadProfileItemlists();
            chambers = userController.profile.itemlists ?? {};
            logger.d("Preset added to Neom Chamber");
          } else {
            logger.d("Preset not added to Neom Chamber");
          }
        } catch (e) {
          AppUtilities.logger.e(e.toString());
          AppUtilities.showSnackBar(AppTranslationConstants.generator.tr, 'Algo salió mal agregando tu preset a tu cámara Neom.');
        }

        AppUtilities.showSnackBar(AppTranslationConstants.generator.tr, 'El preajuste para la frecuencia de "${chamberPreset.neomFrequency!.frequency.ceilToDouble().toString()}" Hz fue agregado a la Cámara Neom: ${chamber.name}.');
      }
    }

    existsInChamber = true;
    isButtonDisabled = false;
    isLoading = false;

    update();
  }

  Future<void> removePreset(BuildContext context) async {


    if(!isButtonDisabled) {
      isButtonDisabled = true;
      isLoading = true;
      update([AppPageIdConstants.generator]);

      logger.i("ChamberPreset would be removed for Itemlist ${chamber.id}");

      if(chamber.id.isEmpty) chamber.id = chambers.values.first.id;

      if(chamber.id.isNotEmpty) {
        try {
          if(await ItemlistFirestore().removePreset(profile.id, chamberPreset, chamber.id)) {
            await userController.reloadProfileItemlists();
            chambers = userController.profile.itemlists ?? {};
            logger.d("Preset removed from Neom Chamber");
          } else {
            logger.d("Preset not removed from Neom Chamber");
          }
        } catch (e) {
          AppUtilities.logger.e(e.toString());
          AppUtilities.showSnackBar(AppTranslationConstants.frequencyGenerator.tr, 'Algo salió mal eliminando tu preset de tu cámara Neom.');
        }

        AppUtilities.showSnackBar(AppTranslationConstants.frequencyGenerator.tr, 'El preajuste para la frecuencia de "${chamberPreset.neomFrequency!.frequency.ceilToDouble().toString()}" Hz fue removido de la Cámara Neom: ${chamber.name} satisfactoriamente.');
      }
    }

    existsInChamber = false;
    isButtonDisabled = false;
    isLoading = false;
    update();
  }

  void setParameterPosition({required double x, required double y, required double z}) {

    try {
      chamberPreset.neomParameter!.x = x;
      chamberPreset.neomParameter!.y = y;
      chamberPreset.neomParameter!.z = z;

      soundController.setPosition(x,y,z);
    } catch(e) {
      AppUtilities.logger.e(e.toString());
    }

    if(existsInChamber) {isUpdate = true;}
    update();
  }

}

