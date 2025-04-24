import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/constants/constants.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/view_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/entity/app_user.dart';
import 'long_form_questions_screen.dart';
import 'edit_traits.dart';

class Mood {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  const Mood({
    required this.id,
    required this.name, 
    required this.emoji,
    required this.color,
  });
}

class MoodData {
  static const List<Mood> moods = [
    Mood(id: 'happy', name: 'Happy', emoji: '😊', color: Color(0xFFFFF176)),
    Mood(id: 'excited', name: 'Excited', emoji: '🤩', color: Color(0xFFFFD54F)),
    Mood(id: 'relaxed', name: 'Relaxed', emoji: '😌', color: Color(0xFF81C784)),
    Mood(id: 'tired', name: 'Tired', emoji: '😴', color: Color(0xFF90CAF9)),
    Mood(id: 'sad', name: 'Sad', emoji: '😔', color: Color(0xFFBBDEFB)),
    Mood(id: 'anxious', name: 'Anxious', emoji: '😰', color: Color(0xFFE1BEE7)),
    Mood(id: 'angry', name: 'Angry', emoji: '😠', color: Color(0xFFEF9A9A)),
    Mood(id: 'romantic', name: 'Romantic', emoji: '❤️', color: Color(0xFFF8BBD0)),
  ];

  static Mood getMoodById(String id) {
    return moods.firstWhere(
      (mood) => mood.id == id,
      orElse: () => moods[0],
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imageURL = "";
  String? userName = "";
  String? bio = "";
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final List<String> questions = [
    'What are your long-term goals?',
    'What are your short-term goals?',
    'What kind of communication style do you have?',
    'How do you handle conflict in a relationship?',
    'What is your love language like?'
  ];
  
  // Mood-related state variables
  String? currentMoodId;
  Timestamp? moodTimestamp;
  bool showMoodToMatches = true;

  Future<void> getProfile() async {
    if (currentUser != null) {
      final userSnapshot =
          await db.collection("users").doc(currentUser?.uid).get();
      final user = AppUser.fromSnapshot(userSnapshot);
      
      final userData = userSnapshot.data() as Map<String, dynamic>?;
      
      setState(() {
        userName = "${user.firstName} ${user.lastName}";
        bio = user.bio;
        _imageURL = user.profilePictureURL;
        
        // Get mood data if available
        currentMoodId = userData?['currentMoodId'];
        moodTimestamp = userData?['moodTimestamp'] as Timestamp?;
        showMoodToMatches = userData?['showMoodToMatches'] ?? true;
      });
    } else {
      print("error getting current user using auth");
    }
  }

  // Update the user's mood
  Future<void> updateMood(String moodId) async {
    if (currentUser == null) return;
    
    setState(() {
      currentMoodId = moodId;
      moodTimestamp = Timestamp.now();
    });
    
    await db.collection("users").doc(currentUser!.uid).update({
      'currentMoodId': moodId,
      'moodTimestamp': Timestamp.now(),
      'showMoodToMatches': showMoodToMatches,
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood updated successfully')),
    );
  }
  
  // Toggle mood visibility to matches
  Future<void> toggleMoodVisibility() async {
    if (currentUser == null) return;
    
    final newVisibility = !showMoodToMatches;
    
    setState(() {
      showMoodToMatches = newVisibility;
    });
    
    await db.collection("users").doc(currentUser!.uid).update({
      'showMoodToMatches': newVisibility,
    });
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newVisibility 
            ? 'Your mood is now visible to matches' 
            : 'Your mood is now private'),
      ),
    );
  }
  

  // Widget for initial mood selector
  Widget _buildMoodSelector({bool showPrompt = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              showPrompt ? 'How are you feeling today?' : 'Current Mood',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your mood with your matches',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showMoodPicker(context),
              child: const Text('Set My Mood'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Show mood picker bottom sheet
  void _showMoodPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        bool localShowMoodToMatches = showMoodToMatches;
        
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your current mood to share with matches',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: MoodData.moods.length,
                      itemBuilder: (context, index) {
                        final mood = MoodData.moods[index];
                        return InkWell(
                          onTap: () {
                            // Update mood with the current visibility setting
                            updateMood(mood.id);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: mood.color.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: mood.color,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  mood.emoji,
                                  style: TextStyle(fontSize: 30),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mood.name,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Add visibility toggle
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              localShowMoodToMatches ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Show mood to matches',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: localShowMoodToMatches,
                          onChanged: (value) {
                            setModalState(() {
                              localShowMoodToMatches = value;
                            });
                            // Update the actual state variable
                            setState(() {
                              showMoodToMatches = value;
                            });
                            // Save the new visibility setting to Firestore
                            db.collection("users").doc(currentUser!.uid).update({
                              'showMoodToMatches': value,
                            });
                          },
                          activeColor: const Color(0xFF5E77DF),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {
        'title': 'Edit Profile',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/edit_profile");
        }
      },
      {
        'title': 'View Profile',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/view_profile");
        }
      },
      {
        'title': 'Profile Privacy',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/profile_privacy");
        }
      },
    ];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Welcome back, ${userName ?? ""}!",
                style: const TextStyle(height: 2, fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    backgroundImage: NetworkImage(
                      (_imageURL != null && _imageURL!.isNotEmpty)
                          ? _imageURL!
                          : Constants.defaultProfilePictureURL,
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                  if (currentMoodId != null && currentMoodId!.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _showMoodPicker(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(0xFF5E77DF),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    MoodData.getMoodById(currentMoodId!).emoji,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    MoodData.getMoodById(currentMoodId!).name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (moodTimestamp != null &&
                                      DateTime.now().difference(moodTimestamp!.toDate()).inHours > 48)
                                    const SizedBox(width: 4),
                                  if (moodTimestamp != null &&
                                      DateTime.now().difference(moodTimestamp!.toDate()).inHours > 48)
                                    Tooltip(
                                      message: 'Last updated: ${DateFormat('MMM d').format(moodTimestamp!.toDate())}',
                                      child: Icon(
                                        Icons.update,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (currentMoodId == null || currentMoodId!.isEmpty)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Tooltip(
                        message: 'Set your mood',
                        child: GestureDetector(
                          onTap: () => _showMoodPicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.emoji_emotions,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(bio ?? ""),
                ),
              ),
              const SizedBox(height: 16),              
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: buttons.map((btn) {
                  return TextButton(
                    onPressed: () => btn['onPressed'](context),
                    child: Text(btn['title']),
                  );
                }).toList(),
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: db.collection('users').doc(currentUser!.uid).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    int index = data['longFormQuestion'] ?? -1;
                    final question = (index >= 0 && index < questions.length)
                        ? questions[index]
                        : 'No question set';
                    final answer =
                        data['longFormAnswer'] ?? 'No answer provided';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Long Form Q&A:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Question: $question'),
                        const SizedBox(height: 8),
                        Text('Answer: $answer'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LongFormQuestionScreen(),
                              ),
                            );
                          },
                          child: const Text('Edit Long Form Questions'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Prompt of the day goes in here"),
                        SizedBox(height: 8),
                        TextField(
                          maxLines: 5,
                          minLines: 1,
                          style: TextStyle(height: 1),
                          decoration: InputDecoration(
                            hintText: "My answer...",
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build countdown unit for mood display
  Widget _buildCountdownUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF5E77DF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF454746),
          ),
        ),
      ],
    );
  }
}