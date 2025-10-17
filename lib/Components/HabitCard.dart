import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Habits/habit_controller.dart';

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
        ? const Color(0xFF5A5CE6)
        : color ?? const Color(0xFF2C2C2E);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(16),
          border: (habit?.isDynamic ?? false)
              ? Border.all(color: const Color(0xFF5A5CE6).withOpacity(0.5), width: 1)
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
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (habit?.isDynamic ?? false)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  if (habit != null)
                    Obx(() => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Streak: ${habit!.streak.value}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    )),
                ],
              ),
            ),
            if (habit != null)
              Obx(() => _buildCheck(habit!.isCompleted.value))
            else
              _buildCheck(isSelected ?? false),
          ],
        ),
      ),
    );
  }

  Widget _buildCheck(bool completed) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? const Color(0xFF4ECDC4) : const Color(0xFF48484A),
        border: Border.all(
          color: completed ? const Color(0xFF4ECDC4) : Colors.grey.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: completed ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
    );
  }
}
