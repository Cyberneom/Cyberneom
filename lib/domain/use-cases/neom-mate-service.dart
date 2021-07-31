import 'package:cyberneom/domain/model/neom-profile.dart';

abstract class NeommateService {

  Future<void> loadNeommates();
  Future<void> loadNeommatesById(List<String> neommateIds);
  Future<void> getNeommateDetails(NeomProfile neommate);
  Future<void> retrieveDetails();
  Future<void> loadNeommate(String neommateId);
  Future<void> getNeommatePosts();
  Future<void> getAddressSimple();
  Future<void> getTotalNeomChambers();
  Future<void> getTotalFrequencies();
  Future<void> follow();
  Future<void> unfollow();
  Future<void> sendMessage();

}