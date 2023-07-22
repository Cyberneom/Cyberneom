import 'dart:async';

import 'package:neom_commons/core/domain/model/item_list.dart';
import 'package:neom_commons/core/domain/model/neom/chamber_preset.dart';

abstract class ChamberRepository {

  Future<bool> addPreset(String profileId, ChamberPreset preset, String chamberId);
  Future<bool> removePreset(String profileId, ChamberPreset appItem, String itemlistId);
  Future<String> insert(String profileId, Itemlist itemlist);
  Future<Map<String, Itemlist>> retrieveNeomChambers(String profileId);
  Future<bool> remove(profileId, itemlistId);
  Future<bool> update(String profileId, Itemlist chamber);
  Future<bool> setAsFavorite(String profileId, Itemlist itemlist);
  Future<bool> unsetOfFavorite(String profileId, Itemlist chamber);
  Future<bool> updatePreset(String profileId, String itemlistId, ChamberPreset preset);

}
