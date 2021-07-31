import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:logger/logger.dart';

class NeomAccountSettingsController extends GetxController {

  var logger = Logger();
  final neomUserController = Get.find<NeomUserController>();


  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  @override
  void onInit() async {
    super.onInit();
    logger.d("AccountSettings Controller Init");
    _isLoading.value = false;
  }


}