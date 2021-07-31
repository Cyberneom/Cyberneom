import 'dart:async';

abstract class NeomInboxRoomService {

  void setMessageText(text);
  Future<void> retrieveMessages();
  Future<void> addMessage();

}
