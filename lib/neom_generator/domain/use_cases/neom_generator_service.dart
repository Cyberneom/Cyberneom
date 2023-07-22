

abstract class NeomGeneratorService {

  Future<void> settingChamber();
  void setFrequency(double frequency);
  void setVolume(double volume);
  void setParameterPosition({required double x, required double y, required double z});
  Future<void> stopPlay();

}