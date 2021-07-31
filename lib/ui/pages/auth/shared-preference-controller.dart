
import 'package:cyberneom/domain/use-cases/shared-preference-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/utils/constants/neom-shared-preference-constants.dart';
import 'package:cyberneom/utils/enum/neom-locale.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferenceController extends GetxController implements SharedPreferenceService {

  final logger = NeomUtilities.logger;
  final neomUserController = Get.find<NeomUserController>();


  @override
  void onInit() async {
    super.onInit();
    readLocal();
    logger.d("");
  }

  late SharedPreferences prefs;

  Future<void> readLocal() async {
    prefs = await SharedPreferences.getInstance();
    String neomLocale = prefs.getString(NeomSharedPreferenceConstants.neomLocale) ?? '';
    if(neomLocale.isNotEmpty) {
      setLocale(EnumToString.fromString(NeomLocale.values, neomLocale)!);
    }

  }

  Future<void> writeLocal() async {

  }

  @override
  Future<void> updateLocale(NeomLocale neomLocale) async {
    logger.d("Setting locale preference to ${EnumToString.convertToString(neomLocale)}");
    await prefs.setString(NeomSharedPreferenceConstants.neomLocale, EnumToString.convertToString(neomLocale));
    setLocale(neomLocale);

  }

  void setLocale(NeomLocale gigLocale) {

    Locale locale = Get.deviceLocale!;

    switch(gigLocale) {
      case NeomLocale.English:
        locale = Locale('en', 'US');
        break;
      case NeomLocale.Spanish:
        locale = Locale('esp', 'MX');
        break;
      case NeomLocale.French:
        locale = Locale('fr', 'FR');
        break;
      case NeomLocale.Deutsch:
        locale = Locale('de', 'DE');
        break;
    }

    Get.updateLocale(locale);

  }


}




