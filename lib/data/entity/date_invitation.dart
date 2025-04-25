import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DateInvitation {
  final String id;
  final String activity;
  final String location;
  final DateTime dateTime;
  final String senderId;
  final String receiverId;
  final String notes;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? postponedTo;

  DateInvitation({
    required this.id,
    required this.activity,
    required this.location, 
    required this.dateTime,
    required this.senderId,
    required this.receiverId,
    this.notes = '',
    this.status = 'accepted',
    this.createdAt,
    this.updatedAt,
    this.postponedTo,
  });

  // Create from Firestore document
  factory DateInvitation.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return DateInvitation(
      id: snapshot.id,
      activity: data['activity'] ?? 'Coffee date',
      location: data['location'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      notes: data['notes'] ?? '',
      status: data['status'] ?? 'accepted',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
      postponedTo: data['postponedTo'] != null 
          ? (data['postponedTo'] as Timestamp).toDate() 
          : null,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'activity': activity,
      'location': location,
      'dateTime': dateTime,
      'senderId': senderId,
      'receiverId': receiverId,
      'notes': notes,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      if (postponedTo != null) 'postponedTo': postponedTo,
    };
  }

  // Create a sample date for testing/preview
  static DateInvitation createSample({
    required String senderId,
    required String receiverId,
    DateTime? dateTime,
  }) {
    return DateInvitation(
      id: 'sample-date-${DateTime.now().millisecondsSinceEpoch}',
      activity: 'Coffee at Starbucks',
      location: 'Chauncey Hill Mall, West Lafayette',
      dateTime: dateTime ?? DateTime.now().add(const Duration(days: 2, hours: 3)),
      senderId: senderId,
      receiverId: receiverId,
      notes: 'Looking forward to our coffee date!',
      status: 'accepted',
      createdAt: DateTime.now(),
    );
  }
  
  // Create a copy with updated fields
  DateInvitation copyWith({
    String? activity,
    String? location,
    DateTime? dateTime,
    String? notes,
    String? status,
    DateTime? updatedAt,
    DateTime? postponedTo,
  }) {
    return DateInvitation(
      id: this.id,
      activity: activity ?? this.activity,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      senderId: this.senderId,
      receiverId: this.receiverId,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      postponedTo: postponedTo ?? this.postponedTo,
    );
  }
  
  // Format date for display
  String getFormattedDate() {
    return DateFormat('EEEE, MMMM d, y').format(dateTime);
  }
  
  // Format time for display
  String getFormattedTime() {
    return DateFormat('h:mm a').format(dateTime);
  }
  
  // Get full formatted date and time
  String getFullFormattedDateTime() {
    return DateFormat('EEEE, MMMM d • h:mm a').format(dateTime);
  }
  
  // Calculate time remaining until date
  Duration getTimeRemaining() {
    return dateTime.difference(DateTime.now());
  }
  
  // Get user-friendly time remaining text
  String getTimeRemainingText() {
    final timeUntil = getTimeRemaining();
    
    if (timeUntil.isNegative) {
      return "Past date";
    }
    
    if (timeUntil.inDays > 0) {
      return '${timeUntil.inDays} day${timeUntil.inDays > 1 ? 's' : ''}, ${timeUntil.inHours % 24} hour${(timeUntil.inHours % 24) != 1 ? 's' : ''}';
    } else if (timeUntil.inHours > 0) {
      return '${timeUntil.inHours} hour${timeUntil.inHours != 1 ? 's' : ''}, ${timeUntil.inMinutes % 60} minute${(timeUntil.inMinutes % 60) != 1 ? 's' : ''}';
    } else {
      return '${timeUntil.inMinutes} minute${timeUntil.inMinutes != 1 ? 's' : ''}';
    }
  }
  
  // Status check helpers
  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isDeclined => status == 'declined';
  bool get isCanceled => status == 'canceled';
  bool get isPostponed => status == 'postponed';
  
  // Time-related helpers
  bool get isPastDate => DateTime.now().isAfter(dateTime);
  bool get isToday => dateTime.day == DateTime.now().day && 
                        dateTime.month == DateTime.now().month && 
                        dateTime.year == DateTime.now().year;
  bool get isWithin24Hours => getTimeRemaining().inHours < 24 && !isPastDate;
  bool get isWithin1Hour => getTimeRemaining().inMinutes < 60 && !isPastDate;
  
  // UI helpers
  String getStatusBadgeText() {
    if (isPastDate) return 'Past';
    if (isCanceled) return 'Canceled';
    if (isDeclined) return 'Declined';
    if (isPostponed) return 'Postponed';
    if (isPending) return 'Awaiting Response';
    if (isWithin1Hour) return 'Starting Soon!';
    if (isToday) return 'Today';
    return 'Upcoming';
  }
  
  Color getStatusColor() {
    if (isPastDate) return Colors.grey;
    if (isCanceled) return Colors.red;
    if (isDeclined) return Colors.red.shade300;
    if (isPostponed) return Colors.orange;
    if (isPending) return Colors.amber;
    if (isWithin1Hour) return Colors.green.shade700;
    if (isToday) return Colors.green.shade500;
    return Colors.blue;
  }
  
  // Create a new invitation (static constructor)
  static Future<String> createInvitation({
    required String activity,
    required String location,
    required DateTime dateTime,
    required String senderId,
    required String receiverId,
    String notes = '',
  }) async {
    final db = FirebaseFirestore.instance;
    final docRef = await db.collection('dateInvitations').add({
      'activity': activity,
      'location': location,
      'dateTime': dateTime,
      'senderId': senderId,
      'receiverId': receiverId,
      'notes': notes,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    return docRef.id;
  }
  
  // Update status in Firestore
  Future<void> updateStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('dateInvitations')
        .doc(id)
        .update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Get list of upcoming dates between two users
  static Future<List<DateInvitation>> getUpcomingDatesBetweenUsers(
    String user1Id, 
    String user2Id
  ) async {
    final now = DateTime.now();
    final snapshot = await FirebaseFirestore.instance
        .collection('dateInvitations')
        .where('dateTime', isGreaterThan: now)
        .where(Filter.or(
          Filter.and(
            Filter('senderId', isEqualTo: user1Id),
            Filter('receiverId', isEqualTo: user2Id),
          ),
          Filter.and(
            Filter('senderId', isEqualTo: user2Id),
            Filter('receiverId', isEqualTo: user1Id),
          ),
        ))
        .orderBy('dateTime')
        .get();
        
    return snapshot.docs
        .map((doc) => DateInvitation.fromSnapshot(doc))
        .toList();
  }
  
  // Convert to/from Firebase array storage
  Map<String, dynamic> toUserArrayObject() {
    return {
      'id': id,
      'activity': activity,
      'location': location,
      'dateTime': Timestamp.fromDate(dateTime),
      'senderId': senderId,
      'receiverId': receiverId,
      'notes': notes,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'postponedTo': postponedTo != null ? Timestamp.fromDate(postponedTo!) : null,
    };
  }
  
  static DateInvitation fromUserArrayObject(Map<String, dynamic> data) {
    return DateInvitation(
      id: data['id'] ?? '',
      activity: data['activity'] ?? 'Coffee date',
      location: data['location'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      notes: data['notes'] ?? '',
      status: data['status'] ?? 'accepted',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
      postponedTo: data['postponedTo'] != null 
          ? (data['postponedTo'] as Timestamp).toDate() 
          : null,
    );
  }

  // User-based date operations
  static Future<void> addDateToUser(String userId, DateInvitation date) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'dates': FieldValue.arrayUnion([date.toUserArrayObject()])
    });
  }
  
  static Future<void> removeDateFromUser(String userId, String dateId) async {
    // First get the user to find the exact date object
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    
    final dates = userData['dates'] as List<dynamic>? ?? [];
    final dateToRemove = dates.firstWhere(
      (date) => date['id'] == dateId, 
      orElse: () => null
    );
    
    if (dateToRemove != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'dates': FieldValue.arrayRemove([dateToRemove])
      });
    }
  }
  
  static Future<List<DateInvitation>> getDatesForUser(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    
    final dates = userData['dates'] as List<dynamic>? ?? [];
    return dates.map((dateMap) => DateInvitation.fromUserArrayObject(dateMap)).toList();
  }

  // Generate unique ID for date
  static String generateDateId() {
    return 'date-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000000)}';
  }
}