import 'package:flutter/material.dart';
import '../../../../data/entity/app_user.dart';

class MatchIntroScreen extends StatefulWidget {
  final AppUser curUser;
  final AppUser match;

  const MatchIntroScreen({Key? key, required this.curUser, required this.match}) : super(key: key);

  @override
  State<MatchIntroScreen> createState() => _MatchIntroScreenState();
}

class _MatchIntroScreenState extends State<MatchIntroScreen> {
  int _pageIndex = 0;

  void _nextPage() {
    setState(() {
      if (_pageIndex < 2) _pageIndex++;
    });
  }

  List<Widget> _buildPages() {
    return [
      // First page: Match Reason
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Why You Were Matched", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(getMatchReason(widget.curUser, widget.match), style: const TextStyle(fontSize: 16)),
        ],
      ),

      // Second page: Common traits
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What You Have in Common", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...widget.curUser.getSharedTraits(widget.match).map((trait) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("• $trait", style: const TextStyle(fontSize: 16)),
              )),
        ],
      ),

      // Third page: TODO: Match photos
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Get to Know Them", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();
    return Scaffold(
      appBar: AppBar(
        title: const Text("You're Matched!"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context), // Return Bond screen
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: pages[_pageIndex],
      ),
      bottomNavigationBar: (_pageIndex < pages.length - 1)
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C519C)),
                child: const Text("Next"),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C519C)),
                child: const Text("Done"),
              ),
            ),
    );
  }

  String getMatchReason(AppUser u1, AppUser u2) {
    final user1Traits = u1.personalTraits.values.toList();
    final user2Traits = u2.personalTraits.values.toList();
    int minIndex = 0;
    int minDiff = 10;
    for (int i = 0; i < 5; i++) {
      int diff = (user1Traits[i] - user2Traits[i]).abs();
      if (diff < minDiff) {
        minDiff = diff;
        minIndex = i;
      }
    }
    switch (minIndex) {
      case 0:
        return "You both value family highly.";
      case 1:
        return "You have similar levels of extroversion.";
      case 2:
        return "You both enjoy a similar pace of life.";
      case 3:
        return "You're both open to new experiences and taking risks.";
      case 4:
        return "You perform similarly under pressure.";
      default:
        return "You share some key personality traits.";
    }
  }
}
