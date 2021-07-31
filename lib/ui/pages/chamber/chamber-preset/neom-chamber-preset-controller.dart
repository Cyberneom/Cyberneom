import 'package:cyberneom/data/api-services/firestore/neom-chamber-preset-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-chamber-firestore.dart';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/use-cases/neom-chamber-preset-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

class NeomChamberPresetController extends GetxController implements NeomChamberPresetService   {

  var logger = Logger();
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

    NeomChamberPreset _neomChamberPreset = NeomChamberPreset();
  NeomChamberPreset get neomChamberPreset => _neomChamberPreset;
  set neomChamberPreset(NeomChamberPreset chamberPreset) => this._neomChamberPreset = chamberPreset;

  NeomChamber _neomChamber = NeomChamber();
  NeomChamber get neomChamber => _neomChamber;
  set neomChamber(NeomChamber chamber) => this._neomChamber = chamber;


  RxMap<String, NeomChamberPreset> _neomChambersPresets = Map<String, NeomChamberPreset>().obs;
  Map<String, NeomChamberPreset> get neomChamberPresets => _neomChambersPresets;
  set neomChamberPresets(Map<String, NeomChamberPreset> neomChamberPresets) => this._neomChambersPresets.value  = neomChamberPresets;

  RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool isPlaying) => this._isPlaying.value = isPlaying;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  String _neomProfileId = "";

  @override
  void onInit() async {
    super.onInit();
    try {
      _neomChamber =  Get.arguments;
    } catch (e) {
      logger.d(e.toString());
    }

    if(_neomChamber.id.isEmpty) {
      logger.d("NeomChamberController Init ready with no chamber");
    } else {
      logger.d(_neomChamber.toString());
      logger.i("Preset Controller for Chamber ${_neomChamber.name}");
      logger.d("${_neomChamber.neomChamberPresets!.length} presets in chamber");

      _neomChamber.neomChamberPresets!.forEach((chamber) {
        logger.d(chamber.name);
        _neomChambersPresets[chamber.id] = chamber;
      });
    }
    _neomProfileId = neomUserController.neomProfile!.id;
    _isLoading.value = false;
  }

  @override
  void onReady() {
    logger.d("");
    super.onReady();
  }
  void clear() {
    neomChamberPresets = Map<String, NeomChamberPreset>();
    _neomChamberPreset = NeomChamberPreset();
  }

  Future<void> updateNeomChamber(NeomChamberPreset neomChamberUpdate) async {

      logger.d("updating neomChamber ${neomChamberUpdate.toString()}");
      try {
        if (await NeomChamberPresetFirestore().updateAtNeomChamber(_neomProfileId, _neomChamber.id, neomChamberUpdate)) {
          _neomChambersPresets.update(neomChamberUpdate.id, (neomChamber) => neomChamber);
          neomUserController.neomProfile!.neomChambers![_neomChamber.id]!
              .neomChamberPresets!.add(neomChamberUpdate);
          neomUserController.neomProfile!.neomChambers![_neomChamber.id]!
              .neomChamberPresets!.remove(neomChamberUpdate);
          if(await NeomChamberFirestore().removePresetFromChamber(_neomProfileId, neomChamberUpdate, _neomChamber.id)){
            logger.d("Neom Chamber was updated and old version deleted.");
          } else {
            logger.d("Neom Chamber was updated but old version remains.");
          }
        } else {
          logger.e("Neom Chamber was not updated");
        }
      } catch (e) {
        logger.d(e.toString());
      }

      Get.back();
      update([NeomPageIdConstants.neomChamber]);
  }

  Future<void> removePresetFromNeomChamber(NeomChamberPreset preset) async {
    logger.d("removing neomChamber ${preset.toString()}");

    try {
      if(await NeomChamberFirestore().removePresetFromChamber(_neomProfileId, preset, _neomChamber.id)){
          logger.d("");
          _neomChambersPresets.remove(preset.id);
          if (neomUserController.neomProfile!.neomChambers!.isNotEmpty) {
            logger.d("Removing preset to global neomChamber from neomUserController");
            neomUserController.neomProfile!.neomChambers![_neomChamber.id]!.neomChamberPresets!.remove(preset);
          }
      } else {
        logger.d(NeomPageIdConstants.neomChamber);
      }
    } catch (e) {
      logger.d(e.toString());
    }

    Get.back();
    update([NeomPageIdConstants.neomChamber]);
  }

  Future<void> getNeomChamberPresetDetails(NeomChamberPreset neomChamber) async {
    logger.d("");
    Get.toNamed(NeomRouteConstants.PRESET_DETAILS, arguments: [neomChamber]);
    update([NeomPageIdConstants.neomChamber]);
  }

}