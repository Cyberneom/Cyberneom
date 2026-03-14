import 'package:sint/sint.dart';

import 'app_de_translations.dart';
import 'app_en_translations.dart';
import 'app_es_translations.dart';
import 'app_fr_translations.dart';

class AppTranslations extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'en': AppEnTranslations.keys,
    'es': AppEsTranslations.keys,
    'fr': AppFrTranslations.keys,
    'de': AppDeTranslations.keys,
  };

}
