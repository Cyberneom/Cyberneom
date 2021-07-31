
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:cyberneom/data/api-services/firestore/neom-app-firestore.dart';
import 'package:cyberneom/domain/model/neom-app.dart';
import 'package:cyberneom/domain/use-cases/login-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/utils/constants/neom-analytics-constants.dart';
import 'package:cyberneom/utils/constants/neom-firestore-constants.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';
import 'package:cyberneom/utils/enum/auth-status.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginController extends GetxController implements LoginService {

  final logger = NeomUtilities.logger;
  final neomUserController = Get.find<NeomUserController>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  Rx<AuthStatus> _authStatus = AuthStatus.NOT_DETERMINED.obs;
  AuthStatus get authStatus => _authStatus.value;
  set authStatus(AuthStatus authStatus) => this._authStatus.value = authStatus;

  final FacebookLogin fb = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _neomUserId = "";
  String _fbAccessToken = "";

  fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  fba.FirebaseAuth get auth => _auth;
  set auth(fba.FirebaseAuth auth) => this._auth = auth;

  Rxn<fba.User> _fbaUser = Rxn<fba.User>();
  fba.User get fbaUser => _fbaUser.value!;
  set fbaUser(fba.User? fbaUser) => this._fbaUser.value = fbaUser;

  SignedInWith _signedInWith = SignedInWith.NOT_DETERMINED;
  SignedInWith get signedInWith => _signedInWith;
  set signedInWith(SignedInWith signedInWith) => this._signedInWith = signedInWith;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  RxBool _isButtonDisabled = false.obs;
  bool get isButtonDisabled => _isButtonDisabled.value;
  set isButtonDisabled(bool isButtonDisabled) => this._isButtonDisabled.value = isButtonDisabled;

  Rxn<NeomApp> _neomApp = Rxn<NeomApp>();
  NeomApp get neomApp => _neomApp.value!;
  set neomApp(NeomApp neomApp) => this._neomApp.value = neomApp;


  @override
  void onInit() async {
    super.onInit();
    logger.d("");
    neomApp = NeomApp();
    fbaUser = _auth.currentUser;
    ever(_fbaUser, handleAuthChanged);
    _fbaUser.bindStream(_auth.authStateChanges());
  }

  @override
  void onReady() {
    super.onReady();
    logger.d("");
    getNeomApp();
    isLoading = false;
  }

  Future<void> handleAuthChanged(user) async {
    logger.d("");
    authStatus = AuthStatus.WAITING;

    try {
      if(auth.currentUser == null) {
        authStatus = AuthStatus.NOT_LOGGED_IN;
        auth = fba.FirebaseAuth.instance;
      } else if (user == null) {
        authStatus = AuthStatus.NOT_LOGGED_IN;
        user = auth.currentUser;
      } else {
        if(user.providerData.isNotEmpty){
          _neomUserId = user.providerData.first.uid!;
          await neomUserController.getNeomUserById(_neomUserId);
        }

        if (neomUserController.neomUser!.id.isEmpty) {
          switch(_signedInWith) {
            case(SignedInWith.email):
              neomUserController.getNeomUserFromFireBase(user);
              break;
            case(SignedInWith.facebook):
              await neomUserController.getNeomUserFromFacebook(_fbAccessToken);
              break;
            case(SignedInWith.google):
              neomUserController.getNeomUserFromFireBase(user);
              break;
            case(SignedInWith.signUp):
              break;
            case(SignedInWith.NOT_DETERMINED):
              authStatus = AuthStatus.NOT_DETERMINED;
              break;
          }
        } else if(!neomUserController.isNewUser && neomUserController.neomUser!.neomProfiles!.isEmpty) {
          logger.i("No NeomProfiles found for $_neomUserId. Please Login Again");
          authStatus = AuthStatus.NOT_LOGGED_IN;
        } else {
          authStatus = AuthStatus.LOGGED_IN;
        }

        if (neomUserController.isNewUser && neomUserController.neomUser!.id.isNotEmpty) {
          authStatus = AuthStatus.LOGGED_IN;
          Get.offAndToNamed(NeomRouteConstants.INTRO_LOCALE);
        } else {
          Get.offAllNamed(NeomRouteConstants.ROOT);
        }
      }
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        MessageTranslationConstants.errorHandlingAuth,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(NeomRouteConstants.ROOT);
    } finally {
      isLoading = false;
    }

  }

  Future<void> getNeomApp() async {
    neomApp = await NeomAppFirestore().retrieveNeomApp();
    logger.i(neomApp.toString());
    update([NeomPageIdConstants.loginPage]);
  }

  void handleLogin(LoginMethod loginMethod) async {

    isButtonDisabled = true;
    isLoading = true;

    switch (loginMethod) {
      case LoginMethod.facebook:
        await facebookLogin();
        break;
      case LoginMethod.google:
        await googleLogin();
        break;
      case LoginMethod.email:
        await emailLogin();
        break;
      case LoginMethod.NOT_DETERMINED:
        break;
    }

    isButtonDisabled = false;
    isLoading = false;

    update([NeomPageIdConstants.loginPage]);
  }


  @override
  Future<void> facebookLogin() async {
    try {
      NeomUtilities.kAnalytics.logLogin(loginMethod: NeomAnalyticsConstants.facebook_login);

      FacebookLoginResult fbLoginResult = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

      switch (fbLoginResult.status) {
        case FacebookLoginStatus.success:
          _neomUserId = fbLoginResult.accessToken!.userId;
          logger.i("FB Logged-in with: $_neomUserId");
          _fbAccessToken = fbLoginResult.accessToken!.token;
          final fbAuthCred = fba.FacebookAuthProvider.credential(_fbAccessToken);
          fba.UserCredential userCredential =  await auth.signInWithCredential(fbAuthCred);
          authStatus = AuthStatus.LOGGED_IN;
          _signedInWith = SignedInWith.facebook;
          fbaUser = userCredential.user;
          logger.i(userCredential.toString());
          break;
        case FacebookLoginStatus.error:
          authStatus = AuthStatus.NOT_LOGGED_IN;
          logger.i("Error");
          break;
        case FacebookLoginStatus.cancel:
          authStatus = AuthStatus.NOT_LOGGED_IN;
          logger.i("CancelledByUser");
          break;
      }
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        MessageTranslationConstants.errorLoginFacebook.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isButtonDisabled = false;
      isLoading = false;
    }

    update([NeomPageIdConstants.loginPage]);
  }


  @override
  Future<void> emailLogin() async {
    NeomUtilities.kAnalytics.logLogin(loginMethod: NeomAnalyticsConstants.email_login);

    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      ).then((authUser) {
        fbaUser = authUser.user;
      });
      authStatus = AuthStatus.LOGGED_IN;
      _signedInWith = SignedInWith.email;
    } on fba.FirebaseAuthException catch (e) {
      logger.e(e.toString());

      String errorMsg = "";
      switch (e.code) {
        case NeomFirestoreConstants.wrongPassword:
          errorMsg = MessageTranslationConstants.invalidPassword;
          break;
        case NeomFirestoreConstants.invalidEmail:
          errorMsg = MessageTranslationConstants.invalidEmailFormat;
          break;
        case NeomFirestoreConstants.userNotFound:
          errorMsg = MessageTranslationConstants.userNotFound;
          break;
        case NeomFirestoreConstants.unknown:
          errorMsg = MessageTranslationConstants.pleaseFillForm;
          break;

      }

      Get.snackbar(
        MessageTranslationConstants.errorLoginEmail.tr,
        errorMsg.tr,
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e){
      logger.e(e.toString());
      Get.snackbar(
        MessageTranslationConstants.errorLoginEmail.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
      isButtonDisabled = false;
    }

    update([NeomPageIdConstants.loginPage]);
  }

  @override
  Future<void> googleLogin() async {
    try {
      NeomUtilities.kAnalytics.logLogin(loginMethod: NeomAnalyticsConstants.google_login);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      fba.AuthCredential credential = fba.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
      );

      authStatus = AuthStatus.LOGGED_IN;
      _signedInWith = SignedInWith.google;

      fbaUser = (await _auth.signInWithCredential(credential)).user;

    } catch (e) {
      fbaUser = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      logger.e(e.toString());
      Get.snackbar(
        MessageTranslationConstants.errorLoginGoogle.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
      isButtonDisabled = false;
    }

    update([NeomPageIdConstants.loginPage]);
  }

  //TODO To Verify Implementation
  void googleLogout() {
    _googleSignIn.signOut();
    Get.offAllNamed(NeomRouteConstants.LOGIN);
  }

  Future<void> signOut() async {
    logger.d("Entering signOut method");
    try {
      await auth.signOut();
      clear();
      Get.offAllNamed(NeomRouteConstants.LOGIN);
    } catch (e) {
      Get.snackbar(
        MessageTranslationConstants.errorSigningOut.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    logger.i("signOut method finished");
  }




  @override
  Future<void> sendEmailVerification(GlobalKey<ScaffoldState> scaffoldKey) {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }


  void clear() {
    fbaUser = null;
    authStatus = AuthStatus.NOT_DETERMINED;
    isButtonDisabled = false;
  }

}




