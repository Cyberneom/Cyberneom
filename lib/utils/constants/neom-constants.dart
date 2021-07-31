import 'package:cyberneom/ui/pages/profile/tabs/neom-profile-chambers.dart';
import 'package:cyberneom/ui/pages/profile/tabs/neom-profile-recordings.dart';
import 'package:cyberneom/ui/pages/profile/tabs/neom-profile-posts.dart';
import 'package:flutter/cupertino.dart';

class NeomConstants {
  static const String cyberneom_title = "Cyberneom";
  static const String current_version = "Beta Version 0.0.1";
  static const String LOGIN = "LOGIN";
  static const String HZ = "HZ";

  static const double frequencyMin  = 80;
  static const double frequencyMax  = 520;
  static const double volumeMin  = 0;
  static const double volumeMax  = 1;
  static const double positionMin  = -0.2;
  static const double positionMax  = 0.2;

  static const String noImageUrl = "http://www.magma.mx/wp-content/plugins/lightbox/images/No-image-found.jpg";
  static const String noInstrumentFulfilledImgUrl = "https://img.favpng.com/20/10/7/vector-graphics-musical-ensemble-portable-network-graphics-silhouette-illustration-png-favpng-MJtvAfC1L6i9nmUwDz583N9Qh.jpg";

  static const String neomVersion = "0.0.1";

  static const String graphApiAuthorityUrl = "graph.facebook.com";
  static const String graphApiUnencondedPath = "/v2.12/me";
  static const String graphApiQueryFieldsParam = "fields";
  static const String graphApiQueryFieldsValues = "name,first_name,last_name,email,hometown,birthday,picture.height(200)";
  static const String graphApiQueryAccessTokenParam = "access_token";

  //The hometown/location is not included in the public permissions.
  String graphFbApiUserUrl =   "https://graph.facebook.com/{userId}?fields=birthday,hometown&access_token={userAccessToken}";
  String fbApiImgUrl = "https://graph.facebook.com/v3.1/{userId}/picture";

  static const String dummyProfilePic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s';

  final String userAccessToken = "{userAccessToken}";
  final String userId = "{userId}";

  static const String likedProfiles = "likedProfiles";
  static const String firstNeomChamber = "firstNeomChamber";
  static const String main_profile = "mainProfile";
  static const String ownerId = "ownerId";

  static const String more = 'more';
  static const String about = 'about';
  static const List<String> choices = ["more", "about", "logout"];

  static const String profile = "profile";
  static const String notifications = "notifications";
  static const String tribes = "tribes";
  static const String cluster = "cluster";
  static const String myClusters = "myClusters";
  static const String helpCenter = "helpCenter";
  static const String rootFrequencies = "rootFrequencies";
  static const String frequencies = "frequencies";
  static const String settingsPrivacy = "settingsPrivacy";
  static const String settings = "settings";
  static const String logout = "logout";

  static const String github = "Github";
  static const String linkedin = "LinkedIn" ;
  static const String twitter = "Twitter";
  static const String blog = "Blog";

  static const String prevVersion1 = "prevVersion1";
  static const String prevVersion2 = "prevVersion2";
  static const String prevVersion3 = "prevVersion3";
  static const String prevVersion4 = "prevVersion4";

  static const String to = 'to';
  static const String from = 'from';

  static const int maxNeomChamberNameLength = 20;
  static const int maxCreatorNameLength = 15;
  static const int maxFrequencyNameLength = 25;
  static const int timelineLimit = 5;

  static const int significantDistanceKM = 5;

  static final neomProfileTabs = ['posts', 'presets', 'chambers'];

  static final List<Widget> neomProfileTabPages = [NeomProfilePosts(), NeomProfileChambers(), NeomProfileRecordings()];

  static final nameMinimumLength = 2;
  static final usernameMinimumLength = 6;
  static final usernameMaximumLength = 16;
  static final passwordMinimumLength = 6;
  static final passwordMaximumLength = 16;
  static final emailMaximumLength = 26;
  static final firstYearDOB = 1930;
  static final lastYearDOB = 2005;

  static const PRIVACY_POLICY_URL = 'https://cyberneom.io/politica-de-privacidad/';
}
