import 'package:cyberneom/data/api-services/firestore/neom-chamber-preset-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-chamber-firestore.dart';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/ui/pages/chamber/neom-chamber-controller.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

class NeomChamberPresetDetailsController extends GetxController {

  var logger = Logger();
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

  String _neomProfileId = "";

  NeomChamberPreset _neomChamberPreset = NeomChamberPreset();
  NeomChamberPreset get neomChamberPreset => _neomChamberPreset;
  set neomChamberPreset(NeomChamberPreset chamberPreset) => this._neomChamberPreset = chamberPreset;

  RxString _neomChamberPresetId = "".obs;
  String get neomChamberPresetId => _neomChamberPresetId.value;
  set neomChamberPresetId(String presetId) => this._neomChamberPresetId.value = presetId;

  RxString _neomChamberId = "".obs;
  String get neomChamberId => _neomChamberId.value;
  set neomChamberId(String neomChamberId) => this._neomChamberId.value = neomChamberId;

  RxBool _wasAdded = false.obs;
  bool get wasAdded => _wasAdded.value;
  set wasAdded(bool wasAdded) => this._wasAdded.value = wasAdded;

  RxBool _existsInNeomChamber = false.obs;
  bool get existsInNeomChamber => _existsInNeomChamber.value;
  set existsInNeomChamber(bool existsInChamber) => this._existsInNeomChamber.value = existsInChamber;

  RxMap<String, NeomChamber> _neomChambers = Map<String, NeomChamber>().obs;
  Map<String, NeomChamber> get neomChambers => _neomChambers;
  set neomChambers(Map<String, NeomChamber> chambers) => this._neomChambers.value = chambers;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value;

  @override
  void onInit() async {
    super.onInit();
    logger.d("Preset Details Controller init");
    try {
      _neomProfileId = neomUserController.neomProfile!.id;
      _neomChambers.assignAll(neomUserController.neomProfile!.neomChambers ?? {});

      List<dynamic> arguments  = Get.arguments;

      neomChamberPreset =  arguments.elementAt(0);

      if(_neomChambers.values.isNotEmpty){
        _existsInNeomChamber.value = presetAlreadyInChamber();
      } else if (arguments.length > 1) { //to save in previously selected neomChamber
        NeomChamber neomChamber =  arguments.elementAt(1);
        _neomChamberPresetId.value = neomChamber.id;
      }

      if(neomChambers.isNotEmpty && neomChambers.length > 0){
        _neomChamberPresetId.value = neomChambers.values.first.id;
      }
    } catch (e) {
      logger.d(e.toString());
    }

    _isLoading.value = false;
  }

  void clear() {
    _neomChamberPreset = NeomChamberPreset();
    _neomChamberPresetId.value = "";
  }

  Future<void> removeNeomChamber() async {
    logger.d("removing neom chamber preset ${_neomChamberPreset.toString()}");

    try {
      if(await NeomChamberFirestore().removePresetFromChamber(_neomProfileId, neomChamberPreset, neomChamberId)){
        logger.d("");
          final neomChamberController = Get.find<NeomChamberController>();
          neomChamberController.neomChamber.neomChamberPresets!.remove(_neomChamberPreset.id);
          logger.d(neomChamberController.neomChamber.neomChamberPresets!.length.toString());

          if (neomUserController.neomProfile!.neomChambers != null &&
              neomUserController.neomProfile!.neomChambers!.isNotEmpty) {
            logger.d("Removing preset from global chamber from userController");
            neomUserController.neomProfile!.neomChambers![neomChamberId]!.neomChamberPresets!.remove(_neomChamberPreset);
          }
      } else {
        logger.d("Preset not removed");
      }
    } catch (e) {
      logger.d(e.toString());
    }

    update([NeomPageIdConstants.neomChamberPreset, NeomPageIdConstants.neomChamber, NeomPageIdConstants.neomChamberPresetDetails]);
    Get.back();
  }

  void setSelectedChamber(String selectedChamber){
    logger.d("Setting selected Chamber $selectedChamber");
    neomChamberId  = selectedChamber;
    existsInNeomChamber = presetAlreadyInChamber();
    update([NeomPageIdConstants.neomChamberPresetDetails]);
  }

  void getNeomChamberPresetDetails(String presetId) async {
    logger.d("");
    await NeomChamberPresetFirestore().fetch(presetId: presetId).then((preset) => _neomChamberPreset  = preset);
    update([NeomPageIdConstants.neomChamberPresetDetails]);
  }


  Future<void> addNeomChamberPreset() async {
    String neomChamberPresetId = "";
    neomChamberId.isEmpty ? neomChamberPresetId = NeomConstants.firstNeomChamber : neomChamberPresetId = _neomChamberPresetId.value;
    logger.d("Preset ${_neomChamberPreset.name} would be added for Chamber $neomChamberPresetId");

    try {
      if(!await NeomChamberPresetFirestore().exists(presetId: _neomChamberPreset.id)){
        await NeomChamberPresetFirestore().insert(_neomChamberPreset);
      }

      if(!existsInNeomChamber) {
        _neomChamberPreset.id = neomChamberPresetId;

        if(await NeomChamberFirestore().addPresetToChamber(_neomProfileId, _neomChamberPreset, neomChamberPresetId)){
            if (neomUserController.neomProfile!.neomChambers!.isNotEmpty) {
              logger.d("Adding preset to global chamber from userController");
              neomUserController.neomProfile!.neomChambers![neomChamberPresetId]!.neomChamberPresets!.add(_neomChamberPreset);
            }

            logger.d("Setting existsInChamber and wasAdded true");
            _existsInNeomChamber.value = true;
            _wasAdded.value = true;
        }
      }
    } catch (e) {
      logger.d(e.toString());
    }

    update([NeomPageIdConstants.neomChamberPreset, NeomPageIdConstants.neomChamber, NeomPageIdConstants.neomChamberPresetDetails]);
    Get.back();
  }

  void gotoSelectedNeomChamber() {
    logger.d("");
    Get.offAllNamed(NeomRouteConstants.HOME);
  }

  bool presetAlreadyInChamber(){
    logger.d("");
    bool presetAlreadyInChamber = false;

    neomChambers.forEach((key, chamber) {
      chamber.neomChamberPresets!.forEach((preset) {
        if (preset.id == neomChamberPreset.id) {
          presetAlreadyInChamber = true;
          _neomChamberPresetId.value = preset.id;
        }
      });
    });

    return presetAlreadyInChamber;
  }

  Future<bool> savePresetInChamber(NeomChamberPreset chamberPreset) async {
    String chamberPresetId = "";

    if (neomChambers.length == 1 && neomChamberId.isEmpty)
      neomChamberId = neomChambers.values.first.id;

    logger.d("Preset ${chamberPreset.name} would be added for Chamber $neomChamberId");

    try {

      if(chamberPresetId.isEmpty || !await NeomChamberPresetFirestore().exists(presetId: _neomChamberPreset.id)) {
        chamberPreset.creatorId = _neomProfileId;
        chamberPresetId = await NeomChamberPresetFirestore().insert(chamberPreset);
        chamberPreset.id = chamberPresetId;
      }

    if(!existsInNeomChamber) {

      if(await NeomChamberFirestore().addPresetToChamber(_neomProfileId, chamberPreset, neomChamberId)){
        if (neomUserController.neomProfile!.neomChambers!.isNotEmpty) {
          logger.d("Adding preset to global chamber from userController");
          neomUserController.neomProfile!.neomChambers![neomChamberId]!.neomChamberPresets!.add(chamberPreset);
          }

          logger.d("Setting existsInChamber and wasAdded true");
          _existsInNeomChamber.value = true;
          _wasAdded.value = true;
          neomChamberPresetId = chamberPresetId;
          neomChamberPreset = chamberPreset;
        }
      }
    } catch (e) {
      logger.d(e.toString());
    }

    update([NeomPageIdConstants.neomChamberPreset, NeomPageIdConstants.neomChamber, NeomPageIdConstants.neomChamberPresetDetails]);
    Get.back();
    return true;
  }

}