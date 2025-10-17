
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';  // For potential date use
import "./CalenderScreen.dart";
import 'habit_controller.dart';
import "../Components/ProfileScreen.dart";

class HabitTrackerScreen extends GetView<HabitTrackerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        leading: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
        title: const Text(
          'Today',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.chevron_right, color: Colors.white, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date selector (hardcoded; future: wire to load per-date completions)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DateItem(day: 'M', date: '9', isSelected: false),
                  _DateItem(day: 'T', date: '10', isSelected: false),
                  _DateItem(day: 'W', date: '11', isSelected: true),
                  _DateItem(day: 'T', date: '12', isSelected: false),
                  _DateItem(day: 'F', date: '13', isSelected: false),
                  _DateItem(day: 'S', date: '14', isSelected: false),
                  _DateItem(day: 'S', date: '15', isSelected: false),
                ],
              ),
            ),
            // Habits list - Reactive via Obx
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.allHabits.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final habit = controller.allHabits[index];
                  return _buildHabitItem(
                    habit: habit,
                  );
                },
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: FloatingActionButton(
          onPressed: controller.navigateToCreateHabit,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(Icons.home, true),
            GestureDetector(
              onTap: controller.navigateToProgress,
              child: _buildBottomNavItem(Icons.bar_chart, false),
            ),
            GestureDetector(
              onTap: controller.navigateToAIChat,
              child: _buildBottomNavItem(Icons.smart_toy, false),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const CalendarScreen());
              },
              child: _buildBottomNavItem(Icons.calendar_today, false),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileScreen());
              },
              child: _buildBottomNavItem(Icons.settings, false),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for date items (static for now)
  static Widget _DateItem({
    required String day,
    required String date,
    required bool isSelected,
  }) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFFFF6B6B) : const Color(0xFF2C2C2E),
            border: isSelected
                ? Border.all(color: const Color(0xFFFF6B6B), width: 2)
                : Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
          ),
          child: Center(
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitItem({
    required HabitItem habit,
  }) {
    return GestureDetector(
      onTap: () => controller.toggleHabitCompletion(habit.id),
      onLongPress: habit.isDynamic
          ? () {
        Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFF2C2C2E),
            title: const Text(
              'Remove Habit',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Do you want to remove "${habit.title}"?',
              style: const TextStyle(color: Colors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  controller.removeDynamicHabit(habit.id);
                },
                child: const Text('Remove', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      }
          : null,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(16),
          border: habit.isDynamic
              ? Border.all(color: const Color(0xFF5A5CE6).withOpacity(0.5), width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Icon(
                habit.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          habit.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (habit.isDynamic)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5A5CE6).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'AI',
                            style: TextStyle(
                              color: Color(0xFF5A5CE6),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (habit.isDynamic)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: const Text(
                        'Long press to remove',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  // New: Streak display
                  Obx(() => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Streak: ${habit.streak.value}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            // Completion indicator (reactive)
            Obx(() => Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: habit.isCompleted.value ? const Color(0xFF4ECDC4) : const Color(0xFF48484A),
                border: Border.all(
                  color: habit.isCompleted.value
                      ? const Color(0xFF4ECDC4)
                      : Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: habit.isCompleted.value
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
                  : null,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: isSelected ? const Color(0xFF5A5CE6) : Colors.grey,
        size: 24,
      ),
    );
  }
}