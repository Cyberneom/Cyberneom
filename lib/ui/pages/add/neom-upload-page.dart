import 'package:cyberneom/ui/pages/add/neom-upload-controller.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/enum/neom-from.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NeomUploadPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomUploadController>(
      id: NeomPageIdConstants.neomUpload,
      init: NeomUploadController(),
      builder: (_) {
         return Scaffold(
           backgroundColor: Colors.transparent,
           body: Container(
              decoration: NeomAppTheme.neomBoxDecoration,
              child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Column(children: [
                    SvgPicture.asset(NeomAssets.uploadSVG, width: 150, height: 150, fit: BoxFit.fitWidth,),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        NeomTranslationConstants.tapToUploadImage.tr,
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: ()=> showDialog(
                      context: context,
                      builder: (context){
                        return SimpleDialog(
                          title: Text(NeomTranslationConstants.createPost.tr),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text(
                                  NeomTranslationConstants.takePhoto.tr
                              ),
                              onPressed: () => _.handleImage(NeomFileFrom.Camera),
                            ),
                            SimpleDialogOption(
                              child: Text(
                                  NeomTranslationConstants.photoFromGallery.tr
                              ),
                              onPressed: () => _.handleImage(NeomFileFrom.Gallery),
                            ),
                            SimpleDialogOption(
                              child: Text(
                                  NeomTranslationConstants.videoFromGallery.tr
                              ),
                              onPressed: () => _.handleVideo(NeomFileFrom.Gallery),
                            ),
                            SimpleDialogOption(
                              child: Text(
                                  NeomTranslationConstants.cancel.tr
                              ),
                              onPressed: () => Get.back()
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ],
                ),
              ),
           ),
        );
      }
    );
  }
}
