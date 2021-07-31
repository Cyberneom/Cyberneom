import 'package:cyberneom/ui/pages/neommates/neommate-controller.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-details/widgets/diagonally_cut_colored_image.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeommateDetailHeader extends StatelessWidget {

  final Color backgroundColor = Colors.transparent;
  final Color textColor = Colors.white70;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var followerStyle = textTheme.subtitle1!.copyWith(color: Color(0xBBFFFFFF));

    return GetBuilder<NeommateController>(
      init: NeommateController(),
      builder: (_) => Stack(
      children: <Widget>[
        DiagonallyCutColoredImage(
          Image(image: NetworkImage(_.neommate.coverImgUrl.isEmpty ? _.neommate.photoUrl : _.neommate.coverImgUrl),
            width: MediaQuery.of(context).size.width,
            height: 250.0,
            fit: BoxFit.cover,
          ),
          color: NeomAppColor.darkViolet.withOpacity(0.8),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.25,
          child: Column(
            children: <Widget>[
              Hero(
                tag: _.neommate.name,
                child:  CircleAvatar(
                  backgroundImage: NetworkImage(_.neommate.photoUrl),
                  radius: 50.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${_.neommate.following.length.toString()} ${NeomTranslationConstants.following.tr}', style: followerStyle),
                      Text(' | ', style: followerStyle.copyWith(fontSize: 24.0, fontWeight: FontWeight.normal),),
                      Text('${_.neommate.followers.length.toString()} ${NeomTranslationConstants.followers.tr}', style: followerStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${_.neommate.neommates.length.toString()} ${NeomTranslationConstants.neommates}', style: followerStyle),
                    ],
                  ),
                ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: NeomAppTheme.neomBoxDecoration,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          minWidth: 140.0,
                          color: backgroundColor,
                          textColor: textColor,
                          child: _.following ? Text(NeomTranslationConstants.unfollow.tr):Text(NeomTranslationConstants.follow.tr),
                          onPressed: () {
                            _.following ? _.unfollow() : _.follow();
                          },
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: NeomAppTheme.neomBoxDecoration,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          minWidth: 140.0,
                          color: backgroundColor,
                          textColor: textColor,
                          child: Text(NeomTranslationConstants.message.tr),
                          onPressed: () {
                            _.sendMessage();
                          },
                        ),
                      ),
                    ),
                  ],
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
    ),);
  }
}
