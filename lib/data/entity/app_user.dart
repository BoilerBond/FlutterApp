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
  Gender gender;
  int age;
  String profilePictureURL;
  List<String> photosURL;
  List<String> blockedUserUIDs;
  int priorityLevel;
  List<String> hobbies;
  bool profileVisible;
  bool photoVisible;
  bool matchResultNotificationEnabled;
  bool messagingNotificationEnabled;
  bool eventNotificationEnabled;
  bool termsAccepted;
  String instagramLink; // NEW FIELD
  String facebookLink; // NEW FIELD

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
    this.profileVisible = true,
    this.photoVisible = true,
    this.matchResultNotificationEnabled = true,
    this.messagingNotificationEnabled = true,
    this.eventNotificationEnabled = true,
    this.termsAccepted = false,
    this.instagramLink = '', // Default to empty
    this.facebookLink = '', // Default to empty
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
      profilePictureURL: data['profilePictureURL'] ?? '',
      photosURL: List<String>.from(data['photosURL'] ?? []),
      blockedUserUIDs: List<String>.from(data['blockedUserUIDs'] ?? []),
      priorityLevel: data['priorityLevel'] ?? 0,
      hobbies: List<String>.from(data['hobbies'] ?? []),
      profileVisible: data['profileVisible'] ?? true,
      photoVisible: data['photoVisible'] ?? true,
      matchResultNotificationEnabled: data['matchResultNotificationEnabled'] ?? true,
      messagingNotificationEnabled: data['messagingNotificationEnabled'] ?? true,
      eventNotificationEnabled: data['eventNotificationEnabled'] ?? true,
      termsAccepted: data['termsAccepted'] ?? false,
      instagramLink: data['instagramLink'] ?? '', // Fetch from Firestore
      facebookLink: data['facebookLink'] ?? '', // Fetch from Firestore
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

  /// Convert AppUser object to Map for Firestore
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
      'profileVisible': profileVisible,
      'photoVisible': photoVisible,
      'matchResultNotificationEnabled': matchResultNotificationEnabled,
      'messagingNotificationEnabled': messagingNotificationEnabled,
      'eventNotificationEnabled': eventNotificationEnabled,
      'termsAccepted': termsAccepted,
      'instagramLink': instagramLink, // Save to Firestore
      'facebookLink': facebookLink, // Save to Firestore
    };
  }
}
