import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class _PrivacySettingsState extends State<PrivacySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: Center(
        child: Column(
          children: [
            ProfileVisibilityToggle(),
            PhotoVisibilityToggle(),
          ],
        )
      ),
    );
  }
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings();

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class ProfileVisibilityToggle extends StatefulWidget {
  const ProfileVisibilityToggle({super.key});

  @override
  State<ProfileVisibilityToggle> createState() => _ProfileVisibilityToggleState();
}

class _ProfileVisibilityToggleState extends State<ProfileVisibilityToggle> {
  bool visibility = true;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Visibility of my profile'),
      subtitle: const Text('By default, your profile is visible to everyone. By turning this off, you are opting out of matchmaking.'),
      value: visibility,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      onChanged: (bool value) {
        setState(() {
          visibility = value;
        });
        final newData = {"visibility": visibility};
        db.collection("users").doc(uid).set(newData, SetOptions(merge: true));
      },
      secondary: const Icon(Icons.visibility),
    );
  }
}

class PhotoVisibilityToggle extends StatefulWidget {
  const PhotoVisibilityToggle({super.key});

  @override
  State<PhotoVisibilityToggle> createState() => _PhotoVisibilityToggleState();
}

class _PhotoVisibilityToggleState extends State<PhotoVisibilityToggle> {
  bool photoVisibility = true;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Visibility of my photos'),
      subtitle: const Text('By default, your photos are visible to everyone. By turning this off, your photos are only visible to your match of the week.'),
      value: photoVisibility,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      onChanged: (bool value) {
        setState(() {
          photoVisibility = value;
        });
        final newData = {"photoVisibility": photoVisibility};
        db.collection("users").doc(uid).set(newData, SetOptions(merge: true));
      },
      secondary: const Icon(Icons.photo_library),
    );
  }
}