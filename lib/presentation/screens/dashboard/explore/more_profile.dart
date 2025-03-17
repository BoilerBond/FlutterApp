import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MoreProfileScreen extends StatelessWidget {
  final String name;
  final String age;
  final String major;
  final String bio;
  final List<String> displayedInterests;
  final bool showHeight;
  final String heightUnit;
  final double heightValue;

  const MoreProfileScreen({
    super.key,
    required this.name,
    required this.age,
    required this.major,
    required this.bio,
    required this.displayedInterests,
    required this.showHeight,
    required this.heightUnit,
    required this.heightValue,
  });

  String _getFormattedHeight() {
    if (!showHeight) {
      return "";
    }

    if (heightUnit == "cm") {
      return "$heightValue cm";
    } else {
      int totalInches = (heightValue / 2.54).round();
      int feet = totalInches ~/ 12;
      int inches = totalInches % 12;
      return "$feet' $inches\"";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name\'s Profile',
            style: const TextStyle(color: Color(0xFF5E77DF))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E77DF)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundImage: const NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                ),
                backgroundColor: const Color(0xFFCDFCFF),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildSocialMediaButton(
                      context,
                      icon: Icons.camera_alt,
                      label: "Instagram",
                      url: "",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSocialMediaButton(
                      context,
                      icon: Icons.facebook,
                      label: "Facebook",
                      url: "",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildProfileField("Name", name),
              _buildProfileField("Age", age),
              _buildProfileField("Major", major),
              if (showHeight) _buildProfileField("Height", _getFormattedHeight()),
              _buildProfileField("Bio", bio),
              const SizedBox(height: 10),
              _buildInterestsSection(),
              const SizedBox(height: 20),
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
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaButton(BuildContext context,
      {required IconData icon, required String label, required String url}) {
    return OutlinedButton.icon(
      onPressed: url.isNotEmpty ? () => _launchURL(context, url) : null,
      icon: Icon(icon, color: url.isNotEmpty ? Colors.blueAccent : Colors.grey),
      label: Text(label,
          style: TextStyle(
              fontSize: 16,
              color: url.isNotEmpty ? Colors.blueAccent : Colors.grey)),
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

  Future<void> _launchURL(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No link available")),
      );
      return;
    }
  }

  Widget _buildInterestsSection() {
    return Column(
      children: [
        Text(
          "Interests",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        displayedInterests.isEmpty
            ? const Text(
                "No interests selected.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  alignment: WrapAlignment.center,
                  children: displayedInterests.map((interest) {
                    return Chip(
                      label: Text(
                        interest,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
}
