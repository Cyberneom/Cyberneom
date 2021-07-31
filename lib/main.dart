import 'package:catcher/catcher.dart';
import 'package:cyberneom/ui/neom-app-router.dart';
import 'package:cyberneom/ui/bindings/loginBinding.dart';
import 'package:cyberneom/ui/pages/neom-root.dart';
import 'package:cyberneom/utils/neom-app-theme.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/neom-translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

void main() async {
  Logger.level = Level.verbose;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CatcherOptions debugOptions = CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["support@cyberneom.io"])
  ]);
  Catcher(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
  runApp(MyApp());
}


class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    initializeDateFormatting('es_MX',"");
    return GetMaterialApp(
      navigatorKey: Catcher.navigatorKey,
      initialBinding: RootBinding(),
      enableLog: true,
      translations: NeomTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      defaultTransition: Transition.upToDown,
      debugShowCheckedModeBanner: false,
      home: NeomRoot(),
      theme: ThemeData(brightness: Brightness.dark, fontFamily: NeomAppTheme.fontFamily),
      initialRoute: NeomRouteConstants.ROOT,
      getPages: NeomAppRoutes.routes,
    );
  }

}

