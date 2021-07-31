import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class SplashController extends GetxController {

  final logger = NeomUtilities.logger;
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

  String _subtitle = "";
  String get subtitle => _subtitle;
  set subtitle(String subtitle) => this._subtitle = subtitle;

  @override
  void onInit() async {
    logger.d("");
    super.onInit();

    String fromRoute = "";
    String toRoute = "";

    try {
      if (Get.arguments != null) {
        List<dynamic> arguments = Get.arguments;
        fromRoute = arguments.elementAt(0);
        if(arguments.length > 1) toRoute = arguments.elementAt(1);
      }
    } catch (e) {
      logger.e(e.toString());
    }

    switch(fromRoute){
      case NeomRouteConstants.HOME:
        Get.offAndToNamed(toRoute);
        break;
      case NeomRouteConstants.LOGOUT:
        loginController.signOut();
        break;
      case NeomRouteConstants.ACCOUNT_SETTINGS:
        subtitle = NeomTranslationConstants.removingAccount;
        neomUserController.removeAccount();
        break;
      case NeomRouteConstants.FORGOT_PASSWORD:
        subtitle = NeomTranslationConstants.sendingPasswordRecovery;
        break;
      case NeomRouteConstants.INTRO_NEOM_REASON:
        subtitle = NeomTranslationConstants.creatingAccount;
        await neomUserController.createNeomUser();
        break;
      case NeomRouteConstants.SIGNUP:
        subtitle = NeomTranslationConstants.creatingAccount;
        break;
      case NeomRouteConstants.INTRO_ADD_IMAGE:
        subtitle = NeomTranslationConstants.welcome;
        neomUserController.createNeomUser();
        break;
      case "":
        logger.d("There is no fromRoute");
        break;
    }

    await Future.delayed(Duration(seconds: 3));
  }

}