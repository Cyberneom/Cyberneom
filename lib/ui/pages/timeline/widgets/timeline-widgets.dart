import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cyberneom/domain/model/neom-comment.dart';
import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cyberneom/ui/pages/timeline/post-comments-page/post-comments-controller.dart';
import 'package:cyberneom/ui/pages/timeline/post-comments-page/post-comments-page.dart';

import 'package:cyberneom/ui/pages/timeline/post-comments-page/post-comments-widgets.dart';
import 'package:cyberneom/ui/pages/timeline/timeline-controller.dart';
import 'package:cyberneom/ui/widgets/neom-custom-media.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';
import 'package:cyberneom/utils/enum/neom-from.dart';
import 'package:cyberneom/utils/enum/neom-media-type.dart';
import 'package:cyberneom/utils/enum/neom-post-type.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget feedCardItem(BuildContext context, TimelineController _, NeomPost neomPost) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(style: BorderStyle.solid, color: Colors.grey, width: 0.5)
    ),
    child: Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            userAvatarSection(context, neomPost),
            space15(),
            Visibility(
                visible: neomPost.neomProfileName.isEmpty == true ? false : true,
                child: Text(neomPost.neomProfileName,
                    softWrap: true,
                    maxLines: 2,
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            space15(),
            Visibility(
                visible: neomPost.caption.isEmpty == true ? false : true,
                child: Text(neomPost.caption,
                    style: TextStyle(fontSize: 14, color: Colors.grey))),
            space15(),
            Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(neomPost.createdTime)),
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            Divider(thickness: 1),
            SizedBox(height: 10),
            likeCommentShare(_, neomPost),
            space15(),
          ],
        ),
      ),
    ),
  );
}

Widget shortFeedCardItem(BuildContext context, PostCommentsController _) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(style: BorderStyle.solid, color: Colors.grey, width: 0.5),
    ),
    child: Card(
      elevation: 0,
      color: Theme.of(context).cardColor.withOpacity(1),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            userAvatarSection(context, _.neomPost),
            space15(),
            Visibility(
                visible: _.neomPost.caption.isEmpty == true ? false : true,
                child: Align(alignment: Alignment.centerLeft, child: Text(_.neomPost.caption,
                    style: TextStyle(fontSize: 14, color: Colors.grey)))) ,
            space15(),
          ],
        ),
      ),
    ),
  );
}

Widget feedCardItemQuestion(BuildContext context, TimelineController _, NeomPost neomPost) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(style: BorderStyle.solid, color: Colors.grey, width: 0.5)
    ),
    child: Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            renderCategoryTime(neomPost),
            space10(),
            userAvatarSection(context, neomPost),
            space15(),
            Visibility(
                visible: neomPost.neomProfileName.isEmpty == true ? false : true,
                child: Text(neomPost.neomProfileName,
                    softWrap: true,
                    maxLines: 2,
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            space15(),
            Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(neomPost.createdTime)),
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            space15(),
            Divider(thickness: 1),
            SizedBox(height: 10),
            likeCommentShare(_, neomPost),
            space15(),
          ],
        ),
      ),
    ),
  );
}

Widget feedCardWithImageItem(BuildContext context, TimelineController _, NeomPost neomPost) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      border: Border.all(style: BorderStyle.solid, color: Colors.grey, width: 0.5)
    ),
    child: Card(
      color: Theme.of(context).cardColor.withOpacity(0.5),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            userAvatarSection(context, neomPost),
            space15(),
            neomPost.caption.isNotEmpty ? Text(neomPost.caption,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(fontSize: 16)
            ) : Container(),
            space15(),
            cachedNetworkImage(neomPost.mediaUrl.isNotEmpty
                ? neomPost.mediaUrl : NeomConstants.noImageUrl),
            space15(),
            Divider(thickness: 1),
            SizedBox(height: 10),
            likeCommentShare(_, neomPost),
            space15(),
          ],
        ),
      ),
    ),
  );
}

Widget btnDecoration(String btnText) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.teal,
      ),
      child: Text(
        btnText,
        style: TextStyle(fontSize: 12, color: Colors.grey[100]),
      ));
}

Widget pollingCard(BuildContext context, TimelineController _, NeomPost neomPost) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(style: BorderStyle.solid, color: Colors.grey, width: 0.5)
    ),
    child: Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            renderCategoryTime(neomPost),
            space10(),
            userAvatarSection(context, neomPost),
            space15(),
            Visibility(
              visible: neomPost.neomProfileName.isEmpty == true ? false : true,
              child: Text(neomPost.neomProfileName,
                softWrap: true,
                maxLines: 2,
                style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              )
            ),
            space15(),
            pollCartSection(),
            space15(),
            Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(neomPost.createdTime)),
                style: TextStyle(fontSize: 10, color: Colors.grey[700])),
            Divider(thickness: 1),
            SizedBox(height: 10),
            likeCommentShare(_, neomPost),
            space15(),
          ],
        ),
      ),
    ),
  );
}

Widget pollCartSection() {
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          pollQuestion('Question 1'),
          pollQuestion('25%'),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          pollQuestion('Question 2'),
          pollQuestion('25%'),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          pollQuestion('Question 3'),
          pollQuestion('50%')
        ],
      )
    ],
  );
}

Widget pollQuestion(String question) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration:
    BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
    child: Text(question),
  );
}


Widget buildTimelineList(BuildContext context, TimelineController controller) {
  return ListView.builder(
    shrinkWrap: true,
    controller: controller.scrollController,
    itemCount: controller.neomPosts.length,
    itemBuilder: (context, index) {
      NeomPost neomPost = controller.neomPosts.values.elementAt(index);
      Widget widget = Container();
      switch(neomPost.type) {
        case NeomPostType.Caption:
          widget = feedCardItem(context, controller, neomPost);
          break;
        case NeomPostType.Image:
          widget = feedCardWithImageItem(context, controller, neomPost);
          break;
        case NeomPostType.Question:
          widget = feedCardItemQuestion(context, controller, neomPost);
          break;
        case NeomPostType.Poll:
          widget = pollingCard(context, controller, neomPost);
          break;
        case NeomPostType.Video:
          break;
        case NeomPostType.Event:
          break;
        case NeomPostType.Youtube:
          break;
        case NeomPostType.Pending:
          break;
      }

      return widget;
    }
  );
}


Widget likeCommentShare(TimelineController _, NeomPost neomPost) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
        onTap: () {
          _.handleLikePost(neomPost);
        },
        child: Row(
          children: <Widget>[
            _.isLikedPost(neomPost) ? Icon( FontAwesomeIcons.solidHeart,size: 18)
                : Icon( FontAwesomeIcons.heart,size: 18),
            SizedBox(width: 5),
            Text('${neomPost.likedProfiles.length}')
          ],
        )
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Get.to(PostCommentsPage(), transition: Transition.native, arguments: neomPost);
            },
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.commentAlt, size: 18),
                SizedBox(width: 5),
                Text(neomPost.neomComments.length.toString())
              ],
            )
          )
        ]
      ),
      GestureDetector(
        onTap: () => Share.share('check out my website https://cyberneom.com'),
        child: Icon(FontAwesomeIcons.bookmark, size: 18),
      ),
      GestureDetector(
        onTap: () => Share.share('check out my website https://cyberneom.com'),
        child: Icon(FontAwesomeIcons.shareAlt, size: 18))
    ],
  );
}


Widget userAvatarSection(BuildContext context, NeomPost neomPost) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: ClipOval(child: Image.network(neomPost.neomProfileImgUrl)),
                    radius: 20),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(neomPost.neomProfileName,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Text(getGenericPostType(neomPost.type),
                            softWrap: true,
                            style: TextStyle(fontSize: 14, color: Colors.grey))
                      ],
                    ),
                    SizedBox(height: 4),
                    neomPost.location.isNotEmpty ? Row(children: [
                      Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(neomPost.createdTime), locale: 'en_short'),
                          style: TextStyle(fontSize: 12, color: Colors.teal)),
                      SizedBox(width: 4),
                      Icon(Icons.location_on, color: Colors.teal, size: 12,),
                      SizedBox(width: 4),
                      Text(neomPost.location,
                          style: TextStyle(fontSize: 12, color: Colors.teal)),
                    ]) : Container()

                  ],
                )
              ],
            ),
            //TODO
            moreOptions3Dots(context),
          ],
        ),
      )
    ],
  );
}

String getGenericPostType(NeomPostType neomPostType){

  String genericPostType = "";

  switch(neomPostType) {
    case NeomPostType.Caption:
      genericPostType = "";
      break;
    case NeomPostType.Image:
      genericPostType = "";
      break;
    case NeomPostType.Question:
      genericPostType = "Asked a question";
      break;
    case NeomPostType.Poll:
      genericPostType = "Created a poll";
      break;
    case NeomPostType.Video:
      break;
    case NeomPostType.Event:
      genericPostType = "Created an event";
      break;
    case NeomPostType.Youtube:
      genericPostType = "Youtube";
      break;
    case NeomPostType.Pending:
      break;
  }

  return genericPostType;

}
Widget moreOptions3Dots(BuildContext context) {
  return GestureDetector(
    // Just For Demo, Doesn't Work As Needed
    onTap: () =>
        _onCenterBottomMenuOn3DotsPressed(context), //_showPopupMenu(context),
    child: Container(
      child: Icon(FontAwesomeIcons.ellipsisV, size: 18),
    ),
  );
}

Widget space10() {
  return SizedBox(height: 10);
}

Widget space15() {
  return SizedBox(height: 10);
}

Widget renderCategoryTime(NeomPost neomPost) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(EnumToString.convertToString(neomPost.type),
          style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(neomPost.createdTime)),
          style: TextStyle(fontSize: 14, color: Colors.grey[700])),
    ],
  );
}

_onCenterBottomMenuOn3DotsPressed(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          child: _buildBottomNavMenu(context),
        );
      });
}

Widget _buildBottomNavMenu(BuildContext context) {

  List<Menu3DotsModel> listMore = [];
  listMore.add(Menu3DotsModel('Hide <Post type>', 'See fewer posts like this', Icons.block));
  listMore.add(Menu3DotsModel('Unfollow <username>', 'Unfollow this user', Icons.person_add));
  listMore.add(Menu3DotsModel('Report <Post type>', 'Report this post', Icons.info));
  listMore.add(Menu3DotsModel('Copy <Post type> link', 'Copy this post to share it', Icons.insert_link));

  return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
        ),
      ),
      child: ListView.builder(
          itemCount: listMore.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Text(listMore[index].title, style: TextStyle(fontSize: 18),),
              subtitle: Text(listMore[index].subtitle),
              leading: Icon(listMore[index].icons, size: 20, color: Colors.teal,),
            );
          })
  );
}


class Menu3DotsModel{

  String title;
  String subtitle;
  IconData icons;

  Menu3DotsModel(this.title, this.subtitle, this.icons);

}

Widget buildMessageComposer(BuildContext context, PostCommentsController _) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    height: 70.0,
    color: NeomAppColor.bottomNavigationBar,
    child: Row(
      children: <Widget>[
        (_.neomUploadController.imageFile.path.isEmpty) ?
        IconButton(
          icon: Icon(Icons.photo),
          iconSize: 25.0,
          color: Theme.of(context).primaryColor,
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
        Stack(children: [
          Container(
            width: 50.0,
            height: 50.0,
            child: fileImage(_.neomUploadController.imageFile.path)
          ),
          Positioned(
            width: 20,
            height: 20,
            top: 30,
            left: 30,
            child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.close, color: Colors.white70, size: 15),
                onPressed:  ()=> _.clearImage()
            ),
          ),
        ]),
        SizedBox(width: 10),
        Expanded(
            child: TextField(
              controller: _.commentController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(hintText: NeomTranslationConstants.writeComment.tr),
            )),
        IconButton(
          icon: Icon(Icons.send),
          iconSize: 25.0,
          color: Theme.of(context).primaryColor,
          onPressed: () => _.addComment(),
        ),
      ],
    ),
  );
}

Widget buildCommentList(BuildContext context, PostCommentsController _) {
  return ListView.builder(
    //TODO Improve shrinkWrap option
      shrinkWrap: true,
      controller: _.scrollController,
      itemCount: _.neomPost.neomComments.length,
      itemBuilder: (context, index) {
        NeomComment comment = _.neomPost.neomComments.elementAt(index);
        Widget widget = Container();
          switch(comment.type) {
            case NeomMediaType.Text:
              widget = othersComment(context, comment);
              break;
            case NeomMediaType.Image:
              widget = othersComment(context, comment);
              break;
            case NeomMediaType.ImageSlider:
              widget = othersCommentWithImageSlider(context, comment);
              break;
            case NeomMediaType.Video:
              break;
            case NeomMediaType.Gif:
              break;
            case NeomMediaType.Youtube:
              break;
          }

        return widget;
      }
  );
}

Widget buildMediaPreview(BuildContext context, PostCommentsController _) {
  return (_.neomUploadController.imageFile.path.isEmpty) ?
        Container() :
        Container(
          padding: EdgeInsets.all(20.0),
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(_.neomUploadController.imageFile.path)),
              fit: BoxFit.cover,
            ),
          ),
        );
}

BoxDecoration boxDecoration() {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      border: Border.all(width: 1, style: BorderStyle.solid, color: Colors.teal),
      color: Colors.black12
  );
}


BoxDecoration selectedBoxDecoration() {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      color: NeomAppColor.mystic.withOpacity(0.9),
      border: Border.all(width: 1, style: BorderStyle.solid, color: Colors.teal));
}


Widget topSpace() {
  return SizedBox(height: 10);
}
