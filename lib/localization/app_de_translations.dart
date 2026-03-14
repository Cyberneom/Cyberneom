import 'package:neom_bank/data/translations/tip_de_translations.dart';
import 'package:neom_daw/data/translations/daw_de_translations.dart';
import 'package:neom_states/data/translations/states_de_translations.dart';

/// German translations — modules with DE support.
/// Modules without DE fall back to the app's fallbackLocale (ES).
class AppDeTranslations {

  static Map<String, String> keys = {
    ...TipDeTranslations.values,
    ...DawDeTranslations.values,
    ...StatesDeTranslations.values,
  };

}
