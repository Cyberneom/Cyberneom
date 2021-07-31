import 'package:cyberneom/ui/pages/profile/neom-profile-controller.dart';
import 'package:cyberneom/ui/pages/profile/tabs/post_tile.dart';
import 'package:cyberneom/utils/constants/neom-assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';

class NeomProfilePosts extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomProfileController>(
      id: "neomProfilePosts",
      init: NeomProfileController(),
      builder: (_) {
        if (_.isLoading) {
          return CircularProgressIndicator();
        } else if (_.neomProfilePosts.isEmpty) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10.0),
                  child: Text(
                    NeomTranslationConstants.noPostsYet.tr,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  NeomAssets.noContent, height: 150.0,),
              ],
            ),
          );
        } else if (_.postOrientation == 'grid') {
          List<GridTile> gridTiles = [];
          _.neomProfilePosts.forEach((post) {
            gridTiles.add(GridTile(child: PostTile(post),),);
          });
          return GridView.count(
            children: gridTiles,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,);
        } else {
          return Column();
        }
      }
    );
  }
}
