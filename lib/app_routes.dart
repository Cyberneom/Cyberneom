import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neom_admin/admin_routes.dart';
import 'package:neom_analytics/analytics_routes.dart';
import 'package:neom_audio_player/audio_player_routes.dart';
import 'package:neom_audio_player/ui/audio_player_root_page.dart';
import 'package:neom_audio_player/ui/player/miniplayer.dart';
import 'package:neom_auth/auth_routes.dart';
import 'package:neom_auth/ui/login/login_page.dart';
import 'package:neom_bands/band_routes.dart';
import 'package:neom_bank/bank_routes.dart';
import 'package:neom_booking/booking_routes.dart';
import 'package:neom_booking/ui/booking_home_page.dart';
import 'package:neom_calendar/calendar_routes.dart';
import 'package:neom_camera/camera_routes.dart';
import 'package:neom_commerce/commerce_routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:neom_commons/common_routes.dart';
import 'package:neom_commons/ui/on_going_page.dart';
import 'package:neom_commons/ui/previous_version_page.dart';
import 'package:neom_commons/ui/splash_page.dart';
import 'package:neom_commons/utils/app_alerts.dart';
import 'package:neom_commons/utils/constants/translations/app_translation_constants.dart';
import 'package:neom_core/domain/use_cases/home_service.dart';
import 'package:neom_core/ui/root_page.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:neom_directory/directory_routes.dart';
import 'package:neom_events/event_routes.dart';
import 'package:neom_events/ui/events_page.dart';
import 'package:neom_frequencies/frequency_routes.dart';
import 'package:neom_generator/generator_routes.dart';
import 'package:neom_home/domain/models/home_tab_item.dart';
import 'package:neom_home/home_routes.dart';
import 'package:neom_home/ui/home_page.dart';
import 'package:neom_inbox/inbox_routes.dart';
import 'package:neom_instruments/instrument_routes.dart';
import 'package:neom_itemlists/itemlist_routes.dart';
import 'package:neom_itemlists/ui/itemlist_page.dart';
import 'package:neom_mates/mate_routes.dart';
import 'package:neom_media_player/media_player_routes.dart';
import 'package:neom_media_upload/media_upload_routes.dart';
import 'package:neom_notifications/notification_routes.dart';
import 'package:neom_onboarding/onboarding_routes.dart';
import 'package:neom_posts/post_routes.dart';
import 'package:neom_profile/profile_routes.dart';
import 'package:neom_releases/release_routes.dart';
import 'package:neom_requests/request_routes.dart';
import 'package:neom_search/search_routes.dart';
import 'package:neom_settings/setting_routes.dart';
import 'package:neom_stripe/stripe_routes.dart';
import 'package:neom_timeline/timeline_routes.dart';
import 'package:neom_timeline/ui/timeline_page.dart';
import 'package:neom_woo/woo_routes.dart';

class AppRoutes {

  static List<GetPage> getAppRoutes() {
    List<GetPage<dynamic>> appRoutes = [
      GetPage(
          name: AppRouteConstants.root,
          page: () => RootPage(
              rootPage: LoginPage(),
              splashPage: SplashPage(),
              homePage: HomePage(tabs: getDefaultTabs()),
              homeService: Get.find<HomeService>(),
              miniPlayer: MiniPlayer(),
              previousVersionPage: PreviousVersionPage(), onGoingPage: OnGoingPage(),
              showExitConfirmationDialog: AppAlerts.showExitConfirmationDialog),
          transition: Transition.zoom
      ),
      GetPage(
        name: AppRouteConstants.home,
        page: () => HomePage(tabs: getDefaultTabs()),
        transition: Transition.rightToLeftWithFade,
      ),
      GetPage(
        name: AppRouteConstants.audioPlayer,
        page: () => const AudioPlayerRootPage(secondaryPage: ItemlistPage(),),
        transition: Transition.rightToLeftWithFade,
      ),
      ...AdminRoutes.routes,
      ...AnalyticsRoutes.routes,
      ...AuthRoutes.routes,
      ...BandRoutes.routes,
      ...BankRoutes.routes,
      ...BookingRoutes.routes,
      ...CalendarRoutes.routes,
      ...CameraRoutes.routes,
      ...CommerceRoutes.routes,
      ...CommonRoutes.routes,
      ...DirectoryRoutes.routes,
      ...EventRoutes.routes,
      ...HomeRoutes.routes,
      ...ItemlistRoutes.routes,
      ...InboxRoutes.routes,
      ...InstrumentRoutes.routes,
      ...MateRoutes.routes,
      ...AudioPlayerRoutes.routes,
      ...MediaPlayerRoutes.routes,
      ...MediaUploadRoutes.routes,
      ...NotificationRoutes.routes,
      ...OnBoardingRoutes.routes,
      ...PostRoutes.routes,
      ...ProfileRoutes.routes,
      ...ReleaseRoutes.routes,
      ...RequestRoutes.routes,
      ...SearchRoutes.routes,
      ...SettingRoutes.routes,
      ...StripeRoutes.routes,
      ...TimelineRoutes.routes,
      ...WooRoutes.routes,
      ...FrequencyRoutes.routes,
      ...GeneratorRoutes.routes,
      // ...NUPALERoutes.routes,
      // ...CaseteRoutes.routes,
    ];

    return appRoutes;
  }

  static List<HomeTabItem> getDefaultTabs() {
    return [
      HomeTabItem(
          title: AppTranslationConstants.home,
          icon: FontAwesomeIcons.house,
          page: TimelinePage()
      ),
      HomeTabItem(
          title: AppTranslationConstants.events,
          icon: Icons.event,
          page: EventsPage()
      ),
      HomeTabItem(
        title: AppTranslationConstants.generator,
        icon: FontAwesomeIcons.om,
        route: AppRouteConstants.generator,
      ),
      HomeTabItem(
          title: AppTranslationConstants.directory,
          icon: FontAwesomeIcons.building,
          page: BookingHomePage()
      ),
      HomeTabItem(
          title: AppTranslationConstants.music,
          icon: LucideIcons.audioWaveform,
          route: AppRouteConstants.audioPlayer
      ),
    ];
  }

}
