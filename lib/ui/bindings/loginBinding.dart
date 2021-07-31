
import 'package:cyberneom/ui/pages/auth/shared-preference-controller.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';


class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NeomUserController>(NeomUserController(), permanent: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<SharedPreferenceController>(SharedPreferenceController(), permanent: true);
  }
}