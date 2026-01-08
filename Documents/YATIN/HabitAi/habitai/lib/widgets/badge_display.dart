import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Habits/habit_controller.dart';

class BadgeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HabitTrackerController>();
    
    return Obx(() => Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.yellow),
              SizedBox(width: 8),
              Text('XP: ${controller.totalXP.value}', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          Text('Badges (${controller.unlockedBadges.length}/${HabitTrackerController.allBadges.length})', 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: HabitTrackerController.allBadges.map((badge) {
              final unlocked = controller.unlockedBadges.any((b) => b.id == badge.id);
              return Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: unlocked ? Colors.yellow.shade100 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                  border: unlocked ? Border.all(color: Colors.yellow, width: 2) : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(badge.emoji, style: TextStyle(fontSize: 24)),
                    SizedBox(height: 4),
                    Text(badge.name, 
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                    Text('${badge.streakRequired} days', 
                      style: TextStyle(fontSize: 8, color: Colors.grey)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ));
  }
}