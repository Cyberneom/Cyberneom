import 'package:cyberneom/utils/enum/neom-from.dart';
import 'package:cyberneom/utils/enum/neom-reason.dart';
import 'package:cyberneom/utils/enum/neom-profile-type.dart';

abstract class OnBoardingService {

  void setProfileType(NeomProfileType neomProfileType);
  Future<void>  addFrequency(int index);
  Future<void> removeFrequencyInstrumentIntro(int index);
  void addFrequenciesToNeomProfile();
  void setNeomReason(NeomReason neomReason);
  void handleImage(NeomFileFrom neomFileFrom);
  void setDateOfBirth(DateTime? pickedDate);
  void finishAccount();


}