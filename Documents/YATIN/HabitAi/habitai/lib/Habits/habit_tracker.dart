import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "./CalenderScreen.dart";
import 'habit_controller.dart';
import "../Components/ProfileScreen.dart";
import '../widgets/badge_display.dart';
import '../theme/app_theme.dart';

class HabitTrackerScreen extends GetView<HabitTrackerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onBackground, size: 30),
        title: Text(
          'Today',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onBackground, size: 30),
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
                        context,
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
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).cardColor,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Obx(() => Row(
            //     children: [
            //       const Icon(Icons.stars, color: Colors.yellow, size: 20),
            //       const SizedBox(width: 8),
            //       Text('XP: ${controller.totalXP.value}', 
            //         style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            //       const Spacer(),
            //       const Icon(Icons.military_tech, color: Colors.orange, size: 20),
            //       const SizedBox(width: 8),
            //       Text('${controller.unlockedBadges.length}/${HabitTrackerController.allBadges.length} Badges', 
            //         style: Theme.of(context).textTheme.bodyLarge),
            //     ],
            //   )),
            // ),
            // 🔹 Habits list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                    () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.visibleHabits.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final habit = controller.visibleHabits[index];
                    return _buildHabitItem(context, habit);
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
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [AppColors.darkPrimary, AppColors.darkSecondary]
                : [AppColors.lightPrimary, AppColors.lightSecondary],
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
      // bottomNavigationBar: Container(
      //   height: 80,
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).scaffoldBackgroundColor,
      //     border: Border(
      //       top: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.5),
      //     ),
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       _buildBottomNavItem(context, Icons.home, true),
      //       GestureDetector(
      //         onTap: controller.navigateToProgress,
      //         child: _buildBottomNavItem(context, Icons.bar_chart, false),
      //       ),
      //       GestureDetector(
      //         onTap: controller.navigateToAIChat,
      //         child: _buildBottomNavItem(context, Icons.smart_toy, false),
      //       ),
      //       GestureDetector(
      //         onTap: () => Get.to(() => const CalendarScreen()),
      //         child: _buildBottomNavItem(context, Icons.calendar_today, false),
      //       ),
      //       GestureDetector(
      //         onTap: () => Get.to(() => ProfileScreen()),
      //         child: _buildBottomNavItem(context, Icons.settings, false),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // 🔹 Date Widget
  static Widget _DateItem(
    BuildContext context, {
    required String day,
    required String date,
    required bool isSelected,
  }) {
    return Column(
      children: [
        Text(
          day,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected 
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            border: Border.all(
              color: isSelected 
                  ? Theme.of(context).primaryColor
                  : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              date,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Habit Tile
  Widget _buildHabitItem(BuildContext context, HabitItem habit) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // color: Theme.of(context).cardColor,
        color: habit.color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: habit.isDynamic
            ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1)
            : Border.all(color: habit.color, width: 2),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: habit.color,
              // gradient: LinearGradient(
              //   colors: Theme.of(context).brightness == Brightness.dark
              //       ? [AppColors.darkPrimary, AppColors.darkSecondary]
              //       : [AppColors.lightPrimary, AppColors.lightSecondary],
              //   begin: Alignment.centerLeft,
              //   end: Alignment.centerRight,
              // ),
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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (habit.isDynamic)
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'AI',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
                Obx(() => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '🔥 Streak: ${habit.streak.value} days',
                    style: Theme.of(context).textTheme.bodySmall,
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
                        ? (Theme.of(context).brightness == Brightness.dark ? AppColors.darkSuccess : AppColors.lightSuccess)
                        : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: habit.isCompleted.value
                          ? (Theme.of(context).brightness == Brightness.dark ? AppColors.darkSuccess : AppColors.lightSuccess)
                          : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
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
                icon: Icon(Icons.edit, color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText, size: 20),
                onPressed: () => controller.openEditHabit(habit),
                tooltip: 'Edit Habit',
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkError : AppColors.lightError, size: 20),
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
  Widget _buildBottomNavItem(BuildContext context, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
        size: 24,
      ),
    );
  }
}