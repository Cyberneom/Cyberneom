import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/data/implementations/push_notification_service.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_theme.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/utils/constants/app_route_constants.dart';
import 'package:neom_commons/core/utils/constants/app_translation_constants.dart';
import 'package:neom_music_player/data/implementations/app_hive_controller.dart';
import 'package:neom_music_player/data/providers/neom_audio_provider.dart';
import 'package:neom_music_player/domain/use_cases/neom_audio_handler.dart';
import 'package:neom_music_player/utils/constants/app_hive_constants.dart';

import 'app_routes.dart';
import 'localization/app_es_translations.dart';
import 'root.dart';
import 'root_binding.dart';

void main() async {

  Logger.level = kDebugMode ? Level.debug : Level.info;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  await Firebase.initializeApp();

  await PushNotificationService.initNotifications(debug: kDebugMode);
  PushNotificationService.actionStreamListener();
  FirebaseMessaging.onMessage.listen(PushNotificationService.onMessageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(PushNotificationService.onMessageOpenApp);
  FirebaseMessaging.onBackgroundMessage(PushNotificationService.backgroundHandler);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  if(kDebugMode) {
    //await JobsFirestore().distributeItemmates();
  }

  await initMusicPlayerModule();
  runApp(const MyApp());
}
  
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    initializeDateFormatting(AppTranslationConstants.es);
    AppFlavour.readProperties(context);
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
        Locale('fr'), // French, France
        Locale('de'), // German, Germany
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

Future<void> initMusicPlayerModule() async {
  try {
    await Hive.initFlutter();
    for (final box in AppHiveConstants.hiveBoxes) {
      await AppHiveController.openHiveBox(
        box[AppHiveConstants.name].toString(),
        limit: box[AppHiveConstants.limit] as bool? ?? false,
      );
    }
    AppHiveController().onInit();
    MetadataGod.initialize();

    final neomAudioProvider = NeomAudioProvider();
    final NeomAudioHandler audioHandler = await neomAudioProvider.getAudioHandler();
    GetIt.I.registerSingleton<NeomAudioHandler>(audioHandler);
    // await JustAudioBackground.init(
    //   androidNotificationChannelId: 'com.gigmeout.letsgig.channel.audio',
    //   androidNotificationChannelName: 'Gigmeout',
    //   androidNotificationOngoing: true,
    // );
    // GetIt.I.registerSingleton<MiniPlayer>(MiniPlayer());
  } catch (e) {
    AppUtilities.logger.e(e.toString());
  }
}
