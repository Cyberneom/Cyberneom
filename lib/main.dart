import 'package:cyberneom/neom_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_locale_constants.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/enums/app_in_use.dart';
import 'package:neom_notifications/notifications/data/implementations/push_notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_routes.dart';
import 'localization/app_es_translations.dart';
import 'root.dart';
import 'root_binding.dart';

void main() async {

  Logger.level = kDebugMode ? Level.debug : Level.info;

  try {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(PushNotificationService.backgroundHandler);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    if(kDebugMode) {
      // await JobsFirestore().distributeSongmates();
    }

    AppFlavour(inUse: AppInUse.c, version: NeomConstants.version);
    await Hive.initFlutter();
  } catch (e) {
    AppUtilities.logger.e(e.toString());
  }

  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(AppLocaleConstants.es);
    return GetMaterialApp(
      localeListResolutionCallback: (locales, supportedLocales) {
        for (var locale in locales!) {
          if (supportedLocales.contains(locale)) {
            return locale;
          }
        }
        return supportedLocales.first;
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      binds: RootBinding().dependencies(),
      enableLog: true,
      translations: AppEsTranslations(),
      locale: const Locale('es'), // Spanish, Mexico
      fallbackLocale: const Locale('es'), // Spanish, Mexico
      supportedLocales: const [
        Locale('es'), // Spanish, Mexico
        Locale('en'), // English, United States
      ],
      defaultTransition: Transition.upToDown,
      debugShowCheckedModeBanner: false,
      home: const Root(),
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: AppTheme.fontFamily,
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColor.getMain()
        ),
      ),
      initialRoute: AppRouteConstants.root,
      getPages: AppRoutes.getAppRoutes(),
    );
  }

}
