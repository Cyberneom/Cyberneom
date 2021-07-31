import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:logger/logger.dart';

class NeomSettingsController extends GetxController {

  var logger = Logger();
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value;

  @override
  void onInit() async {
    super.onInit();
    logger.d("NeomSettings Controller Init");
    _isLoading.value = false;
  }

}