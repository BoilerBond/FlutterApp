import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/presentation/widgets/protected_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'more_profile.dart';
import '../../../../data/entity/app_user.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/non_negotiables_form_screen.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/non_negotiables_filter_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<AppUser> users = [];
  int profileIndex = 0;
  double sliderValue = 0;
  bool isLoading = true;
  AppUser? curUser;

  Future<void> getProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final userSnapshot = await db.collection("users").doc(currentUser?.uid).get();
    setState(() {
      curUser = AppUser.fromSnapshot(userSnapshot);
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    _fetchVisibleUsers();
  }

  /// Fetch visible users from Firestore
  Future<void> _fetchVisibleUsers() async {
    if (curUser != null) print("curuser not null");
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection("users").where('__name__', isNotEqualTo: curUser?.uid).where("profileVisible", isEqualTo: true).get();

      final fetchedUsers = querySnapshot.docs
          .where((doc) {
            return !(curUser!.blockedUserUIDs.contains(doc.id));
          })
          .map((doc) => AppUser.fromSnapshot(doc))
          .toList();

      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      print("Failed to fetch visible users: $e");
      setState(() => isLoading = false);
    }
  }

  void _switchToNextProfile() {
    setState(() {
      if (users.isNotEmpty) {
        if (profileIndex == users.length - 1) {
          // rated all users already
          users.clear();
        } else {
          profileIndex += 1;
        }
      }
    });
  }

  void _navigateToMoreProfile() {
    if (users.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreProfileScreen(
          uid: users[profileIndex].uid,
          name: users[profileIndex].firstName,
          age: users[profileIndex].age.toString(),
          major: users[profileIndex].major,
          bio: users[profileIndex].bio,
          displayedInterests: users[profileIndex].displayedInterests,
          showHeight: users[profileIndex].showHeight,
          heightUnit: users[profileIndex].heightUnit,
          heightValue: users[profileIndex].heightValue,
          photosURL: (users[profileIndex].photoVisible) ? users[profileIndex].photosURL : [],
          pfpLink: users[profileIndex].profilePictureURL,
        ),
      ),
    );
  }

  void _reportProfile() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Report ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ProtectedText(
                    users[profileIndex].firstName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "'s Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<int>(
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
                onChanged: (value) {},
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
                      _switchToNextProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C519C),
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
    );
  }

  // Save rating and switch to the next profile
  Future<void> _submitRating() async {
    if (users.isEmpty) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    try {
      await FirebaseFirestore.instance.collection("ratings").add({
        "ratedProfileId": users[profileIndex].uid,
        "raterId": currentUserId,
        "rating": sliderValue,
      });
      setState(() {
        sliderValue = 0;
      });
      _switchToNextProfile();
    } catch (e) {
      print("Failed to submit rating: $e");
    }
  }

  String getSimilarity(AppUser user2) {
    final List<int> user1Traits = curUser!.personalTraits.values.toList();
    final List<int> user2Traits = user2.personalTraits.values.toList();
    int minIndex = 0;
    int minDiff = 10;
    for (int i = 0; i < 5; i++) {
      int diff = (user1Traits[i] - user2Traits[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        minIndex = i;
      }
    }
    String message = "You and ${user2.firstName}";
    switch (minIndex) {
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
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Explore",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w100,
            fontSize: 22,
            color: Color(0xFF454746),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        actions: [
          Row(
            children: [
              const Text(
                "Edit my non-negotiables",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const NonNegotiablesFormScreen()));
                },
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("No profiles available."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Filter by non-negotiables",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_list_alt),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      const NonNegotiablesFilterScreen()));
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const Divider(
                              height: 20,
                              thickness: 1,
                              color: Color(0xFFE7EFEE),
                            ),
                            const SizedBox(height: 10),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                key: ValueKey(profileIndex),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7EFEE),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text("Why am I seeing this profile?"),
                                              content: Text(getSimilarity(users[profileIndex])),
                                            ),
                                          ),
                                          icon: const Icon(Icons.info_outline),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: _navigateToMoreProfile,
                                      child: CircleAvatar(
                                        radius: MediaQuery.of(context).size.width * 0.2,
                                        backgroundImage: NetworkImage(
                                          users[profileIndex]
                                                  .profilePictureURL
                                                  .isNotEmpty
                                              ? users[profileIndex].profilePictureURL
                                              : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                        ),
                                        backgroundColor: const Color(0xFFCDFCFF),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ProtectedText(
                                          users[profileIndex].firstName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xFF2C519C),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        IconButton(
                                          onPressed: _reportProfile,
                                          icon: const Icon(Icons.more_horiz, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          users[profileIndex].age.toString(),
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Color(0xFF5E77DF)),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text("|", style: TextStyle(color: Color(0xFF2C519C))),
                                        const SizedBox(width: 10),
                                        ProtectedText(
                                          users[profileIndex].major,
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Color(0xFF5E77DF)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCDFCFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "About:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C519C)),
                                  ),
                                  const SizedBox(height: 5),
                                  ProtectedText(
                                    users[profileIndex].bio,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF454746),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: users.isEmpty
          ? null
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Rate this profile:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: sliderValue,
                    min: -2,
                    max: 2,
                    divisions: 4,
                    label: sliderValue.toString(),
                    activeColor: const Color(0xFF5E77DF),
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C519C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Submit Rating"),
                  ),
                ],
              ),
            ),
    ),
  );
  }
}
