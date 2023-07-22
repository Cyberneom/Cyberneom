import 'package:neom_commons/core/domain/model/neom/neom_frequency.dart';

abstract class FrequencyService {

  Future<void> loadFrequencies();
  Future<void>  addFrequency(int index);
  Future<void> removeFrequency(int index);
  void makeMainFrequency(NeomFrequency frequency);
  void sortFavFrequencies();

}
