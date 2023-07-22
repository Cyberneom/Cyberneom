import 'dart:convert';
import 'package:cyberneom/neom_frequencies/frequencies/data/firestore/frequency_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neom_commons/core/data/implementations/app_drawer_controller.dart';
import 'package:neom_commons/core/domain/model/app_profile.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/domain/model/neom/neom_frequency.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_assets.dart';
import 'package:neom_commons/core/utils/constants/app_page_id_constants.dart';
import '../domain/use_cases/frequency_service.dart';

class FrequencyController extends GetxController implements FrequencyService {

  var logger = AppUtilities.logger;
  final userController = Get.find<UserController>();

  final RxMap<String, NeomFrequency> _frequencies = <String, NeomFrequency>{}.obs;
  Map<String, NeomFrequency> get frequencies =>  _frequencies;
  set frequencies(Map<String,NeomFrequency> frequencies) => _frequencies.value = frequencies;

  final RxMap<String, NeomFrequency> _favFrequencies = <String,NeomFrequency>{}.obs;
  Map<String,NeomFrequency> get favFrequencies =>  _favFrequencies;
  set favFrequencies(Map<String,NeomFrequency> favFrequencies) => _favFrequencies.value = favFrequencies;

  final RxMap<String, NeomFrequency> _sortedFrequencies = <String,NeomFrequency>{}.obs;
  Map<String,NeomFrequency> get sortedFrequencies =>  _sortedFrequencies;
  set sortedFrequencies(Map<String,NeomFrequency> sortedFrequencies) => _sortedFrequencies.value = sortedFrequencies;

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => _isLoading.value = isLoading;

  AppProfile profile = AppProfile();

  @override
  void onInit() async {
    super.onInit();
    logger.d("Frequencies Init");

    profile = userController.profile;

    try {
      await loadFrequencies();

      if(userController.profile.frequencies != null) {
        favFrequencies = userController.profile.frequencies!;
      }

      sortFavFrequencies();
    } catch (e) {
      AppUtilities.logger.e(e.toString());
    }

  }

  @override
  Future<void> loadFrequencies() async {
    logger.d("");

    profile.frequencies = await FrequencyFirestore().retrieveFrequencies(profile.id);
    String frequencyStr = await rootBundle.loadString(AppAssets.frequenciesJsonPath);
    List<dynamic> frequencyJSON = jsonDecode(frequencyStr);

    for (var freqJSON in frequencyJSON) {
      NeomFrequency freq = NeomFrequency.fromAssetJSON(freqJSON);
      frequencies[freq.id] = freq;
    }

    logger.d("${frequencies.length} loaded frequencies from json");

    isLoading = false;
    update([AppPageIdConstants.frequencies]);
  }

  @override
  Future<void>  addFrequency(int index) async {
    logger.d("");

    NeomFrequency frequency = sortedFrequencies.values.elementAt(index);
    sortedFrequencies[frequency.id]!.isFav = true;

    logger.i("Adding frequency ${frequency.name}");
    if(await FrequencyFirestore().addFrequency(profileId: profile.id, frequency:  frequency)){
      favFrequencies[frequency.id] = frequency;
    }

    sortFavFrequencies();
    update([AppPageIdConstants.frequencies]);
  }

  @override
  Future<void> removeFrequency(int index) async {
    logger.d("Removing Instrument");
    NeomFrequency frequency = sortedFrequencies.values.elementAt(index);

    sortedFrequencies[frequency.id]!.isFav = false;
    logger.d("Removing frequency ${frequency.name}");

    if(await FrequencyFirestore().removeFrequency(profileId: profile.id, frequencyId: frequency.id)){
      favFrequencies.remove(frequency.id);
    }

    sortFavFrequencies();
    update([AppPageIdConstants.frequencies]);
  }

  @override
  void makeMainFrequency(NeomFrequency frequency){
    logger.d("Main frequency ${frequency.name}");

    String prevInstrId = "";
    for (var instr in favFrequencies.values) {
      if(instr.isMain) {
        instr.isMain = false;
        prevInstrId = instr.id;
      }
    }
    frequency.isMain = true;
    favFrequencies.update(frequency.name, (frequency) => frequency);
    FrequencyFirestore().updateMainFrequency(profileId: profile.id,
      frequencyId: frequency.id, prevInstrId:  prevInstrId);

    profile.frequencies![frequency.id] = frequency;
    Get.find<AppDrawerController>().updateProfile(profile);
    update([AppPageIdConstants.frequencies]);

  }

  @override
  void sortFavFrequencies(){

    sortedFrequencies = {};

    for (var frequency in frequencies.values) {
      if (favFrequencies.containsKey(frequency.id)) {
        sortedFrequencies[frequency.id] = favFrequencies[frequency.id]!;
      }
    }

    for (var frequency in frequencies.values) {
      if (!favFrequencies.containsKey(frequency.id)) {
        sortedFrequencies[frequency.id] = frequencies[frequency.id]!;
      }
    }

  }

}
