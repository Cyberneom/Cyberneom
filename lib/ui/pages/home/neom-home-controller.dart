import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/data/implementations/geolocator-service-impl.dart';
import 'package:cyberneom/domain/use-cases/neom-home-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/ui/pages/timeline/timeline-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class NeomHomeController extends GetxController implements NeomHomeService {

  var logger = NeomUtilities.logger;
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();
  final timelineController = Get.put(TimelineController());

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int currentIndex) => this._currentIndex = currentIndex;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;
  
  final PageController pageController = PageController();

  @override
  void onInit() async {
    super.onInit();
    logger.i("NeomHome Controller Init");

    pageController.addListener(() {
      currentIndex = pageController.page!.toInt();
    });

    int toIndex = Get.arguments ?? 0;
    if(!currentIndex.isEqual(toIndex)) changePageView(toIndex);

    verifyLocation();

  }

  @override
  void onReady() async {
    super.onReady();
     logger.d("NeomHome Controller Ready");
    
    isLoading = false;
  }


  void changePageView(int index) {
    currentIndex = index;

    try {
      if(timelineController.initialized && index == 0) {
        timelineController.getTimeline();
        if(timelineController.scrollController.hasClients) {
          timelineController.scrollController.animateTo(
              0.0, curve: Curves.easeOut,
              duration: Duration(milliseconds: 300));
        }
      }
      pageController.jumpToPage(index);
    } catch (e) {
      logger.d(e.toString());
    }

    update([NeomPageIdConstants.neomHome]);
  }


  Future<void> verifyLocation() async {
    logger.d("");
    isLoading = false;
    neomUserController.neomProfile!.position = await GeoLocatorServiceImpl().updateLocation(
        neomUserController.neomUser!.id, neomUserController.neomProfile!.id, neomUserController.neomProfile!.position);
  }

  @override
  modalBottomSheetMenu(BuildContext context) {
    // TODO: implement modalBottomSheetMenu
    throw UnimplementedError();
  }

}

