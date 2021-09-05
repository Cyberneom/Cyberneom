import 'package:cyberneom/data/api-services/firestore/neom-chamber-firestore.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/use-cases/neom-chamber-service.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';


class NeomChamberController extends GetxController implements NeomChamberService {

  final logger = NeomUtilities.logger;
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

  Rx<NeomChamber> _neomChamber = NeomChamber().obs;
  NeomChamber get neomChamber => _neomChamber.value;
  set neomChamber(NeomChamber chamber) => this._neomChamber.value = chamber;

  RxMap<String, NeomChamber> _neomChambers = Map<String, NeomChamber>().obs;
  Map<String, NeomChamber> get neomChambers => _neomChambers;
  set neomChambers(Map<String, NeomChamber> chambers) => this._neomChambers.value = chambers;

  RxString _newNeomChamberName = "".obs;
  String get newNeomChamberName => _newNeomChamberName.value;
  set newNeomChamberName(String name) => this._newNeomChamberName.value = name;

  RxString _newNeomChamberDesc = "".obs;
  String get newNeomChamberDesc => _newNeomChamberDesc.value;
  set newNeomChamberDesc(String desc) => this._newNeomChamberDesc.value = desc;

  RxString _updateNeomChamberName = "".obs;
  String get updateNeomChamberName => _updateNeomChamberName.value;
  set updateNeomChamberName(String name) => this._updateNeomChamberName.value = name;

  RxString _updateNeomChamberDesc = "".obs;
  String get updateNeomChamberDesc => _updateNeomChamberDesc.value;
  set updateNeomChamberDesc(String desc) => this._updateNeomChamberDesc.value = desc;

  NeomChamber _favNeomChamber = NeomChamber();
  NeomProfile _neomProfile = NeomProfile();

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;


  @override
  void onInit() async {
    super.onInit();
    logger.d("");


    if(neomUserController.neomProfile != null) {
      _neomProfile = neomUserController.neomProfile!;
    }

    retrieveNeomChambers();

  }


  Future<void> retrieveNeomChambers() async {
    if(_neomProfile.neomChambers!.isNotEmpty) {
      logger.d("NeomChambers loaded from neomUserController");
      neomChambers = _neomProfile.neomChambers!;
    } else {
      logger.d("NeomChambers loaded from Firestore");
      neomChambers = await NeomChamberFirestore().retrieveNeomChambers(_neomProfile.id);
    }
    isLoading = false;
    update([NeomPageIdConstants.neomChamber]);
  }


  void clear() {
    neomChambers = Map<String, NeomChamber>();
    neomChamber = NeomChamber();
    update([NeomPageIdConstants.neomChamber]);
  }


  void setNewChamberName(text) {
    newNeomChamberName = text;
    update([NeomPageIdConstants.neomChamber]);
  }


  void setNewChamberDesc(text) {
    newNeomChamberDesc = text;
    update([NeomPageIdConstants.neomChamber]);
  }


  void setUpdateChamberName(text) {
    updateNeomChamberName = text;
    update([NeomPageIdConstants.neomChamber]);
  }


  void setUpdateChamberDesc(text) {
    updateNeomChamberDesc = text;
    update([NeomPageIdConstants.neomChamber]);
  }


  Future<void> createChamber() async {
    logger.d("Start $newNeomChamberName and $newNeomChamberDesc");

    if(newNeomChamberName.isNotEmpty && newNeomChamberDesc.isNotEmpty) {
      NeomChamber basicNeomChamber = NeomChamber.createBasic(newNeomChamberName, newNeomChamberDesc);
      String newNeomChamberId = await NeomChamberFirestore()
          .insert(neomChamber: basicNeomChamber, neomProfileId: _neomProfile.id);
      basicNeomChamber.id = newNeomChamberId;

      if(newNeomChamberId.isNotEmpty){
        _neomChambers[newNeomChamberId] = basicNeomChamber;
        logger.i("NeomChambers " + neomChambers.toString());
      } else {
        logger.d("Something happens trying to insert chamber");
      }

      Get.back();
      update([NeomPageIdConstants.neomChamber]);
    }
  }


  Future<void> deleteChamber(NeomChamber neomChamber) async {

    final neomChamberId = neomChamber.id;

    logger.d("Removing for $neomChamber");
    if(await NeomChamberFirestore().remove(_neomProfile.id, neomChamberId)){
      logger.d("Chamber $neomChamberId removed");
      _neomChambers.remove(neomChamber.id);
    } else {
      logger.d("Something happens trying to remove chamber");
    }

    Get.back();
    update([NeomPageIdConstants.neomChamber]);
  }


  Future<void> setAsFavorite(NeomChamber neomChamber) async {
    logger.d("Making favorite for $neomChamber");

    if(await NeomChamberFirestore().setAsFavorite(_neomProfile.id, neomChamber)){
      neomChamber.isFav = true;
      neomChambers[neomChamber.id] = neomChamber;
      logger.i("Chamber ${neomChamber.id} set as favorite");
      if(await NeomChamberFirestore().unsetOfFavorite(_neomProfile.id, _favNeomChamber)) {
        logger.i("Chamber unset from favorite");
        _favNeomChamber.isFav = false;
        neomChambers[_favNeomChamber.id] = _favNeomChamber;
      }
      _favNeomChamber = neomChamber;
    } else {
      logger.e("Something happens trying to remove chamber");
    }

    Get.back();
    update([NeomPageIdConstants.neomChamber]);
  }


  Future<void> updateChamber(String neomChamberId, NeomChamber neomChamber) async {

    String updateNeomChamberName = _updateNeomChamberName.value;
    String updateNeomChamberDesc = _updateNeomChamberDesc.value;

    if(updateNeomChamberName.isNotEmpty) {
      neomChamber.name = updateNeomChamberName;
    }

    if(updateNeomChamberDesc.isNotEmpty){
      neomChamber.description = updateNeomChamberDesc;
    }

    logger.d("Updating to $neomChamber");

    if(updateNeomChamberName.isNotEmpty || updateNeomChamberDesc.isNotEmpty){
      if(await NeomChamberFirestore().update(_neomProfile.id, neomChamber)){
        logger.d("Chamber $neomChamberId updated");
        _neomChambers[neomChamber.id] = neomChamber;
        // }
      } else {
        logger.d("Something happens trying to update chamber");
      }
  }
    Get.back();
    update([NeomPageIdConstants.neomChamber]);
  }

  @override
  void goToNeomChamberPresets(NeomChamber chamber) {
    neomChamber = chamber;
    Get.toNamed(NeomRouteConstants.CHAMBER_PRESETS, arguments: neomChamber);
  }


}