import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Habits/habit_controller.dart';
import '../theme/app_theme.dart';


class HabitCard extends StatelessWidget {
  // Either reactive habit or static props
  final HabitItem? habit;
  final String? title;
  final IconData? icon;
  final Color? color;
  final bool? isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const HabitCard({
    super.key,
    this.habit,
    this.title,
    this.icon,
    this.color,
    this.isSelected,
    required this.onTap,
    this.onLongPress,
  }) : assert(habit != null || (title != null && icon != null && color != null));

  @override
  Widget build(BuildContext context) {
    final displayTitle = habit?.title ?? title!;
    final displayIcon = habit?.icon ?? icon!;
    final displayColor = habit?.isDynamic == true
        ? Theme.of(context).primaryColor
        : color ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: (habit?.isDynamic ?? false)
              ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [displayColor.withOpacity(0.8), displayColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Icon(displayIcon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (habit?.isDynamic ?? false)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  if (habit != null)
                    Obx(() => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Streak: ${habit!.streak.value}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )),
                ],
              ),
            ),
            if (habit != null)
              Obx(() => _buildCheck(context, habit!.isCompleted.value))
            else
              _buildCheck(context, isSelected ?? false),
          ],
        ),
      ),
    );
  }

  Widget _buildCheck(BuildContext context, bool completed) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed 
            ? (Theme.of(context).brightness == Brightness.dark ? AppColors.darkSuccess : AppColors.lightSuccess) 
            : Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: completed 
              ? (Theme.of(context).brightness == Brightness.dark ? AppColors.darkSuccess : AppColors.lightSuccess) 
              : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
          width: 2,
        ),
      ),
      child: completed ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
    );
  }
}