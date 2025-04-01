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
  List<String> displayedInterests;
  List<String> photosURL;
  List<String> blockedUserUIDs;
  bool profileVisible;
  bool photoVisible;
  bool interestsVisible;
  bool matchResultNotificationEnabled;
  bool messagingNotificationEnabled;
  bool eventNotificationEnabled;
  String match;
  Map<String, dynamic> nonNegotiables;
  int longFormQuestion;
  String longFormAnswer;
  Map<String, int> personalTraits;
  Map<String, int> partnerPreferences;
  int weeksWithoutMatch;

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
    this.instagramLink = '',
    this.facebookLink = '',
    this.match = "",
    this.nonNegotiables = const {},
    this.longFormQuestion = 0,
    this.longFormAnswer = '',
    this.personalTraits = const {},
    this.partnerPreferences = const {},
    this.weeksWithoutMatch = 0,
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
      gender: _parseGender(data['gender']),
      age: data['age'] ?? 0,
      priorityLevel: data['priorityLevel'] ?? 0,
      profilePictureURL: data['profilePictureURL'] ?? '',
      photosURL: List<String>.from(data['photosURL'] ?? []),
      blockedUserUIDs: List<String>.from(data['blockedUserUIDs'] ?? []),
      displayedInterests: List<String>.from(data['displayedInterests'] ?? []), // Fetch from Firestore
      profileVisible: data['profileVisible'] ?? true,
      photoVisible: data['photoVisible'] ?? true,
      interestsVisible: data['interestsVisible'] ?? true,
      matchResultNotificationEnabled:
          data['matchResultNotificationEnabled'] ?? true,
      messagingNotificationEnabled:
          data['messagingNotificationEnabled'] ?? true,
      eventNotificationEnabled: data['eventNotificationEnabled'] ?? true,
      instagramLink: data['instagramLink'] ?? '',
      facebookLink: data['facebookLink'] ?? '',
      match: data['match'] ?? '',
      nonNegotiables: data['nonNegotiables'] ?? {},
      longFormQuestion: data['longFormQuestion'] ?? 0,
      longFormAnswer: data['longFormAnswer'] ?? '',
      personalTraits: Map<String, int>.from(data['personalTraits'] ?? {}),
      partnerPreferences: Map<String, int>.from(data['partnerPreferences'] ?? {}),
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
      'username': username,
      'purdueEmail': purdueEmail,
      'firstName': firstName,
      'lastName': lastName,
      'bio': bio,
      'major': major,
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
      'instagramLink': instagramLink,
      'facebookLink': facebookLink,
      'match': match,
      'nonNegotiables': nonNegotiables,
      'longFormQuestion': longFormQuestion,
      'longFormAnswer': longFormAnswer,
      'weeksWithoutMatch': weeksWithoutMatch
    };
  }
}
