// NewHabitScreen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import 'habit_controller.dart';
import 'create_habit.dart';
class Habit {
  final String id;
  final String name;
  final String emoji;
  const Habit({required this.id, required this.name, this.emoji = ''});
}
class CategoryDef {
  final String id;
  final String label;
  final IconData icon;
  final String subtitle;
  const CategoryDef(this.id, this.label, this.icon, this.subtitle);
}
// Unique habits (no duplication)
const List<Habit> _kHabits = [
  Habit(id: 'walk', name: 'Walk', emoji: '🚶'),
  Habit(id: 'sleep', name: 'Sleep', emoji: '🛌'),
  Habit(id: 'drink_water', name: 'Drink water', emoji: '💧'),
  Habit(id: 'meditation', name: 'Meditation', emoji: '🧘'),
  Habit(id: 'run', name: 'Run', emoji: '🏃'),
  Habit(id: 'stand', name: 'Stand', emoji: '🧍'),
  Habit(id: 'cycling', name: 'Cycling', emoji: '🚴'),
  Habit(id: 'workout', name: 'Workout', emoji: '💪'),
  Habit(id: 'exercise', name: 'Exercise', emoji: '🏋️'),
  Habit(id: 'stretch', name: 'Stretch', emoji: '🧘‍♀️'),
  Habit(id: 'yoga', name: 'Yoga', emoji: '🧘‍♂️'),
  Habit(id: 'swim', name: 'Swim', emoji: '🏊'),
  Habit(id: 'read_book', name: 'Read a book', emoji: '📖'),
  Habit(id: 'track_expenses', name: 'Track expenses', emoji: '📊'),
  Habit(id: 'save_money', name: 'Save money', emoji: '💰'),
  Habit(id: 'study', name: 'Learning', emoji: '🧠'),
  Habit(id: 'eat_fruits', name: 'Eat Fruits', emoji: '🍎'),
  Habit(id: 'eat_veg', name: 'Eat Veg', emoji: '🥦'),
  Habit(id: 'sleep_early', name: 'Sleep early', emoji: '🌙'),
  Habit(id: 'eat_breakfast', name: 'Eat Breakfast', emoji: '🍳'),
  Habit(id: 'active_calorie', name: 'Active Calorie', emoji: '🔥'),
  Habit(id: 'burn_calorie', name: 'Burn Calorie', emoji: '🔥'),
  Habit(id: 'less_carbohydrate', name: 'Less Carbohydrate', emoji: '🥗'),
  Habit(id: 'drink_less_caffeine', name: 'Drink Less Caffeine', emoji: '☕️'),
  Habit(id: 'eat_less_sugar', name: 'Eat Less Sugar', emoji: '🍬'),
  Habit(id: 'breathe', name: 'Breathe', emoji: '😮‍💨'),
  Habit(id: 'review_today', name: 'Review Today', emoji: '🗒️'),
  Habit(id: 'mind_clearing', name: 'Mind Clearing', emoji: '💡'),
  Habit(id: 'anaerobic', name: 'Anaerobic', emoji: '🏋️‍♂️'),
];
// Categories → habit IDs
const Map<String, List<String>> _kCategoryToHabitIds = {
  'popular': [
    'walk',
    'sleep',
    'drink_water',
    'meditation',
    'run',
    'workout',
    'cycling',
    'read_book',
  ],
  'health': [
    'walk',
    'sleep',
    'stand',
    'cycling',
    'exercise',
    'drink_water',
  ],
  'Fitness': [
    'walk',
    'run',
    'stretch',
    'stand',
    'yoga',
    'cycling',
    'swim',
    'workout',
  ],
  'lifestyle': [
    'track_expenses',
    'save_money',
    'meditation',
    'read_book',
    'study',
    'eat_less_sugar',
    'breathe',
    'review_today',
    'mind_clearing',
    'drink_water',
  ],
  'time': [
    'stretch',
    'yoga',
    'swim',
    'exercise',
    'meditation',
    'read_book',
    'study',
  ],
};

const List<CategoryDef> _kCategories = [
  CategoryDef('popular', 'Popular', Icons.local_fire_department_rounded,
      'Most popular habits'),
  CategoryDef('health', 'Health', Icons.favorite_rounded,
      'Health habits are linked with Apple Health App'),
  CategoryDef('Fitness', 'Fitness', Icons.directions_run_rounded,
      'Exercise and fitness related habits'),
  CategoryDef('lifestyle', 'Lifestyle', Icons.home_rounded,
      'Habits to make your life better'),
  CategoryDef('time', 'Time', Icons.access_time_filled_rounded,
      'Habits with time units & timer'),
];

class NewHabitScreen extends StatefulWidget {
  final ValueChanged<Habit>? onPick; // selected habit callback
  final bool popOnPick; // close on pick
  const NewHabitScreen({super.key, this.onPick, this.popOnPick = true});
  @override
  State<NewHabitScreen> createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends State<NewHabitScreen> {
  late final Map<String, Habit> _habitById;
  late final Map<String, List<String>> _categoryToIds;
  String _selectedCategory = 'popular';
  final Set<String> _favoriteHabits = <String>{};
  @override
  void initState() {
    super.initState();
    _habitById = {for (final h in _kHabits) h.id: h};
    _categoryToIds =
        _kCategoryToHabitIds.map((k, v) => MapEntry(k, List<String>.from(v)));
  }
  bool _isHabitAlreadyCreated(String habitName) {
    final controller = Get.find<HabitTrackerController>();
    return controller.habits.any((habit) => habit.title.toLowerCase() == habitName.toLowerCase());
  }
  List<Habit> _habitsForCategory(String id) {
    final ids = _categoryToIds[id] ?? const [];
    return [
      for (final hid in ids)
        if (_habitById.containsKey(hid)) _habitById[hid]!
    ];
  }
  void _toggleFavorite(String habitId) {
    setState(() {
      if (_favoriteHabits.contains(habitId)) {
        _favoriteHabits.remove(habitId);
      } else {
        _favoriteHabits.add(habitId);
      }
    });
  }

  void _pick(Habit h) {
    Get.to(() => CreateNewHabitScreen(initialHabitName: h.name));
  }

  @override
  Widget build(BuildContext context) {
    final cat = _kCategories.firstWhere((c) => c.id == _selectedCategory,
        orElse: () => _kCategories.first);
    final items = _habitsForCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:
          Icon(Icons.arrow_back_ios_new_rounded, color: context.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('New Habit', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.store_mall_directory_rounded,
                color: context.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () => Get.find<HabitTrackerController>().navigateToCustomHabit(),
        child: Container(
          width: 150,
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [AppColors.darkPrimary, AppColors.darkSecondary]
                  : [AppColors.lightPrimary, AppColors.lightSecondary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black26
                    : Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Custom Habit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Container(
        color: context.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 6),
            _CategoryStrip(
              categories: _kCategories,
              selectedId: _selectedCategory,
              onTap: (id) => setState(() => _selectedCategory = id),
            ),
            const SizedBox(height: 8),
            Text(cat.label,
                style: TextStyle(
                    color: context.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(cat.subtitle,
                style:
                TextStyle(color: context.secondaryTextColor, fontSize: 13)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding:
                const EdgeInsets.fromLTRB(16, 0, 16, 96), // room for FAB
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _HabitTile(
                  habit: items[i],
                  isFavorite: _isHabitAlreadyCreated(items[i].name),
                  onToggleFavorite: () => _toggleFavorite(items[i].id),
                  onAdd: () => _pick(items[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _CategoryStrip extends StatelessWidget {
  final List<CategoryDef> categories;
  final String selectedId;
  final ValueChanged<String> onTap;
  const _CategoryStrip(
      {required this.categories,
        required this.selectedId,
        required this.onTap});
  @override
  Widget build(BuildContext context) {
    final bgSelected = context.primaryColor.withOpacity(0.15);
    final bg = context.surfaceColor;
    final border = context.borderColor;
    // return SizedBox(
    //   height: 74,
    //   child: ListView.separated(
    //     scrollDirection: Axis.horizontal,
    //     padding: const EdgeInsets.symmetric(horizontal: 12),
    //     itemCount: categories.length,
    //     // separatorBuilder: (_, __) => const SizedBox(width: 12),
    //     separatorBuilder: (context, index) => SizedBox(width: MediaQuery.of(context).size.width * 0.17),
    //     itemBuilder: (_, i) {
    //       final c = categories[i];
    //       final selected = c.id == selectedId;
    //       return GestureDetector(
    //         onTap: () => onTap(c.id),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             AnimatedContainer(
    //               duration: const Duration(milliseconds: 160),
    //               width: 48,
    //               height: 48,
    //               decoration: BoxDecoration(
    //                 color: selected ? bgSelected : bg,
    //                 borderRadius: BorderRadius.circular(24),
    //                 border: Border.all(
    //                     color: selected ? context.primaryColor : border,
    //                     width: 1),
    //               ),
    //               child: Icon(c.icon,
    //                   color: selected
    //                       ? context.primaryColor
    //                       : context.secondaryTextColor,
    //                   size: 24),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
    return SizedBox(
      height: 74,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: categories.map((c) {
            final selected = c.id == selectedId;
            return GestureDetector(
              onTap: () => onTap(c.id),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: selected ? bgSelected : bg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: selected ? context.primaryColor : border,
                      ),
                    ),
                    child: Icon(
                      c.icon,
                      color: selected
                          ? context.primaryColor
                          : context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );

  }
}
class _HabitTile extends StatelessWidget {
  final Habit habit;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAdd;
  const _HabitTile({required this.habit, required this.isFavorite, required this.onToggleFavorite, required this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Habit ${habit.name}',
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _EmojiCircle(habit.emoji),
            const SizedBox(width: 12),
            Expanded(
              child: Text(habit.name,
                  style: TextStyle(
                      color: context.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
            if (isFavorite) ...[
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
            ],
            _PlusButton(onTap: onAdd),
          ],
        ),
      ),
    );
  }
}
class _EmojiCircle extends StatelessWidget {
  final String emoji;
  const _EmojiCircle(this.emoji);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.borderColor, width: 1),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 22)),
    );
  }
}
class _PlusButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PlusButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Icon(Icons.add_rounded, size: 22),
        ),
      ),
    );
  }
}