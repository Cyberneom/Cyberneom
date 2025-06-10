import 'package:get/get.dart';
import 'package:neom_audio_player/ui/home/audio_player_home_controller.dart';
import 'package:neom_audio_player/ui/player/miniplayer_controller.dart';
import 'package:neom_commons/auth/ui/login/login_controller.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';



class RootBinding extends Binding {

  @override
  List<Bind> dependencies() {
    return [
      Bind.put<UserController>(UserController(), permanent: true),
      Bind.put<LoginController>(LoginController(), permanent: true),
      Bind.lazyPut(() => MiniPlayerController()),
      Bind.lazyPut(() => AudioPlayerHomeController()),
    ];
  }

}