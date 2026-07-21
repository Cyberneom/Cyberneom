import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sint/sint.dart';

import 'ui/experiences/state_visual_bridge.dart';
import 'ui/onboarding/cyberneom_onboarding_wrapper.dart';
import 'package:neom_admin/admin_routes.dart';
import 'package:neom_qa_tracker/neom_qa_tracker.dart';
import 'package:neom_analytics/analytics_routes.dart';
import 'package:neom_audio_player/audio_player_routes.dart';
import 'package:neom_audio_player/ui/audio_player_root_page.dart';
import 'package:neom_audio_player/ui/player/miniplayer.dart';
import 'package:neom_auth/auth_routes.dart';
import 'package:neom_auth/ui/login/login_page.dart';
import 'package:neom_collectives/collective_routes.dart';
import 'package:neom_bank/bank_routes.dart';
import 'package:neom_books/books_routes.dart';
import 'package:neom_booking/booking_routes.dart';
import 'package:neom_booking/ui/booking_home_page.dart';
import 'package:neom_calendar/calendar_routes.dart';
import 'package:neom_camera/camera_routes.dart';
import 'package:neom_commerce/commerce_routes.dart';
import 'package:neom_creator_analytics/creator_analytics_routes.dart';
import 'package:neom_erp/erp_routes.dart';
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
import 'package:neom_experiences/experience_routes.dart';
import 'package:neom_generator/generator_routes.dart';
import 'package:neom_generator/ui/harmonic/harmonic_footprint_widget.dart';
import 'package:neom_generator/domain/models/harmonic/harmonic_footprint.dart';
import 'package:neom_generator/ui/miniplayer/mini_neom_player.dart';
import 'package:neom_inter/inter_routes.dart';
import 'package:neom_home/domain/models/home_tab_item.dart';
import 'package:neom_home/home_routes.dart';
import 'package:neom_home/ui/home_page.dart';
import 'package:neom_inbox/inbox_routes.dart';
import 'package:neom_instruments/instrument_routes.dart';
import 'package:neom_itemlists/itemlist_routes.dart';
import 'package:neom_itemlists/ui/itemlist_page.dart';
import 'package:neom_learning/learning_routes.dart';
import 'package:neom_mates/mate_routes.dart';
import 'package:neom_media_player/media_player_routes.dart';
import 'package:neom_media_upload/media_upload_routes.dart';
import 'package:neom_notifications/notification_routes.dart';
import 'package:neom_onboarding/onboarding_routes.dart';
import 'package:neom_posts/post_routes.dart';
import 'package:neom_profile/profile_routes.dart';
import 'package:neom_releases/release_routes.dart';
import 'package:neom_requests/request_routes.dart';
import 'package:neom_rooms/room_routes.dart';
import 'package:neom_search/search_routes.dart';
import 'package:neom_settings/setting_routes.dart';
import 'package:neom_stripe/stripe_routes.dart';
import 'package:neom_timeline/timeline_routes.dart';
import 'package:neom_timeline/ui/timeline_page.dart';
import 'package:neom_states/neom_states_routes.dart';
import 'package:neom_historic_state/historic_state_routes.dart';
import 'package:neom_eeg/ui/pages/eeg_monitor_page.dart';
import 'package:neom_par/par_routes.dart';
// neom_video_editor uses dart:io directly — excluded from web compilation
// import 'package:neom_video_editor/video_editor/video_editor_routes.dart';
import 'package:neom_levitation/levitation_routes.dart';
import 'package:neom_vr/vr_routes.dart';
import 'package:neom_ar/ar_routes.dart';
import 'package:neom_woo/woo_routes.dart';

class AppRoutes {

  static List<SintPage> getAppRoutes() {
    // Inject visual experiences into state sessions (auto-mapped by beat Hz).
    StatesRoutes.visualLayerBuilder = buildStateVisualLayer;

    List<SintPage<dynamic>> appRoutes = [
      SintPage(
          name: AppRouteConstants.root,
          page: () => RootPage(
              rootPage: LoginPage(),
              splashPage: SplashPage(),
              homePage: HomePage(
                tabs: getDefaultTabs(),
                miniPlayer: MiniPlayer(),
                miniNeomPlayer: const MiniNeomPlayer(),
                onboardingOverlay: const CyberneomOnboardingWrapper(),
              ),
              homeService: Sint.find<HomeService>(),
              previousVersionPage: PreviousVersionPage(), onGoingPage: OnGoingPage(),
              showExitConfirmationDialog: AppAlerts.showExitConfirmationDialog),
          transition: Transition.zoom
      ),
      SintPage(
        name: AppRouteConstants.home,
        page: () => HomePage(
          tabs: getDefaultTabs(),
          miniPlayer: MiniPlayer(),
          miniNeomPlayer: const MiniNeomPlayer(),
        ),
        transition: Transition.rightToLeftWithFade,
      ),
      SintPage(
        name: AppRouteConstants.audioPlayer,
        page: () => const AudioPlayerRootPage(secondaryPage: ItemlistPage(),),
        transition: Transition.rightToLeftWithFade,
      ),
      ...AdminRoutes.routes,
      SintPage(
        name: '/admin/qa-tracker',
        page: () => const SaiaQaTrackerPage(),
        binding: SaiaQaTrackerBinding(),
        transition: Transition.rightToLeftWithFade,
      ),
      ...AnalyticsRoutes.routes,
      ...AuthRoutes.routes,
      ...CollectiveRoutes.routes,
      ...BankRoutes.routes,
      ...BooksRoutes.routes,
      ...BookingRoutes.routes,
      ...CalendarRoutes.routes,
      if (!kIsWeb) ...CameraRoutes.routes,
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
      if (!kIsWeb) ...MediaPlayerRoutes.routes,
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
      ...CreatorAnalyticsRoutes.routes,
      ...ErpRoutes.routes,
      ...LearningRoutes.routes,
      ...NeomRoomRoutes.routes,
      // if (!kIsWeb) ...VideoEditorRoutes.routes, // dart:io incompatible with web
      ...FrequencyRoutes.routes,
      ...GeneratorRoutes.routes,
      ...ExperienceRoutes.routes,
      ...InterRoutes.routes,
      ...StatesRoutes.routes,
      ...HistoricStateRoutes.routes,
      SintPage(
        name: '/eeg',
        page: () => const EegMonitorPage(),
        transition: Transition.rightToLeftWithFade,
      ),
      SintPage(
        name: '/huella',
        page: () => HarmonicFootprintWidget(
          footprint: Sint.arguments != null
              ? Sint.arguments as HarmonicFootprint
              : HarmonicFootprint(userId: ''),
        ),
        transition: Transition.rightToLeftWithFade,
      ),
      ...ParRoutes.routes,
      ...LevitationRoutes.routes,
      if (!kIsWeb) ...VrRoutes.routes,
      if (!kIsWeb) ...ArRoutes.routes,
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
