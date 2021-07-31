import 'package:cyberneom/domain/model/neom-activity-feed.dart';

abstract class NeomActivityFeedRepository {

  removeLikeFromActivityFeed(String neomUserId, String neomOwnerId, NeomActivityFeed neomActivityFeed);
  removeLikeFromFeed();

  Future<bool> addFollowToActivityFeed(String neomProfileId, NeomActivityFeed neomActivityFeed);
  Future<bool> addActivityFeed(NeomActivityFeed neomActivityFeed);
  Future<List<NeomActivityFeed>> retrieveActivityFeed(String neomProfileId);

  Future<bool> removePostActivityFeed(String neomPostId);
  Future<bool> removeEventActivityFeed(String neomEventId);

}


