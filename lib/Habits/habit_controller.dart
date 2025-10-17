// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:habit_ai/progress/progress.dart';
// //
// // import '../Ai Chat/ai_chat.dart';
// // import '../Ai Chat/chat_controller.dart';
// // import 'create_habit.dart';
// //
// //
// // // Models
// // class HabitItem {
// //   final IconData icon;
// //   final String title;
// //   final String subtitle;
// //   bool isCompleted;
// //   final bool isDynamic;
// //   HabitItem({
// //     required this.icon,
// //     required this.title,
// //     required this.subtitle,
// //     this.isCompleted = false,
// //     this.isDynamic = false,
// //   });
// // }
// //
// // // GetX Controller
// // class HabitTrackerController extends GetxController {
// //   // Observable lists
// //   final RxList<HabitItem> _staticHabits = <HabitItem>[].obs;
// //   final RxList<HabitItem> _dynamicHabits = <HabitItem>[].obs;
// //
// //   // Getters
// //   List<HabitItem> get staticHabits => _staticHabits;
// //   List<HabitItem> get dynamicHabits => _dynamicHabits;
// //   List<HabitItem> get allHabits => [..._staticHabits, ..._dynamicHabits];
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initializeStaticHabits();
// //   }
// //
// //   void _initializeStaticHabits() {
// //     _staticHabits.assignAll([
// //       HabitItem(
// //         icon: Icons.water_drop,
// //         title: 'Drink Water',
// //         subtitle: '8 glasses daily',
// //         isCompleted: true,
// //       ),
// //       HabitItem(
// //         icon: Icons.directions_run,
// //         title: 'Exercise',
// //         subtitle: '30 min daily',
// //         isCompleted: false,
// //       ),
// //       HabitItem(
// //         icon: Icons.menu_book,
// //         title: 'Read',
// //         subtitle: '20 pages daily',
// //         isCompleted: true,
// //       ),
// //       HabitItem(
// //         icon: Icons.self_improvement,
// //         title: 'Meditate',
// //         subtitle: '10 min daily',
// //         isCompleted: false,
// //       ),
// //     ]);
// //   }
// //
// //   void navigateToAIChat() async {
// //     // Pehle binding ensure karo
// //     Get.put<OpenAIService>(OpenAIService(), permanent: true);
// //     Get.put<AICoachController>(AICoachController());
// //
// //     final result = await Get.to(() => AICoachChatScreen());
// //
// //     if (result is HabitTemplate) {
// //       addDynamicHabit(result);
// //     }
// //   }
// //
// //   void addDynamicHabit(HabitTemplate template) {
// //     _dynamicHabits.add(HabitItem(
// //       icon: _getIconForCategory(template.category),
// //       title: template.title,
// //       subtitle: _getSubtitleForTemplate(template),
// //       isCompleted: false,
// //       isDynamic: true,
// //     ));
// //
// //     // Show success message
// //     Get.snackbar(
// //       'Success',
// //       'New habit "${template.title}" added!',
// //       snackPosition: SnackPosition.BOTTOM,
// //       backgroundColor: Colors.green,
// //       colorText: Colors.white,
// //       duration: Duration(seconds: 2),
// //       icon: Icon(Icons.check_circle, color: Colors.white),
// //       margin: EdgeInsets.all(16),
// //     );
// //   }
// //
// //   IconData _getIconForCategory(String category) {
// //     switch (category) {
// //       case 'health':
// //         return Icons.favorite;
// //       case 'work':
// //         return Icons.work;
// //       case 'study':
// //         return Icons.school;
// //       case 'mindfulness':
// //         return Icons.spa;
// //       case 'finance':
// //         return Icons.account_balance_wallet;
// //       case 'relationships':
// //         return Icons.people;
// //       default:
// //         return Icons.check_circle;
// //     }
// //   }
// //
// //   String _getSubtitleForTemplate(HabitTemplate template) {
// //     final days = template.cadence.days.length;
// //     final times = template.cadence.times;
// //
// //     if (days == 7) {
// //       return 'Daily at ${times.join(", ")}';
// //     } else {
// //       return '${days} days/week at ${times.join(", ")}';
// //     }
// //   }
// //
// //   void toggleHabitCompletion(int index) {
// //     if (index < allHabits.length) {
// //       // Find if it's in static or dynamic habits
// //       if (index < _staticHabits.length) {
// //         _staticHabits[index].isCompleted = !_staticHabits[index].isCompleted;
// //         _staticHabits.refresh(); // Trigger UI update
// //       } else {
// //         final dynamicIndex = index - _staticHabits.length;
// //         _dynamicHabits[dynamicIndex].isCompleted = !_dynamicHabits[dynamicIndex].isCompleted;
// //         _dynamicHabits.refresh(); // Trigger UI update
// //       }
// //     }
// //   }
// //   void navigateToCreateHabit() async {
// //     final result = await Get.to(() => CreateNewHabitScreen());
// //
// //     if (result is HabitItem) {
// //       _staticHabits.add(result);
// //
// //       Get.snackbar(
// //         'Success',
// //         'New habit "${result.title}" added!',
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.green,
// //         colorText: Colors.white,
// //         duration: Duration(seconds: 2),
// //       );
// //     }
// //   }
// //   void removeDynamicHabit(int dynamicIndex) {
// //     if (dynamicIndex >= 0 && dynamicIndex < _dynamicHabits.length) {
// //       final habitTitle = _dynamicHabits[dynamicIndex].title;
// //       _dynamicHabits.removeAt(dynamicIndex);
// //
// //       Get.snackbar(
// //         'Removed',
// //         'Habit "$habitTitle" removed!',
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.orange,
// //         colorText: Colors.white,
// //         duration: Duration(seconds: 2),
// //         margin: EdgeInsets.all(16),
// //       );
// //     }
// //   }
// //
// //   // Reset dynamic habits (can be called on app restart)
// //   void resetDynamicHabits() {
// //     _dynamicHabits.clear();
// //   }
// //   void navigateToProgress() async {
// //     final result = await Get.to(() => ProgressScreen());
// //
// //   }
// //   double calculateWeeklyProgress() {
// //     if (allHabits.isEmpty) return 0.0;
// //
// //     int completedHabits = allHabits.where((habit) => habit.isCompleted).length;
// //     return completedHabits / allHabits.length;
// //   }
// //   Map<String, int> getCompletionStats() {
// //     int completed = allHabits.where((habit) => habit.isCompleted).length;
// //     int total = allHabits.length;
// //
// //     return {
// //       'completed': completed,
// //       'total': total,
// //       'percentage': total > 0 ? ((completed / total) * 100).round() : 0,
// //     };
// //   }
// //
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firestore_service.dart';
// import 'create_habit.dart';
// import '../progress/progress.dart';
// import '../Ai Chat/ai_chat.dart';
// import '../Ai Chat/chat_controller.dart';
//
// class HabitItem {
//   final String id;
//   final String userId;
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final String frequency;
//   final String goal;
//   final bool isDynamic;
//   final DateTime createdAt;
//   final DateTime? lastUpdated;
//
//   HabitItem({
//     required this.id,
//     required this.userId,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.frequency,
//     required this.goal,
//     this.isDynamic = false,
//     required this.createdAt,
//     this.lastUpdated,
//   });
//
//   factory HabitItem.fromFirestore(Map<String, dynamic> data, String id) {
//     return HabitItem(
//       id: id,
//       userId: data['userId'] ?? 'demo_user',
//       icon: _iconFromString(data['icon'] ?? 'self_improvement'),
//       title: data['title'] ?? '',
//       subtitle: data['subtitle'] ?? '',
//       frequency: data['frequency'] ?? 'Daily',
//       goal: data['goal'] ?? '',
//       isDynamic: data['isDynamic'] ?? false,
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'userId': userId,
//       'icon': _stringFromIcon(icon),
//       'title': title,
//       'subtitle': subtitle,
//       'frequency': frequency,
//       'goal': goal,
//       'isDynamic': isDynamic,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'lastUpdated': Timestamp.fromDate(DateTime.now()),
//     };
//   }
//
//   static String _stringFromIcon(IconData icon) {
//     return icon.toString().split('Icons.')[1].split(',')[0];
//   }
//
//   static IconData _iconFromString(String iconStr) {
//     final map = {
//       'water_drop': Icons.water_drop,
//       'directions_run': Icons.directions_run,
//       'menu_book': Icons.menu_book,
//       'self_improvement': Icons.self_improvement,
//       'bedtime': Icons.bedtime,
//       'eco': Icons.eco,
//       'fitness_center': Icons.fitness_center,
//       'edit': Icons.edit,
//       'track_changes': Icons.track_changes,
//       'rocket_launch': Icons.rocket_launch,
//       'favorite': Icons.favorite,
//       'work': Icons.work,
//       'school': Icons.school,
//       'spa': Icons.spa,
//       'account_balance_wallet': Icons.account_balance_wallet,
//       'people': Icons.people,
//       'check_circle': Icons.check_circle,
//     };
//     return map[iconStr] ?? Icons.self_improvement;
//   }
// }
//
// class HabitLog {
//   final String id;
//   final String habitId;
//   final String date;
//   final bool completed;
//   final DateTime timestamp;
//
//   HabitLog({
//     required this.id,
//     required this.habitId,
//     required this.date,
//     required this.completed,
//     required this.timestamp,
//   });
//
//   factory HabitLog.fromFirestore(Map<String, dynamic> data, String id) {
//     return HabitLog(
//       id: id,
//       habitId: data['habitId'] ?? '',
//       date: data['date'] ?? '',
//       completed: data['completed'] ?? false,
//       timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       'habitId': habitId,
//       'date': date,
//       'completed': completed,
//       'timestamp': Timestamp.fromDate(timestamp),
//     };
//   }
// }
//
// class HabitTemplate {
//   final String title;
//   final String category;
//   final Cadence cadence;
//
//   HabitTemplate({required this.title, required this.category, required this.cadence});
// }
//
// class Cadence {
//   final List<int> days;
//   final List<String> times;
//   Cadence({required this.days, required this.times});
// }
//
// class HabitTrackerController extends GetxController {
//   final FirestoreService _firestore = FirestoreService();
//   final Rx<Stream<List<HabitItem>>> habitsStream = Stream<List<HabitItem>>.value([]).obs;
//   final Rx<DateTime> selectedDate = DateTime.now().obs;
//
//   List<HabitItem> get allHabits => [];
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeHabitsStream();
//     _initializeStaticHabitsIfNeeded();
//   }
//
//   void _initializeHabitsStream() {
//     habitsStream.value = _firestore.getHabitsStream();
//   }
//
//   Future<void> _initializeStaticHabitsIfNeeded() async {
//     final snapshot = await _firestore._db.collection('habits').where('userId', isEqualTo: _firestore.userId).limit(1).get();
//     if (snapshot.docs.isEmpty) {
//       final staticHabits = [
//         HabitItem(
//           id: const Uuid().v4(),
//           userId: _firestore.userId,
//           icon: Icons.water_drop,
//           title: 'Drink Water',
//           subtitle: '8 glasses daily',
//           frequency: 'Daily',
//           goal: '8 glasses',
//           isDynamic: false,
//           createdAt: DateTime.now(),
//         ),
//         HabitItem(
//           id: const Uuid().v4(),
//           userId: _firestore.userId,
//           icon: Icons.directions_run,
//           title: 'Exercise',
//           subtitle: '30 min daily',
//           frequency: 'Daily',
//           goal: '30 minutes',
//           isDynamic: false,
//           createdAt: DateTime.now(),
//         ),
//         HabitItem(
//           id: const Uuid().v4(),
//           userId: _firestore.userId,
//           icon: Icons.menu_book,
//           title: 'Read',
//           subtitle: '20 pages daily',
//           frequency: 'Daily',
//           goal: '20 pages',
//           isDynamic: false,
//           createdAt: DateTime.now(),
//         ),
//         HabitItem(
//           id: const Uuid().v4(),
//           userId: _firestore.userId,
//           icon: Icons.self_improvement,
//           title: 'Meditate',
//           subtitle: '10 min daily',
//           frequency: 'Daily',
//           goal: '10 minutes',
//           isDynamic: false,
//           createdAt: DateTime.now(),
//         ),
//       ];
//       for (final habit in staticHabits) {
//         await _firestore.addHabit(habit);
//       }
//     }
//   }
//
//   void navigateToAIChat() async {
//     Get.put<OpenAIService>(OpenAIService(), permanent: true);
//     Get.put<AICoachController>(AICoachController());
//     final result = await Get.to(() => AICoachChatScreen());
//     if (result is HabitTemplate) {
//       addDynamicHabit(result);
//     }
//   }
//
//   void addDynamicHabit(HabitTemplate template) async {
//     final habitId = const Uuid().v4();
//     final newHabit = HabitItem(
//       id: habitId,
//       userId: _firestore.userId,
//       icon: _getIconForCategory(template.category),
//       title: template.title,
//       subtitle: _getSubtitleForTemplate(template),
//       frequency: template.cadence.days.length == 7 ? 'Daily' : '${template.cadence.days.length} days/week',
//       goal: '',
//       isDynamic: true,
//       createdAt: DateTime.now(),
//     );
//     await _firestore.addHabit(newHabit);
//     Get.snackbar(
//       'Success',
//       'New habit "${template.title}" added!',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//       icon: const Icon(Icons.check_circle, color: Colors.white),
//       margin: const EdgeInsets.all(16),
//     );
//   }
//
//   IconData _getIconForCategory(String category) {
//     switch (category) {
//       case 'health':
//         return Icons.favorite;
//       case 'work':
//         return Icons.work;
//       case 'study':
//         return Icons.school;
//       case 'mindfulness':
//         return Icons.spa;
//       case 'finance':
//         return Icons.account_balance_wallet;
//       case 'relationships':
//         return Icons.people;
//       default:
//         return Icons.check_circle;
//     }
//   }
//
//   String _getSubtitleForTemplate(HabitTemplate template) {
//     final days = template.cadence.days.length;
//     final times = template.cadence.times;
//     if (days == 7) {
//       return 'Daily at ${times.join(", ")}';
//     } else {
//       return '${days} days/week at ${times.join(", ")}';
//     }
//   }
//
//   Future<void> toggleHabitCompletion(String habitId) async {
//     final dateStr = _formatDate(selectedDate.value);
//     final logDoc = await _firestore.getLog(habitId, dateStr);
//     final isCurrentlyCompleted = logDoc.exists && (await logDoc.data()?['completed'] ?? false);
//     await _firestore.setLog(habitId, dateStr, !isCurrentlyCompleted);
//   }
//
//   Future<bool> getCompletionForHabit(String habitId) async {
//     final dateStr = _formatDate(selectedDate.value);
//     final logDoc = await _firestore.getLog(habitId, dateStr);
//     return logDoc.exists && (await logDoc.data()?['completed'] ?? false);
//   }
//
//   Future<int> getStreakForHabit(String habitId) async {
//     final logs = await _firestore.getRecentLogsStream(habitId).first;
//     final selectedDateStr = _formatDate(selectedDate.value);
//     final sortedLogs = logs..sort((a, b) => a.date.compareTo(b.date));
//     int streak = 0;
//     DateTime current = selectedDate.value;
//     while (true) {
//       final dateStr = _formatDate(current);
//       final log = sortedLogs.firstWhereOrNull((l) => l.date == dateStr && l.completed);
//       if (log == null) break;
//       streak++;
//       current = current.subtract(const Duration(days: 1));
//     }
//     return streak;
//   }
//
//   void navigateToCreateHabit() async {
//     final result = await Get.to(() => CreateNewHabitScreen());
//     if (result is HabitItem) {
//       Get.snackbar(
//         'Success',
//         'New habit "${result.title}" added!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//       );
//     }
//   }
//
//   void removeDynamicHabit(String habitId) async {
//     await _firestore._db.collection('habits').doc(habitId).delete();
//     Get.snackbar(
//       'Removed',
//       'Habit removed!',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//       margin: const EdgeInsets.all(16),
//     );
//   }
//
//   void resetDynamicHabits() async {
//     final dynamicHabits = await _firestore.getHabitsStream().first;
//     for (final habit in dynamicHabits.where((h) => h.isDynamic)) {
//       await _firestore._db.collection('habits').doc(habit.id).delete();
//     }
//   }
//
//   void navigateToProgress() async {
//     await Get.to(() => ProgressScreen());
//   }
//
//   String _formatDate(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
// }
//
// extension IterableExtension<T> on Iterable<T> {
//   T? firstWhereOrNull(bool Function(T) test) {
//     try {
//       return firstWhere(test);
//     } catch (_) {
//       return null;
//     }
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:habitai/features/progress/progress.dart';
import '../Ai Chat/ai_chat.dart';
import '../Ai Chat/chat_controller.dart';
import 'create_habit.dart';

// Models
class HabitItem {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final String frequency;
  final String goal;
  final bool isDynamic;
  final RxBool isCompleted = false.obs;
  final RxInt streak = 0.obs;

  HabitItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.frequency,
    required this.goal,
    required this.isDynamic,
  });

  factory HabitItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final iconCode = data['iconCode'] as int? ?? 0xe3b0; // Default fallback
    return HabitItem(
      id: doc.id,
      icon: IconData(iconCode, fontFamily: 'MaterialIcons'),
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      frequency: data['frequency'] ?? 'Daily',
      goal: data['goal'] ?? '',
      isDynamic: data['isDynamic'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'iconCode': icon.codePoint,
      'frequency': frequency,
      'goal': goal,
      'isDynamic': isDynamic,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

// GetX Controller
class HabitTrackerController extends GetxController {
  // Observable list from Firestore
  final RxList<HabitItem> _habits = <HabitItem>[].obs;
  List<HabitItem> get allHabits => _habits;

  StreamSubscription? _habitsStream;
  StreamSubscription? _completionsStream;

  // Map WelcomeScreen titles to Firestore-compatible habit data
  final List<Map<String, dynamic>> _initialHabitsData = [
    {
      'welcomeTitle': 'Stay Hydrated',
      'title': 'Drink Water',
      'subtitle': '8 glasses daily',
      'iconCode': Icons.water_drop.codePoint,
      'frequency': 'Daily',
      'goal': '8 glasses',
      'isDynamic': false,
    },
    {
      'welcomeTitle': 'Exercise Daily',
      'title': 'Exercise',
      'subtitle': '30 min daily',
      'iconCode': Icons.directions_run.codePoint,
      'frequency': 'Daily',
      'goal': '30 min',
      'isDynamic': false,
    },
    {
      'welcomeTitle': 'Read More',
      'title': 'Read',
      'subtitle': '20 pages daily',
      'iconCode': Icons.menu_book.codePoint,
      'frequency': 'Daily',
      'goal': '20 pages',
      'isDynamic': false,
    },
    {
      'welcomeTitle': 'Meditate',
      'title': 'Meditate',
      'subtitle': '10 min daily',
      'iconCode': Icons.self_improvement.codePoint,
      'frequency': 'Daily',
      'goal': '10 min',
      'isDynamic': false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _setupStreams();
    _handleChosenHabits();
    _checkAndInitializeHabits();
  }

  Future<void> _handleChosenHabits() async {
    final chosenHabits = Get.arguments as List<String>?;
    if (chosenHabits == null || chosenHabits.isEmpty) return;

    // Check existing habits to avoid duplicates
    final existingTitles = (await FirebaseFirestore.instance.collection('habits').get())
        .docs
        .map((doc) => doc['title'] as String)
        .toSet();

    for (var habitTitle in chosenHabits) {
      // Find matching predefined habit
      final predefined = _initialHabitsData.firstWhereOrNull(
            (h) => h['welcomeTitle'] == habitTitle,
      );

      final data = predefined != null
          ? {
        'title': predefined['title'],
        'subtitle': predefined['subtitle'],
        'iconCode': predefined['iconCode'],
        'frequency': predefined['frequency'],
        'goal': predefined['goal'],
        'isDynamic': false,
        'createdAt': FieldValue.serverTimestamp(),
      }
          : {
        'title': habitTitle,
        'subtitle': 'Daily habit',
        'iconCode': Icons.check_circle.codePoint,
        'frequency': 'Daily',
        'goal': 'Complete daily',
        'isDynamic': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (!existingTitles.contains(data['title'])) {
        await FirebaseFirestore.instance.collection('habits').add(data);
        existingTitles.add(data['title']);
      }
    }
  }

  void _setupStreams() {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Habits stream
    _habitsStream = FirebaseFirestore.instance
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _habits.value = snapshot.docs.map((doc) => HabitItem.fromFirestore(doc)).toList();
      _updateCompletionsAndStreaks();
    });

    // Today's completions stream
    _completionsStream = FirebaseFirestore.instance
        .collection('completions')
        .where('date', isEqualTo: todayStr)
        .snapshots()
        .listen((snapshot) {
      final completionMap = <String, bool>{};
      for (var doc in snapshot.docs) {
        completionMap[doc['habitId']] = doc['completed'] as bool;
      }
      for (var habit in _habits) {
        habit.isCompleted.value = completionMap[habit.id] ?? false;
      }
    });
  }

  Future<void> _checkAndInitializeHabits() async {
    final snapshot = await FirebaseFirestore.instance.collection('habits').limit(1).get();
    if (snapshot.docs.isEmpty && Get.arguments == null) {
      for (var data in _initialHabitsData) {
        await FirebaseFirestore.instance.collection('habits').add({
          'title': data['title'],
          'subtitle': data['subtitle'],
          'iconCode': data['iconCode'],
          'frequency': data['frequency'],
          'goal': data['goal'],
          'isDynamic': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  Future<void> _updateCompletionsAndStreaks() async {
    for (var habit in _habits) {
      await _calculateAndSetStreak(habit);
    }
  }

  Future<void> _calculateAndSetStreak(HabitItem habit) async {
    int currentStreak = 0;
    var currentDate = DateTime.now();
    const maxCheckDays = 365;

    for (int i = 0; i < maxCheckDays; i++) {
      final dateStr = DateFormat('yyyy-MM-dd').format(currentDate);
      final docRef = FirebaseFirestore.instance
          .collection('completions')
          .doc('${habit.id}_$dateStr');
      final docSnap = await docRef.get();
      if (docSnap.exists && docSnap.data()!['completed'] == true) {
        currentStreak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    habit.streak.value = currentStreak;
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    final newValue = !habit.isCompleted.value;
    habit.isCompleted.value = newValue;

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docRef = FirebaseFirestore.instance.collection('completions').doc('${habitId}_$todayStr');
    await docRef.set({
      'habitId': habitId,
      'date': todayStr,
      'completed': newValue,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _calculateAndSetStreak(habit);
  }

  // Future<void> navigateToAIChat() async {
  //   Get.put(OpenAIService(), permanent: true);
  //   Get.put(AICoachController());
  //
  //   final result = await Get.to(() => AICoachChatScreen());
  //
  //   if (result is HabitTemplate) {
  //     await addDynamicHabit(result);
  //   }
  // }
  Future<void> navigateToAIChat() async {
    Get.put(OpenAIService(), permanent: true);
    Get.put(AICoachController());
    final result = await Get.to(() => AICoachChatScreen());
    if (result is HabitTemplate) {
      await addDynamicHabit(result);
    }
  }

  Future<void> addDynamicHabit(HabitTemplate template) async {
    final iconData = _getIconForCategory(template.category);
    final days = template.cadence.days.length;
    final times = template.cadence.times;
    final frequency = days == 7 ? 'Daily' : '${days} days/week';
    final subtitle = days == 7
        ? 'Daily at ${times.join(", ")}'
        : '${days} days/week at ${times.join(", ")}';

    final data = {
      'title': template.title,
      'subtitle': subtitle,
      'iconCode': iconData.codePoint,
      'frequency': frequency,
      'goal': '',
      'isDynamic': true,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('habits').add(data);
      Get.snackbar(
        'Success',
        'New habit "${template.title}" added!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add habit: $e');
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'health':
        return Icons.favorite;
      case 'work':
        return Icons.work;
      case 'study':
        return Icons.school;
      case 'mindfulness':
        return Icons.spa;
      case 'finance':
        return Icons.account_balance_wallet;
      case 'relationships':
        return Icons.people;
      default:
        return Icons.check_circle;
    }
  }

  String _getSubtitleForTemplate(HabitTemplate template) {
    final days = template.cadence.days.length;
    final times = template.cadence.times;

    if (days == 7) {
      return 'Daily at ${times.join(", ")}';
    } else {
      return '${days} days/week at ${times.join(", ")}';
    }
  }

  Future<void> removeDynamicHabit(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    if (!habit.isDynamic) return;

    try {
      await FirebaseFirestore.instance.collection('habits').doc(habitId).delete();
      Get.snackbar(
        'Removed',
        'Habit "${habit.title}" removed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove habit: $e');
    }
  }

  Future<void> navigateToCreateHabit() async {
    await Get.to(() => CreateNewHabitScreen());
  }

  void navigateToProgress() async {
    await Get.to(() => ProgressScreen());
  }

  void resetDynamicHabits() {
    FirebaseFirestore.instance
        .collection('habits')
        .where('isDynamic', isEqualTo: true)
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) => doc.reference.delete()));
  }

  double calculateWeeklyProgress() {
    if (allHabits.isEmpty) return 0.0;
    final completedCount = allHabits.where((habit) => habit.isCompleted.value).length;
    return completedCount / allHabits.length;
  }

  Map<String, int> getCompletionStats() {
    final completed = allHabits.where((habit) => habit.isCompleted.value).length;
    final total = allHabits.length;
    return {
      'completed': completed,
      'total': total,
      'percentage': total > 0 ? ((completed / total) * 100).round() : 0,
    };
  }

  @override
  void onClose() {
    _habitsStream?.cancel();
    _completionsStream?.cancel();
    super.onClose();
  }
}

// Binding
class HabitTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HabitTrackerController>(() => HabitTrackerController());
  }
}