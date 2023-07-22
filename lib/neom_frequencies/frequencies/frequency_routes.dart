import 'package:cyberneom/neom_frequencies/frequencies/ui/frequency_page.dart';
import 'package:get/get.dart';

import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'ui/frequency_fav_page.dart';

class FrequencyRoutes {

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: AppRouteConstants.frequencyFav,
      page: () => const FrequencyFavPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: AppRouteConstants.frequency,
      page: () => const FrequencyPage(),
      transition: Transition.rightToLeft,
    ),
  ];

}
