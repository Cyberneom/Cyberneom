import 'package:cyberneom/localization/app_translations.dart';
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
import 'package:neom_commons/app_flavour.dart';
import 'package:neom_commons/ui/theme/app_color.dart';
import 'package:neom_commons/ui/theme/app_theme.dart';
import 'package:neom_core/app_config.dart';
import 'package:neom_core/app_properties.dart';
import 'package:neom_core/utils/constants/app_route_constants.dart';
import 'package:neom_core/utils/enums/app_in_use.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:neom_core/utils/enums/app_locale.dart';
import 'package:neom_notifications/data/implementations/push_notification_invoker.dart';

import 'app_routes.dart';
import 'root_binding.dart';

void main() async {

  Logger.level = kDebugMode ? Level.debug : Level.info;

  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Orientación solo en móvil (no funciona en web)
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }

    await Firebase.initializeApp(
      options: kIsWeb ? getFirebaseOptions() : null,
    );

    // Background messaging solo en móvil
    // Crashlytics solo en móvil (no disponible en web)
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(PushNotificationInvoker.backgroundHandler);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    }

    if(kDebugMode) {
      // await JobsFirestore().distributeSongmates();
    }

    await AppConfig.instance.initialize(app: AppInUse.c);
    AppProperties();
    AppFlavour();
    await Hive.initFlutter();
  } catch (e) {
    AppConfig.logger.e(e.toString());
  }

  runApp(const MyApp());

}
  
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(AppLocale.spanish.code);
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
      translations: AppTranslations(),
      locale: const Locale('es'),
      // Spanish, Mexico
      fallbackLocale: const Locale('es'),
      // Spanish, Mexico
      supportedLocales: const [
        Locale('es'), // Spanish, Mexico
        Locale('en'), // English, United States
      ],
      defaultTransition: Transition.upToDown,
      debugShowCheckedModeBanner: false,

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

FirebaseOptions getFirebaseOptions() {
  return const FirebaseOptions(
    apiKey: 'AIzaSyBjXsAC6AdS4AzjiP3jDUZCVdGls0ixmfA',
    appId: '1:144129075582:web:1af560c46ccbd0c411eb2f',
    messagingSenderId: '144129075582',
    projectId: 'cyberneom-edd2d',
    authDomain: 'cyberneom-edd2d.firebaseapp.com',
    storageBucket: 'cyberneom-edd2d.appspot.com',
    measurementId: 'G-0HP3HHDQ45',
  );
}