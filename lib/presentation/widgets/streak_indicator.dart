import 'package:flutter/material.dart';

class StreakIndicator extends StatelessWidget {
  final int currentStreak;
  final DateTime? lastInteractionDate;
  final bool isStreakAboutToExpire;

  const StreakIndicator({
    Key? key,
    required this.currentStreak,
    this.lastInteractionDate,
    this.isStreakAboutToExpire = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streakColor = currentStreak > 0
        ? (isStreakAboutToExpire ? Colors.orange : const Color(0xFF5E77DF))
        : Colors.grey;

    String streakMessage = '';
    if (currentStreak == 0) {
      streakMessage = 'Start your streak by interacting today!';
    } else if (currentStreak == 1) {
      streakMessage = '1 day streak! Keep it going!';
    } else {
      streakMessage = '$currentStreak day streak! 🔥';
    }
    
    String timeRemainingText = '';
    if (lastInteractionDate != null && currentStreak > 0) {
      final expiryTime = lastInteractionDate!.add(const Duration(hours: 24));
      final remaining = expiryTime.difference(DateTime.now());
      
      if (remaining.isNegative) {
        timeRemainingText = 'Streak expired';
      } else if (remaining.inHours > 0) {
        timeRemainingText = '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining';
      } else {
        timeRemainingText = '${remaining.inMinutes}m remaining';
      }
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: streakColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: streakColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_fire_department,
                color: streakColor,
                size: 24, // Slightly smaller icon
              ),
              const SizedBox(width: 8),
              Flexible(  // Added Flexible to prevent overflow
                child: Text(
                  streakMessage,
                  style: TextStyle(
                    color: streakColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Slightly smaller text
                  ),
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
              ),
            ],
          ),
          if (timeRemainingText.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              timeRemainingText,
              style: TextStyle(
                color: isStreakAboutToExpire ? Colors.orange : Colors.grey,
                fontSize: 13, // Smaller font
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 6), // Smaller gap
          Text(
            'Interact daily to build your connection strength!',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12, // Smaller font
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}