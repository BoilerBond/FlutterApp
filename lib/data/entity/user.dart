import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { none, man, woman, other }

class User {
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


  User({
    required this.uid,
    required this.username,
    required this.purdueEmail,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.major,
    required this.gender,
    required this.age,
    required this.profilePictureURL,
    required this.photosURL,
    required this.blockedUserUIDs,
    required this.priorityLevel,
    required this.hobbies,
    required this.profileVisible,
    required this.photoVisible,
    required this.matchResultNotificationEnabled,
    required this.messagingNotificationEnabled,
    required this.eventNotificationEnabled
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
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
    );
  }

  static Gender _parseGender(String gender) {
    switch (gender) {
      case 'male':
        return Gender.man;
      case 'female':
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
      'profileVisible': profileVisible,
      'photoVisible': photoVisible,
    };
  }
}