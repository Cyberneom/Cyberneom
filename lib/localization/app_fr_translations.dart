import 'package:neom_bank/data/translations/tip_fr_translations.dart';
import 'package:neom_daw/data/translations/daw_fr_translations.dart';
import 'package:neom_states/data/translations/states_fr_translations.dart';

/// French translations — modules with FR support.
/// Modules without FR fall back to the app's fallbackLocale (ES).
class AppFrTranslations {

  static Map<String, String> keys = {
    ...TipFrTranslations.values,
    ...DawFrTranslations.values,
    ...StatesFrTranslations.values,
  };

}
