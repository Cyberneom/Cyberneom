import 'dart:async';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';

abstract class NeomChamberPresetRepository {

  Future<NeomChamberPreset> fetch({required String presetId});
  Future<bool> exists({required String presetId});

  Future<void> insert(NeomChamberPreset preset);
  Future<bool> remove(NeomChamberPreset preset);

  Future<bool> updateAtNeomChamber(String neomUserId, String chamberId, NeomChamberPreset presetId);
  Future<bool> removeFromNeomChamber(String neomUserId, String chamberId, NeomChamberPreset presetId);

  Future<bool> addPresetToChamber(NeomChamberPreset preset, String chamberId);
  Future<void> removePresetFromChamber(String presetId, String chamberId);

  Future<Map<String, NeomChamberPreset>> getPresetsFromNeomChamber(String neomUserId, NeomChamber chamber);
}