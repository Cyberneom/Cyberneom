import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cyberneom/ui/widgets/neom-custom-media.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/enum/neom-post-type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PostTile extends StatelessWidget {
  final NeomPost neomPost;

  PostTile(this.neomPost);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    child: neomPost.type == NeomPostType.Image ?
      cachedNetworkImage(neomPost.mediaUrl)
        : neomPost.type == NeomPostType.Video ?
      cachedNetworkThumbnail(neomPost.thumbnailUrl, neomPost.mediaUrl)
        : Text("neomEvent"),
      onLongPress:()=> Get.toNamed(NeomRouteConstants.NEOMPOST_DETAILS, arguments: neomPost)
    );
  }

}
