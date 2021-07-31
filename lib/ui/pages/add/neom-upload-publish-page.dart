import 'dart:io';
import 'package:cyberneom/ui/pages/add/neom-upload-controller.dart';
import 'package:cyberneom/ui/pages/static/splash-page.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/enum/neom-post-type.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class NeomUploadPublishPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomUploadController>(
      id: NeomPageIdConstants.neomUpload,
      init: NeomUploadController(),
      builder: (_) =>
          Scaffold(
            appBar: AppBar(
              backgroundColor: NeomAppColor.bottomNavigationBar,
              title: Center(child: Text("")),
              actions: <Widget>[
                _.isUploading ? Text("") : TextButton(
                  child: Text(NeomTranslationConstants.post.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),
                  ),
                  onPressed: ()=> {
                    if(!_.isButtonDisabled) _.handleSubmit(),
                    _.isButtonDisabled = true,
                    _.isUploading = true,
                  },
                ),
              ],
            ),
            body: _.isLoading ? Center(child: CircularProgressIndicator())
          : _.isUploading ? SplashPage() : Container(decoration: NeomAppTheme.neomBoxDecoration,
              child: ListView(
              children: <Widget>[
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width*.8,
                  child: Center(
                    child: AspectRatio(aspectRatio: NeomAppTheme.aspectRatio,
                      child: _.neomPostType == NeomPostType.Image ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(_.imageFile.path))
                              ),
                        ),
                      ) : Stack(
                          children: [
                            VideoPlayer(_.videoPlayerController),
                            Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0x36FFFFFF).withOpacity(0.1),
                                            Color(0x0FFFFFFF).withOpacity(0.1)
                                          ],
                                          begin: FractionalOffset.topLeft,
                                          end: FractionalOffset.bottomRight
                                      ),
                                      borderRadius: BorderRadius.circular(50)
                                  ),

                                  child: IconButton(
                                  icon: Icon(_.videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,),
                                  iconSize: 30,
                                  color: Colors.white70.withOpacity(0.5),
                                  onPressed: () => _.playPauseVideo(),
                                ),),
                            ),
                          ],),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(_.neomUserController.neomProfile!.photoUrl),
                  ),
                  title: Container(
                    width: 250.0,
                    child: TextField(
                      controller: _.captionController,
                      decoration: InputDecoration(
                        hintText: NeomTranslationConstants.writeCaption.tr,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.pin_drop,size: 30.0,),
                  title: Container(
                    width: 250.0,
                    child: TextField(
                      controller: _.locationController,
                      decoration: InputDecoration(
                        hintText: NeomTranslationConstants.wherePhotoTaken.tr,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left:12.0),
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: Text(NeomTranslationConstants.userCurrentLocation.tr),
                    icon: Icon(Icons.my_location,),
                    style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    primary: Theme.of(context).backgroundColor,),
                    onPressed: _.getUserLocation,
                  ),
                )
              ],
              ),
            ),
          ),
        );
    }
}
