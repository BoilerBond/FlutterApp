import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/entity/app_user.dart';
import 'package:cloud_functions/cloud_functions.dart';

class EventRoomScreen extends StatefulWidget {
  const EventRoomScreen({super.key});

  @override
  State<EventRoomScreen> createState() => _EventRoomScreenState();
}

class _EventRoomScreenState extends State<EventRoomScreen> {
  AppUser? curUser;
  AppUser? matchUser;
  bool hasSubmittedAnswer = false;
  bool hasSubmittedGuess = false;
  int? rankPercentile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final db = FirebaseFirestore.instance;

    // Load current user
    final userSnap = await db.collection("users").doc(uid).get();
    AppUser user = AppUser.fromSnapshot(userSnap);

    AppUser? match;

    // Load match user
    if (user.match.isNotEmpty) {
      final matchSnap = await db.collection("users").doc(user.match).get();
      match = AppUser.fromSnapshot(matchSnap);

      // If current user hasn't initiated the event, but match has
      if (user.currentEventQuestion == null &&
          match.currentEventQuestion != null) {
        user = AppUser(
          uid: user.uid,
          username: user.username,
          purdueEmail: user.purdueEmail,
          firstName: user.firstName,
          lastName: user.lastName,
          bio: user.bio,
          major: user.major,
          college: user.college,
          gender: user.gender,
          age: user.age,
          priorityLevel: user.priorityLevel,
          profilePictureURL: user.profilePictureURL,
          photosURL: user.photosURL,
          blockedUserUIDs: user.blockedUserUIDs,
          displayedInterests: user.displayedInterests,
          profileVisible: user.profileVisible,
          photoVisible: user.photoVisible,
          interestsVisible: user.interestsVisible,
          matchResultNotificationEnabled: user.matchResultNotificationEnabled,
          messagingNotificationEnabled: user.messagingNotificationEnabled,
          eventNotificationEnabled: user.eventNotificationEnabled,
          keepMatch: user.keepMatch,
          instagramLink: user.instagramLink,
          facebookLink: user.facebookLink,
          spotifyUsername: user.spotifyUsername,
          showHeight: user.showHeight,
          heightUnit: user.heightUnit,
          heightValue: user.heightValue,
          showMajorToMatch: user.showMajorToMatch,
          showMajorToOthers: user.showMajorToOthers,
          showBioToMatch: user.showBioToMatch,
          showBioToOthers: user.showBioToOthers,
          showAgeToMatch: user.showAgeToMatch,
          showAgeToOthers: user.showAgeToOthers,
          showInterestsToMatch: user.showInterestsToMatch,
          showInterestsToOthers: user.showInterestsToOthers,
          showSocialMediaToMatch: user.showSocialMediaToMatch,
          showSocialMediaToOthers: user.showSocialMediaToOthers,
          match: user.match,
          nonNegotiables: user.nonNegotiables,
          longFormQuestion: user.longFormQuestion,
          longFormAnswer: user.longFormAnswer,
          personalTraits: user.personalTraits,
          partnerPreferences: user.partnerPreferences,
          weeksWithoutMatch: user.weeksWithoutMatch,
          hasSeenMatchIntro: user.hasSeenMatchIntro,
          showSpotifyToMatch: user.showSpotifyToMatch,
          showSpotifyToOthers: user.showSpotifyToOthers,
          showPhotosToMatch: user.showPhotosToMatch,
          showPhotosToOthers: user.showPhotosToOthers,
          ratedUsers: user.ratedUsers,
          currentEventQuestion: match.currentEventQuestion,
          currentEventPhase: match.currentEventPhase,
          currentEventAnswer: user.currentEventAnswer,
          currentEventGuess: user.currentEventGuess,
        );
      }

      // Auto-advance to "guessing" if both answered
      if (user.currentEventPhase == "answering" &&
          user.currentEventAnswer != null &&
          match.currentEventAnswer != null) {
        await db.collection("users").doc(uid).update({
          'currentEventPhase': 'guessing',
        });
        user =
            AppUser.fromSnapshot(await db.collection("users").doc(uid).get());
      }

      // Auto-advance to "completed" if user submitted answer
      if (user.currentEventPhase == "guessing" &&
          user.currentEventGuess != null) {
        await db.collection("users").doc(uid).update({
          'currentEventPhase': 'completed',
        });

        // Reload this user with updated phase
        user =
            AppUser.fromSnapshot(await db.collection("users").doc(uid).get());
      }
    }

    setState(() {
      curUser = user;
      matchUser = match;
      hasSubmittedAnswer = user.currentEventAnswer != null;
      hasSubmittedGuess = user.currentEventGuess != null;
    });

    if (user.currentEventPhase == "answering" && !hasSubmittedAnswer) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showAnswerPopup());
    } else if (user.currentEventPhase == "guessing" && !hasSubmittedGuess) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showGuessPopup());
    }
  }

  Future<void> _initiateEvent() async {
    if (curUser == null || matchUser == null) return;

    final questions = [
      "What’s your go-to comfort food?",
      "If you could travel anywhere right now, where would it be?",
      "What’s a movie you could watch over and over?",
      "What's your dream vacation?",
      "What's something people often misunderstand about you?",
    ];
    final selectedQuestion = (questions..shuffle()).first;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(curUser!.uid)
          .update({
        'currentEventQuestion': selectedQuestion,
        'currentEventPhase': 'answering',
        'currentEventAnswer': null,
        'currentEventGuess': null,
      });
      print("Event initiated by user: ${curUser!.uid}");
    } catch (e) {
      print("Failed to initiate event: $e");
    }

    // Refresh state to immediately reflect event data
    await _loadUserData();
  }

  Future<void> _showAnswerPopup() async {
    String answer = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Answer"),
        content: TextField(
          onChanged: (value) => answer = value,
          decoration: InputDecoration(hintText: curUser!.currentEventQuestion),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final db = FirebaseFirestore.instance;
              final uid = curUser!.uid;

              // Save current user's answer
              await db.collection("users").doc(uid).update({
                'currentEventAnswer': answer,
              });

              setState(() => hasSubmittedAnswer = true);
              Navigator.of(context).pop();

              // Load match's document to check their answer status
              final matchSnap =
                  await db.collection("users").doc(curUser!.match).get();
              final matchAnswered =
                  matchSnap.data()?['currentEventAnswer'] != null;

              // If both answered, move both to guessing phase
              if (matchAnswered) {
                await db.collection("users").doc(uid).update({
                  'currentEventPhase': 'guessing',
                });
              }

              await _loadUserData();
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  Future<void> _showGuessPopup() async {
    String userGuess = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Guess your match's answer"),
        content: TextField(
          onChanged: (value) => userGuess = value,
          decoration: InputDecoration(hintText: curUser!.currentEventQuestion),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final db = FirebaseFirestore.instance;
              final uid = curUser!.uid;
              final matchId = curUser!.match;

              // Save current user's guess
              await db.collection("users").doc(uid).update({
                'currentEventGuess': userGuess,
              });

              setState(() => hasSubmittedGuess = true);
              Navigator.of(context).pop();

              // Reload the updated user data
              await _loadUserData();

              // Fetch fresh data for both users
              final userSnap = await db.collection("users").doc(uid).get();
              final matchSnap = await db.collection("users").doc(matchId).get();
              final userData = userSnap.data();
              final matchData = matchSnap.data();

              final userCompletedGuess = userData?['currentEventGuess'] != null;
              final matchCompletedGuess =
                  matchData?['currentEventGuess'] != null;

              // If both guessed, compute and store scores
              if (userCompletedGuess && matchCompletedGuess) {
                final userAnswer = userData?['currentEventAnswer'] ?? "";
                final userGuessNow = userData?['currentEventGuess'] ?? "";

                final matchAnswer = matchData?['currentEventAnswer'] ?? "";
                final matchGuessNow = matchData?['currentEventGuess'] ?? "";

                // Compute similarity scores
                final userScore =
                    computeSimilarityScore(userGuessNow, matchAnswer);
                final matchScore =
                    computeSimilarityScore(matchGuessNow, userAnswer);
                final averageScore = ((userScore + matchScore) / 2).round();

                // Update matchScores field for both users
                await db.collection("users").doc(uid).update({
                  'matchScores.\$matchId': {
                    'userScore': userScore,
                    'matchScore': matchScore,
                    'averageScore': averageScore,
                  }
                });

                // Mark current user as completed
                await db.collection("users").doc(uid).update({
                  'currentEventPhase': 'completed',
                });

                // Reload current user
                await _loadUserData();
              }
            },
            child: Text("Submit Guess"),
          ),
        ],
      ),
    );
  }

  double computeSimilarityScore(String guess, String answer) {
    final guessWords = guess.toLowerCase().split(RegExp(r'\s+'));
    final answerWords = answer.toLowerCase().split(RegExp(r'\s+'));

    final matchCount =
        guessWords.where((word) => answerWords.contains(word)).length;
    final score = (matchCount / answerWords.length) * 100;
    return score.clamp(0, 100);
  }

  Future<void> _calculateRankLocally() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || curUser == null) return;

    final db = FirebaseFirestore.instance;
    final matchId = curUser!.match;
    if (matchId.isEmpty) return;

    // Get your current match average score
    final userSnap = await db.collection('users').doc(uid).get();
    final userData = userSnap.data();
    final userMatchScores = userData?['matchScores'] ?? {};
    final userMatchEntry = userMatchScores[matchId];
    final userAverageScore = userMatchEntry?['averageScore'];

    if (userAverageScore == null) {
      print('No match average score yet.');
      return;
    }

    // Fetch all users' match scores
    final allUsersSnap = await db.collection('users').get();
    List<num> allScores = [];

    for (var doc in allUsersSnap.docs) {
      final data = doc.data();
      final matchScores = data['matchScores'] ?? {};
      for (var scoreEntry in matchScores.values) {
        if (scoreEntry != null && scoreEntry['averageScore'] != null) {
          allScores.add(scoreEntry['averageScore']);
        }
      }
    }

    if (allScores.isEmpty) {
      print('No scores found.');
      return;
    }

    final betterThanOrEqual =
      allScores.where((score) => score <= userAverageScore).length;
    final percentile = ((betterThanOrEqual / allScores.length) * 100).round();

    setState(() {
      rankPercentile = percentile;
    });

    print('Your local match percentile: $percentile%');
  }

  Future<Widget> _buildEventContent() async {
    if (curUser == null || matchUser == null) {
      return Center(child: CircularProgressIndicator());
    }
    final db = FirebaseFirestore.instance;
    final question = curUser!.currentEventQuestion;
    final phase = curUser!.currentEventPhase;
    final matchPhase = matchUser!.currentEventPhase;
    final uid = curUser!.uid;
    final matchId = curUser!.match;

    if (phase == "completed" && matchPhase != "completed") {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You've completed the event!",
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 12),
            Text("Waiting for your match to finish..."),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserData,
              child: Text("Refresh"),
            )
          ],
        ),
      );
    }

    if (phase == "completed" && matchPhase == "completed") {
      final updatedUserDoc = await db.collection("users").doc(uid).get();
      final updatedScoreInfo = updatedUserDoc.data()?['matchScores']?[matchId];
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Event Complete!",
                style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 12),
            Text("You answered: ${curUser!.currentEventAnswer ?? ''}"),
            Text("They guessed: ${matchUser?.currentEventGuess ?? ''}"),
            SizedBox(height: 8),
            Text("They answered: ${matchUser?.currentEventAnswer ?? ''}"),
            Text("You guessed: ${curUser!.currentEventGuess ?? ''}"),
            SizedBox(height: 12),
            Text("Your Avg Match Score: ${updatedScoreInfo['averageScore']}%"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                final db = FirebaseFirestore.instance;

                await db.collection("users").doc(uid).update({
                  'currentEventQuestion': FieldValue.delete(),
                  'currentEventPhase': FieldValue.delete(),
                  'currentEventAnswer': FieldValue.delete(),
                  'currentEventGuess': FieldValue.delete(),
                });

                await _loadUserData();
              },
              child: Text("Refresh"),
            )
          ],
        ),
      );
    }

    if (question == null) {
      // Trigger percentile rank calculation
      final updatedUserDoc = await db.collection("users").doc(uid).get();
      final updatedScoreInfo = updatedUserDoc.data()?['matchScores']?[matchId];
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No current event."),
            SizedBox(height: 20),
            Text("Your Avg Match Score: ${updatedScoreInfo['averageScore']}%"),
            SizedBox(height: 20),
            if (rankPercentile != null)
              Text('Your Match Ranking: Top $rankPercentile%')
            else
              ElevatedButton(
                onPressed: _calculateRankLocally,
                child: const Text('View My Ranking'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initiateEvent,
              child: Text("Start a New Event"),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Event Ongoing!",
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),
          Text("Question: $question"),
          SizedBox(height: 20),
          if (phase == 'answering')
            hasSubmittedAnswer
                ? Text("You've answered! Waiting for your match...")
                : ElevatedButton(
                    onPressed: _showAnswerPopup,
                    child: Text("Answer Now"),
                  )
          else if (phase == 'guessing')
            hasSubmittedGuess
                ? Text("You've guessed! Waiting for your match...")
                : ElevatedButton(
                    onPressed: _showGuessPopup,
                    child: Text("Guess Now"),
                  )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Event Room"),
      ),
      body: FutureBuilder<Widget>(
        future: _buildEventContent(), // still async inside
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
