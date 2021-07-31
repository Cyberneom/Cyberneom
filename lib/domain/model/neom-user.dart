import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberneom/domain/model/neom-profile.dart';
import 'package:cyberneom/utils/enum/neom-user-role.dart';
import 'package:enum_to_string/enum_to_string.dart';

class NeomUser {

  String id;
  String name;
  String firstName;
  String lastName;
  String dateOfBirth;
  String homeTown;
  String phoneNumber;
  String countryCode;

  String? password;
  String email;
  String photoUrl;
  NeomUserRole? neomUserRole;
  bool isVerified;
  bool isBanned;

  String androidNotificationToken;
  List<NeomProfile>? neomProfiles;


  NeomUser({
      this.id = "",
      this.name = "",
      this.firstName = "",
      this.lastName = "",
      this.dateOfBirth = "",
      this.homeTown = "",
      this.phoneNumber = "",
      this.countryCode = "",
      this.password,
      this.email = "",
      this.photoUrl = "",
      this.neomUserRole,
      this.isVerified = false,
      this.isBanned = false,
      this.androidNotificationToken = "",
      this.neomProfiles});


  @override
  String toString() {
    return 'NeomUser{id: $id, name: $name, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, homeTown: $homeTown, phoneNumber: $phoneNumber, countryCode: $countryCode, password: $password, email: $email, photoUrl: $photoUrl, neomUserRole: $neomUserRole, isVerified: $isVerified, isBanned: $isBanned, androidNotificationToken: $androidNotificationToken, neomProfiles: $neomProfiles}';
  }

  NeomUser.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) :
    id = documentSnapshot.id,
    name = documentSnapshot.get("name"),
    firstName = documentSnapshot.get("firstName"),
    lastName = documentSnapshot.get("lastName"),
    dateOfBirth = documentSnapshot.get("dateOfBirth"),
    homeTown = documentSnapshot.get("homeTown"),
    phoneNumber = documentSnapshot.get("phoneNumber"),
    countryCode = documentSnapshot.get("countryCode"),
    password = documentSnapshot.get("password"),
    email = documentSnapshot.get("email"),
    photoUrl =  documentSnapshot.get("photoUrl"),
    neomUserRole =  EnumToString.fromString(NeomUserRole.values, documentSnapshot.get("neomUserRole")),
    isVerified =  documentSnapshot.get("isVerified"),
    isBanned =   documentSnapshot.get("isBanned"),
    androidNotificationToken = documentSnapshot.get("androidNotificationToken");


  NeomUser.fromFbProfile(profile) :
    id = profile["id"],
    name = profile["name"],
    firstName = profile["first_name"],
    lastName = profile["last_name"],
    email = profile["email"],
    photoUrl = profile['picture']['data']['url'],
    dateOfBirth = "",
    homeTown = "",
    phoneNumber = "",
    countryCode = "",
    isBanned = false,
    isVerified = false,
    androidNotificationToken = "";


  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      //'userId': userId, //not needed at firebase
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'homeTown': homeTown,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'photoUrl': photoUrl,
      'neomUserRole': EnumToString.convertToString(neomUserRole),
      'isVerified': isVerified,
      'isBanned': isBanned,
      'androidNotificationToken': androidNotificationToken,
    };
  }

}