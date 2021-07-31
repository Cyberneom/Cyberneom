import 'package:cyberneom/domain/model/neom-chamber.dart';

abstract class NeomChamberService {

  void setNewChamberName(text);
  void setNewChamberDesc(text);
  void setUpdateChamberName(text);
  void setUpdateChamberDesc(text);

  Future<void> retrieveNeomChambers();
  Future<void> createChamber();
  Future<void> deleteChamber(NeomChamber chamber);
  Future<void> updateChamber(String chamberId, NeomChamber chamber);
  Future<void> setAsFavorite(NeomChamber chamber);
  void goToNeomChamberPresets(NeomChamber chamber);
}