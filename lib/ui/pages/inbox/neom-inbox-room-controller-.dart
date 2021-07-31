import 'dart:async';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cyberneom/data/api-services/firestore/neom-inbox-firestore.dart';
import 'package:cyberneom/domain/model/neom-inbox.dart';
import 'package:cyberneom/domain/model/neom-message.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/use-cases/neom-inbox-room-service-.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:logger/logger.dart';

class NeomInboxRoomController extends GetxController implements NeomInboxRoomService {

  var logger = Logger();
  final neomUserController = Get.find<NeomUserController>();

  final TextEditingController textController = TextEditingController();
  late Timer _timer;

  RxString _messageText = "".obs;
  String get messageText => _messageText.value;
  set messageText(String message) => this._messageText.value = message;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  RxList<NeomMessage> _neomMessages = <NeomMessage>[].obs;
  List<NeomMessage> get neomMessages => _neomMessages;
  set neomMessages(List<NeomMessage> messages) => this._neomMessages.value = messages;

  Rx<NeomInbox> _neomInbox = NeomInbox().obs;
  NeomInbox get neomInbox => _neomInbox.value;
  set neomInbox(NeomInbox neomInbox) => this._neomInbox.value = neomInbox;

  Rx<NeomProfile> _neomProfile = NeomProfile().obs;
  NeomProfile get neomProfile => _neomProfile.value;
  set neomProfile(NeomProfile profile) => this._neomProfile.value = profile;

  String _neomInboxRoomId = "";


  @override
  void onInit() async {
    super.onInit();
    logger.d("NeomInbox Controller");

    _neomInbox.value = await Get.arguments;
    _neomInboxRoomId = neomInbox.id;

    _neomProfile.value = neomUserController.neomProfile!;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      logger.d("Verifying more Messages");
      retrieveMessages();
    });

    _isLoading.value = false;
  }

  @override
  FutureOr onClose() {
    super.onClose();
    _timer.cancel();
  }


  void clear() {
    _neomProfile.value = NeomProfile();
    _neomMessages.value = [];
  }


  void setMessageText(text) {
    _messageText.value = text;
  }


  Future<void> retrieveMessages() async {
    logger.d("$_neomInboxRoomId Retrieving messages");
    _neomMessages.value = await NeomInboxFirestore().retrieveNeomMessages(_neomInboxRoomId);
    logger.d("Retrieveing ${neomMessages.length} messages");
    update([NeomPageIdConstants.neomInboxRoom]);
  }


  Future<void> addMessage() async {
    logger.d("");

    NeomMessage neomMessage;
    if (messageText.isNotEmpty) {
      neomMessage = NeomMessage(text: messageText, sender: neomProfile.name, createdTime: DateTime.now().millisecondsSinceEpoch);

      try {
        if(await NeomInboxFirestore().addMessage(_neomInboxRoomId, neomMessage)) {
          //_neomMessages.add(neomMessage);
        }
      } catch (e) {
        logger.d(e.toString());
      }

      logger.d("");
      _messageText.value = "";
      textController.clear();
      update([NeomPageIdConstants.neomInboxRoom]);
    }
  }

}

