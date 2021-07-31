import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:logger/logger.dart';

//TODO
class NeomChamberPresetSearchController extends GetxController {

  var logger = Logger();

  RxMap<String, NeomChamberPreset> _neomChamberPresets = Map<String, NeomChamberPreset>().obs;
  Map<String, NeomChamberPreset> get neomChamberPresets => _neomChamberPresets;
  set neomChamberPresets(Map<String, NeomChamberPreset> presets) => this._neomChamberPresets.value = presets;

  RxString _searchParam = "".obs;
  String get searchParam => _searchParam.value;
  set searchParam(String searchParam) => this._searchParam.value = searchParam;


    @override
  void onInit() async {
    super.onInit();
  }


  void clear() {
    neomChamberPresets = Map<String, NeomChamberPreset>();
  }


  void setSearchParam(String text) {
    searchParam = text;
  }


  Future<void> getNeomChamberPresetDetails(NeomChamberPreset neomChamberPreset) async {
    logger.d("Sending neom chamber preset with name ${neomChamberPreset.name} to chamber preset controller");
    Get.toNamed(NeomRouteConstants.PRESET_DETAILS, arguments: [neomChamberPreset]);
  }


}