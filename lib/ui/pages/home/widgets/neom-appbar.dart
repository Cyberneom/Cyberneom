import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NeomAppBar extends StatelessWidget implements PreferredSizeWidget{

  final String title;
  final String profileImg;

  NeomAppBar(this.title, this.profileImg);


  @override
  Size get preferredSize => NeomAppTheme.appBarHeight;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        child: Container(
          height: 30,
          width: 30,
          margin: EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 12),
          decoration: BoxDecoration(
            border: Border.all(color: NeomAppColor.appBar, width: 2),
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: CachedNetworkImageProvider(profileImg.isNotEmpty ? profileImg : NeomConstants.dummyProfilePic),
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: ()=> Scaffold.of(context).openDrawer(),
      ),
      title: GestureDetector(child: Image.asset(
        NeomAssets.logo_letters,
        height: 60,
        width: 120,
        ), onTap: () => {
            NeomUtilities.showAlert(context, NeomConstants.cyberneom_title, "Beta Version ${NeomConstants.neomVersion}"),
          }
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
              icon: Icon(Icons.notifications),
              color: Colors.white70,
              onPressed: ()=>{
                //TODO CHANGE TO NOTIFICATIONS
                //Get.toNamed(NeomRouteConstants.FEED_ACTIVITY)
              }
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white70,
              onPressed: ()=>{
                Get.toNamed(NeomRouteConstants.SEARCH)
              }
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
              icon: Icon(Icons.add_box_outlined),
              color: Colors.white70,
              onPressed: ()=>{ showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text(NeomTranslationConstants.add.tr),
                        children: <Widget>[
                          SimpleDialogOption(
                              child: Text(
                                  NeomTranslationConstants.multimediaUpload.tr),
                              onPressed: () => Get.offAndToNamed(NeomRouteConstants.NEOM_UPLOAD)
                          ),
                          SimpleDialogOption(
                              child: Text(NeomTranslationConstants.createEvent.tr),
                              onPressed: () =>
                              //TODO
                              NeomUtilities.showAlert(context, NeomTranslationConstants.aboutCyberneom.tr, NeomTranslationConstants.underConstruction.tr)
                          ),
                          SimpleDialogOption(
                              child: Text(NeomTranslationConstants.cancel.tr),
                              onPressed: () => Get.back()
                          ),
                        ],
                      );
                    }
                )
              }
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return NeomConstants.choices.map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice.capitalizeFirst!),
                  );
                }).toList();
              },
            )
        ),
        Divider()
      ],
    );
  }

  void choiceAction(String choice){
    if(choice == NeomConstants.more){
      print('more');
    } else if(choice == NeomConstants.about){
      print('about');
    }else if(choice == NeomConstants.logout){
      final loginController = Get.find<LoginController>();
      loginController.signOut();
    }
  }

}
