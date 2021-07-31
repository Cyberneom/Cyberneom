import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cyberneom/ui/pages/timeline/post-comments-page/post-comments-controller.dart';
import 'package:cyberneom/ui/pages/timeline/widgets/timeline-widgets.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-translation-constants.dart';


class PostCommentsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostCommentsController>(
      id: NeomPageIdConstants.postComments,
      init: PostCommentsController(),
      builder: (_) => Container(
      decoration: NeomAppTheme.neomBoxDecoration,
      child: Scaffold(
      backgroundColor: Colors.transparent,
        bottomNavigationBar: buildMessageComposer(context, _),
      appBar: AppBar(
        title: Text(NeomTranslationConstants.comments.tr, style: TextStyle(fontWeight: FontWeight.bold),),
        elevation: 0,
        backgroundColor: NeomAppColor.appBar,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                shortFeedCardItem(context, _),
                buildCommentList(context, _),
              ],
            ),
          ),
        ),
      ),
     ),),
   );
  }
}
