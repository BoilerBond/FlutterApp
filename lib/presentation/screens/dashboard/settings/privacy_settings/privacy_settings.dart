import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../data/entity/app_user.dart';

class _PrivacySettingsState extends State<PrivacySettings> {
  bool visibility = false;
  bool photoVisibility = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> getProfile() async {
    if (currentUser != null) {
      final userSnapshot = await db.collection("users").doc(currentUser?.uid).get();
      final user = AppUser.fromSnapshot(userSnapshot);
      setState(() {
        visibility = user.profileVisible;
        photoVisibility = user.photoVisible;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: Center(
          child: Column(
        children: [
          SwitchListTile(
            title: const Text('Visibility of my profile'),
            subtitle: const Text('By default, your profile is visible to everyone. By turning this off, you are opting out of matchmaking.'),
            value: visibility,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (bool value) {
              setState(() {
                visibility = value;
              });
              final newData = {"profileVisible": visibility};
              db.collection("users").doc(uid).set(newData, SetOptions(merge: true));
            },
            secondary: const Icon(Icons.visibility),
          ),
          SwitchListTile(
            title: const Text('Visibility of my photos'),
            subtitle: const Text('By default, your photos are visible to everyone. By turning this off, your photos are only visible to your match of the week.'),
            value: photoVisibility,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (bool value) {
              setState(() {
                photoVisibility = value;
              });
              final newData = {"photoVisible": photoVisibility};
              db.collection("users").doc(uid).set(newData, SetOptions(merge: true));
            },
            secondary: const Icon(Icons.photo_library),
          )
        ],
      )),
    );
  }
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}
