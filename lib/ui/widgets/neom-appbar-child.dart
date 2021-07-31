import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class NeomAppBarChild extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  NeomAppBarChild(this.title);

  @override
  Size get preferredSize => NeomAppTheme.appBarHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextButton(
          child: Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18,),),
          onPressed:() => {
            NeomUtilities.showAlert(context, NeomConstants.cyberneom_title, NeomConstants.current_version),
          }
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  void choiceAction(String choice){
    if(choice == NeomConstants.more){
      print('More');
    } else if(choice == NeomConstants.about){
      print('About');
    }else if(choice == NeomConstants.logout){
      final loginController = Get.find<LoginController>();
      loginController.signOut();
    }
  }
}
