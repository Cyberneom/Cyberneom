import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-user.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:logger/logger.dart';

class SideBarMenuController extends GetxController {

  var logger = Logger();
  final neomUserController = Get.find<NeomUserController>();

  final PageController pageController = PageController();

  NeomUser _neomUser = NeomUser();
  NeomUser get neomUser => _neomUser;

  NeomProfile _neomProfile = NeomProfile();
  NeomProfile get neomProfile => _neomProfile;

  @override
  void onInit() async {
    super.onInit();
    logger.i("SideBar Controller Init");
    _neomUser = neomUserController.neomUser!;
    _neomProfile = neomUserController.neomProfile!;
  }

}
