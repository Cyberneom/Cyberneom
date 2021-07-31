import 'package:cyberneom/domain/model/neom-frequency.dart';

abstract class FrequencyService {

  Future<void> loadFrequencies();

  Future<void>  addFrequency(int index);
  Future<void> removeFrequency(int index);
  makeRootFrequency(NeomFrequency frequency);


}