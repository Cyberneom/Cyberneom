import 'package:cyberneom/data/api-services/firestore/neom-post-firestore.dart';
import 'package:cyberneom/data/api-services/firestore/neom-profile-firestore.dart';
import 'package:cyberneom/data/implementations/geolocator-service-impl.dart';
import 'package:cyberneom/domain/model/neom-post.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/domain/model/neom-chamber-preset.dart';
import 'package:cyberneom/domain/use-cases/neom-profile-service.dart';
import 'package:cyberneom/ui/pages/auth/neom-user-controller.dart';
import 'package:cyberneom/ui/pages/auth/login/login-controller.dart';
import 'package:cyberneom/utils/constants/neom-route-constants.dart';
import 'package:cyberneom/utils/neom-utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class NeomProfileController extends GetxController implements NeomProfileService {

  final logger = NeomUtilities.logger;
  final neomUserController = Get.find<NeomUserController>();
  final loginController = Get.find<LoginController>();

  RxBool _editStatus = false.obs;
  bool get editStatus => _editStatus.value;
  set editStatus(bool editStatus) => this._editStatus.value = editStatus;

  RxString _location = "".obs;
  String get location => _location.value;
  set location(String location) => this._location.value = location;

  Rx<NeomProfile> _neomProfile = NeomProfile().obs;
  NeomProfile get neomProfile => _neomProfile.value;
  set neomProfile(NeomProfile neomProfile) => this._neomProfile.value = neomProfile;

  RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool isLoading) => this._isLoading.value = isLoading;

  RxMap<String, NeomChamberPreset> _totalNeomChamberPresets = Map<String, NeomChamberPreset>().obs;
  Map<String, NeomChamberPreset> get totalNeomChamberPresets => _totalNeomChamberPresets;
  set totalNeomChamberPresets(Map<String, NeomChamberPreset> totalPresets) => this._totalNeomChamberPresets.value = totalPresets;

  RxString _postOrientation = ''.obs;
  String get postOrientation => _postOrientation.value;
  set postOrientation(String postOrientation) => this._postOrientation.value = postOrientation;

  int postCount=0;

  bool isFollowing= false;

  late List<NeomPost> _neomProfilePosts;
  List<NeomPost> get neomProfilePosts => _neomProfilePosts;

  @override
  void onInit() async {
    super.onInit();


    neomProfile = neomUserController.neomProfile!;

    if(neomProfile.position != null)
      location = await GeoLocatorServiceImpl().getAddressSimple(neomProfile.position!);

    postOrientation ='grid';

    totalNeomChamberPresets = NeomUtilities.getTotalNeomChamberPresets(neomProfile.neomChambers ?? {});
    getNeomProfilePosts();

  }

  void clear() {
    _neomProfile.value = NeomProfile();
    _neomProfilePosts = [];
  }

  Future<void> editNeomProfile() async {
    logger.d("");
  }

  void changeEditStatus(){
    logger.d("Changing edit status from $editStatus");

    editStatus ? _editStatus.value = false
        : _editStatus.value = true;

    update(['neomProfile']);
  }


  Future<void> getNeomProfilePosts() async {
    logger.d("");
    _neomProfilePosts = await NeomPostFirestore().getPosts(neomProfile.id);
    logger.d("${neomProfilePosts.length} Total Posts for NeomProfile");
    isLoading = false;
    update(['neomProfile']);
  }


  Future<void> updateLocation() async {
    logger.d("");
    try {

      Position newPosition =  await GeoLocatorServiceImpl().getCurrentPosition();
      if(await NeomProfileFirestore().updatePosition(neomUserController.neomUser!.id, neomProfile.id, newPosition)){
        neomProfile.position = newPosition;
        location = await GeoLocatorServiceImpl().getAddressSimple(neomProfile.position!);
      }
    } catch (e) {
      logger.d(e.toString());
    }

    logger.d("");
    update(['neomProfile']);
  }

  final _scaffoldKey =GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  String _neomProfileName = "";
  String _neomProfileAboutMe = "";
  bool _bioValid=true;
  bool _neomProfileNameValid=true;

  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  Future<void> updateProfileData(context) async {
    _neomProfileName.trim().length < 3 || _neomProfileName.isEmpty
        ? _neomProfileNameValid = false : _neomProfileNameValid = true;

    bioController.text.trim().length > 150
        ? _bioValid = false : _bioValid = true;

    if (_neomProfileNameValid && _bioValid) {
      await NeomProfileFirestore().updateNeomProfileInfo(neomProfile.id, _neomProfileName, _neomProfileAboutMe);
    }

    SnackBar snackBar = SnackBar(content: Text('Profile updated successfully!'),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  Column buildDisplayField()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top:12.0),
          child: Text('Display Name'),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: 'Update Display Name',
            errorText: _neomProfileNameValid ? null : "Display name is too short",
          ),
        ),
      ],
    );
  }
  Column buildBioField()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top:12.0),
          child: Text('Bio'),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: 'Update Bio',
            errorText: _bioValid ? null : 'Bio is too long',
          ),
        )
      ],
    );
  }

  buildTogglePostOrientation(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on,color: postOrientation =='grid'?Theme.of(context).colorScheme.secondary:Colors.white,),
          onPressed: (){
            _postOrientation.value ='grid';
          },
        ),
        IconButton(
          onPressed: (){
            _postOrientation.value ='list';
          },
          icon: Icon(Icons.list,color: postOrientation =='list'?Theme.of(context).colorScheme.secondary:Colors.white,),
        ),
      ],
    );
  }

  @override
  Future<void> getneomChamberPresetDetails(NeomChamberPreset neomChamberPreset) async {
    logger.d("");
    Get.toNamed(NeomRouteConstants.PRESET_DETAILS, arguments: [neomChamberPreset]);
    update(["neomChamberPreset"]);
  }

}