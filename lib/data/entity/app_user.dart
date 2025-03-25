import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { none, man, woman, other }

class AppUser {
  String uid;
  String username;
  String purdueEmail;
  String firstName;
  String lastName;
  String bio;
  String major;
  String instagramLink;
  String facebookLink;
  String profilePictureURL;
  int age;
  int priorityLevel;
  Gender gender;
  List<String> hobbies;
  List<String> displayedInterests;
  List<String> photosURL;
  List<String> blockedUserUIDs;
  bool profileVisible;
  bool photoVisible;
  bool matchResultNotificationEnabled;
  bool messagingNotificationEnabled;
  bool eventNotificationEnabled;
  bool termsAccepted;
  int weeksWithoutMatch;
  String match;

  AppUser({
    required this.uid,
    this.username = '',
    this.purdueEmail = '',
    this.firstName = '',
    this.lastName = '',
    this.bio = '',
    this.major = '',
    this.gender = Gender.none,
    this.age = 0,
    this.profilePictureURL = '',
    this.photosURL = const [],
    this.blockedUserUIDs = const [],
    this.priorityLevel = 0,
    this.hobbies = const [],
    this.displayedInterests = const [],
    this.profileVisible = true,
    this.photoVisible = true,
    this.matchResultNotificationEnabled = true,
    this.messagingNotificationEnabled = true,
    this.eventNotificationEnabled = true,
    this.termsAccepted = false,
    this.instagramLink = '',
    this.facebookLink = '',
    this.weeksWithoutMatch = 0,
    this.match = ""
  });

  factory AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    final firestore = FirebaseFirestore.instance;

    return AppUser(
      uid: snapshot.id,
      username: data['username'] ?? '',
      purdueEmail: data['purdueEmail'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      bio: data['bio'] ?? '',
      major: data['major'] ?? '',
      gender: _parseGender(data['gender']),
      age: data['age'] ?? 0,
      profilePictureURL: data['profilePictureURL'] ?? '',
      photosURL: List<String>.from(data['photosURL'] ?? []),
      blockedUserUIDs: List<String>.from(data['blockedUserUIDs'] ?? []),
      priorityLevel: data['priorityLevel'] ?? 0,
      hobbies: List<String>.from(data['hobbies'] ?? []),
      displayedInterests: List<String>.from(data['displayedInterests'] ?? []), // Fetch from Firestore
      profileVisible: data['profileVisible'] ?? true,
      photoVisible: data['photoVisible'] ?? true,
      matchResultNotificationEnabled: data['matchResultNotificationEnabled'] ?? true,
      messagingNotificationEnabled: data['messagingNotificationEnabled'] ?? true,
      eventNotificationEnabled: data['eventNotificationEnabled'] ?? true,
      termsAccepted: data['termsAccepted'] ?? false,
      instagramLink: data['instagramLink'] ?? '',
      facebookLink: data['facebookLink'] ?? '',
      weeksWithoutMatch: data['weeksWithoutMatch'] ?? 0,
      match: data['match'] ?? '',
    );
  }

  static Future<AppUser> getById(String id) async {
    final snapshot = await FirebaseFirestore.instance.collection("users").doc(id).get();
    return AppUser.fromSnapshot(snapshot);
  }

  static Future<void> delete(String id) async {
    await FirebaseFirestore.instance.collection("users").doc(id).delete();
  }

  Future<void> save({String id = "", bool merge = false}) async {
    await FirebaseFirestore.instance.collection("users").doc(id).set(
      toMap(),
      SetOptions(merge: merge)
    );
  }

  static Gender _parseGender(String? gender) {
    switch (gender) {
      case 'man':
        return Gender.man;
      case 'woman':
        return Gender.woman;
      case 'other':
        return Gender.other;
      default:
        return Gender.none;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'purdueEmail': purdueEmail,
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'major': major,
      'gender': gender.toString().split('.').last,
      'age': age,
      'profilePictureURL': profilePictureURL,
      'photosURL': photosURL,
      'blockedUserUIDs': blockedUserUIDs,
      'priorityLevel': priorityLevel,
      'hobbies': hobbies,
      'displayedInterests': displayedInterests,
      'profileVisible': profileVisible,
      'photoVisible': photoVisible,
      'matchResultNotificationEnabled': matchResultNotificationEnabled,
      'messagingNotificationEnabled': messagingNotificationEnabled,
      'eventNotificationEnabled': eventNotificationEnabled,
      'termsAccepted': termsAccepted,
      'instagramLink': instagramLink,
      'facebookLink': facebookLink,
      'weeksWithoutMatch': weeksWithoutMatch,
      'match': match
    };
  }
}
