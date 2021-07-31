import 'package:cyberneom/utils/enum/neom-role.dart';

class NeomTribePrivateData {

  Map<String,NeomRole>? neomRoles;

  NeomTribePrivateData({this.neomRoles});

  @override
  String toString() {
    return 'NeomTribePrivateData{neomRoles: $neomRoles}';
  }
}
