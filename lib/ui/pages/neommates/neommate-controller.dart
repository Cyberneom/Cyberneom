import 'package:cyberneom/data/api-services/firestore/frequency-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-inbox-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-post-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-chamber-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-mate-firestore.dart';
import 'package:cyberneom/data/implementations/geolocator-service-impl.dart';
import 'package:cyberneom/domain/model/neom-inbox.dart';
import 'package:cyberneom/domain/model/neom-frequency.dart';
import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/model/neom-chamber.dart';
import 'package:cyberneom/domain/use-cases/geolocator-service.dart';
import 'package:cyberneom/domain/use-cases/neom-mate-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/constants/neom-page-id-constants.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:get/get.dart';

class NeommateController extends GetxController implements NeommateService {

  var logger = NeomUtilities.logger;
  final loginController = Get.find<LoginController>();
  final neomUserController = Get.find<NeomUserController>();

  RxMap<String, NeomProfile> _neommates = Map<String, NeomProfile>().obs;
  Map<String, NeomProfile> get neommates => _neommates;
  set neommates(Map<String, NeomProfile> neommates) => this._neommates.value = neommates;

  Rx<NeomProfile> _neommate = NeomProfile().obs;
  NeomProfile get neommate => _neommate.value;
  set neommate(NeomProfile neommate) => this.neommate = neommate;

  NeomProfile _neomProfile = NeomProfile();
  String _neomUserId = "";

  RxString _address = "".obs;
  String get address => _address.value;
  set address(String address) => this._address.value = address;

  RxDouble _distance = 0.0.obs;
  double get distance => _distance.value;
  set distance(double distance) => this._distance.value = distance;

  RxMap<String, NeomChamberPreset> _totalNeomChamberPresets = Map<String, NeomChamberPreset>().obs;
  Map<String, NeomChamberPreset> get totalNeomChambers => _totalNeomChamberPresets;
  set totalNeomChambers(Map<String, NeomChamberPreset> totalPresets) => this._totalNeomChamberPresets.value = totalPresets;

  RxBool _following = false.obs;
  bool get following => _following.value;
  set following(bool following) => this._following.value = following;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;


  @override
  void onInit() async {
    super.onInit();
    logger.d("");
    List<String> neommateIds = Get.arguments ?? [];
    _neomUserId = neomUserController.neomUser!.id;
    _neomProfile = neomUserController.neomProfile!;


    neommateIds.isEmpty ? await loadNeommates()
    : neommateIds.length == 1 ? await loadNeommate(neommateIds.first)
    : await loadNeommatesById(neommateIds);

  }

  RxString _postOrientation = 'grid'.obs;
  String get postOrientation => _postOrientation.value;
  set postOrientation(String postOrientation) => this._postOrientation;

  late List<NeomPost> _neommatePosts;
  List<NeomPost> get neommatePosts => _neommatePosts;

  Future<void> loadNeommates() async {
    logger.d("");
    _neommates.value = await NeommateFirestore().getNeommates(_neomUserId);
    logger.d(neommates.length.toString() + " neommates found ");
    _isLoading.value = false;
    update(['neommates']);
  }

  Future<void> loadNeommatesById(List<String> neommateIds) async {
    logger.d("");

    for(int i=0; i < neommateIds.length; i++) {
      NeomProfile neomProfile = await NeomProfileFirestore().retrieveNeomProfile(neommateIds.elementAt(i));
      _neommates[neomProfile.id] = neomProfile;
    }

    logger.d(neommates.length.toString() + " neommates found ");
    _isLoading.value = false;
    update(['neommates']);
  }

  Future<void> getNeommateDetails(NeomProfile neommate) async {
    logger.d("");
    _neommate.value = neommate;
    _following.value = _neomProfile.following.contains(neommate.id);
    await retrieveDetails();
    Get.toNamed(NeomRouteConstants.NEOMMATE_DETAILS);
    update([NeomPageIdConstants.neommate]);
  }

  Future<void> retrieveDetails() async {
    logger.d("");
    await getAddressSimple();
    await getNeommatePosts();
    await getTotalNeomChambers();
    await getTotalFrequencies();
    logger.d("");
  }

  Future<void> loadNeommate(String neommateId) async {
    logger.d("");
    _neommate.value = await NeomProfileFirestore().retrieveNeomProfile(neommateId);
    if(neommate.id.isNotEmpty) {
      _following.value = _neomProfile.following.contains(neommateId);
      await retrieveDetails();
      _isLoading.value = false;
    }

    update([NeomPageIdConstants.neommate]);
  }

  Future<void> getNeommatePosts() async {
    logger.d("");
    _neommatePosts = await NeomPostFirestore().getPosts(neommate.id);
    logger.d("${neommatePosts.length} Total Posts for NeomProfile");
    _isLoading.value = false;
    update([NeomPageIdConstants.neommate]);
  }

  void clear() {
    _neommates.value = Map<String, NeomProfile>();
  }

  GeoLocatorService geoLocatorService = GeoLocatorServiceImpl();

  Future<void> getAddressSimple() async {
    logger.d("");
    String address = "";
    double distance = 0.0;
    try {
      address = await geoLocatorService.getAddressSimple(neommate.position!);
      _address.value = address;

      distance = geoLocatorService.distanceBetweenPositions(_neomProfile.position!, neommate.position!);
      _distance.value = distance;
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("$address and $distance km");
  }

  Future<void> getTotalNeomChambers()  async{
    logger.d("");
    Map<String,NeomChamber> neomChambers = await NeomChamberFirestore().retrieveNeomChambers(neommate.id);
    _totalNeomChamberPresets.value = NeomUtilities.getTotalNeomChamberPresets(neomChambers);
    logger.d("${totalNeomChambers.length} Total Presets for NeomProfile");
    update([NeomPageIdConstants.neommate]);
  }

  Future<void> getTotalFrequencies()  async{
    logger.d("");
    Map<String, NeomFrequency> frequencies = await FrequencyFirestore().retrieveFrequencies(neommate.id);
    frequencies.isNotEmpty ? neommate.rootFrequencies = frequencies : logger.d("Frequencies not found");
    logger.d("${neommate.rootFrequencies!.length} Total Frequencies for NeomProfile");
    update([NeomPageIdConstants.neommate]);
  }



  Future<void> follow() async {
    logger.d("");
    try {
      NeomProfileFirestore().followNeomProfile(_neomUserId, neommate.id);
      _following.value = true;
      neomUserController.neomProfile!.following.add(neommate.id);
      _neommate.value.followers.add(_neomUserId);
    } catch (e) {
      logger.d(e.toString());
    }

    update([NeomPageIdConstants.neommate, NeomPageIdConstants.neomProfile]);
  }

  Future<void> unfollow() async {
    logger.d("");
    try {
      NeomProfileFirestore().unfollowNeomProfile(_neomUserId, neommate.id);
      _following.value = false;
      neomUserController.neomProfile!.following.remove(neommate.id);
      _neommate.value.followers.remove(_neomUserId);
    } catch (e) {
      logger.d(e.toString());
    }

    update([NeomPageIdConstants.neommate, NeomPageIdConstants.neomProfile]);
  }

  Future<void> sendMessage() async {
    logger.d("");
    NeomInbox neomInbox = await NeomInboxFirestore().getOrCreateNeomInboxRoom(_neomProfile, neommate);
    Get.toNamed(NeomRouteConstants.INBOX_ROOM, arguments: neomInbox);
  }

}