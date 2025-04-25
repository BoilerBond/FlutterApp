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

    String timeRemainingText = '';
    if (lastInteractionDate != null && currentStreak > 0) {
      final expiryTime = lastInteractionDate!.add(const Duration(hours: 24));
      final remaining = expiryTime.difference(DateTime.now());
      
      if (remaining.isNegative) {
        timeRemainingText = 'Expired';
      } else if (remaining.inHours > 0) {
        timeRemainingText = '${remaining.inHours}h ${remaining.inMinutes % 60}m left';
      } else {
        timeRemainingText = '${remaining.inMinutes}m left';
      }
    }
    
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: streakColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: streakColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "🔥",
                  style: TextStyle(
                    fontSize: 28,
                    color: currentStreak > 0 ? null : Colors.grey.withOpacity(0.7),
                  ),
                ),
                Positioned(
                  child: Text(
                    currentStreak.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black54,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentStreak == 1 ? "1 day streak" : "$currentStreak day streak",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: streakColor,
                  ),
                ),
                if (timeRemainingText.isNotEmpty)
                  Text(
                    timeRemainingText,
                    style: TextStyle(
                      fontSize: 11,
                      color: isStreakAboutToExpire ? Colors.orange.shade700 : Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}