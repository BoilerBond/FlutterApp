import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/explore_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../data/entity/app_user.dart';
import '../../../widgets/protected_text.dart';
import '../../../widgets/confirm_dialog.dart';

class MoreProfileScreen extends StatefulWidget {
  final String uid;
  final String name;
  final String age;
  final String major;
  final String bio;
  final List<String> displayedInterests;
  final bool showHeight;
  final String heightUnit;
  final double heightValue;
  final List<String> photosURL;
  final String pfpLink;
  final String? spotifyUsername;
  final String viewerUid;
  final bool isMatchViewer;
  final String viewerHeightUnit;


  const MoreProfileScreen({
    super.key,
    required this.uid,
    required this.name,
    required this.age,
    required this.major,
    required this.bio,
    required this.displayedInterests,
    required this.showHeight,
    required this.heightUnit,
    required this.heightValue,
    required this.photosURL,
    required this.pfpLink,
    this.spotifyUsername,
    required this.viewerUid,
    required this.isMatchViewer,
    required this.viewerHeightUnit,
  });

  @override
  State<MoreProfileScreen> createState() => _MoreProfileScreenState();
}

class _MoreProfileScreenState extends State<MoreProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, bool> visibilityPrefs = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVisibilitySettings();
  }

  Future<void> fetchVisibilitySettings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
    final data = snapshot.data();
    if (data == null) return;

    setState(() {
      visibilityPrefs = {
        'showAge':
            data[widget.isMatchViewer ? 'showAgeToMatch' : 'showAgeToOthers'] ??
                true,
        'showMajor': data[widget.isMatchViewer
                ? 'showMajorToMatch'
                : 'showMajorToOthers'] ??
            true,
        'showBio':
            data[widget.isMatchViewer ? 'showBioToMatch' : 'showBioToOthers'] ??
                true,
        'showInterests': data[widget.isMatchViewer
                ? 'showInterestsToMatch'
                : 'showInterestsToOthers'] ??
            true,
        'showSocialMedia': data[widget.isMatchViewer
                ? 'showSocialMediaToMatch'
                : 'showSocialMediaToOthers'] ??
            true,
        'showHeight': data['showHeight'] ?? false,
      };
      isLoading = false;
    });
  }

String _getFormattedHeight() {
  if (!widget.showHeight || !visibilityPrefs['showHeight']!) return "";

  if (widget.viewerHeightUnit == "cm") {
    return "${widget.heightValue} cm";
  }

  int totalInches = (widget.heightValue / 2.54).round();
  int feet = totalInches ~/ 12;
  int inches = totalInches % 12;
  return "$feet' $inches\"";
}


  Future<void> blockUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .update({
      "blockedUserUIDs": FieldValue.arrayUnion([widget.uid])
    });
    Navigator.of(context).pop();
    ExploreScreen.shouldReload.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name}'s Profile",
            style: const TextStyle(color: Color(0xFF5E77DF))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E77DF)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundImage: NetworkImage(widget.pfpLink.isNotEmpty
                          ? widget.pfpLink
                          : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                      backgroundColor: const Color(0xFFCDFCFF),
                    ),
                    const SizedBox(height: 20),
                    if (visibilityPrefs['showSocialMedia']!)
                      Column(
                        children: [
                          _buildSocialMediaRow(
                              "Instagram", Icons.camera_alt, ""),
                          _buildSocialMediaRow("Facebook", Icons.facebook, ""),
                          if (widget.spotifyUsername != null &&
                              widget.spotifyUsername!.isNotEmpty)
                            _buildSocialMediaRow("Spotify", Icons.music_note,
                                "https://open.spotify.com/user/${widget.spotifyUsername}"),
                        ],
                      ),
                    const SizedBox(height: 20),
                    _buildProfileField("Name", widget.name),
                    if (visibilityPrefs['showAge']!)
                      _buildProfileField("Age", widget.age),
                    if (visibilityPrefs['showMajor']!)
                      _buildProfileField("Major", widget.major),
                    if (widget.showHeight && visibilityPrefs['showHeight']!)
                      _buildProfileField("Height", _getFormattedHeight()),
                    if (visibilityPrefs['showBio']!)
                      _buildProfileField("Bio", widget.bio),
                    const SizedBox(height: 10),
                    if (visibilityPrefs['showInterests']!)
                      _buildInterestsSection(),
                    const SizedBox(height: 20),
                    _buildPhotos(context, widget.photosURL),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onErrorContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          confirmDialog(context, () {
                            blockUser();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("User successfully blocked.")),
                            );
                          });
                        },
                        child: const Text('Block user'),
                      ),
                    ),
                  ],
                ),
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
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[600])),
          const SizedBox(height: 4),
          ProtectedText(
            value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaRow(String label, IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton.icon(
        icon:
            Icon(icon, color: url.isNotEmpty ? Colors.blueAccent : Colors.grey),
        label: Text(label,
            style: TextStyle(
                fontSize: 16,
                color: url.isNotEmpty ? Colors.blueAccent : Colors.grey)),
        onPressed: url.isNotEmpty ? () => _launchURL(context, url) : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: url.isNotEmpty ? Colors.blueAccent : Colors.grey,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      children: [
        Text("Interests",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.grey[600])),
        const SizedBox(height: 4),
        widget.displayedInterests.isEmpty
            ? const Text("No interests selected.",
                style: TextStyle(color: Colors.grey, fontSize: 16))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  alignment: WrapAlignment.center,
                  children: widget.displayedInterests.map((interest) {
                    return Chip(
                      label: Text(
                        interest,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: const Color(0xFF5E77DF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),
              ),
      ],
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No link available")));
      return;
    }

    if (kIsWeb) {
      await launchUrlString(url, webOnlyWindowName: '_blank');
    } else {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Could not open $url")));
      }
    }
  }

  Widget _buildPhotoItem(BuildContext context, String url) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            pageBuilder: (BuildContext context, _, __) {
              return Align(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Hero(
                    tag: "zoom",
                    child: Image.network(url),
                  ),
                ),
              );
            },
          ),
        );
      },
      child: Image.network(url),
    );
  }

  Widget _buildPhotos(BuildContext context, List<String> photosURL) {
    return Column(
      children: [
        Text(
          "Photos",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        photosURL.isEmpty
            ? const Text(
                "No photos uploaded.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            : SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.count(
                  crossAxisCount: (photosURL.length == 1) ? 1 : 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: photosURL.map((photoURL) {
                    return _buildPhotoItem(context, photoURL);
                  }).toList(),
                ),
              ),
      ],
    );
  }
}