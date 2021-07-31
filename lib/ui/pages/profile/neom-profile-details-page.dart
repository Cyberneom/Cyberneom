import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-controller.dart';
import 'package:cyberneom/ui/widgets/neom-appbar-child.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NeomProfileEditPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomProfileController>(
      init: NeomProfileController(),
      builder: (_) => Scaffold(
        appBar: NeomAppBarChild(NeomTranslationConstants.profileDetails.tr),
        body: Container(
          decoration: NeomAppTheme.neomBoxDecoration,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(_.neomProfile.photoUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                      onTap: ()=>NeomUtilities.showAlert(context, NeomConstants.cyberneom_title, NeomTranslationConstants.onTapPhotoChange.tr),
                                    ),
                                  ],
                                ),
                              ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        NeomTranslationConstants.profileInformation.tr,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Obx(()=>Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _.editStatus ? Container() :
                                      GestureDetector(
                                        child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                          radius: 14.0,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                          onTap: () {
                                            NeomUtilities.showAlert(context, NeomConstants.cyberneom_title, NeomTranslationConstants.onTapProfileEdit.tr);
                                            //_.changeEditStatus();
                                          }
                                        ),
                                      ],
                                  ),),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        NeomTranslationConstants.username.tr,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Obx(()=>Flexible(
                                    child: TextField(
                                      decoration:  InputDecoration(
                                        labelText: _.neomUserController.neomUser!.name,
                                      ),
                                      enabled: _.editStatus,
                                      autofocus: _.editStatus,
                                    ),
                                  ),),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: _.neomUserController.neomUser!.email,
                                        enabled: _.editStatus,
                                    ),
                                  ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Location',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: _.location,
                                        enabled: _.editStatus,
                                    ),
                                  ),
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Neom Reason',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Profile Type',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: EnumToString.convertToString(_.neomProfile.neomReason),
                                          enabled: _.editStatus,
                                      ),
                                    ),
                                  ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Text(EnumToString.convertToString(_.neomProfile.type)),
                                    flex: 2,
                                  ),
                                ],
                              ),
                          ),
                          Obx(()=> !_.editStatus ? Container() :
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Container(
                                        child: ElevatedButton(
                                          child: Text("Save"),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              textStyle: TextStyle(color: Colors.white),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0)),
                                          ),
                                          onPressed: () {
                                            _.editNeomProfile();
                                          },
                                        )
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Container(
                                        child: ElevatedButton(
                                          child: Text("Cancel"),
                                          style: ElevatedButton.styleFrom(primary: Colors.red,
                                            textStyle: TextStyle(color: Colors.white),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0)),
                                          ),
                                          onPressed: () {
                                            _.changeEditStatus();
                                          },
                                        ),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
