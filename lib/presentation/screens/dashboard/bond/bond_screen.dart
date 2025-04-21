import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/presentation/screens/dashboard/explore/more_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../../data/entity/app_user.dart';
import 'chat.dart';
import 'match_intro_screen.dart';
import 'relationship_advice_screen.dart';
import '../../../widgets/streak_indicator.dart';

class BondScreen extends StatefulWidget {
  const BondScreen({super.key});

  @override
  State<BondScreen> createState() => _BondScreenState();
}

class _BondScreenState extends State<BondScreen> {
  final placeholder_match = "BP25avUQfZUVYNVLZ2Eoiw5jYlf1";
  AppUser? curUser;
  AppUser? match;
  bool isMatchBlocked = false;
  bool isMatchUnbonded = false;
  bool keepMatchToggle = true;
  bool loading = true;
  bool isAwaitingMatch = false;

  // Countdown timer variables
  Timer? _countdownTimer;
  Duration _timeUntilNextBond = Duration.zero;
  DateTime? _nextBondDate;

  List<Map<String, dynamic>> _upcomingDates = [];
  bool _loadingDates = true;

  Future<void> getUserProfiles() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final curUserSnapshot = await db.collection("users").doc(currentUser?.uid).get();
    AppUser user = AppUser.fromSnapshot(curUserSnapshot);
    //final matchSnapshot = await db.collection("users").doc(user.match).get();
    if (user.match.isNotEmpty) {
      final matchSnapshot = await db.collection("users").doc(user.match).get();
      final matchUser = AppUser.fromSnapshot(matchSnapshot);
      setState(() {
        curUser = user;
        match = matchUser;
        keepMatchToggle = user.keepMatch;
        isMatchBlocked = user.blockedUserUIDs.contains(matchUser.uid);
        isMatchUnbonded = !user.keepMatch;
      });
      _loadUpcomingDates();

      final hasSeenIntro = curUserSnapshot.data()?['hasSeenMatchIntro'] ?? false;
      if (!hasSeenIntro) {
        // Wait for build to finish
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showIntroduction(context);
        });

        await db.collection("users").doc(currentUser!.uid).update({
          'hasSeenMatchIntro': true,
        });
      }
    } else if (user.keepMatch) {
      // the user wanted a match but didnt get one
      setState(() {
        isAwaitingMatch = true;
      });
    }
  }

  Future<void> _loadUpcomingDates() async {
    if (curUser == null || match == null) return;
    
    setState(() {
      _loadingDates = true;
    });
    
    try {
      // hardcoded for now
      final now = DateTime.now();
      _upcomingDates = [
        {
          'id': 'sample-date-1',
          'activity': 'Coffee at Starbucks',
          'location': 'Chauncey Hill Mall, West Lafayette',
          'dateTime': now.add(const Duration(days: 2, hours: 3)),
          'senderId': match!.uid,
          'notes': 'Looking forward to our coffee date!',
        }
      ];
      print("Finished loading dates: $_upcomingDates");
    } catch (e) {
      print('Error loading upcoming dates: $e');
    } finally {
      setState(() {
        _loadingDates = false;
      });
    }
  }

  Widget _buildUpcomingDateSection() {
    if (_upcomingDates.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final upcomingDate = _upcomingDates.first;
    final DateTime dateTime = upcomingDate['dateTime'];
    final Duration timeUntil = dateTime.difference(DateTime.now());
    
    // Skip if the date is in the past
    if (timeUntil.isNegative) {
      return const SizedBox.shrink();
    }
    
    // Format time remaining
    String timeRemainingText;
    if (timeUntil.inDays > 0) {
      timeRemainingText = '${timeUntil.inDays} days, ${timeUntil.inHours % 24} hours';
    } else if (timeUntil.inHours > 0) {
      timeRemainingText = '${timeUntil.inHours} hours, ${timeUntil.inMinutes % 60} minutes';
    } else {
      timeRemainingText = '${timeUntil.inMinutes} minutes';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5E77DF), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF5E77DF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Upcoming Date',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'In $timeRemainingText',
                    style: const TextStyle(
                      color: Color(0xFF5E77DF),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.event,
                      size: 20,
                      color: Color(0xFF5E77DF),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        upcomingDate['activity'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                      color: Color(0xFF5E77DF),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        upcomingDate['location'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 20,
                      color: Color(0xFF5E77DF),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEEE, MMM d • h:mm a').format(dateTime),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                if (upcomingDate['notes'] != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            upcomingDate['notes'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showCancelDateDialog(upcomingDate['id']),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel Date'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showPostponeDateDialog(upcomingDate['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E77DF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Postpone'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDateDialog(String dateId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Date'),
        content: const Text(
          'Are you sure you want to cancel this date? This action cannot be undone and will notify your match.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              _cancelDate(dateId);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('YES, CANCEL'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelDate(String dateId) async {
    // Immediately update UI by removing the canceled date
    setState(() {
      _upcomingDates.removeWhere((date) => date['id'] == dateId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Date canceled successfully')),
    );
  
    // TODO: Implement Firestore update
    // try {
    //   await FirebaseFirestore.instance
    //       .collection('dateInvitations')
    //       .doc(dateId)
    //       .update({
    //     'status': 'canceled',
    //     'updatedAt': FieldValue.serverTimestamp(),
    //   });
    // } catch (e) {
    //   print('Error canceling date in database: $e');
    // }
  }

  void _showPostponeDateDialog(String dateId) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.now();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Postpone Date'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select a new date and time:'),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(DateFormat('EEE, MMM d, yyyy').format(selectedDate)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 8),
                          Text(selectedTime.format(context)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Combine date and time
                  final newDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  _postponeDate(dateId, newDateTime);
                  Navigator.of(context).pop();
                },
                child: const Text('CONFIRM'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _postponeDate(String dateId, DateTime newDateTime) async {
    try {
      // TODO: fix for Firestore
      // await FirebaseFirestore.instance
      //     .collection('dateInvitations')
      //     .doc(dateId)
      //     .update({
      //   'status': 'postponed',
      //   'dateTime': Timestamp.fromDate(newDateTime),
      //   'postponedTo': Timestamp.fromDate(newDateTime),
      //   'updatedAt': FieldValue.serverTimestamp(),
      // });
      
      setState(() {
        final index = _upcomingDates.indexWhere((date) => date['id'] == dateId);
        if (index != -1) {
          _upcomingDates[index]['dateTime'] = newDateTime;
          _upcomingDates[index]['postponedTo'] = newDateTime;
          _upcomingDates[index]['status'] = 'postponed';
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date postponed successfully')),
      );
    } catch (e) {
      print('Error postponing date: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to postpone date')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserProfiles();

    if (match != null) {
      _calculateNextBondDate();
      _startCountdownTimer();
      //_loadStreakData();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    //_streakExpirationTimer?.cancel();
    super.dispose();
  }

  void _calculateNextBondDate() {
    // Assuming new bonds are given every Monday at 12:00 AM
    final now = DateTime.now();
    final currentWeekday = now.weekday;

    // Calculate days until next Monday (weekday 1)
    int daysUntilNextMonday = (8 - currentWeekday) % 7;
    if (daysUntilNextMonday == 0) daysUntilNextMonday = 7; // If today is Monday, next bond is next Monday

    // Create next bond date (next Monday at midnight)
    _nextBondDate = DateTime(
      now.year,
      now.month,
      now.day + daysUntilNextMonday,
    ).subtract(Duration(hours: now.hour, minutes: now.minute, seconds: now.second));

    // Calculate time remaining
    _updateRemainingTime();
  }

  Widget _buildAwaitingMatchView() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const Icon(
                Icons.favorite_border,
                size: 72,
                color: Color(0xFF5E77DF),
              ),
              const SizedBox(height: 24),
              const Text(
                "Looking for your next match",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C519C),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "We're working on finding someone compatible with you and have moved you up in priority. Check back soon!",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),  
              const SizedBox(height: 32),
              
              // Suggestions container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE7EFEE), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "While you wait, you can:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                                      _buildSuggestionItem(
                    Icons.edit,
                    "Update your profile",
                    "Add more photos or update your bio",
                  ),
                    _buildSuggestionItem(
                      Icons.question_answer,
                      "Complete personality questions", 
                      "Help us match you more accurately",
                    ),
                    _buildSuggestionItem(
                      Icons.interests,
                      "Add more interests and hobbies",
                      "Expand your profile to attract better matches",
                    ),
                    _buildSuggestionItem(
                      Icons.swipe,
                      "Swipe on more profiles",
                      "Increase your visibility in our matching system",
                    ),
                    _buildSuggestionItem(
                      Icons.tune,
                      "Review your preferences",
                      "Adjust your matching criteria",
                    ),
                    _buildSuggestionItem(
                      Icons.update,
                      "Use the app regularly",
                      "Consistency improves your match quality",
                    ),
                    _buildSuggestionItem(
                      Icons.search,
                      "Explore other profiles",
                      "Browse potential matches",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSuggestionItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5E77DF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateRemainingTime() {
    if (_nextBondDate != null) {
      final now = DateTime.now();
      final remaining = _nextBondDate!.difference(now);
      setState(() {
        _timeUntilNextBond = remaining.isNegative ? Duration.zero : remaining;
      });
    }
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

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
                displayedInterests: match!.displayedInterests,
                showHeight: match!.showHeight,
                heightUnit: match!.heightUnit,
                viewerHeightUnit: curUser!.heightUnit,
                heightValue: match!.heightValue,
                photosURL: match!.photosURL,
                pfpLink: match!.profilePictureURL,
                spotifyUsername: match!.spotifyUsername,
                viewerUid: curUser!.uid,
                isMatchViewer: true,
              )),
    );
  }

  int _currentStreak = 0;
  DateTime? _lastInteractionDate;
  bool _isStreakAboutToExpire = false;
  Timer? _streakExpirationTimer;
  
  // void _loadStreakData() async {
  //   if (curUser == null || match == null) return;
    
  //   try {
  //     // Fetch streak data from user's document
  //     final userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(curUser!.uid)
  //       .get();
        
  //     if (userDoc.exists) {
  //       final userData = userDoc.data() as Map<String, dynamic>;
  //       // Check if there's a streaks map in the user data
  //       if (userData.containsKey('streaks')) {
  //         final streaks = userData['streaks'] as Map<String, dynamic>? ?? {};
  //         final matchStreakData = streaks[match!.uid] as Map<String, dynamic>?;
          
  //         if (matchStreakData != null) {
  //           setState(() {
  //             _currentStreak = matchStreakData['currentStreak'] ?? 0;
  //             _lastInteractionDate = matchStreakData['lastInteractionDate'] != null 
  //                 ? (matchStreakData['lastInteractionDate'] as Timestamp).toDate() 
  //                 : null;
              
  //             // Check if streak is about to expire
  //             if (_lastInteractionDate != null) {
  //               final expiryTime = _lastInteractionDate!.add(const Duration(hours: 24));
  //               final remaining = expiryTime.difference(DateTime.now());
  //               _isStreakAboutToExpire = remaining.inHours <= 1 && remaining.isNegative == false;
  //             }
  //           });
            
  //           // Start streak expiration timer
  //           _startStreakExpirationTimer();
  //         }
  //       } else {
  //         // If no streaks field exists yet, initialize it
  //         await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(curUser!.uid)
  //           .update({
  //             'streaks': {
  //               match!.uid: {
  //                 'currentStreak': 0,
  //                 'streakBroken': false,
  //                 'updatedAt': FieldValue.serverTimestamp(),
  //               }
  //             }
  //           });
          
  //         // Also initialize for match
  //         await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(match!.uid)
  //           .update({
  //             'streaks': {
  //               curUser!.uid: {
  //                 'currentStreak': 0,
  //                 'streakBroken': false,
  //                 'updatedAt': FieldValue.serverTimestamp(),
  //               }
  //             }
  //           });
  //       }
  //     }
  //   } catch (e) {
  //     print('Error loading streak data: $e');
  //   }
  // }
  
  // void _startStreakExpirationTimer() {
  //   if (_lastInteractionDate == null) return;
    
  //   // Calculate time until streak expires
  //   final expiryTime = _lastInteractionDate!.add(const Duration(hours: 24));
  //   final remaining = expiryTime.difference(DateTime.now());
    
  //   if (remaining.isNegative) {
  //     // Streak has already expired
  //     _checkAndResetStreak();
  //     return;
  //   }
    
  //   // Check every minute if we're close to expiration
  //   _streakExpirationTimer?.cancel();
  //   _streakExpirationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
  //     final timeRemaining = expiryTime.difference(DateTime.now());
      
  //     if (timeRemaining.isNegative) {
  //       // Streak expired
  //       _checkAndResetStreak();
  //       timer.cancel();
  //     } else if (timeRemaining.inHours <= 1 && !_isStreakAboutToExpire) {
  //       // About to expire, notify user
  //       setState(() {
  //         _isStreakAboutToExpire = true;
  //       });
        
  //       _showStreakExpirationWarning();
  //     }
  //   });
  // }
  
  // void _checkAndResetStreak() async {
  //   if (_lastInteractionDate == null || curUser == null || match == null) return;
    
  //   // Check if the streak has expired (no interaction in past 24 hours)
  //   final now = DateTime.now();
  //   final expiryTime = _lastInteractionDate!.add(const Duration(hours: 24));
    
  //   if (now.isAfter(expiryTime)) {
  //     // Reset streak
  //     try {
  //       await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(curUser!.uid)
  //         .update({
  //           'streaks.${match!.uid}.currentStreak': 0,
  //           'streaks.${match!.uid}.streakBroken': true,
  //           'streaks.${match!.uid}.updatedAt': FieldValue.serverTimestamp(),
  //         });
        
  //       // Also update match's streak data
  //       await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(match!.uid)
  //         .update({
  //           'streaks.${curUser!.uid}.currentStreak': 0,
  //           'streaks.${curUser!.uid}.streakBroken': true,
  //           'streaks.${curUser!.uid}.updatedAt': FieldValue.serverTimestamp(),
  //         });
        
  //       setState(() {
  //         _currentStreak = 0;
  //       });
        
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Your streak has ended! Start a new interaction to rebuild your streak.'),
  //           duration: Duration(seconds: 5),
  //         ),
  //       );
  //     } catch (e) {
  //       print('Error resetting streak: $e');
  //     }
  //   }
  // }
  
  // void _showStreakExpirationWarning() {
  //   if (!mounted) return;
    
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Your streak is about to expire! Interact with your match to keep it going.'),
  //       action: SnackBarAction(
  //         label: 'MESSAGE',
  //         onPressed: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ChatScreen(user: curUser!, match: match!),
  //             )
  //           );
  //         },
  //       ),
  //       duration: const Duration(seconds: 8),
  //     ),
  //   );
  // }
  
  // Future<void> _updateStreak() async {
  //   if (curUser == null || match == null) return;
    
  //   try {
  //     final userRef = FirebaseFirestore.instance.collection('users').doc(curUser!.uid);
  //     final userDoc = await userRef.get();
  //     final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      
  //     final streaks = userData['streaks'] as Map<String, dynamic>? ?? {};
  //     final matchStreakData = streaks[match!.uid] as Map<String, dynamic>? ?? {};
      
  //     final now = DateTime.now();
  //     final int currentStreak = matchStreakData['currentStreak'] ?? 0;
  //     final lastInteraction = matchStreakData['lastInteractionDate'] != null 
  //         ? (matchStreakData['lastInteractionDate'] as Timestamp).toDate() 
  //         : null;
      
  //     int newStreak = 1; // Default to 1 for new streaks
      
  //     if (lastInteraction != null) {
  //       final today = DateTime(now.year, now.month, now.day);
  //       final lastInteractionDay = DateTime(
  //         lastInteraction.year,
  //         lastInteraction.month,
  //         lastInteraction.day,
  //       );
        
  //       // If last interaction was yesterday or earlier today, continue streak
  //       if (today.difference(lastInteractionDay).inDays <= 1) {
  //         // Only increment if it's a new day
  //         newStreak = today.isAfter(lastInteractionDay) 
  //             ? currentStreak + 1
  //             : currentStreak;
  //       }
  //     }
      
  //     // Update user's streak data
  //     await userRef.update({
  //       'streaks.${match!.uid}.currentStreak': newStreak,
  //       'streaks.${match!.uid}.lastInteractionDate': Timestamp.fromDate(now),
  //       'streaks.${match!.uid}.streakBroken': false,
  //       'streaks.${match!.uid}.updatedAt': FieldValue.serverTimestamp(),
  //     });
      
  //     // Also update match's streak data
  //     await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(match!.uid)
  //       .update({
  //         'streaks.${curUser!.uid}.currentStreak': newStreak,
  //         'streaks.${curUser!.uid}.lastInteractionDate': Timestamp.fromDate(now),
  //         'streaks.${curUser!.uid}.streakBroken': false,
  //         'streaks.${curUser!.uid}.updatedAt': FieldValue.serverTimestamp(),
  //       });
      
  //     setState(() {
  //       _currentStreak = newStreak;
  //       _lastInteractionDate = now;
  //       _isStreakAboutToExpire = false;
  //     });
      
  //     // Restart the timer for streak expiration
  //     _startStreakExpirationTimer();
      
  //   } catch (e) {
  //     print('Error updating streak: $e');
  //   }
  // }
  
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Add a safety check for personalTraits
    List<String> sharedTraits = [];
    try {
      if (curUser!.personalTraits.isNotEmpty && match!.personalTraits.isNotEmpty) {
        sharedTraits = curUser!.getSharedTraits(match!);
      }
    } catch (e) {
      print("Error getting shared traits: $e");
    }
    return SafeArea(
        child: Scaffold(
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
      body: isMatchBlocked
          ? _buildBlockedView()
          : isAwaitingMatch
              ? _buildAwaitingMatchView()
          : isMatchUnbonded
              ? _buildUnbondedView()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16).copyWith(top: 0),
                    child: Column(
                      children: [
                        const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),
                        match == null
                            ? Text(
                                "No bond available. Please participate in matching to obtain a bond.",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              )
                            : (Column(
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    IconButton(
                                      onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) => AlertDialog(title: const Text("Why was I matched with this profile?"), content: Text(curUser!.getMatchReason(match!))),
                                      ),
                                      icon: Icon(Icons.info_outline),
                                    )
                                  ]),
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.2,
                                    backgroundImage: match!.profilePictureURL.isEmpty
                                        ? NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                        : NetworkImage(match!.profilePictureURL),
                                    backgroundColor: const Color(0xFFCDFCFF),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(match!.firstName, style: Theme.of(context).textTheme.headlineMedium),
                                  const SizedBox(height: 8),
                                  Text("${match!.age} | ${match!.major}", style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Color(0xFF5E77DF))),
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("What you have in common:", style: TextStyle(fontSize: 16)),
                                      if (sharedTraits.isEmpty) const Text("No traits in common yet.") else ...sharedTraits.map((trait) => Text("• $trait")).toList(),
                                    ],
                                  ),
                                  // const SizedBox(height: 12),
                                  // StreakIndicator(
                                  //   currentStreak: _currentStreak,
                                  //   lastInteractionDate: _lastInteractionDate,
                                  //   isStreakAboutToExpire: _isStreakAboutToExpire,
                                  // ),
                                  const SizedBox(height: 8),
                                  // Spotify Button
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        final spotifyUsername = match?.spotifyUsername;
                                        final String url = spotifyUsername != null && spotifyUsername.isNotEmpty ? "https://open.spotify.com/user/" + spotifyUsername : "";
                                        _launchURL(url);
                                      },
                                      icon: Icon(Icons.music_note, color: match?.spotifyUsername != null && match!.spotifyUsername.isNotEmpty ? Colors.blueAccent : Colors.grey),
                                      label:
                                          Text("Spotify", style: TextStyle(fontSize: 16, color: match?.spotifyUsername != null && match!.spotifyUsername.isNotEmpty ? Colors.blueAccent : Colors.grey)),
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

                                  _buildActionButton(Icons.chat_bubble, "Go to our messages", () async {
                                    //await _updateStreak();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(user: curUser!, match: match!),
                                      )
                                    );
                                  }),
                                  _buildActionButton(Icons.favorite, "Relationship suggestions", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RelationshipAdviceScreen(user: curUser!, match: match!),
                                      ),
                                    );
                                  }),
                                  _buildActionButton(Icons.info, "View Match Introduction", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MatchIntroScreen(
                                          curUser: curUser!,
                                          match: match!,
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 15),
                                  _buildUpcomingDateSection(),

                                  const SizedBox(height: 15),
                                  const Divider(),
                                  const SizedBox(height: 5),

                                  // Keep Match Toggle
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: SwitchListTile(
                                      title: const Text("Keep this match for next week", style: TextStyle(fontSize: 16)),
                                      subtitle: Text(keepMatchToggle ? "You'll keep this match" : "You'll get a new match next week", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      value: keepMatchToggle,
                                      activeColor: const Color(0xFF5E77DF),
                                      onChanged: (bool value) {
                                        _updateKeepMatch(value);
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 16),

                                  // Block User Button
                                  ElevatedButton.icon(
                                    onPressed: _confirmBlockUser,
                                    icon: const Icon(Icons.block, color: Colors.white),
                                    label: const Text("Block User", style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    ),
                                  ),
                                ],
                              )),
                      ],
                    ),
                  ),
                ),
    ));
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

  Future<void> _unbond() async {
    if (curUser == null || match == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Update Firebase to indicate the user doesn't want to keep the match
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'keepMatch': false});

    // Update local state
    setState(() {
      keepMatchToggle = false;
      isMatchUnbonded = true;
      if (curUser != null) {
        curUser!.keepMatch = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You've unbonded from this user. You'll receive a new match next week")));
  }

  void _showIntroduction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchIntroScreen(curUser: curUser!, match: match!),
      ),
    );
  }

  Future<void> _updateKeepMatch(bool value) async {
    setState(() {
      keepMatchToggle = value;
    });

    if (curUser != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'keepMatch': value});

      // Update local data model
      if (curUser != null) {
        curUser!.keepMatch = value;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value ? "You'll keep this match for next week" : "You'll receive a new match next week")));
    }
  }

  // Shows the unbonded view
  Widget _buildUnbondedView() {
    // Format the countdown timer values for display
    final days = _timeUntilNextBond.inDays;
    final hours = _timeUntilNextBond.inHours % 24;
    final minutes = _timeUntilNextBond.inMinutes % 60;
    final seconds = _timeUntilNextBond.inSeconds % 60;

    // Format the next bond date for display
    String formattedDate = '';
    if (_nextBondDate != null) {
      final DateFormat formatter = DateFormat('EEEE, MMMM d');
      formattedDate = formatter.format(_nextBondDate!);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.link_off,
              size: 72,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              "You've unbonded from this user",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "You'll receive a new match next week.",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Countdown timer container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF5E77DF), width: 1),
              ),
              child: Column(
                children: [
                  const Text(
                    "Your next bond will be available on:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C519C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C519C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Time remaining:",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2C519C),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Countdown display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountdownUnit(days.toString(), "Days"),
                      const SizedBox(width: 8),
                      const Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _buildCountdownUnit(hours.toString().padLeft(2, '0'), "Hours"),
                      const SizedBox(width: 8),
                      const Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _buildCountdownUnit(minutes.toString().padLeft(2, '0'), "Mins"),
                      const SizedBox(width: 8),
                      const Text(":", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _buildCountdownUnit(seconds.toString().padLeft(2, '0'), "Secs"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to the dashboard with the explore tab (index 0) selected
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false, arguments: {'initialIndex': 0});
              },
              icon: const Icon(Icons.explore),
              label: const Text("Explore Profiles"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shows the blocked user view
  Widget _buildBlockedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.block,
              size: 72,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              "You've blocked this user",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "This user will no longer appear in your matches. "
              "You can unblock users from your settings.",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to the blocked profiles screen and refresh data when returning
                Navigator.pushNamed(context, '/settings/blocked_profiles').then((_) {
                  // Refresh user data when returning from blocked profiles screen
                  getUserProfiles();
                });
              },
              icon: const Icon(Icons.settings),
              label: const Text("Manage Blocked Users"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Block the current match with confirmation
  Future<void> _blockUser() async {
    if (match == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Update Firestore
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "blockedUserUIDs": FieldValue.arrayUnion([match!.uid])
    });

    // Update local state
    setState(() {
      if (curUser != null) {
        curUser!.blockedUserUIDs.add(match!.uid);
      }
      isMatchBlocked = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User has been blocked")));
  }

  // Show confirmation dialog before blocking
  Future<void> _confirmBlockUser() async {
    if (match == null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User?"),
        content: Text("Are you sure you want to block ${match!.firstName}? \n\n"
            "Blocked users won't appear in your explore feed, matches, or be able to contact you."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("BLOCK", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _blockUser();
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

  // Helper method to build each countdown unit (days, hours, minutes, seconds)
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
                    onChanged: (value) {},
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
