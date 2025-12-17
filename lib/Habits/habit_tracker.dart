import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "./CalenderScreen.dart";
import 'habit_controller.dart';
import "../Components/ProfileScreen.dart";
import '../widgets/badge_display.dart';

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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.chevron_right, color: Colors.white, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Dynamic Date Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Obx(() {
                final today = DateTime.now();
                final startOfWeek =
                today.subtract(Duration(days: today.weekday - 1)); // Monday start
                final days =
                List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: days.map((day) {
                    final isSelected =
                    DateUtils.isSameDay(day, controller.selectedDate.value);
                    final dayLabel = DateFormat('E').format(day).substring(0, 1);
                    final dateLabel = day.day.toString();

                    return GestureDetector(
                      onTap: () => controller.selectedDate.value = day,
                      child: _DateItem(
                        day: dayLabel,
                        date: dateLabel,
                        isSelected: isSelected,
                      ),
                    );
                  }).toList(),
                );
              }),
            ),

            // 🔹 XP and Badge Display
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => Row(
                children: [
                  Icon(Icons.stars, color: Colors.yellow, size: 20),
                  SizedBox(width: 8),
                  Text('XP: ${controller.totalXP.value}', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Icon(Icons.military_tech, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text('${controller.unlockedBadges.length}/${HabitTrackerController.allBadges.length} Badges', 
                    style: TextStyle(color: Colors.white)),
                ],
              )),
            ),

            // 🔹 Habits list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                    () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.habits.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final habit = controller.habits[index];
                    return _buildHabitItem(habit);
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔹 Floating Add Button
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

      // 🔹 Bottom Navigation Bar
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
              onTap: () => Get.to(() => const CalendarScreen()),
              child: _buildBottomNavItem(Icons.calendar_today, false),
            ),
            GestureDetector(
              onTap: () => Get.to(() => ProfileScreen()),
              child: _buildBottomNavItem(Icons.settings, false),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Static Colors
  static const List<Color> gradientColors = [Color(0xFF6875DE), Color(0xFF7353AE)];

  // 🔹 Date Widget
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
            border: Border.all(
              color:
              isSelected ? const Color(0xFFFF6B6B) : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
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

  // 🔹 Habit Tile
  Widget _buildHabitItem(HabitItem habit) {
    return Container(
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
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Icon(habit.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),

          // Info
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
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                ),
                Obx(() => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '🔥 Streak: ${habit.streak.value} days',
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

          // Actions: Complete / Edit / Delete
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Toggle Complete
              Obx(() => GestureDetector(
                onTap: () => controller.toggleHabitCompletion(habit.id),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: habit.isCompleted.value
                        ? const Color(0xFF4ECDC4)
                        : const Color(0xFF48484A),
                    border: Border.all(
                      color: habit.isCompleted.value
                          ? const Color(0xFF4ECDC4)
                          : Colors.grey.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: habit.isCompleted.value
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              )),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                onPressed: () => controller.openEditHabit(habit),
                tooltip: 'Edit Habit',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 20),
                onPressed: () => controller.removeHabit(habit.id),
                tooltip: 'Delete Habit',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Bottom Nav Item
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
