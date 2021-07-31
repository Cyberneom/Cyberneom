import 'package:cyberneom/ui/pages/static/splash-controller.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (_) => Scaffold(
      body: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        child: Center(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                NeomAssets.logo,
                height: 200,
                width: 200,
              ),
              CircularProgressIndicator(),
              SizedBox(height: 30,),
              Text(_.subtitle.tr,
                style: TextStyle(
                  color: Colors.white.withOpacity(1.0),
                  fontFamily: NeomAppTheme.fontFamily,
                  fontSize: 15.0,

                ),
              ),
            ]
          ),
        ),
        ),
      ),
    );
  }

}
