import 'package:get/get.dart';
import 'package:neom_audio_player/data/implementations/player_hive_controller.dart';
import 'package:neom_audio_player/ui/home/audio_player_home_controller.dart';
import 'package:neom_audio_player/ui/player/miniplayer_controller.dart';
import 'package:neom_audio_player/utils/theme/music_player_theme.dart';
import 'package:neom_commons/auth/ui/login/login_controller.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/data/implementations/app_hive_controller.dart';
import 'package:neom_commons/core/data/implementations/shared_preference_controller.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/utils/enums/app_in_use.dart';
import 'package:neom_commons/core/utils/neom_stopwatch.dart';

import 'neom_constants.dart';


class RootBinding extends Binding {

  @override
  List<Bind> dependencies() {
    return [
      Bind.put<AppFlavour>(AppFlavour(inUse: AppInUse.c, version: NeomConstants.appVersion), permanent: true),
      Bind.put<UserController>(UserController(), permanent: true),
      Bind.put<SharedPreferenceController>(SharedPreferenceController(), permanent: true),
      Bind.put<LoginController>(LoginController(), permanent: true),
      Bind.put<AppHiveController>(AppHiveController(), permanent: true),
      Bind.put<NeomStopwatch>(NeomStopwatch(), permanent: true),
      Bind.lazyPut(() => MusicPlayerTheme()),
      Bind.lazyPut(() => PlayerHiveController()),
      Bind.lazyPut(() => MiniPlayerController()),
      Bind.lazyPut(() => AudioPlayerHomeController()),
    ];
  }

}