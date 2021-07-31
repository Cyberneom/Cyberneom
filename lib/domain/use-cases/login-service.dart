import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cyberneom/utils/enum/auth-status.dart';


abstract class LoginService {

  Future<void> getNeomApp();
  Future<void> handleAuthChanged(user);

  void handleLogin(LoginMethod loginMethod);

  Future<void> facebookLogin();
  Future<void> googleLogin();
  Future<void> emailLogin();

  Future<void> signOut();

  Future<void> sendEmailVerification(GlobalKey<ScaffoldState> scaffoldKey);

}