import 'dart:convert';
import 'package:cyberneom/data/api-services/firestore/frequency-firestore.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/use-cases/fequency-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';

import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class FrequencyController extends GetxController implements FrequencyService {

  var logger = NeomUtilities.logger;
  final neomUserController = Get.find<NeomUserController>();

  RxMap<String, NeomFrequency> _frequencies = Map<String,NeomFrequency>().obs;
  Map<String, NeomFrequency> get frequencies =>  _frequencies;
  set frequencies(Map<String,NeomFrequency> frequencies) => this._frequencies.value = frequencies;

  RxMap<String, NeomFrequency> _favFrequencies = Map<String,NeomFrequency>().obs;
  Map<String,NeomFrequency> get favFrequencies =>  _favFrequencies;
  set favFrequencies(Map<String,NeomFrequency> favFrequencies) => this._favFrequencies.value = favFrequencies;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  String _neomProfileId = "";

  @override
  void onInit() async {
    super.onInit();
    logger.d("Frequencies Init");

    _neomProfileId = neomUserController.neomProfile!.id;
    favFrequencies = neomUserController.neomProfile!.rootFrequencies ?? {};
    await loadFrequencies();
  }

  Future<void> loadFrequencies() async {
    logger.d("");
    String frequencyPresets = await rootBundle.loadString(NeomAssets.frequencyPresets_JSONPath);
    
    List<dynamic> frequencyJSON = jsonDecode(frequencyPresets);
    List<NeomFrequency> frequencyList = [];
    frequencyJSON.forEach((freqJSON) {
      frequencyList.add(NeomFrequency.fromJsonDefault(freqJSON));
    });

    logger.d("${frequencyList.length} loaded frequencies from JSON");

    frequencies = Map.fromIterable(frequencyList, key: (e) => e.id, value: (e) => e);

    isLoading = false;
    update([NeomPageIdConstants.frequencies]);
  }

  Future<void>  addFrequency(int index) async {
    logger.d("");

    String frequencyKey = frequencies.keys.elementAt(index);
    NeomFrequency frequency = frequencies[frequencyKey]!;
    frequencies[frequencyKey]!.isFav = true;

    logger.i("Adding frequency ${frequency.name}");
    String frequencyId = await FrequencyFirestore().addBasicFrequency(neomProfileId: _neomProfileId, frequencyName:  frequency.id);
    if(frequencyId.isNotEmpty){
      frequency.id = frequencyId;
      favFrequencies[frequencyKey] = frequency;
    }

    update([NeomPageIdConstants.frequencies]);
  }

  Future<void> removeFrequency(int index) async {
    String frequencyKey = frequencies.keys.elementAt(index);
    logger.d("Removing Frequency");
    NeomFrequency frequency = frequencies[frequencyKey]!;
    frequencies[frequencyKey]!.isFav = false;
    logger.d("Removing frequency ${frequency.name}");

    if(await FrequencyFirestore().removeFrequency(neomProfileId: _neomProfileId, frequencyId: frequency.id)){
      favFrequencies.remove(frequencyKey);
    }

    update([NeomPageIdConstants.frequencies]);
  }

  void makeRootFrequency(NeomFrequency frequency){
    logger.d("Main root frequency ${frequency.name}");

    String prevFreqId = "";
    favFrequencies.values.forEach((freq) {
      if(freq.isRoot) {
        freq.isRoot = false;
        prevFreqId = freq.id;
      }
    });
    frequency.isRoot = true;
    favFrequencies.update(frequency.name, (freq) => frequency);
    FrequencyFirestore().updateRootFrequency(neomProfileId: _neomProfileId,
      frequencyId: frequency.id, prevFreqId:  prevFreqId);

    update([NeomPageIdConstants.frequencies, NeomPageIdConstants.sidebarMenu]);


  }


}