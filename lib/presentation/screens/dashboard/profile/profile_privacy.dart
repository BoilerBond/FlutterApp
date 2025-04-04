import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../data/entity/app_user.dart';

class ProfilePrivacyScreen extends StatefulWidget {
  const ProfilePrivacyScreen({super.key});

  @override
  State<ProfilePrivacyScreen> createState() => _ProfilePrivacyScreenState();
}

class _ProfilePrivacyScreenState extends State<ProfilePrivacyScreen> {
  AppUser? currentUser;
  bool isLoading = true;
  final Map<String, bool> _visibilitySettings = {};

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    final user = AppUser.fromSnapshot(snapshot);
    final data = user.toMap();

    setState(() {
      currentUser = user;
      isLoading = false;

      _visibilitySettings['showBioToMatch'] = data['showBioToMatch'] ?? true;
      _visibilitySettings['showBioToOthers'] = data['showBioToOthers'] ?? true;
      _visibilitySettings['showInterestsToMatch'] =
          data['showInterestsToMatch'] ?? true;
      _visibilitySettings['showInterestsToOthers'] =
          data['showInterestsToOthers'] ?? true;
      _visibilitySettings['showSocialMediaToMatch'] =
          data['showSocialMediaToMatch'] ?? true;
      _visibilitySettings['showSocialMediaToOthers'] =
          data['showSocialMediaToOthers'] ?? true;
      _visibilitySettings['showSpotifyToMatch'] =
          data['showSpotifyToMatch'] ?? true;
      _visibilitySettings['showSpotifyToOthers'] =
          data['showSpotifyToOthers'] ?? true;
      _visibilitySettings['showPhotosToMatch'] =
          data['showPhotosToMatch'] ?? true;
      _visibilitySettings['showPhotosToOthers'] =
          data['showPhotosToOthers'] ?? true;
    });
  }

  Future<void> saveSettings() async {
    if (currentUser == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .set(_visibilitySettings, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Privacy settings updated.")),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Privacy")),
      body: isLoading || currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection("Bio",
                    matchKey: 'showBioToMatch', othersKey: 'showBioToOthers'),
                _buildSection("Interests",
                    matchKey: 'showInterestsToMatch',
                    othersKey: 'showInterestsToOthers'),
                _buildSection("Social Media",
                    matchKey: 'showSocialMediaToMatch',
                    othersKey: 'showSocialMediaToOthers'),
                _buildSection("Spotify",
                    matchKey: 'showSpotifyToMatch',
                    othersKey: 'showSpotifyToOthers'),
                _buildSection("Photos",
                    matchKey: 'showPhotosToMatch',
                    othersKey: 'showPhotosToOthers'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveSettings,
                  child: const Text("Save Settings"),
                ),
              ],
            ),
    );
  }

  Widget _buildSection(String label,
      {required String matchKey, required String othersKey}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        CheckboxListTile(
          title: const Text("Visible to Match"),
          value: _visibilitySettings[matchKey] ?? true,
          onChanged: (val) {
            setState(() {
              _visibilitySettings[matchKey] = val!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text("Visible to Others"),
          value: _visibilitySettings[othersKey] ?? true,
          onChanged: (val) {
            setState(() {
              _visibilitySettings[othersKey] = val!;
            });
          },
        ),
        const Divider(),
      ],
    );
  }
}
