import 'dart:async';
import 'package:cyberneom/domain/model/neom-app.dart';


abstract class NeomAppRepository {

  Future<NeomApp> retrieveNeomApp();

}
