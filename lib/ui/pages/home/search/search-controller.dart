import 'package:get/get.dart';
import 'package:cyberneom/domain/use-cases/search-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/ui/pages/timeline/timeline-controller.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class SearchController extends GetxController implements SearchService {

  var logger = NeomUtilities.logger;
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();
  final timelineController = Get.put(TimelineController());


  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

    @override
  void onInit() async {
    super.onInit();

  }

  @override
  void onReady() async {
    super.onReady();
    isLoading = false;
  }

}

