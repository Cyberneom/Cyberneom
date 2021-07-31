import 'package:cyberneom/ui/pages/auth/shared-preference-controller.dart';
import 'package:cyberneom/ui/pages/drawer/frequencies/frequency-controller.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/use-cases/onboarding-service.dart';
import 'package:cyberneom/ui/pages/add/neom-upload-controller.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/message-translation-constants.dart';
import 'package:cyberneom/utils/enum/neom-from.dart';
import 'package:cyberneom/utils/enum/neom-locale.dart';
import 'package:cyberneom/utils/enum/neom-reason.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/enum/neom-profile-type.dart';
import 'package:cyberneom/utils/enum/neom-upload-image-type.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class OnBoardingController extends GetxController implements OnBoardingService {

  var logger = NeomUtilities.logger;

  final neomUserController = Get.find<NeomUserController>();
  final frequencyController = Get.put(FrequencyController());
  final neomUploadController = Get.put(NeomUploadController());


  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  Rx<DateTime> _dateOfBirth = DateTime(NeomConstants.lastYearDOB).obs;
  DateTime get dateOfBirth => _dateOfBirth.value;
  set dateOfBirth(DateTime dateOfBirth) => this._dateOfBirth.value = dateOfBirth;

  TextEditingController controllerAboutMe = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerCountryCode = TextEditingController();

  String countryCode = '';
  String phoneNumber = '';
  String aboutMe = '';

  final FocusNode focusNodeAboutMe = new FocusNode();


  @override
  void onInit() async {
    super.onInit();
  }

  void setLocale(NeomLocale neomLocale) {
    Get.find<SharedPreferenceController>().updateLocale(neomLocale);
    update([NeomPageIdConstants.onBoardingNeomProfile]);
    Get.toNamed(NeomRouteConstants.INTRO_PROFILE);
  }

  @override
  void setProfileType(NeomProfileType neomProfileType) {
    logger.d("ProfileType registered as ${EnumToString.convertToString(neomProfileType)}");
    neomUserController.neomProfile!.type = neomProfileType;

    update([NeomPageIdConstants.onBoardingNeomProfile]);
    Get.toNamed(NeomRouteConstants.INTRO_FREQUENCY);
  }


  Future<void>  addFrequency(int index) async {
    logger.d("Adding frequency to new account");
    String instrumentKey = frequencyController.frequencies.keys.elementAt(index);
    NeomFrequency frequency = frequencyController.frequencies[instrumentKey]!;
    frequencyController.frequencies[instrumentKey]!.isFav = true;
    frequencyController.favFrequencies[instrumentKey] = frequency;

    update([NeomPageIdConstants.onBoardingFrequencies]);
  }


  Future<void> removeFrequencyInstrumentIntro(int index) async {
    logger.d("Removing frequency from new account");

    String instrumentKey = frequencyController.frequencies.keys.elementAt(index);
    NeomFrequency frequency = frequencyController.frequencies[instrumentKey]!;
    frequencyController.frequencies[instrumentKey]!.isFav = false;
    logger.d("Removing frequency ${frequency.name}");
    frequencyController.favFrequencies.remove(instrumentKey);

    update([NeomPageIdConstants.onBoardingFrequencies]);
  }


  void addFrequenciesToNeomProfile(){
    logger.d("Adding ${frequencyController.favFrequencies.length} Frequencies to NeomProfile");

    neomUserController.neomProfile!.rootFrequencies = frequencyController.favFrequencies
        .map((name, frequency) => MapEntry<String,NeomFrequency>(name,frequency));

    update([NeomPageIdConstants.onBoardingFrequencies]);
    Get.toNamed(NeomRouteConstants.INTRO_NEOM_REASON);
  }


  @override
  void setNeomReason(NeomReason neomReason) {
    logger.d("ProfileType registered neomReason as ${EnumToString.convertToString(neomReason)}");
    neomUserController.neomProfile!.neomReason = neomReason;
    update([NeomPageIdConstants.onBoardingNeomReason]);

    Get.toNamed(NeomRouteConstants.INTRO_ADD_IMAGE, arguments: [NeomRouteConstants.INTRO_NEOM_REASON]);

  }

  handleImage(NeomFileFrom neomFileFrom) async {
    await neomUploadController.handleImage(neomFileFrom, isProfilePicture: true);
    update([NeomPageIdConstants.onBoardingAddImage]);
  }

  setDateOfBirth(DateTime? pickedDate) {
    logger.d("");
    try {
      if (pickedDate != null
          && pickedDate.compareTo(dateOfBirth) != 0
          && pickedDate.compareTo(DateTime.now()) < 0)
        dateOfBirth = pickedDate;
    } catch (e) {
      logger.e(e.toString());
    }

    update([NeomPageIdConstants.onBoardingAddImage]);
  }


  Future<void> finishAccount() async {
    focusNodeAboutMe.unfocus();
    isLoading = true;

    String validateMsg = "";

    if(dateOfBirth.compareTo(DateTime(NeomConstants.lastYearDOB)) >= 0)
      validateMsg = MessageTranslationConstants.pleaseEnterDOB;

    if(validateMsg.isEmpty){
      if(neomUploadController.imageFile.path.isNotEmpty) {
        neomUserController.neomUser!.photoUrl = await neomUploadController.handleUploadImage(NeomUploadImageType.Profile);
      }
      neomUserController.neomUser!.phoneNumber = controllerPhone.text;
      neomUserController.neomUser!.countryCode = controllerCountryCode.text;
      if(controllerAboutMe.text.isNotEmpty) neomUserController.neomProfile!.aboutMe = controllerAboutMe.text;

      Get.toNamed(NeomRouteConstants.INTRO_WELCOME, arguments: [NeomRouteConstants.INTRO_ADD_IMAGE]);
    } else {
      isLoading = false;
      Get.snackbar(
        MessageTranslationConstants.finishingAccount.tr,
        validateMsg.tr,
        snackPosition: SnackPosition.BOTTOM);
    }

  }



}