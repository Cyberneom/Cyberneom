import 'package:cyberneom/ui/neom-app-router.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cyberneom/ui/pages/drawer/sidebar-menu.dart';
import 'package:cyberneom/ui/pages/home/widgets/neom-bottom-app-bar.dart';
import 'package:cyberneom/ui/pages/home/neom-home-controller.dart';
import 'package:cyberneom/ui/pages/home/widgets/neom-appbar.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeomHomePage extends StatelessWidget {

  Widget build(BuildContext context){
    return GetBuilder<NeomHomeController>(
      id: NeomPageIdConstants.neomHome,
      init: NeomHomeController(),
      builder: (_) => Scaffold(
        appBar: NeomAppBar(NeomConstants.cyberneom_title, _.neomUserController.neomUser!.photoUrl.isNotEmpty
            ? _.neomUserController.neomUser!.photoUrl : NeomConstants.noImageUrl),
        drawer: SidebarMenu(),
        body: _.isLoading ? Container(decoration: NeomAppTheme.neomBoxDecoration ,child: Center(child: CircularProgressIndicator()))
            : PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _.pageController,
          children: NeomAppRoutes.homePages),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.grey[900]),
          child: NeomBottomAppBar(
            backgroundColor: NeomAppColor.bottomNavigationBar,
            color: Colors.white54,
            selectedColor: Theme.of(context).colorScheme.secondary,
            notchedShape: CircularNotchedRectangle(),
            iconSize: 20.0,
            onTabSelected:(int index) => _.changePageView(index),
            items: [
              NeomBottomAppBarItem(iconData: FontAwesomeIcons.home, text: NeomTranslationConstants.home.tr),
              NeomBottomAppBarItem(iconData: Icons.graphic_eq, text: NeomTranslationConstants.chambers),
              NeomBottomAppBarItem(iconData: FontAwesomeIcons.chartBar, text: NeomTranslationConstants.statistics.tr),
              NeomBottomAppBarItem(iconData: FontAwesomeIcons.comments, text: NeomTranslationConstants.inbox.capitalizeFirst!.tr),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: NeomTranslationConstants.neomSession.tr,
          splashColor: Colors.teal,
          onPressed: () => {
            Get.toNamed(NeomRouteConstants.NEOM_GENERATOR)
          },
          child: Icon(FontAwesomeIcons.om),
          elevation: 0,
        ),
      ),
    );
  }
}

