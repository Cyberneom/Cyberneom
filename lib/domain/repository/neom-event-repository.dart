import 'package:cyberneom/domain/model/neom-event.dart';


abstract class NeomEventRepository {

  Future<NeomEvent> retrieveEvent(String neomEventId);
  Future<List<NeomEvent>> retrieveEvents();
  Future<String> createEvent(NeomEvent neomEvent);
  Future<bool> deleteEvent(String neomProfileId, String neomEventId);

}


