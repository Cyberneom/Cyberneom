import 'dart:convert';

import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-user-firestore.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-user.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/use-cases/neom-user-service.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/ui/pages/auth/signup/signup-controller.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-controller.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/enum/neom-user-role.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class NeomUserController extends GetxController implements NeomUserService {

  final logger = NeomUtilities.logger;
  final neomProfileController = Get.lazyPut(() => NeomProfileController());

  Rxn<NeomUser> _neomUser = Rxn<NeomUser>();
  NeomUser? get neomUser => _neomUser.value;
  set neomUser(NeomUser? neomUser) => this._neomUser.value = neomUser;

  bool _isNewNeomUser = false;
  bool get isNewUser => _isNewNeomUser;
  set isNewUser(bool isNewUser) => this._isNewNeomUser = isNewUser;

  Rxn<NeomProfile> _neomProfile = Rxn<NeomProfile>();
  NeomProfile? get neomProfile => _neomProfile.value;
  set neomProfile(NeomProfile? neomProfile) => this._neomProfile.value = neomProfile;

  @override
  void onInit() async {
    super.onInit();
    neomUser = NeomUser();
    neomProfile = NeomProfile();
    logger.d("");
  }


  Future<void> getNeomUserFromFacebook(String fbAccessToken) async {
    logger.i("NeomUser is new");

    try {

      Uri fbURI = Uri.https(NeomConstants.graphApiAuthorityUrl, NeomConstants.graphApiUnencondedPath,
          {NeomConstants.graphApiQueryFieldsParam: NeomConstants.graphApiQueryFieldsValues,
            NeomConstants.graphApiQueryAccessTokenParam: fbAccessToken});

      var graphResponse = await http.get(fbURI);

      if(graphResponse.statusCode == 200) {
        var jsonResponse = jsonDecode(graphResponse.body) as Map<String, dynamic>;
        logger.i("Profile from Graph FB API ${jsonResponse.toString()}");
        neomUser = NeomUser.fromFbProfile(jsonResponse);
      } else {
        logger.w("Request failed with status: ${graphResponse.statusCode}");
      }
    } catch (e) {
      Get.snackbar(
        MessageTranslationConstants.errorCreatingAccount.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      logger.e(e);
    }
  }


  void getNeomUserFromFireBase(fba.User fbaUser) {
    logger.d("Getting NeomUser Info From Google Sign-In");
    neomUser =  NeomUser(
      dateOfBirth: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
          .toString(),
      homeTown: NeomTranslationConstants.somewhereUniverse.tr,
      photoUrl: fbaUser.photoURL ?? "",
      name: fbaUser.displayName ?? "",
      firstName: "",
      lastName: "",
      email: fbaUser.email ?? "",
      id: fbaUser.providerData.first.uid ?? "",
      phoneNumber: fbaUser.phoneNumber ?? "",
      isVerified: false,
      password: "",
      );

    logger.d('Last login at: ${fbaUser.metadata.lastSignInTime}');
    logger.d(neomUser.toString());
  }


  void getNeomUserFromSignUp() {
    logger.d("Getting NeomUser Info From Sign-up text fields");

    try {
      SignUpController signupController = Get.find<SignUpController>();
      neomUser =  NeomUser(
        homeTown: NeomTranslationConstants.somewhereUniverse.tr,
        photoUrl: "",
        name: signupController.usernameController.text,
        firstName: signupController.firstNameController.text,
        lastName: signupController.lastNameController.text,
        email: signupController.emailController.text,
        id: signupController.emailController.text,
        password: signupController.passwordController.text,
      );
    } catch (e) {
      logger.e(e.toString());
    }

    logger.d(neomUser.toString());
  }

  void clear() {
    neomUser = NeomUser();
  }


  Future<void> createNeomUser() async {

    logger.d("NeomUser to create ${neomUser!.name}");
    NeomUser newNeomUser = neomUser!;

    NeomProfile newNeomProfile = NeomProfile();
    newNeomProfile.name = newNeomUser.name;
    newNeomProfile.photoUrl = newNeomUser.photoUrl;
    newNeomProfile.coverImgUrl = newNeomUser.photoUrl;
    newNeomProfile.aboutMe = neomProfile!.aboutMe;
    newNeomProfile.rootFrequency = neomProfile!.rootFrequencies!.values.first.name;
    newNeomProfile.isActive = true;
    newNeomProfile.type = neomProfile!.type;
    newNeomProfile.neomReason = neomProfile!.neomReason;
    newNeomProfile.favGenres = [];
    newNeomProfile.bannedGenres = [];
    newNeomProfile.neommates = [];
    newNeomProfile.following = [];
    newNeomProfile.followers = [];
    newNeomProfile.neomPosts = [];
    newNeomProfile.neomTribes = [];
    newNeomProfile.neomEvents = [];
    newNeomProfile.neomClusterIds = [];
    newNeomProfile.neomChambers = Map();
    newNeomProfile.neomChambers![NeomConstants.firstNeomChamber] = NeomChamber.myFirstNeomChamber();
    newNeomProfile.rootFrequencies = neomProfile!.rootFrequencies;
    newNeomUser.neomProfiles = [newNeomProfile];
    newNeomUser.neomUserRole = NeomUserRole.Subscriber;

    await Future.delayed(Duration(seconds: 2));

    try {
      if(await NeomUserFirestore().insertUser(newNeomUser)){
        isNewUser = false;
        neomUser = newNeomUser;

        String neomProfileId = await NeomProfileFirestore().insertNeomProfile(neomUser!.id, neomUser!.neomProfiles!.first);
        neomUser!.neomProfiles!.first.id = neomProfileId;
        neomProfile = neomUser!.neomProfiles!.first;

        if(neomProfileId.isEmpty) {
          await NeomUserFirestore().removeNeomUser(newNeomUser.id);
          logger.e("Something wrong creating account.");
          Get.offAllNamed(NeomRouteConstants.LOGOUT);
        } else {
          Get.offAllNamed(NeomRouteConstants.HOME);
        }
      } else {
        logger.e("Something wrong creating account.");
        Get.offAllNamed(NeomRouteConstants.LOGIN);
      }
    } catch (e) {
      Get.snackbar(
        MessageTranslationConstants.errorCreatingAccount.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    logger.d("");
  }


  Future<void> getNeomUserById(String neomUserId) async {
    try {
      NeomUser neomUserFromFirestore = await NeomUserFirestore().getUserById(neomUserId);
      if(neomUserFromFirestore.id.isNotEmpty){
        logger.d("NeomUser $neomUserId exists!!");
        neomUser = neomUserFromFirestore;
        neomProfile = neomUser!.neomProfiles!.first;
      } else {
        logger.i("NeomUser $neomUserId not exists!!");
        isNewUser = true;
      }
    } catch (e) {
      logger.e(e.toString);
    }
  }


  Future<void> removeAccount() async {
    logger.d("removeAccount method Started");
    try {
      LoginController loginController = Get.find<LoginController>();
      await loginController.fbaUser.delete();
      await loginController.auth.signOut();
      if(await NeomUserFirestore().removeNeomUser(neomUser!.id)) {
        clear();
      }
    } on fba.FirebaseAuthException catch (e) {
      Get.snackbar(
        MessageTranslationConstants.errorSigningOut.tr,
        e.code,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        MessageTranslationConstants.errorSigningOut.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      Get.offAllNamed(NeomRouteConstants.ROOT);
    }


    logger.i("removeAccount method Finished");
  }

}

