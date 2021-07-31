import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:get/get.dart';
import 'package:cyberneom/data/api-services/firestore/neom-inbox-firestore.dart';
import 'package:cyberneom/domain/model/neom-inbox.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/use-cases/neom-inbox-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:logger/logger.dart';

class NeomInboxController extends GetxController implements NeomInboxService{

  var logger = Logger();
  final neomUserController = Get.find<NeomUserController>();

  RxList<NeomInbox> _neomInboxs = <NeomInbox>[].obs;
  List<NeomInbox> get neomInboxs => _neomInboxs;
  set neomInboxs(List<NeomInbox> inboxs) => this._neomInboxs.value = inboxs;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  Rx<NeomProfile> _neomProfile = NeomProfile().obs;
  NeomProfile get neomProfile => _neomProfile.value;
  set neomProfile(NeomProfile profile) => this._neomProfile.value = profile;

  @override
  void onInit() async {
    super.onInit();
    neomProfile = neomUserController.neomProfile!;
    await loadNeomInbox();
  }

  void clear() {
    _neomProfile.value = NeomProfile();
    _neomInboxs.value = [];
  }

  Future<void> loadNeomInbox() async {
    logger.d("Start");
    _neomInboxs.value = await NeomInboxFirestore().getNeomProfileInbox(neomProfile.id);
    _isLoading.value = false;
    update([NeomPageIdConstants.neomInbox]);
  }

}
