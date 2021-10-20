
import 'package:cyberneom/ui/pages/onboarding/widgets/slider-model.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-controller.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RequiredPermissionsPage extends StatefulWidget {
  @override
  _RequiredPermissionsPageState createState() => _RequiredPermissionsPageState();
}

class _RequiredPermissionsPageState extends State<RequiredPermissionsPage> {

  List<SliderModel> slides = [];
  int currentState = 0;
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    slides= SliderModel.getRequiredPermissionsSlides();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView.builder(
        itemBuilder: (context,index){
          return SlideTiles(
            slides[index].imagePath,
            slides[index].msg1,
            slides[index].title,
            index,
            msg2: slides[index].msg2,
          );
        },
        controller: pageController,
        itemCount: slides.length,
        scrollDirection: Axis.horizontal,
        onPageChanged: (val){
          currentState=val;
        },
      ),
    );
  }
}

class SlideTiles extends StatelessWidget {

  final String imagePath,msg1,title, msg2;
  final int current;

  SlideTiles(this.imagePath, this.msg1, this.title,this.current, {this.msg2 = ""});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: NeomAppTheme.neomBoxDecoration,
        height: NeomAppTheme.fullHeight(context),
        width: NeomAppTheme.fullWidth(context),
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Image.asset(imagePath, fit: BoxFit.fill),
          NeomAppTheme.heightSpace10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i=0; i<SliderModel.getRequiredPermissionsSlides().length; i++)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  width: current==i ? 20:8,
                  height: 6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: current ==  i ? NeomAppColor.mystic : Colors.grey[400]
                  ),
                ),
            ],
          ),
          NeomAppTheme.heightSpace10,
          Text(title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
          NeomAppTheme.heightSpace10,
          Text(msg1,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
          NeomAppTheme.heightSpace20,
          msg2.isNotEmpty ? Text(msg2,style: TextStyle(fontSize: 16),textAlign: TextAlign.center) : Container(),
          NeomAppTheme.heightSpace20,
          GestureDetector(
            onTap: () async {
              try {
                Get.find<NeomProfileController>().updateLocation();
              } catch (e) {
                Get.put(NeomProfileController()).updateLocation();
              }

              Get.toNamed(NeomRouteConstants.INTRO_LOCALE);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 100),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: Colors.grey,
                    offset: Offset(0,2)
                  )
                ]
              ),
              child: Text(NeomTranslationConstants.allow.tr.toUpperCase(),
                style: TextStyle(
                  color: NeomAppColor.textButton,
                  fontWeight: FontWeight.bold,
                  fontFamily: NeomAppTheme.fontFamily
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          NeomAppTheme.heightSpace20,
          GestureDetector(
            onTap: () async {
              Get.toNamed(NeomRouteConstants.LOGOUT,
                  arguments: [NeomRouteConstants.LOGOUT, NeomRouteConstants.LOGIN]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 100),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        color: Colors.grey,
                        offset: Offset(0,2)
                    )
                  ]
              ),
              child: Text(NeomTranslationConstants.deny.tr.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: NeomAppTheme.fontFamily
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),),
    );
  }
}
