import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cyberneom/domain/model/neom-comment.dart';
import 'package:cyberneom/ui/pages/timeline/widgets/timeline-widgets.dart';
import 'package:cyberneom/ui/widgets/neom-custom-media.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget othersComment(BuildContext context, NeomComment neomComment) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          child: ClipOval(child: Image.network(neomComment.neomProfileImgUrl)),
          radius: 20),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              style: BorderStyle.solid, color: Colors.grey, width: 0.5)),
            child: Card(
              color: Theme.of(context).cardColor.withOpacity(0.8),
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  usernameSectionWithoutAvatar(context, neomComment),
                  space15(),
                  neomComment.mediaUrl.isEmpty ? Container() :
                  Column(children: [
                    Container(
                      height: 250,width: 250,
                      child: cachedNetworkImage(neomComment.mediaUrl)),
                    space15(),
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      neomComment.text.isEmpty ? Container() :
                      Text(neomComment.text, softWrap: true,
                          maxLines: 3, style: TextStyle(fontSize: 14)),
                      Icon(
                        FontAwesomeIcons.heart,
                        size: 14, color: Colors.teal,
                      )
                    ],
                  ),
                  space15(),
                  Divider(thickness: 1),
                  menuReply(neomComment),
                  space15(),
                ],
              ),
            ),
          ),
        )
            //commentReply(context, FeedBloc().feedList[2]),
            )
      ],
    ),
  );
}

Widget othersCommentWithImageSlider(BuildContext context, NeomComment neomComment) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
            backgroundColor: Colors.grey,
            child: ClipOval(
                child: Image.network(neomComment.neomProfileImgUrl)
            ),
            radius: 20),
        SizedBox(width: 20),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  style: BorderStyle.solid, color: Colors.grey, width: 0.5)),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  usernameSectionWithoutAvatar(context, neomComment),
                  space15(),
                  Text(neomComment.text,
                      softWrap: true,
                      maxLines: 3,
                      style: TextStyle(fontSize: 14)),
                  space15(),
                  imageCarouselSlider(),
                  Divider(thickness: 1),
                  SizedBox(height: 10),
                  menuReply(neomComment),
                  space15(),
                ],
              ),
            ),
          ),
        )
            //commentReply(context, FeedBloc().feedList[2]),
            )
      ],
    ),
  );
}

Widget imageCarouselSlider() {
  var imageSliderDemo = [
    'https://images.pexels.com/photos/618612/pexels-photo-618612.jpeg',
    'https://images.pexels.com/photos/618612/pexels-photo-618612.jpeg',
    'https://2rdnmg1qbg403gumla1v9i2h-wpengine.netdna-ssl.com/wp-content/uploads/sites/3/2019/05/kidsRaceAge-891544116-770x553-650x428.jpg',
    'https://media.gettyimages.com/photos/working-out-by-the-ocean-picture-id621494554?s=612x612'
  ];
  return CarouselSlider(
    options: CarouselOptions(
      height: 150.0,
      enableInfiniteScroll: true,
      autoPlay: true,
      scrollDirection: Axis.horizontal,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn
    ),
    items: imageSliderDemo.map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Image.network(
                i,
                fit: BoxFit.cover,
              ));
        },
      );
    }).toList(),
  );
}

Widget menuReply(NeomComment neomComment) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => debugPrint('${neomComment.likedProfiles} tapped'),
                child: Text('${neomComment.likedProfiles.length} ${NeomTranslationConstants.likes.tr}',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () => print(""),
                child: Text('${neomComment.neomReplies.length} ${NeomTranslationConstants.replies.tr}',
                style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text(NeomTranslationConstants.toReply.tr,
            style: TextStyle(
              color: Colors.teal,
              fontSize: 12,
              fontWeight: FontWeight.bold)
          ),
        ],
      ),
    ],
  );
}

Widget usernameSectionWithoutAvatar(BuildContext context, NeomComment neomComment) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(neomComment.neomProfileName,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(neomComment.createdTime), locale: 'en_short'),
                            style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                      ],
                    ),
                  ],
                )
              ],
            ),
            moreOptions3Dots(context),
          ],
        ),
      )
    ],
  );
}

Widget commentReply(BuildContext context, NeomComment neomComment) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                style: BorderStyle.solid,
                  color: Colors.grey, width: 0.5
              ),
            ),
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    neomComment.mediaUrl.isEmpty ? Container() :
                    cachedNetworkImage(neomComment.mediaUrl),
                    neomComment.text.isEmpty ? Container() :
                    Text(neomComment.text,
                        softWrap: true,
                        maxLines: 3,
                        style: TextStyle(fontSize: 14)),
                    space15(),
                    Divider(thickness: 1),
                    menuCommentReply(neomComment),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        CircleAvatar(
            backgroundColor: Colors.grey,
            child: ClipOval(
                child: Image.network(neomComment.neomProfileImgUrl)
            ),
            radius: 20),
      ],
    ),
  );
}

Widget menuCommentReply(NeomComment neomComment) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
          onTap: () => debugPrint('${neomComment.likedProfiles} tapped'),
          child: Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.heart,
                size: 16,
                color: Colors.teal,
              ),
              SizedBox(width: 5),
              Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(neomComment.createdTime), locale: 'en_short'),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              Divider(thickness: 1),
              Text(
                '${neomComment.likedProfiles}',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
      ),
    ],
  );
}
