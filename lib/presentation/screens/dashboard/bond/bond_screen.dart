import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/more_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../data/entity/app_user.dart';

class BondScreen extends StatefulWidget {
  const BondScreen({super.key});

  @override
  State<BondScreen> createState() => _BondScreenState();
}

class _BondScreenState extends State<BondScreen> {
  final placeholder_match = "BP25avUQfZUVYNVLZ2Eoiw5jYlf1";
  AppUser? curUser;
  AppUser? match;
  bool keepMatchToggle = true;

  Future<void> getUserProfiles() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final curUserSnapshot = await db.collection("users").doc(currentUser?.uid).get();
    AppUser user = AppUser.fromSnapshot(curUserSnapshot);
    //final matchSnapshot = await db.collection("users").doc(user.match).get();
    final matchSnapshot = await db.collection("users").doc(placeholder_match).get();
    setState(() {
      curUser = user;
      match = AppUser.fromSnapshot(matchSnapshot);
      keepMatchToggle = user.keepMatch;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserProfiles();
  }

  // We use this sample user to test View Profile functionalities
  final Map<String, dynamic> bondedUser = {
    "name": "Sophia",
    "age": "22",
    "major": "Psychology",
    "bio": "Passionate about mental health awareness and neuroscience.",
    "displayedInterests": ["Mindfulness", "Counseling", "Brain Science"]
  };

  void _navigateToMoreProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreProfileScreen(
          uid: match!.uid,
          name: match!.firstName,
          age: match!.age.toString(),
          major: match!.major,
          bio: match!.bio,
          showHeight: match!.showHeight,
          heightUnit: match!.heightUnit, 
          heightValue: match!.heightValue,
          displayedInterests: match!.displayedInterests,
          photosURL: ["https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"],
          pfpLink: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
          spotifyUsername: match!.spotifyUsername,
        ),
      ),
    );
  }

  String getMatchReason() {
    final List<int> user1Traits = curUser!.personalTraits.values.toList();
    final List<int> user2Traits = match!.personalTraits.values.toList();
    int minIndex = 0;
    int minDiff = 10;
    for (int i = 0; i < 5; i++) {
      int diff = (user1Traits[i] - user2Traits[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        minIndex = i;
      }
    }
    String message = "You and ${match!.firstName}";
    switch(minIndex) {
      case 1:
        message += " have similar levels of extroversion.";
        break;
      case 0:
        message += " have similar views on the importance of family.";
        break;
      case 2:
        message += " have lifestyles with similar levels of physical activity.";
        break;
      case 4:
        message += " perform similarly under pressure.";
        break;
      case 3:
        message += " have similar views on trying new things and taking risks.";
        break;
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Bond",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w100,
            fontSize: 22,
            color: Color(0xFF454746),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black54),
            onPressed: () {
              _reportProfile(context, match!.firstName);
            },
          ),
        ],
        toolbarHeight: 40,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16).copyWith(top: 0),
          child: Column(
          children: [
            const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder:
                            (BuildContext context) => AlertDialog(
                          title: const Text("Why was I matched with this profile?"),
                          content: Text(getMatchReason())),
                        ),
                      icon: Icon(Icons.info_outline),
                  )
                ]
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                  backgroundColor: const Color(0xFFCDFCFF),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(match!.firstName, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text("${match!.age} | ${match!.major}",
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Color(0xFF5E77DF))),
            const SizedBox(height: 16),

            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: _navigateToMoreProfile,
                        child: const Text("View More"),
                      ),
                    ),
                  ),
                  const VerticalDivider(indent: 16, endIndent: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: () => _confirmUnbondDialog(context),
                        child: const Text("Unbond"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            
            // Spotify Button
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  final spotifyUsername = match?.spotifyUsername;
                  final String url = spotifyUsername != null && spotifyUsername.isNotEmpty
                      ? "https://open.spotify.com/user/" + spotifyUsername
                      : "";
                  _launchURL(url);
                },
                icon: Icon(Icons.music_note, color: match?.spotifyUsername != null && match!.spotifyUsername.isNotEmpty ? Colors.blueAccent : Colors.grey),
                label: Text("Spotify",
                    style: TextStyle(
                        fontSize: 16,
                        color: match?.spotifyUsername != null && match!.spotifyUsername.isNotEmpty ? Colors.blueAccent : Colors.grey)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    color: match?.spotifyUsername != null && match!.spotifyUsername.isNotEmpty ? Colors.blueAccent : Colors.grey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            _buildActionButton(Icons.chat_bubble, "Go to our messages", () {}),

            _buildActionButton(Icons.favorite, "Relationship suggestions", () {}),

            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 5),
            
            // Keep Match Toggle
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SwitchListTile(
                title: const Text("Keep this match for next week",
                  style: TextStyle(fontSize: 16)),
                subtitle: Text(keepMatchToggle 
                  ? "You'll keep this match" 
                  : "You'll get a new match next week",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                value: keepMatchToggle,
                activeColor: const Color(0xFF5E77DF),
                onChanged: (bool value) {
                  _updateKeepMatch(value);
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

    void _confirmUnbondDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Are you sure you want to unbond?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "This action will remove your bond and cannot be undone.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _unbond();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C519C),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Yes, Unbond"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _unbond() {
    // Implement the logic to unbond the user
  }

  Future<void> _updateKeepMatch(bool value) async {
    setState(() {
      keepMatchToggle = value;
    });
    
    if (curUser != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'keepMatch': value});
      
      // Update local data model
      if (curUser != null) {
        curUser!.keepMatch = value;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value 
          ? "You'll keep this match for next week" 
          : "You'll receive a new match next week"))
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No link available")),
      );
      return;
    }

    if (kIsWeb) {
      await launchUrlString(url, webOnlyWindowName: '_blank');
    } else {
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

  void _reportProfile(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Report $name's Profile",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Why do you want to report this profile?',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text("Profile goes against one of my non-negotiables."),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text("Profile appears to be fake or catfishing."),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text("Offensive content against community standards."),
                    ),
                  ],
                  onChanged: (value) {
                    
                  },
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                       // implement reporting logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2C519C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Report"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
