import 'package:get/get.dart';
import 'package:neom_commons/auth/ui/login/login_controller.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/data/implementations/shared_preference_controller.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/utils/enums/app_in_use.dart';

import 'neom_constants.dart';


class RootBinding extends Binding {

  @override
  List<Bind> dependencies() {
    return [
      Bind.put<AppFlavour>(AppFlavour(inUse: AppInUse.cyberneom, version: NeomConstants.appVersion), permanent: true),
      Bind.put<UserController>(UserController(), permanent: true),
      Bind.put<SharedPreferenceController>(SharedPreferenceController(), permanent: true),
      Bind.put<LoginController>(LoginController(), permanent: true),
    ];
  }

}
