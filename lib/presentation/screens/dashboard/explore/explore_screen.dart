import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datingapp/presentation/widgets/protected_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'more_profile.dart';
import '../../../../data/entity/app_user.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/non_negotiables_form_screen.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/non_negotiables_filter_screen.dart';
class ExploreScreen extends StatefulWidget {
  static ValueNotifier<bool> shouldReload = ValueNotifier<bool>(false);
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<AppUser> recommendedUsers = [];
  int profileIndex = 0;
  double sliderValue = 0;
  bool isLoading = true;
  AppUser? curUser;
  Map<String, dynamic> filterData = {};
  Map<int, String> reportReasons = {
    0: "Profile goes against one of my non-negotiables.",
    1: "Profile appears to be fake or catfishing.",
    2: "Offensive content against community standards."
  };
  int selectedReportReasonIdx = 0;

  Future<void> getProfiles() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final userSnapshot = await db.collection("users").doc(currentUser?.uid).get();
    setState(() {
      curUser = AppUser.fromSnapshot(userSnapshot);
    });

    final callable = FirebaseFunctions.instance.httpsCallable('user-recommendation-recommendProfiles');
    final result = await callable.call({
      'limit': 10,
    });
    try {
      final List<dynamic> resultList = result.data as List<dynamic>;

      List<AppUser> fetchedUsers = [];

      for (final dynamic entry in resultList) {
        try {
          // Access properties without casting the entire object
          final userId = entry['uid']?.toString();
          final distance =
              double.tryParse(entry['distance']?.toString() ?? '0.0') ?? 0.0;

          if (userId == null) {
            print("Missing uid in recommendation result");
            continue;
          }

          final snap = await db.collection("users").doc(userId).get();

          if (snap.exists) {
            final user = AppUser.fromSnapshot(snap);
            print("User: ${user.firstName}, Distance: $distance");
            fetchedUsers.add(user);
          }
        } catch (e) {
          print("Error processing recommendation entry: $e");
          // Continue processing other entries even if one fails
          continue;
        }
      }

      // Apply filters if needed
      if (filterData.isNotEmpty) {
        List<AppUser> listFiltered = [];
        for (AppUser u in fetchedUsers) {
          if (!u.matchGenderPreference(filterData["genderPreferences"]) ||
              !u.matchAgePreference(filterData["ageRange"]) ||
              !u.hasInterests(filterData["mustHaveHobbies"]) ||
              !u.notHaveInterests(filterData["mustNotHaveHobbies"])) {
            listFiltered.add(u);
          }
        }
        for (AppUser x in listFiltered) {
          fetchedUsers.remove(x);
        }
      }

      setState(() {
        recommendedUsers = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      print("Error parsing data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProfiles();
    ExploreScreen.shouldReload.addListener(() {
      if (ExploreScreen.shouldReload.value) {
        if (mounted) {
          setState(() {
            profileIndex += 1;
          });
          ExploreScreen.shouldReload.value = false;
        }
      }
    });
  }

  void _switchToNextProfile() {
    recommendedUsers.remove(recommendedUsers[profileIndex]);
  }

  void _navigateToMoreProfile() {
    if (recommendedUsers.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreProfileScreen(
          uid: recommendedUsers[profileIndex].uid,
          name: recommendedUsers[profileIndex].firstName,
          age: recommendedUsers[profileIndex].age.toString(),
          major: recommendedUsers[profileIndex].major,
          bio: recommendedUsers[profileIndex].bio,
          displayedInterests: recommendedUsers[profileIndex].displayedInterests,
          showHeight: recommendedUsers[profileIndex].showHeight,
          heightUnit: recommendedUsers[profileIndex].heightUnit,
          viewerHeightUnit: curUser!.heightUnit, // ✅ Add this
          heightValue: recommendedUsers[profileIndex].heightValue,
          photosURL: recommendedUsers[profileIndex].photoVisible
              ? recommendedUsers[profileIndex].photosURL
              : [],
          pfpLink: recommendedUsers[profileIndex].profilePictureURL,
          viewerUid: curUser!.uid,
          isMatchViewer: false,
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
                    recommendedUsers[profileIndex].firstName,
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
                value: selectedReportReasonIdx,
                onChanged: (value) {
                  setState(() {
                    selectedReportReasonIdx = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Why do you want to report this profile?',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  ...reportReasons.entries.map((entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
                ],
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
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('reports').add({
                        'type': 'USER',
                        'target': recommendedUsers[profileIndex].uid,
                        'description': reportReasons[selectedReportReasonIdx],
                        'createdAt': FieldValue.serverTimestamp(),
                      });
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
    if (recommendedUsers.isEmpty) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('user-profileRating-rateProfile');
      await callable.call({"targetUid": recommendedUsers[profileIndex].uid, "score": sliderValue});
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NonNegotiablesFormScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : recommendedUsers.isEmpty
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NonNegotiablesFilterScreen()));
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
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text("Why am I seeing this profile?"),
                                                content: Text(getSimilarity(recommendedUsers[profileIndex])),
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
                                            recommendedUsers[profileIndex].profilePictureURL.isNotEmpty
                                                ? recommendedUsers[profileIndex].profilePictureURL
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
                                            recommendedUsers[profileIndex].firstName,
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
                                            recommendedUsers[profileIndex].age.toString(),
                                            style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF5E77DF)),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text("|", style: TextStyle(color: Color(0xFF2C519C))),
                                          const SizedBox(width: 10),
                                          ProtectedText(
                                            recommendedUsers[profileIndex].major,
                                            style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF5E77DF)),
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
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C519C)),
                                    ),
                                    const SizedBox(height: 5),
                                    ProtectedText(
                                      recommendedUsers[profileIndex].bio,
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
        bottomNavigationBar: recommendedUsers.isEmpty
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
