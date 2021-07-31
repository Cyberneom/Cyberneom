import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/onboarding/onboarding-controller.dart';
import 'package:cyberneom/ui/pages/onboarding/widgets/onboarding-widgets.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/ui/pages/auth/widgets/signup-widgets.dart';
import 'package:cyberneom/utils/enum/neom-from.dart';


class OnBoardingAddImagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingController>(
      id: NeomPageIdConstants.onBoardingAddImage,
      init: OnBoardingController(),
      builder: (_) => Scaffold(
        body: Container(
          decoration: NeomAppTheme.neomBoxDecoration,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            (_.neomUploadController.imageFile.path.isEmpty &&
                            _.neomUserController.neomUser!.photoUrl.isEmpty) ?
                            Icon(Icons.account_circle, size: 150.0, color: Colors.grey) :
                            Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                image: _.neomUploadController.imageFile.path.isEmpty ?
                                DecorationImage(
                                  image: CachedNetworkImageProvider(_.neomUserController.neomUser!.photoUrl),
                                  fit: BoxFit.cover,
                                ) : DecorationImage(
                                  image: FileImage(File(_.neomUploadController.imageFile.path)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: (_.neomUploadController.imageFile.path.isEmpty) ? FloatingActionButton(
                                child: Icon(Icons.camera_alt),
                                onPressed:  ()=> showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Text(NeomTranslationConstants.addProfileImg.tr),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            child: Text(NeomTranslationConstants.takePhoto.tr),
                                            onPressed: () => _.handleImage(NeomFileFrom.Camera),
                                          ),
                                          SimpleDialogOption(
                                            child: Text(NeomTranslationConstants.photoFromGallery.tr),
                                            onPressed: () => _.handleImage(NeomFileFrom.Gallery),
                                          ),
                                          SimpleDialogOption(
                                              child: Text(NeomTranslationConstants.cancel.tr),
                                              onPressed: () => Get.back()
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                ) :
                                FloatingActionButton(
                                  child: Icon(Icons.close),
                                  onPressed:  ()=> _.neomUploadController.clearImage()
                                  ),
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(20.0),
                      ),
                      buildLabel(context, "${NeomTranslationConstants.welcome.tr} ${_.neomUserController.neomUser!.name.split(" ").first}",
                          _.neomUserController.neomUser!.photoUrl.isEmpty
                              ? NeomTranslationConstants.addProfileImgMsg.tr
                              : NeomTranslationConstants.addLastProfileInfoMsg.tr
                      ),
                      SizedBox(height: 20),
                      _.neomUserController.neomUser!.name.isEmpty ?
                      buildEntryField(NeomTranslationConstants.username.tr, controller: _.controllerAboutMe) : Container(),
                      buildContainerTextField("${NeomTranslationConstants.tellAboutYou.tr} (${NeomTranslationConstants.optional.tr})",
                          controller: _.controllerAboutMe),
                      SizedBox(height: 20),
                      buildEntryDateField(_.dateOfBirth,
                        context: context, dateFunction: _.setDateOfBirth),
                      SizedBox(height: 20),
                      (_.neomUploadController.imageFile.path.isEmpty
                        && _.neomUserController.neomUser!.photoUrl.isEmpty)
                        ? Container() :
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: TextButton(
                          onPressed: () => _.finishAccount(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            backgroundColor: NeomAppColor.bondiBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),),
                          child: Text(NeomTranslationConstants.finishAccount.tr,
                            style: TextStyle(
                              color: Colors.white,fontSize: 18.0,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(left: NeomAppTheme.appPadding, right: NeomAppTheme.appPadding),
                ),
                // Loading
                Positioned(
                  child: _.isLoading ?
                  Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(NeomAppColor.dodgetBlue)),
                    ),
                    color: Colors.black.withOpacity(0.8),
                  ) : Container(),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
