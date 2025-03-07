import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  AppUser? appUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (docSnapshot.exists) {
      setState(() {
        appUser = AppUser.fromSnapshot(docSnapshot);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

Future<void> _launchURL(String url) async {
  if (url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No link available")),
    );
    return;
  }

  // Debug print to check if URL is correct
  print("Attempting to launch: $url");

  if (kIsWeb) {
    // Flutter Web: Open in a new tab
    await launchUrlString(url, webOnlyWindowName: '_blank');
  } else {
    // Mobile/Desktop: Use normal launcher
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open $url")),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Profile', style: TextStyle(color: Color(0xFF5E77DF))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E77DF)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // Profile Picture
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    backgroundImage: NetworkImage(appUser?.profilePictureURL ??
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    backgroundColor: const Color(0xFFCDFCFF),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildSocialMediaButton(
                          icon: Icons.camera_alt,
                          label: "Instagram",
                          url: appUser?.instagramLink ?? "",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSocialMediaButton(
                          icon: Icons.facebook,
                          label: "Facebook",
                          url: appUser?.facebookLink ?? "",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  
                  _buildProfileField("First Name", appUser?.firstName ?? "N/A"),
                  _buildProfileField("Last Name", appUser?.lastName ?? "N/A"),
                  _buildProfileField("Age", appUser?.age.toString() ?? "N/A"),
                  _buildProfileField("Major", appUser?.major ?? "N/A"),
                  _buildProfileField("Biography", appUser?.bio ?? "No bio yet."),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }


  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaButton({required IconData icon, required String label, required String url}) {
    return OutlinedButton.icon(
      onPressed: url.isNotEmpty ? () => _launchURL(url) : null,
      icon: Icon(icon, color: url.isNotEmpty ? Colors.blueAccent : Colors.grey),
      label: Text(label, style: TextStyle(fontSize: 16, color: url.isNotEmpty ? Colors.blueAccent : Colors.grey)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 1,
          color: url.isNotEmpty ? Colors.blueAccent : Colors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
