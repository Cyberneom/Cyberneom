import 'package:cyberneom/ui/pages/add/create-post/neom-post-detail-controller.dart';
import 'package:cyberneom/ui/widgets/neom-custom-widgets.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeomPostPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NeomPostDetailController>(
        init: NeomPostDetailController(),
        builder: (_) => Scaffold(
            appBar: header(context, pageTitle: _.neomPost.caption.capitalizeFirst!),
            body: Container(
              decoration: NeomAppTheme.neomBoxDecoration,
              child: Obx(() =>_.isLoading ? Center(child: CircularProgressIndicator()): Stack(
              children: [ListView(
               children: <Widget>[ListTile(
                    leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(_.neomPost.mediaUrl),
                    backgroundColor: Colors.teal,
                    ),
                    title: Text(_.neomPost.neomProfileName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => _.neomProfile.id==_.neomPost.ownerId ?
                    Get.toNamed(NeomRouteConstants.PROFILE) : Get.toNamed(NeomRouteConstants.NEOMMATE_DETAILS, arguments: [_.neomPost.ownerId]),
                    subtitle: Text(_.location),
                    trailing: _.neomPost.ownerId ==_.neomProfile.id ? IconButton(
                    onPressed: () => _.handleDeletePost(context),
                    icon: Icon(Icons.more_vert),
                    ) : Text(""),
                  ),
               ],
              ),],),
              ),
            ),
        ),
    );
  }

}
