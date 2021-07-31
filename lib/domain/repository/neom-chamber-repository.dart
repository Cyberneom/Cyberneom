import 'dart:async';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';


abstract class NeomChamberRepository {

  Future<bool> addPresetToChamber(String neomProfileId, NeomChamberPreset preset, String chamberId);
  Future<bool> removePresetFromChamber(String neomProfileId, NeomChamberPreset preset, String chamberId);

  Future<String> insert({required String neomProfileId, required NeomChamber neomChamber});
  Future<bool> remove(neomProfileId, chamberId);
  Future<bool> update(String neomProfileId, NeomChamber chamber);

  Future<Map<String, NeomChamber>> retrieveNeomChambers(String neomProfileId);

  Future<bool> setAsFavorite(String neomProfileId, NeomChamber chamber);
  Future<bool> unsetOfFavorite(String neomProfileId, NeomChamber chamber);

}