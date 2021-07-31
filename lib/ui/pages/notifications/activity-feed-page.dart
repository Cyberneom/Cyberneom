import 'package:cyberneom/domain/model/neom-activity-feed.dart';
import 'package:cyberneom/ui/pages/notifications/activity-feed-controller.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyberneom/utils/constants/neom-constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedPage extends StatelessWidget{

  Widget build(BuildContext context){
    return GetBuilder<ActivityFeedController>(
      id: "neomActivityFeed",
      init: ActivityFeedController(),
      builder: (_) => Scaffold(
        body: Container(
          decoration: NeomAppTheme.neomBoxDecoration,
          child: _.isLoading ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
              child: Stack(
                    children: [
                  ListView.builder(
                    padding: EdgeInsets.only(top: 55),
                    itemCount: _.neomActivityFeedItems.length,
                      itemBuilder: (context, index) {
                      NeomActivityFeed neomActivityFeed = _.neomActivityFeedItems.elementAt(index);
                      _.configureMediaPreview(context, neomActivityFeed);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Container(
                            color: Colors.transparent,
                            child: ListTile(
                              title: GestureDetector(
                                onTap: ()=>_.showProfile(neomActivityFeed.id),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 14.0),
                                    children: [
                                      TextSpan(
                                        text: neomActivityFeed.neomProfileName,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text:' ${_.activityItemText}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(neomActivityFeed.neomProfileImgUrl.isEmpty ? NeomConstants.noImageUrl: neomActivityFeed.neomProfileImgUrl),
                              ),
                              subtitle: Text(
                                timeago.format(DateTime.fromMillisecondsSinceEpoch(neomActivityFeed.createdTime)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: _.mediaPreview,
                            ),
                          ),
                        );
                      }
                  ),
                  Positioned(
                    top: 26.0,
                    left: 4.0,
                    child: BackButton(color: Colors.white),
                  ),
                ],),
            onRefresh: () => _.getActivityFeed(),
          ),
        ),
      ),
    );
  }
}