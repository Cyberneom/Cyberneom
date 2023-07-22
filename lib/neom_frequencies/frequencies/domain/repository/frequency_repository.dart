import 'dart:async';
import 'package:neom_commons/core/domain/model/neom/neom_frequency.dart';

abstract class FrequencyRepository {

  Future<Map<String?,NeomFrequency>> retrieveFrequencies(profileId);
  Future<bool> removeFrequency({required String profileId, required String frequencyId});
  Future<bool> addFrequency({required String profileId, required NeomFrequency frequency});
  Future<bool> updateMainFrequency({required String profileId,
    required String frequencyId, required String prevInstrId});

}
