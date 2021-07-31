
import 'package:firebase_auth/firebase_auth.dart';

abstract class NeomUserService {

  Future<void> createNeomUser();
  Future<void> removeAccount();
  Future<void> getNeomUserFromFacebook(String fbAccessToken);
  void getNeomUserFromFireBase(User fbaUser);
  Future<void> getNeomUserById(String neomUserId);

}