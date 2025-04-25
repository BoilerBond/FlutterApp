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

  List<Map<String, dynamic>> _pendingInvitations = [];
  bool _loadingInvitations = true;

  Future<void> getUserProfiles() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    final curUserSnapshot =
        await db.collection("users").doc(currentUser?.uid).get();
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
      _loadDateInvitations();

      final hasSeenIntro =
          curUserSnapshot.data()?['hasSeenMatchIntro'] ?? false;
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

  Future<void> _loadDateInvitations() async {
    if (curUser == null || match == null) return;
  
    setState(() {
      _loadingInvitations = true;
    });
  
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(curUser!.uid)
          .get();
      
      if (!userDoc.exists) {
        setState(() {
          _pendingInvitations = [];
          _loadingInvitations = false;
        });
        return;
      }
      
      final userData = userDoc.data();
      final datesData = userData?['dates'] as Map<String, dynamic>? ?? {};
      final matchDates = datesData[match!.uid] as Map<String, dynamic>? ?? {};
      
      final List<Map<String, dynamic>> invitations = [];
      
      // Process all dates with this match
      matchDates.forEach((dateId, dateData) {
        final data = dateData as Map<String, dynamic>;
        if (data['status'] == 'pending') {
          invitations.add({
            'id': dateId,
            'activity': data['activity'] ?? '',
            'location': data['location'] ?? '',
            'dateTime': (data['dateTime'] as Timestamp).toDate(),
            'notes': data['notes'] ?? '',
            'senderId': data['senderId'] ?? '',
            'receiverId': data['receiverId'] ?? '',
            'status': data['status'] ?? '',
            'sentByMe': data['senderId'] == curUser!.uid,
          });
        }
      });
      
      setState(() {
        _pendingInvitations = invitations;
        _pendingInvitations.sort((a, b) => (a['dateTime'] as DateTime).compareTo(b['dateTime'] as DateTime));
        _loadingInvitations = false;
      });
      
      print("Loaded ${_pendingInvitations.length} pending date invitations");
    } catch (e) {
      print('Error loading date invitations: $e');
      setState(() {
        _loadingInvitations = false;
      });
    }
  }
  
  Future<void> _proposeDateInvitation(
      String activity, String location, DateTime dateTime, String notes) async {
    if (curUser == null || match == null) return;
  
    try {
      // Your existing date creation code...
      
      // Make sure this line executes - add debug print to verify
      print('About to update streak from: $_currentStreak');
      await _updateStreak();
      print('Streak should now be: ${_currentStreak}');
  
      // Reload pending invitations
      _loadDateInvitations();
      _loadUpcomingDates();
  
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date invitation sent!')),
      );
    } catch (e) {
      print('Error creating date invitation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send date invitation')),
      );
    }
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
  
    // Don't reset the streak when canceling a date
    // The streak should remain intact
    print('Date canceled. Current streak remains at: $_currentStreak');
  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Date canceled successfully')),
    );
  
    // Note: we're intentionally not calling _loadStreakData() here
    // as that would reset the streak
  }
  
  void _handleCalendarTap() {
    if (_upcomingDates.isEmpty) {
      _showCreateDateDialog();
    } else {
      _showDateDetails(context);
    }
  }

  void _showCreateDateDialog() {
    final _activityCtrl  = TextEditingController();
    final _locationCtrl  = TextEditingController();
    final _notesCtrl     = TextEditingController();
    DateTime? _pickedDate;
    TimeOfDay? _pickedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create a Date'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _activityCtrl,
                    decoration: const InputDecoration(labelText: 'Activity'),
                  ),
                  TextField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(_pickedDate == null
                        ? 'Pick a date'
                        : DateFormat('EEE, MMM d, yyyy').format(_pickedDate!)),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (d != null) setState(() => _pickedDate = d);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(_pickedTime == null
                        ? 'Pick a time'
                        : _pickedTime!.format(context)),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) setState(() => _pickedTime = t);
                    },
                  ),
                  TextField(
                    controller: _notesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('SEND'),
                onPressed: () {
                  if (_activityCtrl.text.trim().isEmpty ||
                      _locationCtrl.text.trim().isEmpty ||
                      _pickedDate == null ||
                      _pickedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }
                  final combined = DateTime(
                    _pickedDate!.year,
                    _pickedDate!.month,
                    _pickedDate!.day,
                    _pickedTime!.hour,
                    _pickedTime!.minute,
                  );
                  _proposeDateInvitation(
                    _activityCtrl.text.trim(),
                    _locationCtrl.text.trim(),
                    combined,
                    _notesCtrl.text.trim(),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(DateFormat('EEE, MMM d, yyyy')
                              .format(selectedDate)),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
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

  void _showDateDetails(BuildContext context) {
    if (_upcomingDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No upcoming dates scheduled')),
      );
      return;
    }

    final upcomingDate = _upcomingDates.first;
    final DateTime dateTime = upcomingDate['dateTime'];
    final Duration timeUntil = dateTime.difference(DateTime.now());

    // Skip if the date is in the past
    if (timeUntil.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No upcoming dates scheduled')),
      );
      return;
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF5E77DF), size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Upcoming Date',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF5E77DF), width: 1),
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
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.event, size: 20, color: Color(0xFF5E77DF)),
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
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 20, color: Color(0xFF5E77DF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    upcomingDate['location'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Color(0xFF5E77DF)),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE, MMM d • h:mm a').format(dateTime),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (upcomingDate['notes'] != null) ...[
              const SizedBox(height: 16),
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
                    const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey),
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCancelDateDialog(upcomingDate['id']);
                    },
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
                    onPressed: () {
                      Navigator.pop(context);
                      _showPostponeDateDialog(upcomingDate['id']);
                    },
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
    );
  }

  Widget _buildDateTimeIndicator() {
    if (_upcomingDates.isEmpty) return const SizedBox.shrink();
    
    final upcomingDate = _upcomingDates.first;
    final DateTime dateTime = upcomingDate['dateTime'];
    final Duration timeUntil = dateTime.difference(DateTime.now());
    
    // Skip if the date is in the past
    if (timeUntil.isNegative) return const SizedBox.shrink();
    
    // Format time remaining
    String timeRemainingText;
    if (timeUntil.inDays > 0) {
      timeRemainingText = '${timeUntil.inDays} day${timeUntil.inDays != 1 ? 's' : ''}, ${timeUntil.inHours % 24} hour${(timeUntil.inHours % 24) != 1 ? 's' : ''}';
    } else if (timeUntil.inHours > 0) {
      timeRemainingText = '${timeUntil.inHours} hour${timeUntil.inHours != 1 ? 's' : ''}, ${timeUntil.inMinutes % 60} minute${(timeUntil.inMinutes % 60) != 1 ? 's' : ''}';
    } else {
      timeRemainingText = '${timeUntil.inMinutes} minute${timeUntil.inMinutes != 1 ? 's' : ''}';
    }
    
    return GestureDetector(
      onTap: () => _showDateDetails(context),
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF5E77DF), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: Color(0xFF5E77DF),
            ),
            const SizedBox(width: 6),
            Text(
              "Date in $timeRemainingText",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E77DF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMoodIcon(String moodId) {
    switch (moodId.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'romantic':
        return Icons.favorite;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'excited':
        return Icons.celebration;
      case 'tired':
        return Icons.bedtime;
      case 'stressed':
        return Icons.psychology;
      case 'angry':
        return Icons.mood_bad;
      default:
        return Icons.emoji_emotions;
    }
  }

  Color _getMoodColor(String moodId) {
    switch (moodId.toLowerCase()) {
      case 'happy':
        return Colors.amber;
      case 'romantic':
        return Colors.pink;
      case 'sad':
        return Colors.blueGrey;
      case 'excited':
        return Colors.purple;
      case 'tired':
        return Colors.indigo;
      case 'stressed':
        return Colors.orange;
      case 'angry':
        return Colors.red;
      default:
        return const Color(0xFF5E77DF);
    }
  }

  String _formatMood(String moodId) {
    if (moodId.isEmpty) return "Unknown";
    return moodId.substring(0, 1).toUpperCase() +
        moodId.substring(1).toLowerCase();
  }

  Future<void> getUserMood() async {
    if (curUser == null || match == null) return;
  
    try {
      final moodSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(match!.uid)
          .collection('moods')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
  
      if (moodSnapshot.docs.isNotEmpty) {
        final moodData = moodSnapshot.docs.first.data();
        setState(() {
          match!.currentMoodId = moodData['mood'] ?? '';
          match!.moodTimestamp = moodData['timestamp'] as Timestamp;
        });
      }
    } catch (e) {
      print('Error fetching user mood: $e');
    }
  }

  String _formatMoodAge(Timestamp timestamp) {
    final now = DateTime.now();
    final moodTime = timestamp.toDate();
    final difference = now.difference(moodTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }
  
  @override
  void initState() {
    super.initState();
    getUserProfiles();

    if (match != null) {
      _calculateNextBondDate();
      _startCountdownTimer();
      _loadStreakData();
      getUserMood();
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
    if (daysUntilNextMonday == 0)
      daysUntilNextMonday = 7; // If today is Monday, next bond is next Monday

    // Create next bond date (next Monday at midnight)
    _nextBondDate = DateTime(
      now.year,
      now.month,
      now.day + daysUntilNextMonday,
    ).subtract(
        Duration(hours: now.hour, minutes: now.minute, seconds: now.second));

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

  void _loadStreakData() async {
    // Don't reset streak if we already have a value (solves the cancellation issue)
    if (_currentStreak > 0) {
      // We already have a streak, don't reset it
      print('Keeping existing streak value: $_currentStreak');
      return;
    }
    
    // Only set to 0 if we don't have a streak yet (first load)
    setState(() {
      _currentStreak = 0;
      _lastInteractionDate = null;
      _isStreakAboutToExpire = false;
    });
    
    print('Initialized new streak: $_currentStreak');
  }
  
  // Helper method to ensure streak is initialized
  Future<void> _initializeStreakIfNeeded(Map<String, dynamic> userData) async {
    if (!userData.containsKey('streaks') || 
        !(userData['streaks'] as Map<String, dynamic>?)?[match!.uid] is Map) {
      
      // Initialize streak data for both users
      await FirebaseFirestore.instance
        .collection('users')
        .doc(curUser!.uid)
        .update({
          'streaks.${match!.uid}': {
            'currentStreak': 0,
            'streakBroken': false,
            'updatedAt': FieldValue.serverTimestamp(),
          }
        });

      await FirebaseFirestore.instance
        .collection('users')
        .doc(match!.uid)
        .update({
          'streaks.${curUser!.uid}': {
            'currentStreak': 0,
            'streakBroken': false,
            'updatedAt': FieldValue.serverTimestamp(),
          }
        });
        
      setState(() {
        _currentStreak = 0;
      });
    }
  }

  void _startStreakExpirationTimer() {
    if (_lastInteractionDate == null) return;

    // Calculate time until streak expires
    final expiryTime = _lastInteractionDate!.add(const Duration(hours: 24));
    final remaining = expiryTime.difference(DateTime.now());

    if (remaining.isNegative) {
      // Streak has already expired
      _checkAndResetStreak();
      return;
    }

    // Check every minute if we're close to expiration
    _streakExpirationTimer?.cancel();
    _streakExpirationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final timeRemaining = expiryTime.difference(DateTime.now());

      if (timeRemaining.isNegative) {
        // Streak expired
        _checkAndResetStreak();
        timer.cancel();
      } else if (timeRemaining.inHours <= 1 && !_isStreakAboutToExpire) {
        // About to expire, notify user
        setState(() {
          _isStreakAboutToExpire = true;
        });

        _showStreakExpirationWarning();
      }
    });
  }

  void _checkAndResetStreak() async {
    if (_lastInteractionDate == null || curUser == null || match == null) return;

    // Check if the streak has expired (no interaction in past 24 hours)
    final now = DateTime.now();
    final expiryTime = _lastInteractionDate!.add(const Duration(hours: 24));

    if (now.isAfter(expiryTime)) {
      // Reset streak
      try {
        await FirebaseFirestore.instance
          .collection('users')
          .doc(curUser!.uid)
          .update({
            'streaks.${match!.uid}.currentStreak': 0,
            'streaks.${match!.uid}.streakBroken': true,
            'streaks.${match!.uid}.updatedAt': FieldValue.serverTimestamp(),
          });

        // Also update match's streak data
        await FirebaseFirestore.instance
          .collection('users')
          .doc(match!.uid)
          .update({
            'streaks.${curUser!.uid}.currentStreak': 0,
            'streaks.${curUser!.uid}.streakBroken': true,
            'streaks.${curUser!.uid}.updatedAt': FieldValue.serverTimestamp(),
          });

        setState(() {
          _currentStreak = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your streak has ended! Start a new interaction to rebuild your streak.'),
            duration: Duration(seconds: 5),
          ),
        );
      } catch (e) {
        print('Error resetting streak: $e');
      }
    }
  }

  void _showStreakExpirationWarning() {
    if (!mounted) return;
  
    _showPushNotification(
      'Streak About to Expire!',
      'Your streak with ${match!.firstName} will expire in 1 hour! Interact with your match to keep it going.',
      isWarning: true,
    );
  }
  
  Future<void> _updateStreak() async {
    // Simple hardcoded solution - increment streak whenever called
    final newStreak = _currentStreak + 1;
    
    print('Incrementing streak from $_currentStreak to $newStreak');
    
    // Update UI immediately without Firebase
    setState(() {
      _currentStreak = newStreak;
      _lastInteractionDate = DateTime.now();
      _isStreakAboutToExpire = false;
    });
  
    // Show feedback to user with the new push notification style
    if (mounted) {
      _showPushNotification(
        'Streak Updated! 🔥',
        'Your streak with ${match?.firstName ?? 'your match'} is now $_currentStreak days!',
        isWarning: false,
      );
    }
  }

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
        leading: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Color(0xFF5E77DF)),
              onPressed: _handleCalendarTap,
            ),
            if (_upcomingDates.isNotEmpty)
              const Positioned(
                top: 10,
                right: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(width: 10, height: 10),
                ),
              ),
          ],
        ),
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
                            const Divider(
                                height: 20,
                                thickness: 1,
                                color: Color(0xFFE7EFEE)),
                            match == null
                                ? Text(
                                    "No bond available. Please participate in matching to obtain a bond.",
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  )
                                : (Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  showDialog<String>(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    AlertDialog(
                                                        title: const Text(
                                                            "Why was I matched with this profile?"),
                                                        content: Text(curUser!
                                                            .getMatchReason(
                                                                match!))),
                                              ),
                                              icon: Icon(Icons.info_outline),
                                            )
                                          ]),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: MediaQuery.of(context).size.width * 0.2,
                                                backgroundImage: match!.profilePictureURL.isEmpty
                                                    ? NetworkImage(
                                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                                    : NetworkImage(match!.profilePictureURL),
                                                backgroundColor: const Color(0xFFCDFCFF),
                                              ),
                                                                                            if (match!.currentMoodId.isNotEmpty && (match!.showMoodToMatches ?? true))
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
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
                                                        Icon(
                                                          _getMoodIcon(match!.currentMoodId),
                                                          size: 18,
                                                          color: _getMoodColor(match!.currentMoodId),
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          _formatMood(match!.currentMoodId),
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (match!.moodTimestamp != null && 
                                                            DateTime.now().difference(match!.moodTimestamp!.toDate()).inHours > 48)
                                                          const SizedBox(width: 4),
                                                          if (match!.moodTimestamp != null && 
                                                              DateTime.now().difference(match!.moodTimestamp!.toDate()).inHours > 48)
                                                            Tooltip(
                                                              message: 'Mood updated ${_formatMoodAge(match!.moodTimestamp!)}',
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
                                      Text(match!.firstName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                      const SizedBox(height: 8),
                                      Text("${match!.age} | ${match!.major}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                              color: Color(0xFF5E77DF))),
                                    
                                      if (!_loadingDates && _upcomingDates.isNotEmpty)
                                        _buildDateTimeIndicator(),
                                    
                                      const SizedBox(height: 16),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: TextButton(
                                                  onPressed:
                                                      _navigateToMoreProfile,
                                                  child:
                                                      const Text("View More"),
                                                ),
                                              ),
                                            ),
                                            const VerticalDivider(
                                                indent: 16, endIndent: 16),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: TextButton(
                                                  onPressed: () =>
                                                      _confirmUnbondDialog(
                                                          context),
                                                  child: const Text("Unbond"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("What you have in common:",
                                              style: TextStyle(fontSize: 16)),
                                          if (sharedTraits.isEmpty)
                                            const Text(
                                                "No traits in common yet.")
                                          else
                                            ...sharedTraits
                                                .map(
                                                    (trait) => Text("• $trait"))
                                                .toList(),
                                        ],
                                      ),

                                      const SizedBox(height: 12),
                                      StreakIndicator(
                                        currentStreak: _currentStreak,
                                        lastInteractionDate: _lastInteractionDate,
                                        isStreakAboutToExpire: _isStreakAboutToExpire,
                                      ),
                                      const SizedBox(height: 12),

                                      // Add streak testing buttons
                                      // Replace the existing buttons with these:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isStreakAboutToExpire = true;
                                                  _lastInteractionDate = DateTime.now().subtract(const Duration(hours: 23));
                                                });
                                                _showPushNotification(
                                                  'Streak About to Expire!',
                                                  'Your streak with ${match!.firstName} will expire in 1 hour! Send a message or plan a date to keep it going.',
                                                  isWarning: true,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                              ),
                                              child: const Text('Simulate Expiring Streak', style: TextStyle(fontSize: 12)),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _currentStreak = 0;
                                                  _lastInteractionDate = DateTime.now().subtract(const Duration(hours: 25));
                                                });
                                                _showPushNotification(
                                                  'Streak Ended',
                                                  'Your streak with ${match!.firstName} has ended! Start a new interaction to rebuild your streak.',
                                                  isWarning: true,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                              ),
                                              child: const Text('Simulate Missed Day', style: TextStyle(fontSize: 12)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Spotify Button
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            final spotifyUsername =
                                                match?.spotifyUsername;
                                            final String url = spotifyUsername !=
                                                        null &&
                                                    spotifyUsername.isNotEmpty
                                                ? "https://open.spotify.com/user/" +
                                                    spotifyUsername
                                                : "";
                                            _launchURL(url);
                                          },
                                          icon: Icon(Icons.music_note,
                                              color: match?.spotifyUsername !=
                                                          null &&
                                                      match!.spotifyUsername
                                                          .isNotEmpty
                                                  ? Colors.blueAccent
                                                  : Colors.grey),
                                          label: Text("Spotify",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: match?.spotifyUsername !=
                                                              null &&
                                                          match!.spotifyUsername
                                                              .isNotEmpty
                                                      ? Colors.blueAccent
                                                      : Colors.grey)),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              width: 1,
                                              color: match?.spotifyUsername !=
                                                          null &&
                                                      match!.spotifyUsername
                                                          .isNotEmpty
                                                  ? Colors.blueAccent
                                                  : Colors.grey,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),

                                      _buildActionButton(Icons.chat_bubble,
                                          "Go to our messages", () async {
                                        String rid = curUser!.roomID;

                                        if (rid.isEmpty) {
                                          rid = curUser!.uid + match!.uid;
                                          final roomRef = FirebaseFirestore
                                              .instance
                                              .collection("rooms")
                                              .doc(rid);

                                          // Only write an empty room if it doesn't exist
                                          final snap = await roomRef.get();
                                          if (!snap.exists) {
                                            await roomRef.set({
                                              "messages": [],
                                              "roomID": rid,
                                              "users": [
                                                curUser!.uid,
                                                match!.uid
                                              ],
                                            });
                                          }

                                          // Persist room ID to user document
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(curUser!.uid)
                                              .update({"roomID": rid});
                                          await FirebaseFirestore.instance.collection("users").doc(match!.uid).update({"roomID": rid});

                                          setState(() {
                                            curUser!.roomID = rid;
                                          });
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                user: curUser!,
                                                match: match!,
                                                roomID: rid),
                                          ),
                                        );
                                      }),
                                      _buildActionButton(Icons.favorite,
                                          "Relationship suggestions", () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RelationshipAdviceScreen(
                                                    user: curUser!,
                                                    match: match!),
                                          ),
                                        );
                                      }),
                                      _buildActionButton(
                                          Icons.info, "View Match Introduction",
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MatchIntroScreen(
                                              curUser: curUser!,
                                              match: match!,
                                            ),
                                          ),
                                        );
                                      }),
                                      const SizedBox(height: 15),
                                      const Divider(),
                                      const SizedBox(height: 5),

                                      // Keep Match Toggle
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: SwitchListTile(
                                          title: const Text(
                                              "Keep this match for next week",
                                              style: TextStyle(fontSize: 16)),
                                          subtitle: Text(
                                              keepMatchToggle
                                                  ? "You'll keep this match"
                                                  : "You'll get a new match next week",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey)),
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
                                        icon: const Icon(Icons.block,
                                            color: Colors.white),
                                        label: const Text("Block User",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'keepMatch': false});

    // Update local state
    setState(() {
      keepMatchToggle = false;
      isMatchUnbonded = true;
      if (curUser != null) {
        curUser!.keepMatch = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "You've unbonded from this user. You'll receive a new match next week")));
  }

  void _showIntroduction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MatchIntroScreen(curUser: curUser!, match: match!),
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

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'keepMatch': value});

      // Update local data model
      if (curUser != null) {
        curUser!.keepMatch = value;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value
              ? "You'll keep this match for next week"
              : "You'll receive a new match next week")));
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
                      const Text(":",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _buildCountdownUnit(
                          hours.toString().padLeft(2, '0'), "Hours"),
                      const SizedBox(width: 8),
                      const Text(":",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _buildCountdownUnit(
                          minutes.toString().padLeft(2, '0'), "Mins"),
                      const SizedBox(width: 8),
                      const Text(":",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _buildCountdownUnit(
                          seconds.toString().padLeft(2, '0'), "Secs"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                // Navigate to the dashboard with the explore tab (index 0) selected
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (route) => false,
                    arguments: {'initialIndex': 0});
              },
              icon: const Icon(Icons.explore),
              label: const Text("Explore Profiles"),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                Navigator.pushNamed(context, '/settings/blocked_profiles')
                    .then((_) {
                  // Refresh user data when returning from blocked profiles screen
                  getUserProfiles();
                });
              },
              icon: const Icon(Icons.settings),
              label: const Text("Manage Blocked Users"),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("User has been blocked")));
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                        child: Text(
                            "Profile goes against one of my non-negotiables."),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child:
                            Text("Profile appears to be fake or catfishing."),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text(
                            "Offensive content against community standards."),
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
void _showPushNotification(String title, String message, {bool isWarning = false}) {
  // Cancel any existing overlay
  _removeNotificationOverlay();
  
  // Create an overlay entry
  final overlay = Overlay.of(context);
  _notificationOverlay = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: 20,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF5E77DF), // Always use blue color
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isWarning ? Icons.warning_rounded : Icons.local_fire_department,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _removeNotificationOverlay,
                child: const Icon(
                  Icons.close,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  
  // Add the overlay to the screen
  overlay?.insert(_notificationOverlay!);
  
  // Auto-dismiss after 4 seconds
  Future.delayed(const Duration(seconds: 4), _removeNotificationOverlay);
}
OverlayEntry? _notificationOverlay;

void _removeNotificationOverlay() {
  _notificationOverlay?.remove();
  _notificationOverlay = null;
}
}
