import 'package:cyberneom/domain/model/neom-user.dart';

abstract class NeomUserRepository {

  Future<bool> insertUser(NeomUser neomUser);
  Future<NeomUser> getUserById(neomUserId);
  Future<bool> removeNeomUser(String neomUserId);
  Future<bool> updateAndroidNotificationToken(String neomUserId, String token);
  Future<bool> isAvailableEmail(String email);

}
