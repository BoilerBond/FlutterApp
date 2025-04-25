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
  bool showSpotifyToMatch;
  bool showSpotifyToOthers;
  bool showPhotosToMatch;
  bool showPhotosToOthers;
  List<String> ratedUsers;
  int lastDailyPromptTime;
  String roomID;
  String currentMoodId;
  bool showMoodToMatches;
  Timestamp? moodTimestamp;

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
    this.nonNegotiables = const {
      "ageRange": {"max": null, "min": null},
      "genderPreferences": [],
      "majors": [],
      "mustHaveHobbies": [],
      "mustNotHaveHobbies": []
    },
    this.longFormQuestion = 0,
    this.longFormAnswer = '',
    this.personalTraits = const {},
    this.partnerPreferences = const {},
    this.weeksWithoutMatch = 0,
    this.hasSeenMatchIntro = false,
    this.showSpotifyToMatch = true,
    this.showSpotifyToOthers = true,
    this.showPhotosToMatch = true,
    this.showPhotosToOthers = true,
    this.ratedUsers = const [],
    this.lastDailyPromptTime = 0,
    this.roomID = '',
    this.currentMoodId = '',
    this.showMoodToMatches = true,
    this.moodTimestamp = null,
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
        heightValue: (data['heightValue'] ?? 0).toDouble(),
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
        hasSeenMatchIntro: data['hasSeenMatchIntro'] ?? false,
        showSpotifyToMatch: data['showSpotifyToMatch'] ?? true,
        showSpotifyToOthers: data['showSpotifyToOthers'] ?? true,
        showPhotosToMatch: data['showPhotosToMatch'] ?? true,
        showPhotosToOthers: data['showPhotosToOthers'] ?? true,
        ratedUsers: List<String>.from(data['ratedUsers'] ?? []),
        lastDailyPromptTime:
            int.tryParse(data['lastDailyPromptTime'].toString()) ?? 0,
        roomID: data['roomID'] ?? '',
        currentMoodId: data['currentMoodId'] ?? '',
        showMoodToMatches: data['showMoodToMatches'] ?? true,
        moodTimestamp: data['moodTimestamp'] as Timestamp?);
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
      'spotifyUsername': spotifyUsername,
      'hasSeenMatchIntro': hasSeenMatchIntro,
      'showSpotifyToMatch': showSpotifyToMatch,
      'showSpotifyToOthers': showSpotifyToOthers,
      'showPhotosToMatch': showPhotosToMatch,
      'showPhotosToOthers': showPhotosToOthers,
      'ratedUsers': ratedUsers,
      'lastDailyPromptTime': lastDailyPromptTime,
      'roomID': roomID,
      'currentMoodId': currentMoodId,
      'showMoodToMatches': showMoodToMatches,
      'moodTimestamp': moodTimestamp,
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
    common.add(getMostSimilarMetric(other));

    return common;
  }

  String getMostSimilarMetric(AppUser user2) {
    final List<int> user1Traits = this.personalTraits.values.toList();
    final List<int> user2Traits = user2.personalTraits.values.toList();
    int minIndex = 0;
    int minDiff = 10;
    for (int i = 0; i < 5; i++) {
      int diff = (user1Traits[i] - user2Traits[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        minIndex = i;
      }
    }
    String message = "You and ${user2.firstName}";
    switch (minIndex) {
      case 1:
        message += " have similar levels of extroversion.";
        break;
      case 0:
        message += " have similar views on the importance of family.";
        break;
      case 2:
        message += " have lifestyles with similar levels of physical activity.";
        break;
      case 4:
        message += " are similarly emotionally expressive.";
        break;
      case 3:
        message += " have similar views on trying new things and taking risks.";
        break;
    }
    return message;
  }

  double preferenceCompatibility(AppUser user2) {
    // get how closely user2 matches user1's preferences

    double sum = 0.0;
    List<int> p1 = this.partnerPreferences.values.toList();
    List<int> p2 = user2.personalTraits.values.toList();
    sum += pow(p1[0] + p2[4], 2); // emotionally expressive vs. calm
    sum += pow(p1[1] - p2[3], 2); // spontaneous vs. trying new things
    sum += pow(p1[2] - p2[1], 2); // outgoing vs. enjoy socializing
    sum += pow(p1[3] - p2[2], 2); // active vs. physical activity
    sum += pow(p1[4] - p2[0], 2); // family vs. family
    return sqrt(sum);
  }

  String getPreferenceTo(AppUser user2) {
    final List<int> p1 = this.partnerPreferences.values.toList();
    final List<int> p2 = user2.personalTraits.values.toList();
    List<int> difference = [0, 0, 0, 0, 0];
    difference[0] = (p1[0] + p2[4]).abs();
    difference[1] = (p1[1] - p2[3]).abs();
    difference[2] = (p1[2] - p2[1]).abs();
    difference[3] = (p1[3] - p2[2]).abs();
    difference[4] = (p1[4] - p2[0]).abs();
    int minIndex = 0;
    int minDiff = 10;
    for (int i = 0; i < 5; i++) {
      if (difference[i] < minDiff) {
        minDiff = difference[i];
        minIndex = i;
      }
    }
    String message = "${user2.firstName}";
    switch (minIndex) {
      case 1:
        message +=
            "'s level of extroversion matches your partner preference.\n";
        break;
      case 0:
        message +=
            "'s views on the importance of family matches your partner preference\n.";
        break;
      case 2:
        message += "'s lifestyle matches your partner preference\n.";
        break;
      case 4:
        message +=
            "'s emotional expressiveness matches your partner preference\n.";
        break;
      case 3:
        message +=
            "'s willingness to try new things and take risks matches your partner preference\n.";
        break;
    }
    return message;
  }

  String getPreferenceFrom(AppUser user2) {
    final List<int> p1 = this.personalTraits.values.toList();
    final List<int> p2 = user2.partnerPreferences.values.toList();
    List<int> difference = [0, 0, 0, 0, 0];
    difference[0] = (p1[0] + p2[4]).abs();
    difference[1] = (p1[1] - p2[3]).abs();
    difference[2] = (p1[2] - p2[1]).abs();
    difference[3] = (p1[3] - p2[2]).abs();
    difference[4] = (p1[4] - p2[0]).abs();
    int minIndex = 0;
    int minDiff = 10;
    for (int i = 0; i < 5; i++) {
      if (difference[i] < minDiff) {
        minDiff = difference[i];
        minIndex = i;
      }
    }
    String message = "Your ";
    switch (minIndex) {
      case 1:
        message += "level of extroversion ";
        break;
      case 0:
        message += "views on the importance of family ";
        break;
      case 2:
        message += "lifestyle ";
        break;
      case 4:
        message += "emotional expressiveness ";
        break;
      case 3:
        message += "willingness to try new things and take risks ";
        break;
    }
    message += "matches ${user2.firstName}'s partner preference.\n";
    return message;
  }

  String getMatchReason(AppUser u2) {
    String message = "";
    message += this.getPreferenceTo(u2);
    message += "\n";
    message += this.getPreferenceFrom(u2);
    return message;
  }

  bool hasInterests(List<dynamic> list) {
    if (list.isEmpty) return true;
    bool result = true;
    for (String i in list) {
      if (!this.displayedInterests.contains(i)) {
        return false;
      }
    }
    return result;
  }

  bool notHaveInterests(List<dynamic> list) {
    if (list.isEmpty) return true;
    bool result = true;
    for (String i in list) {
      if (this.displayedInterests.contains(i)) {
        return false;
      }
    }
    return result;
  }

  String gts(Gender g) {
    switch (g) {
      case Gender.man:
        return 'man';
      case Gender.woman:
        return 'woman';
      case Gender.other:
        return 'other';
      default:
        return 'none';
    }
  }

  bool matchGenderPreference(List<dynamic> list) {
    if (list.isEmpty) return true;
    bool result = false;
    for (String i in list) {
      if (gts(this.gender).toLowerCase() == i.toLowerCase()) {
        return true;
      }
    }
    return result;
  }

  bool matchAgePreference(Map<String, dynamic> list) {
    bool result = true;
    if (list.values.first != null) {
      result = result && this.age >= list.values.first;
    }
    if (list.values.last != null) {
      return this.age <= list.values.last;
    }
    return result;
  }

  bool matchMajor(List<dynamic> list) {
    if (list.isEmpty) return true;
    bool result = false;
    for (var i in list) {
      if (i["major"] == this.major.toLowerCase()) return true;
    }
    return result;
  }
}
