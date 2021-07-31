import 'package:cyberneom/domain/model/neom-chamber-preset.dart';

abstract class NeomChamberPresetService {

  Future<void> updateNeomChamber(NeomChamberPreset neomChamberPreset);
  Future<void> removePresetFromNeomChamber(NeomChamberPreset neomChamberPreset);
  Future<void> getNeomChamberPresetDetails(NeomChamberPreset neomChamberPreset);

}