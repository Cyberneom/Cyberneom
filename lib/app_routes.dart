import 'package:get/get.dart';
import 'package:neom_admin/admin/admin_routes.dart';
import 'package:neom_audio_player/neom_audio_player_routes.dart';
import 'package:neom_bands/bands/bands_routes.dart';
import 'package:neom_booking/booking/booking_routes.dart';
import 'package:neom_calendar/calendar/calendar_routes.dart';
import 'package:neom_commerce/commerce/commerce_routes.dart';
import 'package:neom_commerce/woo/woo_routes.dart';
import 'package:neom_commons/auth/auth_routes.dart';
import 'package:neom_commons/core/core_routes.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_events/events/events_routes.dart';
import 'package:neom_frequencies/frequencies/frequency_routes.dart';
import 'package:neom_home/home/home_routes.dart';
import 'package:neom_inbox/inbox/inbox_routes.dart';
import 'package:neom_instruments/instruments/instruments_routes.dart';
import 'package:neom_itemlists/itemlists/itemlists_routes.dart';
import 'package:neom_notifications/neom_notifications.dart';
import 'package:neom_onboarding/neom_onboarding.dart';
import 'package:neom_posts/posts/posts_routes.dart';
import 'package:neom_profile/mates/mate_routes.dart';
import 'package:neom_profile/profile/profile_routes.dart';
import 'package:neom_releases/releases_routes.dart';
import 'package:neom_requests/neom_requests.dart';
import 'package:neom_search/search_routes.dart';
import 'package:neom_timeline/neom_timeline.dart';
import 'package:neom_generator/neom_generator/neom_generator_routes.dart';

import 'root.dart';

class AppRoutes {

  static List<GetPage> getAppRoutes() {
    List<GetPage<dynamic>> appRoutes = [
      GetPage(
          name: AppRouteConstants.root,
          page: () => const Root(),
          transition: Transition.zoom
      ),
      ...AdminRoutes.routes,
      ...AuthRoutes.routes,
      ...BandsRoutes.routes,
      ...BookingRoutes.routes,
      ...CalendarRoutes.routes,
      ...CommerceRoutes.routes,
      ...CoreRoutes.routes,
      ...EventsRoutes.routes,
      ...HomeRoutes.routes,
      ...ItemlistsRoutes.routes,
      ...InboxRoutes.routes,
      ...InstrumentsRoutes.routes,
      ...MatesRoutes.routes,
      ...NeomAudioPlayerRoutes.routes,
      ...NotificationsRoutes.routes,
      ...OnBoardingRoutes.routes,
      ...PostsRoutes.routes,
      ...ProfileRoutes.routes,
      ...ReleasesRoutes.routes,
      ...RequestsRoutes.routes,
      ...SearchRoutes.routes,
      ...TimelineRoutes.routes,
      ...WooRoutes.routes,
      ...FrequencyRoutes.routes,
      ...NeomGeneratorRoutes.routes,
    ];

    return appRoutes;
  }

}
