import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-user.dart';
import 'package:cyberneom/ui/pages/drawer/sidebar-menu-controller.dart';
import 'package:cyberneom/ui/pages/drawer/settings/widgets/customUrlText.dart';
import 'package:cyberneom/ui/widgets/neom-custom-widgets.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/neom-utilities.dart';

class SidebarMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SideBarMenuController>(
    id: "sidebarMenu",
    init: SideBarMenuController(),
    builder: (_) {
      return Drawer(
        child: Container(
          color: NeomAppColor.bottomNavigationBar,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 45),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      _menuHeader(context, _.neomUser, _.neomProfile),
                      Divider(),
                      _menuListRowButton(NeomConstants.profile,  Icon(Icons.person), true, context),
                      _menuListRowButton(NeomConstants.notifications, Icon(Icons.notifications), false, context),
                      _menuListRowButton(NeomConstants.rootFrequencies, Icon(Icons.multitrack_audio_sharp), true, context),
                      _menuListRowButton(NeomConstants.tribes, Icon(Icons.people), false, context),
                      _menuListRowButton(NeomConstants.myClusters, Icon(FontAwesomeIcons.networkWired), false, context),
                      Divider(),
                      _menuListRowButton(NeomConstants.settings, Icon(Icons.settings), true, context),
                      _menuListRowButton(NeomConstants.helpCenter, Icon(Icons.help_center), false, context),
                      Divider(),
                      _menuListRowButton(NeomConstants.logout, Icon(Icons.logout), true, context),
                    ],
                  ),
                ),
              //TODO Verify if needed
              _footer()
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _menuHeader(context, NeomUser neomUser, NeomProfile neomProfile) {
    if (neomUser.id.isEmpty) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(0),
          onTap: () => Get.offAllNamed(NeomRouteConstants.LOGIN),
          splashColor: Theme.of(context).primaryColorLight,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 200, minHeight: 100),
            child: Center(
              child: Text(
                NeomTranslationConstants.loginToContinue.tr,
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
              height: 56,
              width: 56,
              margin: EdgeInsets.only(left: 20, top: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(neomProfile.photoUrl.isNotEmpty ? neomProfile.photoUrl : NeomConstants.dummyProfilePic),
                  fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: ()=> Get.toNamed(NeomRouteConstants.PROFILE),
            ),
            ListTile(
              onTap: () {
                Get.toNamed(NeomRouteConstants.PROFILE);
              },
              title: Row(
                children: <Widget>[
                  UrlText(
                    text: neomProfile.name,
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600).copyWith(
                        color: Colors.white, fontSize: 20),
                  ),
                  neomUser.isVerified ? Icon(Icons.verified) : Icon(Icons.verified_outlined, color: Colors.white70)
                ],
              ),
              subtitle: customText(NeomUtilities().getRootFrequency(neomProfile.rootFrequencies ?? <String,NeomFrequency>{}).tr,
                  style: TextStyle(color: Colors.white).copyWith(
                    color: Colors.white70, fontSize: 15),
                  context: context),
              trailing: IconButton(
                icon: Icon(Icons.arrow_left_outlined),
                onPressed: ()=> Get.back(),)
            ),
          ],
        ),
      );
    }
  }

  ListTile _menuListRowButton(String title, Icon icon, bool isEnabled, BuildContext context) {
    return ListTile(
      onTap: () {
        switch(title) {
          case NeomConstants.profile:
            if (isEnabled) Get.toNamed(NeomRouteConstants.PROFILE);
            break;
          case NeomConstants.rootFrequencies:
            if (isEnabled) Get.toNamed(NeomRouteConstants.FREQUENCY_FAV);
            break;
          case NeomConstants.notifications:
            if (isEnabled) Get.toNamed(NeomRouteConstants.FEED_ACTIVITY);
            break;
          case NeomConstants.tribes:
            if (isEnabled) Get.toNamed(NeomRouteConstants.TRIBES);
            break;
          case NeomConstants.settings:
            if (isEnabled) Get.toNamed(NeomRouteConstants.SETTINGS_PRIVACY);
            break;
          case NeomConstants.logout:
            if (isEnabled) Get.toNamed(NeomRouteConstants.LOGOUT, arguments: [NeomRouteConstants.LOGOUT, NeomRouteConstants.LOGIN]);
            break;
        }
      },
      leading: Padding(
              padding: EdgeInsets.only(top: 5),
              child: icon
            ),
      title: customText(
        title.tr,
        style: TextStyle(
          fontSize: 20,
          color: isEnabled ? NeomAppColor.lightGrey : NeomAppColor.secondary,
        ), context: context,
      ),
    );
  }

  Positioned _footer() {
    return Positioned(
      bottom: 10,
      right: 0,
      left: 0,
      child: Image.asset(NeomAssets.logo,
        height: 50,
      ),
    );
  }
}
