import 'package:cyberneom/domain/model/neom-profile.dart';

abstract class NeommateRepository {


  Future<Map<String, NeomProfile>> getNeommatesForProfile(String neomProfileId);
  Future<Map<String, NeomProfile>> getNeommates(String neomProfileId);
  Future<NeomProfile>? getNeommateDetails(NeomProfile neomProfile);
  Future<bool> addNeommate(String neomProfileId, String neommateUserId);
  Future<bool> removeNeommate(String neomProfileId, String neommateUserId);
  void sendNeommateRequest();

}
