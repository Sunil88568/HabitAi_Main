import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Habits/habit_controller.dart';
import '../widgets/badge_display.dart';

class BadgeTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HabitTrackerController>();
    
    return Scaffold(
      appBar: AppBar(title: Text('Badge System Test')),
      body: Column(
        children: [
          BadgeDisplay(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Test Badge System:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await controller.awardDailyXP();
                    Get.snackbar('XP Awarded', '+${HabitTrackerController.dailyCheckInXP} XP');
                  },
                  child: Text('Award Daily XP (+${HabitTrackerController.dailyCheckInXP})'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final badges = await controller.checkStreakAndAwardBadges(7);
                    if (badges.isNotEmpty) {
                      Get.snackbar('Badge Unlocked!', badges.first.name);
                    } else {
                      Get.snackbar('No New Badges', 'Badge already unlocked or streak too low');
                    }
                  },
                  child: Text('Test 7-Day Badge'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final badges = await controller.checkStreakAndAwardBadges(30);
                    if (badges.isNotEmpty) {
                      Get.snackbar('Badge Unlocked!', badges.first.name);
                    }
                  },
                  child: Text('Test 30-Day Badge'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final badges = await controller.checkStreakAndAwardBadges(365);
                    if (badges.isNotEmpty) {
                      Get.snackbar('Badge Unlocked!', badges.first.name);
                    }
                  },
                  child: Text('Test 365-Day Badge'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    controller.totalXP.value = 0;
                    controller.unlockedBadges.clear();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('total_xp');
                    await prefs.remove('unlocked_badges');
                    Get.snackbar('Reset', 'All badges and XP cleared');
                  },
                  child: Text('Reset All Badges & XP'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}