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

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {
      currentUser = AppUser.fromSnapshot(snapshot);
      isLoading = false;
    });
  }

  Future<void> saveSettings() async {
    if (currentUser == null) return;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .set(currentUser!.toMap(), SetOptions(merge: true));
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
                _buildSection("Major",
                    match: 'showMajorToMatch',
                    others: 'showMajorToOthers'),
                _buildSection("Bio",
                    match: 'showBioToMatch',
                    others: 'showBioToOthers'),
                _buildSection("Age",
                    match: 'showAgeToMatch',
                    others: 'showAgeToOthers'),
                _buildSection("Interests",
                    match: 'showInterestsToMatch',
                    others: 'showInterestsToOthers'),
                _buildSection("Social Media",
                    match: 'showSocialMediaToMatch',
                    others: 'showSocialMediaToOthers'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveSettings,
                  child: const Text("Save Settings"),
                ),
              ],
            ),
    );
  }

  Widget _buildSection(String label, {required String match, required String others}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SwitchListTile(
          title: const Text("Visible to Match"),
          value: currentUser?.toMap()[match] ?? true,
          onChanged: (val) {
            setState(() {
              currentUser = AppUser.fromSnapshot(
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser!.uid)
                    .get()
                    .then((_) {
                      final map = currentUser!.toMap();
                      map[match] = val;
                      return currentUser!..toMap().update(match, (_) => val);
                    }) as DocumentSnapshot<Object?>
              );
            });
          },
        ),
        SwitchListTile(
          title: const Text("Visible to Others"),
          value: currentUser?.toMap()[others] ?? true,
          onChanged: (val) {
            setState(() {
              currentUser = AppUser.fromSnapshot(
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser!.uid)
                    .get()
                    .then((_) {
                      final map = currentUser!.toMap();
                      map[others] = val;
                      return currentUser!..toMap().update(others, (_) => val);
                    }) as DocumentSnapshot<Object?>
              );
            });
          },
        ),
        const Divider(),
      ],
    );
  }
} 
