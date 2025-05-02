import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datingapp/presentation/widgets/protected_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'more_profile.dart';
import '../../../../data/entity/app_user.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/non_negotiables_form_screen.dart';
import "events.dart";

class ExploreScreen extends StatefulWidget {
  static ValueNotifier<bool> shouldReload = ValueNotifier<bool>(false);
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<AppUser> visibleUsers = [];
  List<AppUser> recommendedUsers = [];
  int profileIndex = 0;
  double sliderValue = 0;
  bool isLoading = true;
  AppUser? curUser;
  Map<String, dynamic> nonnegotiablesData = {};
  bool filterOn = true;
  Map<int, String> reportReasons = {
    0: "Profile goes against one of my non-negotiables.",
    1: "Profile appears to be fake or catfishing.",
    2: "Offensive content against community standards."
  };
  int selectedReportReasonIdx = 0;
  bool showEventRoom = false;

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

  Future<void> getProfiles() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final userSnapshot =
    await db.collection("users").doc(currentUser?.uid).get();
    setState(() {
      curUser = AppUser.fromSnapshot(userSnapshot);
      nonnegotiablesData = curUser!.nonNegotiables;
    });

    final callable = FirebaseFunctions.instance
        .httpsCallable('user-recommendation-recommendProfiles');
    final result = await callable.call({'limit': 10});

    try {
      final List<dynamic> resultList = result.data as List<dynamic>;
      List<AppUser> fetchedUsers = [];

      for (final dynamic entry in resultList) {
        try {
          final userId = entry['uid']?.toString();
          final distance =
              double.tryParse(entry['distance']?.toString() ?? '0.0') ?? 0.0;
          if (userId == null || curUser!.ratedUsers.contains(userId)) continue;

          final snap = await db.collection("users").doc(userId).get();
          if (snap.exists) {
            final user = AppUser.fromSnapshot(snap);
            print("User: ${user.firstName}, Distance: $distance");
            fetchedUsers.add(user);
          }
        } catch (e) {
          print("Error processing recommendation entry: $e");
          continue;
        }
      }

      setState(() {
        visibleUsers = fetchedUsers;
        recommendedUsers = [];
      });
      filterNN();
    } catch (e) {
      print(e);
    }
  }

  void filterNN() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final userSnapshot =
    await db.collection("users").doc(currentUser?.uid).get();
    curUser = AppUser.fromSnapshot(userSnapshot);
    nonnegotiablesData = curUser!.nonNegotiables;
    List<AppUser> listFiltered = [];

    try {
      if (nonnegotiablesData.isNotEmpty) {
        for (AppUser u in visibleUsers) {
          if (!u.matchGenderPreference(
              nonnegotiablesData["genderPreferences"]) ||
              !u.matchAgePreference(nonnegotiablesData["ageRange"]) ||
              !u.hasInterests(nonnegotiablesData["mustHaveHobbies"]) ||
              !u.notHaveInterests(nonnegotiablesData["mustNotHaveHobbies"]) ||
              !u.matchMajor(nonnegotiablesData["majors"])) {
            continue;
          } else {
            listFiltered.add(u);
          }
        }
      }
      else listFiltered = visibleUsers;
      setState(() {
        recommendedUsers = listFiltered;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void filterRated(List<AppUser> users) {
    List<AppUser> result =
    users.where((u) => !curUser!.ratedUsers.contains(u.uid)).toList();
    setState(() {
      recommendedUsers = result;
    });
  }

  void _switchToNextProfile() {
    visibleUsers.remove(recommendedUsers[profileIndex]);
    recommendedUsers.removeAt(profileIndex);
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
          viewerHeightUnit: curUser!.heightUnit,
          heightValue: recommendedUsers[profileIndex].heightValue,
          photosURL: recommendedUsers[profileIndex].photoVisible
              ? recommendedUsers[profileIndex].photosURL
              : [],
          pfpLink: recommendedUsers[profileIndex].profilePictureURL,
          viewerUid: curUser!.uid,
          isMatchViewer: false,
          spotifyUsername: recommendedUsers[profileIndex].spotifyUsername ?? "",
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

  Future<void> _submitRating() async {
    if (recommendedUsers.isEmpty) return;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;
    final db = FirebaseFirestore.instance;

    try {
      final callable = FirebaseFunctions.instance
          .httpsCallable('user-profileRating-rateProfile');
      await callable.call({
        "targetUid": recommendedUsers[profileIndex].uid,
        "score": sliderValue
      });
      curUser!.ratedUsers.add(recommendedUsers[profileIndex].uid);
      await db
          .collection("users")
          .doc(curUser!.uid)
          .set({"ratedUsers": curUser!.ratedUsers}, SetOptions(merge: true));
      setState(() {
        sliderValue = 0;
      });
      _switchToNextProfile();
    } catch (e) {
      print("Failed to submit rating: \$e");
    }
  }

  String getSimilarity(AppUser user2) {
    final user1Traits = curUser!.personalTraits.values.toList();
    final user2Traits = user2.personalTraits.values.toList();
    int minIndex = 0;
    int minDiff = 10;
    for (int i = 0; i < 5; i++) {
      int diff = (user1Traits[i] - user2Traits[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        minIndex = i;
      }
    }
    final List<String> messages = [
      "have similar views on the importance of family.",
      "have similar levels of extroversion.",
      "have lifestyles with similar levels of physical activity.",
      "have similar views on trying new things and taking risks.",
      "perform similarly under pressure."
    ];
    return "You and ${user2.firstName} ${messages[minIndex]}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            showEventRoom ? "Event Room" : "Explore",
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w100,
              fontSize: 22,
              color: Color(0xFF454746),
            ),
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 40,
          actions: [
            IconButton(
              icon: Icon(showEventRoom ? Icons.explore : Icons.celebration,
                  color: Colors.black54),
              tooltip:
              showEventRoom ? 'Switch to Explore' : 'Switch to Event Room',
              onPressed: () {
                setState(() {
                  showEventRoom = !showEventRoom;
                });
              },
            )
          ],
        ),
        body: showEventRoom ? const EventRoomScreen() : _buildExploreBody(),
      ),
    );
  }

  Widget _buildExploreBody() {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Edit my non-negotiables",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => NonNegotiablesFormScreen()));
                      setState(() {
                        isLoading = true;
                      });
                      filterNN();
                    },
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                const Text(
                  "Filter by non-negotiables",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Switch(
                    value: filterOn,
                    activeColor: Colors.green,
                    onChanged: (bool v) {
                      setState(() {
                        isLoading = true;
                        filterOn = v;
                        if (filterOn) {
                          filterNN();
                        } else {
                          recommendedUsers = visibleUsers;
                        }
                        isLoading = false;
                      });
                    }),
              ]),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : recommendedUsers.isEmpty
                  ? Center(child: Text("No profiles available."))
                  : SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Divider(
                            height: 20,
                            thickness: 1,
                            color: Color(0xFFE7EFEE),
                          ),
                          SizedBox(height: 10),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              key: ValueKey(profileIndex),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Color(0xFFE7EFEE),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
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
                                            title: Text("Why am I seeing this profile?"),
                                            content: Text(getSimilarity(recommendedUsers[profileIndex])),
                                          ),
                                        ),
                                        icon: Icon(Icons.info_outline),
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
                                      backgroundColor: Color(0xFFCDFCFF),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ProtectedText(
                                        recommendedUsers[profileIndex].firstName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color(0xFF2C519C),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      IconButton(
                                        onPressed: _reportProfile,
                                        icon: const Icon(Icons.more_horiz, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        recommendedUsers[profileIndex].age.toString(),
                                        style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF5E77DF)),
                                      ),
                                      SizedBox(width: 10),
                                      Text("|", style: TextStyle(color: Color(0xFF2C519C))),
                                      SizedBox(width: 10),
                                      ProtectedText(
                                        recommendedUsers[profileIndex].major,
                                        style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF5E77DF)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color(0xFFCDFCFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "About:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C519C)),
                                ),
                                SizedBox(height: 5),
                                ProtectedText(
                                  recommendedUsers[profileIndex].bio,
                                  style: TextStyle(
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
              )
            ]),
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
