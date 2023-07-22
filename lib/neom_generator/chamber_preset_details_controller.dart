//TODO VERIFY IF NEEDED
// import 'package:cyberneom/neom_constants.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'package:neom_commons/core/domain/model/neom/chamber_preset.dart';
// import 'package:neom_commons/core/domain/model/neom/neom_frequency.dart';
// import 'package:neom_commons/neom_commons.dart';
//
// class ChamberPresetDetailsController extends GetxController {
//
//   var logger = Logger();
//   final loginController = Get.find<LoginController>();
//   final userController = Get.find<UserController>();
//
//   String _neomProfileId = "";
//
//   ChamberPreset _neomChamberPreset = ChamberPreset();
//   ChamberPreset get neomChamberPreset => _neomChamberPreset;
//   set neomChamberPreset(ChamberPreset chamberPreset) => this._neomChamberPreset = chamberPreset;
//
//   RxString _neomChamberPresetId = "".obs;
//   String get neomChamberPresetId => _neomChamberPresetId.value;
//   set neomChamberPresetId(String presetId) => this._neomChamberPresetId.value = presetId;
//
//   RxString _neomChamberId = "".obs;
//   String get neomChamberId => _neomChamberId.value;
//   set neomChamberId(String neomChamberId) => this._neomChamberId.value = neomChamberId;
//
//   RxBool _wasAdded = false.obs;
//   bool get wasAdded => _wasAdded.value;
//   set wasAdded(bool wasAdded) => this._wasAdded.value = wasAdded;
//
//   RxBool _existsInNeomChamber = false.obs;
//   bool get existsInNeomChamber => _existsInNeomChamber.value;
//   set existsInNeomChamber(bool existsInChamber) => this._existsInNeomChamber.value = existsInChamber;
//
//   RxMap<String, Itemlist> _neomChambers = Map<String, Itemlist>().obs;
//   Map<String, Itemlist> get neomChambers => _neomChambers;
//   set neomChambers(Map<String, Itemlist> chambers) => this._neomChambers.value = chambers;
//
//   RxBool _isLoading = true.obs;
//   bool get isLoading => _isLoading.value;
//   set isLoading(bool isLoading) => this._isLoading.value;
//
//   @override
//   void onInit() async {
//     super.onInit();
//     logger.d("Preset Details Controller init");
//     try {
//       _neomProfileId = userController.profile.id;
//       // _neomChambers.assignAll(neomUserController.profile!.neomChambers ?? {});
//
//       List<dynamic> arguments  = Get.arguments ?? [];
//
//       if(arguments.isNotEmpty) {
//         if(arguments.elementAt(0) is ChamberPreset) {
//           neomChamberPreset =  arguments.elementAt(0);
//         } else if(arguments.elementAt(0) is NeomFrequency) {
//           NeomFrequency freq =  arguments.elementAt(0);
//           neomChamberPreset.neomFrequency = freq;
//         }
//
//       }
//
//       if(neomChambers.isNotEmpty){
//         _existsInNeomChamber.value = presetAlreadyInChamber();
//       } else if (arguments.length > 1) { //to save in previously selected neomChamber
//         Itemlist neomChamber =  arguments.elementAt(1);
//         neomChamberPresetId = neomChamber.id;
//       }
//
//       if(neomChambers.isNotEmpty && neomChambers.length > 0){
//         neomChamberPresetId = neomChambers.values.first.id;
//       }
//     } catch (e) {
//       logger.d(e.toString());
//     }
//
//     isLoading = false;
//   }
//
//   void clear() {
//     neomChamberPreset = ChamberPreset();
//     neomChamberPresetId = "";
//   }
//
//   Future<void> removeNeomChamber() async {
//     logger.d("removing neom chamber preset ${_neomChamberPreset.toString()}");
//
//     // try {
//     //   if(await NeomChamberFirestore().removePresetFromChamber(_neomProfileId, neomChamberPreset, neomChamberId)){
//     //     logger.d("");
//     //       final neomChamberController = Get.find<NeomChamberController>();
//     //       neomChamberController.neomChamber.neomChamberPresets!.remove(_neomChamberPreset.id);
//     //       logger.d(neomChamberController.neomChamber.neomChamberPresets!.length.toString());
//     //
//     //       if (neomUserController.neomProfile!.neomChambers != null &&
//     //           neomUserController.neomProfile!.neomChambers!.isNotEmpty) {
//     //         logger.d("Removing preset from global chamber from userController");
//     //         neomUserController.neomProfile!.neomChambers![neomChamberId]!.neomChamberPresets!.remove(_neomChamberPreset);
//     //       }
//     //   } else {
//     //     logger.d("Preset not removed");
//     //   }
//     // } catch (e) {
//     //   logger.d(e.toString());
//     // }
//
//     update([AppPageIdConstants.chamberPreset, AppPageIdConstants.chamber, AppPageIdConstants.chamberPresetDetails]);
//     Get.back();
//   }
//
//   void setSelectedChamber(String selectedChamber){
//     logger.d("Setting selected Chamber $selectedChamber");
//     neomChamberId  = selectedChamber;
//     existsInNeomChamber = presetAlreadyInChamber();
//     update([AppPageIdConstants.chamberPresetDetails]);
//   }
//
//   void getNeomChamberPresetDetails(String presetId) async {
//     logger.d("");
//     // await NeomChamberPresetFirestore().fetch(presetId: presetId).then((preset) => _neomChamberPreset  = preset);
//     update([AppPageIdConstants.chamberPresetDetails]);
//   }
//
//
//   Future<void> addNeomChamberPreset() async {
//     String neomChamberPresetId = "";
//     neomChamberId.isEmpty ? neomChamberPresetId = NeomConstants.firstNeomChamber : neomChamberPresetId = _neomChamberPresetId.value;
//     logger.d("Preset ${_neomChamberPreset.name} would be added for Chamber $neomChamberPresetId");
//
//     try {
//       // if(!await NeomChamberPresetFirestore().exists(presetId: _neomChamberPreset.id)){
//       //   await NeomChamberPresetFirestore().insert(_neomChamberPreset);
//       // }
//
//       if(!existsInNeomChamber) {
//         _neomChamberPreset.id = neomChamberPresetId;
//
//         // if(await NeomChamberFirestore().addPresetToChamber(_neomProfileId, _neomChamberPreset, neomChamberPresetId)){
//         //     if (neomUserController.profile!.neomChambers!.isNotEmpty) {
//         //       logger.d("Adding preset to global chamber from userController");
//         //       neomUserController.profile!.neomChambers![neomChamberPresetId]!.neomChamberPresets!.add(_neomChamberPreset);
//         //     }
//         //
//         //     logger.d("Setting existsInChamber and wasAdded true");
//         //     _existsInNeomChamber.value = true;
//         //     _wasAdded.value = true;
//         // }
//       }
//     } catch (e) {
//       logger.d(e.toString());
//     }
//
//     update([AppPageIdConstants.chamberPreset, AppPageIdConstants.chamber, AppPageIdConstants.chamberPresetDetails]);
//     Get.back();
//   }
//
//   void gotoSelectedNeomChamber() {
//     logger.d("");
//     Get.offAllNamed(AppRouteConstants.home);
//   }
//
//   bool presetAlreadyInChamber(){
//     logger.d("");
//     bool presetAlreadyInChamber = false;
//
//     neomChambers.forEach((key, chamber) {
//       chamber.chamberPresets!.forEach((preset) {
//         if (preset.id == neomChamberPreset.id) {
//           presetAlreadyInChamber = true;
//           neomChamberPresetId = preset.id;
//         }
//       });
//     });
//
//     return presetAlreadyInChamber;
//   }
//
//   Future<bool> savePresetInChamber(ChamberPreset chamberPreset) async {
//
//     if (neomChambers.length == 1 && neomChamberId.isEmpty)
//       neomChamberId = neomChambers.values.first.id;
//
//     logger.d("Preset ${chamberPreset.name} would be added for Chamber $neomChamberId");
//
//     try {
//
//       // if(chamberPresetId.isEmpty || !await NeomChamberPresetFirestore().exists(presetId: _neomChamberPreset.id)) {
//       //   chamberPreset.creatorId = _neomProfileId;
//       //   chamberPresetId = await NeomChamberPresetFirestore().insert(chamberPreset);
//       //   chamberPreset.id = chamberPresetId;
//       // }
//
//     if(!existsInNeomChamber) {
//
//       // if(await NeomChamberFirestore().addPresetToChamber(_neomProfileId, chamberPreset, neomChamberId)) {
//       //   if (neomUserController.neomProfile!.neomChambers!.isNotEmpty) {
//       //     logger.d("Adding preset to global chamber from userController");
//       //     neomUserController.neomProfile!.neomChambers![neomChamberId]!.neomChamberPresets!.add(chamberPreset);
//       //     }
//       //
//       //     logger.d("Setting existsInChamber and wasAdded true");
//       //     _existsInNeomChamber.value = true;
//       //     _wasAdded.value = true;
//       //     neomChamberPresetId = chamberPresetId;
//       //     neomChamberPreset = chamberPreset;
//       //   }
//       }
//     } catch (e) {
//       logger.d(e.toString());
//     }
//
//     update([AppPageIdConstants.chamberPreset, AppPageIdConstants.chamber, AppPageIdConstants.chamberPresetDetails]);
//     Get.back();
//     return true;
//   }
//
// }