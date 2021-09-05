import 'package:cyberneom/ui/pages/add/neom-upload-publish-page.dart';
import 'package:cyberneom/ui/pages/add/neom-upload-page.dart';
import 'package:cyberneom/ui/pages/auth/forgotPassword/forgot-password-page.dart';
import 'package:cyberneom/ui/pages/auth/login/login-page.dart';
import 'package:cyberneom/ui/pages/auth/signup/signup-page.dart';
import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-details-page.dart';
import 'package:cyberneom/ui/pages/chamber/chamber-preset/neom-chamber-preset-search-page.dart';
import 'package:cyberneom/ui/pages/chamber/chamber-neom-chamber-preset-page.dart';
import 'package:cyberneom/ui/pages/chamber/neom-chamber-page.dart';
import 'package:cyberneom/ui/pages/drawer/frequencies/frequency-fav-page.dart';
import 'package:cyberneom/ui/pages/drawer/frequencies/frequency-page.dart';
import 'package:cyberneom/ui/pages/neom-generator/neom-generator-page.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-details/neommate-details-page.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-details-page.dart';
import 'package:cyberneom/ui/pages/drawer/settings/about-page.dart';
import 'package:cyberneom/ui/pages/drawer/settings/account-settings-page.dart';
import 'package:cyberneom/ui/pages/drawer/settings/privacy-safety-page.dart';
import 'package:cyberneom/ui/pages/drawer/settings/settings-privacy-page.dart';
import 'package:cyberneom/ui/pages/add/create-post/neom-post-page.dart';
import 'package:cyberneom/ui/pages/home/neom-home-page.dart';
import 'package:cyberneom/ui/pages/inbox/neom-inbox-page.dart';
import 'package:cyberneom/ui/pages/inbox/neom-inbox-room-page.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-list-page.dart';
import 'package:cyberneom/ui/pages/neommates/neommate-search-page.dart';
import 'package:cyberneom/ui/pages/onboarding/onboarding-add-image-page.dart';
import 'package:cyberneom/ui/pages/onboarding/onboarding-reason-page.dart';
import 'package:cyberneom/ui/pages/onboarding/onboarding-frequency-page.dart';
import 'package:cyberneom/ui/pages/onboarding/onboarding-locale-page.dart';
import 'package:cyberneom/ui/pages/onboarding/onboarding-profile-type-page.dart';
import 'package:cyberneom/ui/pages/neom-root.dart';
import 'package:cyberneom/ui/pages/home/search/search-page.dart';
import 'package:cyberneom/ui/pages/profile/neom-profile-page.dart';

import 'package:cyberneom/ui/pages/static/previous-version-page.dart';
import 'package:cyberneom/ui/pages/static/splash-page.dart';
import 'package:cyberneom/ui/pages/static/under-construction-page.dart';
import 'package:cyberneom/ui/pages/statistics/audio-processing-page.dart';
import 'package:cyberneom/ui/pages/statistics/statistics-page.dart';
import 'package:cyberneom/ui/pages/timeline/timeline-page.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:get/get.dart';

class NeomAppRoutes {

  static final homePages = [TimelinePage(), NeomChamberPage(), StatisticsPage(), NeomInboxPage(),];

  static final routes = [
    GetPage(
      name: NeomRouteConstants.ACCOUNT_REMOVE,
      page: () => SplashPage(),
    ),
    GetPage(
      name: NeomRouteConstants.SPLASH_SCREEN,
      page: () => SplashPage(),
      transition: Transition.zoom
    ),
    GetPage(
      name: NeomRouteConstants.ROOT,
      page: () => NeomRoot(),
      transition: Transition.zoom
    ),
    GetPage(
      name: NeomRouteConstants.INTRO_LOCALE,
      page: () => OnBoardingLocalePage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: NeomRouteConstants.INTRO_PROFILE,
      page: () => OnBoardingProfileTypePage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: NeomRouteConstants.INTRO_FREQUENCY,
      page: () => OnBoardingFrequencyPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: NeomRouteConstants.INTRO_NEOM_REASON,
      page: () => OnBoardingReasonPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: NeomRouteConstants.INTRO_ADD_IMAGE,
      page: () => OnBoardingAddImagePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
        name: NeomRouteConstants.INTRO_CREATING,
        page: () => SplashPage(),
        transition: Transition.zoom
    ),
    GetPage(
      name: NeomRouteConstants.INTRO_WELCOME,
      page: () => SplashPage(),
      transition: Transition.zoom
    ),
    GetPage(
      name: NeomRouteConstants.HOME,
      page: () => NeomHomePage(),
      transition: Transition.zoom
    ),
    GetPage(
      name: NeomRouteConstants.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: NeomRouteConstants.FORGOT_PASSWORD,
      page: () => ForgotPasswordPage(),
    ),
    GetPage(
      name: NeomRouteConstants.FORGOT_PASSWORD_SENDING,
      page: () => SplashPage(),
    ),
    GetPage(
      name: NeomRouteConstants.SIGNUP,
      page: () => SignupPage(),
    ),
    GetPage(
      name: NeomRouteConstants.LOGOUT,
      page: () => SplashPage(),
    ),
    GetPage(
      name: NeomRouteConstants.NEOM_GENERATOR,
      page: () => NeomGeneratorPage(),
      transition: Transition.downToUp
    ),
    GetPage(
      name: NeomRouteConstants.PROFILE,
      page: () => NeomProfilePage(),
      transition: Transition.zoom
    ),
    GetPage(
      name: NeomRouteConstants.PROFILE_DETAILS,
      page: () => NeomProfileEditPage(),
    ),
    GetPage(
      name: NeomRouteConstants.CHAMBERS,
      page: () => NeomChamberPage(),
    ),
    GetPage(
      name: NeomRouteConstants.PRESET_SEARCH,
      page: () => NeomChamberPresetSearchPage(),
    ),
    GetPage(
      name: NeomRouteConstants.PRESET_DETAILS,
      page: () => NeomChamberPresetDetailsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: NeomRouteConstants.FREQUENCY_FAV,
      page: () => FrequencyFavPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: NeomRouteConstants.FREQUENCIES,
      page: () => FrequencyPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: NeomRouteConstants.CHAMBER_PRESETS,
      page: () => ChamberNeomChamberPresetsPage(),
    ),
    GetPage(
      name: NeomRouteConstants.NEOMMATES,
      page: () => NeommateListPage(),
    ),
    GetPage(
      name: NeomRouteConstants.NEOMMATE_SEARCH,
      page: () => NeommateSearchPage(),
    ),
    GetPage(
      name: NeomRouteConstants.SEARCH,
      page: () => SearchPage(),
    ),
    GetPage(
      name: NeomRouteConstants.NEOMMATE_DETAILS,
      page: () => NeommateDetailsPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: NeomRouteConstants.INBOX,
      page: () => NeomInboxPage(),
      transition: Transition.leftToRight
    ),
    GetPage(
      name: NeomRouteConstants.INBOX_ROOM,
      page: () => NeomInboxRoomPage(),
    ),
    GetPage(
      name: NeomRouteConstants.PRIVACY_POLICY,
      page: () => PrivacySafetyPage(),
    ),
    GetPage(
      name: NeomRouteConstants.SETTINGS_ACCOUNT,
      page: () => AccountSettingsPage(),
    ),
    GetPage(
      name: NeomRouteConstants.SETTINGS_PRIVACY,
      page: () => SettingsPrivacyPage(),
    ),
    GetPage(
      name: NeomRouteConstants.ABOUT,
      page: () => AboutPage(),
    ),
    GetPage(
      name: NeomRouteConstants.NEOMPOST_DETAILS,
      page: () => NeomPostPage(),
    ),
    GetPage(
      name: NeomRouteConstants.NEOM_UPLOAD,
      page: () => NeomUploadPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: NeomRouteConstants.NEOM_UPLOAD_2,
      page: () => NeomUploadPublishPage(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: NeomRouteConstants.PREVIOUS_VERSION,
      page: () => PreviousVersionPage(),
    ),
    GetPage(
      name: NeomRouteConstants.UNDER_CONSTRUCTION,
      page: () => UnderConstructionPage(),
    ),
  ];

}
