import 'package:cyberneom/domain/model/neom-chamber-preset.dart';

abstract class NeomProfileService {

  Future<void> editNeomProfile();

  void getneomChamberPresetDetails(NeomChamberPreset neomChamber);

  Future<void> updateLocation();
  Future<void> updateProfileData(context);


}