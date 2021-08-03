import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-details/widgets/diagonally_cut_colored_image.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeomProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return GetBuilder<NeomProfileController>(
      id: NeomPageIdConstants.neomProfile,
      init: NeomProfileController(),
      builder: (_) => Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: NeomAppTheme.neomBoxDecoration,
          child: _.isLoading ? Center(child: CircularProgressIndicator())
         : SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[ Stack(
              children: <Widget>[
                GestureDetector(child: DiagonallyCutColoredImage(
                  Image(
                    image: CachedNetworkImageProvider(_.neomProfile.coverImgUrl.isNotEmpty ? _.neomProfile.coverImgUrl
                        :_.neomProfile.photoUrl.isNotEmpty ? _.neomProfile.photoUrl :  NeomConstants.noImageUrl),
                    width: MediaQuery.of(context).size.width,
                    height: 250.0,
                    fit: BoxFit.cover,
                  ),
                  color: NeomAppColor.darkViolet.withOpacity(0.8),
                  ),
                  onLongPress: () {
                    NeomUtilities.showAlert(context, NeomConstants.cyberneom_title, NeomTranslationConstants.onTapCoverChange.tr);
                  }),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  heightFactor: 1.08,
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: _.neomProfile.name,
                        child: GestureDetector(child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(_.neomProfile.photoUrl,),
                          radius: 50.0,
                          ),
                          onTap: () => Get.toNamed(NeomRouteConstants.PROFILE_DETAILS),
                        ),
                      ),
                      _buildFollowerInfo(context, _.neomProfile, Theme.of(context).textTheme),
                      Container(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _.neomProfile.name,
                              style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                            ),
                            Row(
                              children: <Widget>[
                                Text(_.location.isNotEmpty ? _.location : NeomTranslationConstants.notSpecified,
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.place,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  onPressed: ()=> _.updateLocation(),
                                ),
                              ],
                            ),
                            Text(_.neomProfile.aboutMe.isEmpty ? NeomTranslationConstants.noProfileDesc.tr : _.neomProfile.aboutMe,
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white70, fontSize: 16.0),
                            ),
                            ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: DefaultTabController(
                          length: NeomConstants.neomProfileTabs.length,
                          child: Obx(() => Column(
                            children: <Widget>[
                              TabBar(
                                tabs: [Tab(text: '${NeomConstants.neomProfileTabs.elementAt(0).capitalizeFirst!.tr} (${_.neomProfile.neomPosts.length})'),
                                      Tab(text: '${NeomConstants.neomProfileTabs.elementAt(1).capitalizeFirst!.tr} '
                                          '(${NeomUtilities.getTotalNeomChamberPresets(_.neomProfile.neomChambers!).length.toString()})'),
                                      Tab(text: '${NeomConstants.neomProfileTabs.elementAt(2).capitalizeFirst!.tr} (${_.neomProfile.neomChambers!.length})'),],
                                indicatorColor: Colors.white,
                                labelStyle: TextStyle(fontSize: 15),
                                unselectedLabelStyle: TextStyle(fontSize: 12),
                                labelPadding: EdgeInsets.symmetric(horizontal: 0.0),
                              ),
                              SizedBox.fromSize(
                                size: Size.fromHeight(200.0),
                                child: TabBarView(
                                  children: NeomConstants.neomProfileTabPages
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 26.0,
                  left: 4.0,
                  child: BackButton(color: Colors.white),
                ),
              ],
            ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFollowerInfo(context, NeomProfile neommate, TextTheme textTheme) {
  var followerStyle = textTheme.subtitle1!.copyWith(color: const Color(0xBBFFFFFF));
  return Padding(
    padding: EdgeInsets.only(top: 16.0),
    child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Text('${neommate.neommates.length.toString()} ${NeomTranslationConstants.neommates.capitalizeFirst}', style: followerStyle),
            onTap: () => NeomUtilities.showAlert(context, "Neommates", NeomTranslationConstants.neommatesMsg.tr),
          ),
        ],
      ),
    ],
    ),
  );
}