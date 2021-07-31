
import 'package:cyberneom/utils/enum/neom-locale.dart';

abstract class SharedPreferenceService {

  Future<void> readLocal();
  Future<void> writeLocal();
  Future<void> updateLocale(NeomLocale languageCode);

}