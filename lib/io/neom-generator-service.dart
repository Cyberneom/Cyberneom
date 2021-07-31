
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-parameter.dart';

abstract class NeomGeneratorService {

  Future<void> settingChamber();
  void setFrequency(NeomFrequency frequency);
  void setVolume(NeomParameter parameter);
  void setPosition(NeomParameter parameter);
  Future<void> stopPlay();

}