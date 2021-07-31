import 'dart:async';
import 'package:cyberneom/domain/model/neom-inbox.dart';
import 'package:cyberneom/domain/model/neom-message.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';

abstract class NeomInboxRepository {

  Future<bool> addMessage(String neomInboxRoomId, NeomMessage neomMessage);
  Future<bool> neomInboxExists(String neomInboxId);
  Future<List<NeomMessage>> retrieveNeomMessages(String neomInboxId);

  searchInboxByName(String searchField);

  Future<bool> addNeomInbox(NeomInbox neomInbox);
  Future<List<NeomInbox>> getNeomProfileInbox(String neomProfileId);
  Future<NeomInbox> getOrCreateNeomInboxRoom(NeomProfile neomProfile, NeomProfile neommate);

  Stream listenToInboxRealTime(neomInboxRoomId);
}


