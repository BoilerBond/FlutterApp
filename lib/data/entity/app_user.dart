import 'dart:math';

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
  String college;
  String instagramLink;
  String facebookLink;
  String spotifyUsername;
  String profilePictureURL;
  int age;
  double priorityLevel;
  Gender gender;
  List<String> displayedInterests;
  List<String> photosURL;
  List<String> blockedUserUIDs;
  bool profileVisible;
  bool photoVisible;
  bool interestsVisible;
  bool matchResultNotificationEnabled;
  bool messagingNotificationEnabled;
  bool eventNotificationEnabled;
  bool showHeight;
  String heightUnit;
  double heightValue;
  bool showMajorToMatch;
  bool showMajorToOthers;
  bool showBioToMatch;
  bool showBioToOthers;
  bool showAgeToMatch;
  bool showAgeToOthers;
  bool showInterestsToMatch;
  bool showInterestsToOthers;
  bool showSocialMediaToMatch;
  bool showSocialMediaToOthers;
  bool keepMatch;
  String match;
  Map<String, dynamic> nonNegotiables;
  int longFormQuestion;
  String longFormAnswer;
  Map<String, int> personalTraits;
  Map<String, int> partnerPreferences;
  int weeksWithoutMatch;
  bool hasSeenMatchIntro;

  AppUser({
    required this.uid,
    this.username = '',
    this.purdueEmail = '',
    this.firstName = '',
    this.lastName = '',
    this.bio = '',
    this.major = '',
    this.college = '',
    this.gender = Gender.none,
    this.age = 0,
    this.priorityLevel = 0,
    this.profilePictureURL = '',
    this.photosURL = const [],
    this.blockedUserUIDs = const [],
    this.displayedInterests = const [],
    this.profileVisible = true,
    this.interestsVisible = true,
    this.photoVisible = true,
    this.matchResultNotificationEnabled = true,
    this.messagingNotificationEnabled = true,
    this.eventNotificationEnabled = true,
    this.keepMatch = true,
    this.instagramLink = '',
    this.facebookLink = '',
    this.spotifyUsername = '',
    this.showHeight = false,
    this.heightUnit = '',
    this.heightValue =
        0.0, // height is stored in cm and displayed according to user preference
    this.showMajorToMatch = true,
    this.showMajorToOthers = true,
    this.showBioToMatch = true,
    this.showBioToOthers = true,
    this.showAgeToMatch = true,
    this.showAgeToOthers = true,
    this.showInterestsToMatch = true,
    this.showInterestsToOthers = true,
    this.showSocialMediaToMatch = true,
    this.showSocialMediaToOthers = true,
    this.match = "",
    this.nonNegotiables = const {},
    this.longFormQuestion = 0,
    this.longFormAnswer = '',
    this.personalTraits = const {},
    this.partnerPreferences = const {},
    this.weeksWithoutMatch = 0,
    this.hasSeenMatchIntro = false,
  });

  factory AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return AppUser(
      uid: snapshot.id,
      username: data['username'] ?? '',
      purdueEmail: data['purdueEmail'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      bio: data['bio'] ?? '',
      major: data['major'] ?? '',
      college: data['college'] ?? '',
      gender: _parseGender(data['gender']),
      age: data['age'] ?? 0,
      priorityLevel: (data['priorityLevel'] ?? 0).toDouble(),
      profilePictureURL: data['profilePictureURL'] ?? '',
      photosURL: List<String>.from(data['photosURL'] ?? []),
      blockedUserUIDs: List<String>.from(data['blockedUserUIDs'] ?? []),
      displayedInterests: List<String>.from(
          data['displayedInterests'] ?? []), // Fetch from Firestore
      profileVisible: data['profileVisible'] ?? true,
      photoVisible: data['photoVisible'] ?? true,
      interestsVisible: data['interestsVisible'] ?? true,
      matchResultNotificationEnabled:
          data['matchResultNotificationEnabled'] ?? true,
      messagingNotificationEnabled:
          data['messagingNotificationEnabled'] ?? true,
      eventNotificationEnabled: data['eventNotificationEnabled'] ?? true,
      keepMatch: data['keepMatch'] ?? true,
      instagramLink: data['instagramLink'] ?? '',
      facebookLink: data['facebookLink'] ?? '',
      spotifyUsername: data['spotifyUsername'] ?? '',
      showHeight: data['showHeight'] ?? true,
      heightUnit: data['heightUnit'] ?? '',
      heightValue: data['heightValue'] ?? 0.0,
      showMajorToMatch: data['showMajorToMatch'] ?? true,
      showMajorToOthers: data['showMajorToOthers'] ?? true,
      showBioToMatch: data['showBioToMatch'] ?? true,
      showBioToOthers: data['showBioToOthers'] ?? true,
      showAgeToMatch: data['showAgeToMatch'] ?? true,
      showAgeToOthers: data['showAgeToOthers'] ?? true,
      showInterestsToMatch: data['showInterestsToMatch'] ?? true,
      showInterestsToOthers: data['showInterestsToOthers'] ?? true,
      showSocialMediaToMatch: data['showSocialMediaToMatch'] ?? true,
      showSocialMediaToOthers: data['showSocialMediaToOthers'] ?? true,
      match: data['match'] ?? '',
      nonNegotiables: data['nonNegotiables'] ?? {},
      longFormQuestion: data['longFormQuestion'] ?? 0,
      longFormAnswer: data['longFormAnswer'] ?? '',
      personalTraits: Map<String, int>.from(data['personalTraits'] ?? {}),
      partnerPreferences:
          Map<String, int>.from(data['partnerPreferences'] ?? {}),
      weeksWithoutMatch: data['weeksWithoutMatch'] ?? 0,
    );
  }

  static Future<AppUser> getById(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    return AppUser.fromSnapshot(snapshot);
  }

  static Future<void> delete(String id) async {
    await FirebaseFirestore.instance.collection("users").doc(id).delete();
  }

  Future<void> save({String id = "", bool merge = false}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(toMap(), SetOptions(merge: merge));
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
      'username': username,
      'purdueEmail': purdueEmail,
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'major': major,
      'college': college,
      'gender': gender.toString().split('.').last,
      'age': age,
      'priorityLevel': priorityLevel,
      'profilePictureURL': profilePictureURL,
      'photosURL': photosURL,
      'blockedUserUIDs': blockedUserUIDs,
      'displayedInterests': displayedInterests,
      'profileVisible': profileVisible,
      'photoVisible': photoVisible,
      'matchResultNotificationEnabled': matchResultNotificationEnabled,
      'messagingNotificationEnabled': messagingNotificationEnabled,
      'eventNotificationEnabled': eventNotificationEnabled,
      'keepMatch': keepMatch,
      'instagramLink': instagramLink,
      'facebookLink': facebookLink,
      'showHeight': showHeight,
      'heightUnit': heightUnit,
      'heightValue': heightValue,
      'showMajorToMatch': showMajorToMatch,
      'showMajorToOthers': showMajorToOthers,
      'showBioToMatch': showBioToMatch,
      'showBioToOthers': showBioToOthers,
      'showAgeToMatch': showAgeToMatch,
      'showAgeToOthers': showAgeToOthers,
      'showInterestsToMatch': showInterestsToMatch,
      'showInterestsToOthers': showInterestsToOthers,
      'showSocialMediaToMatch': showSocialMediaToMatch,
      'showSocialMediaToOthers': showSocialMediaToOthers,
      'match': match,
      'nonNegotiables': nonNegotiables,
      'longFormQuestion': longFormQuestion,
      'longFormAnswer': longFormAnswer,
      'weeksWithoutMatch': weeksWithoutMatch,
      'spotifyUsername': spotifyUsername
    };
  }

  double calculateDistance(AppUser user2) {
    double dist = 0.0;
    double sum = 0.0;
    List<int> p1 = personalTraits.values.toList();
    List<int> p2 = user2.personalTraits.values.toList();
    for (int i = 0; i < 5; i++) {
      sum += pow(p1[i] - p2[i], 2);
    }
    dist = sqrt(sum);
    return dist;
  }

  List<String> getSharedTraits(AppUser other) {
    List<String> common = [];

    if (this.major == other.major) common.add("Same major: ${major}");
    if (this.age == other.age) common.add("Same age: $age");

    final sharedInterests = displayedInterests
        .toSet()
        .intersection(other.displayedInterests.toSet());

    if (sharedInterests.isNotEmpty) {
      common.add("Shared interests: ${sharedInterests.join(", ")}");
    }

    final traitKeys = personalTraits.keys;
    for (var key in traitKeys) {
      if (personalTraits[key] == other.personalTraits[key]) {
        common.add("Similar trait: $key");
      }
    }

    return common;
  }
}