import 'package:datingapp/presentation/widgets/protected_text.dart';
import 'package:flutter/material.dart';

class MoreProfileScreen extends StatelessWidget {
  final String name;
  final String age;
  final String major;
  final String bio;
  final List<String> displayedInterests;
  final List<String> photosURL;
  final String pfpLink;

  const MoreProfileScreen({
    super.key,
    required this.name,
    required this.age,
    required this.major,
    required this.bio,
    required this.displayedInterests,
    required this.photosURL,
    required this.pfpLink,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name\'s Profile', style: const TextStyle(color: Color(0xFF5E77DF))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E77DF)),
      ),
      body: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            children: [
                const SizedBox(height: 10),

                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  backgroundImage: (pfpLink.isEmpty) ?
                      NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                      : NetworkImage(pfpLink),
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
                _buildProfileField("Bio", bio),

                const SizedBox(height: 10),

                _buildInterestsSection(),

                const SizedBox(height: 20),

                _buildPhotos(context, photosURL)
              ],
            ),
          )
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
          ProtectedText(
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

  Widget _buildSocialMediaButton(BuildContext context, {required IconData icon, required String label, required String url}) {
    return OutlinedButton.icon(
      onPressed: url.isNotEmpty ? () => _launchURL(context, url) : null,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      photosURL.isEmpty ? const Text("No photos uploaded.",
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
              return Container(
                  padding: EdgeInsets.all(5),
                  width: 50,
                  height: 50,
                  child: Image.network(photoURL)
              );
            }).toList()
      ))
    ]
  );
}