import 'package:flutter/cupertino.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NeomAppBarSearch extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => NeomAppTheme.appBarHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        maxLines: 1,
        decoration: InputDecoration(
          suffixIcon: Icon(CupertinoIcons.search),
          contentPadding: EdgeInsets.all(12),
          hintText: NeomTranslationConstants.searchPostProfileNeommates.tr,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 0.5),
          ),
        ),
      ),
      backgroundColor: NeomAppColor.bottomNavigationBar,
      elevation: 0.0,
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
