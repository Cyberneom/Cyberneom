import 'dart:async';
import 'package:cyberneom/domain/model/neom-frequency.dart';

abstract class FrequencyRepository {

  Future<Map<String?,NeomFrequency>> retrieveFrequencies(neomUserId);

  Future<bool> removeFrequency({required String neomProfileId, required String frequencyId});

  Future<String> addBasicFrequency({required String neomProfileId, required String frequencyName});

  Future<bool> updateRootFrequency({required String neomProfileId,
    required String frequencyId, required String prevFreqId});

}

