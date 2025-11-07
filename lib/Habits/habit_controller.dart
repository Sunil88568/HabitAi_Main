import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../Ai Chat/ai_chat.dart';
import '../Ai Chat/chat_controller.dart';
import 'create_habit.dart';
import '../features/progress/progress.dart';

/// Utility for UTC date strings (yyyy-MM-dd)
String dateUTCString([DateTime? now]) {
  final n = (now ?? DateTime.now()).toUtc();
  final mm = n.month.toString().padLeft(2, '0');
  final dd = n.day.toString().padLeft(2, '0');
  return '${n.year}-$mm-$dd';
}

/// --- HABIT MODEL ---
class HabitItem {
  final String id;
  final String title;
  final String subtitle;
  final int iconCode;
  final String cadence;
  final List<int> daysOfWeek;
  final String category;
  final bool reminders;
  final bool isDynamic;
  final DateTime createdAt;
  final DateTime updatedAt;

  final RxBool isCompleted = false.obs;
  final RxInt streak = 0.obs;

  HabitItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconCode,
    required this.cadence,
    required this.daysOfWeek,
    required this.category,
    required this.reminders,
    required this.isDynamic,
    required this.createdAt,
    required this.updatedAt,
  });

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  factory HabitItem.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return HabitItem(
      id: doc.id,
      title: d['title'] ?? '',
      subtitle: d['subtitle'] ?? '',
      iconCode: d['iconCode'] ?? Icons.check_circle.codePoint,
      cadence: d['cadence'] ?? 'daily',
      daysOfWeek:
      (d['daysOfWeek'] as List?)?.map((e) => e as int).toList() ??
          [1, 2, 3, 4, 5, 6, 7],
      category: d['category'] ?? 'general',
      reminders: d['reminders'] ?? false,
      isDynamic: d['isDynamic'] ?? false,
      createdAt: (d['createdAt'] is Timestamp)
          ? (d['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: (d['updatedAt'] is Timestamp)
          ? (d['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

/// --- CONTROLLER ---
class HabitTrackerController extends GetxController {
  final RxList<HabitItem> habits = <HabitItem>[].obs;
  final RxMap<String, bool> todayCompletions = <String, bool>{}.obs;
  final selectedDate = DateTime.now().obs;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  StreamSubscription? _hSub;
  StreamSubscription? _lSub;

  @override
  void onInit() {
    super.onInit();
    _enablePersistence();
    _watchHabits();
    _watchLogsForSelectedDate();
  }

  /// ✅ Enable offline persistence
  Future<void> _enablePersistence() async {
    try {
      _db.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      print('✅ Firestore offline persistence configured');
    } catch (e) {
      print('⚠️ Persistence setup failed: $e');
    }
  }

  /// ✅ Listen to habits collection
  void _watchHabits() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _hSub = _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      habits.value = snapshot.docs.map(HabitItem.fromDoc).toList();
      // Refresh completion whenever habits reload
      _refreshCompletionsForSelectedDate();
    });
  }

  /// ✅ Watch logs dynamically based on selected date
  void _watchLogsForSelectedDate() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    ever(selectedDate, (DateTime date) {
      final dateStr = dateUTCString(date);
      _lSub?.cancel();

      _lSub = _db
          .collection('users')
          .doc(uid)
          .collection('logs')
          .where('dateUTC', isEqualTo: dateStr)
          .snapshots()
          .listen((snapshot) {
        final m = <String, bool>{};
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          m[data['habitId']] = data['completed'] ?? false;
        }
        todayCompletions.value = m;

        for (final habit in habits) {
          habit.isCompleted.value = m[habit.id] ?? false;
        }
        print('📅 Logs updated for $dateStr (${snapshot.docs.length} entries)');
      });
    });

    selectedDate.refresh(); // trigger once for today
  }

  /// 🔹 Manually refresh completions (useful after habits reload)
  void _refreshCompletionsForSelectedDate() {
    final m = todayCompletions;
    for (final habit in habits) {
      habit.isCompleted.value = m[habit.id] ?? false;
    }
  }

  /// ✅ Toggle completion for current date
  /// ✅ Toggle completion for the currently selected date
  Future<void> toggleHabitCompletion(String habitId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // use selected date, not today
    final selected = selectedDate.value;
    final dateStr = dateUTCString(selected);
    final logId = '${habitId}_$dateStr';
    final logsRef = _db.collection('users').doc(uid).collection('logs');

    // Check local completion state
    final currentCompleted = todayCompletions[habitId] ?? false;
    final newCompleted = !currentCompleted;

    // Update UI instantly
    todayCompletions[habitId] = newCompleted;
    final habit = habits.firstWhereOrNull((h) => h.id == habitId);
    if (habit != null) habit.isCompleted.value = newCompleted;

    // Write to Firestore (works offline too)
    await logsRef.doc(logId).set({
      'habitId': habitId,
      'dateUTC': dateStr,
      'completed': newCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Force refresh for selected date
    _refreshCompletionsForSelectedDate();

    // Update streak locally and in UI
    final newStreak = await _calculateStreak(habitId);
    if (habit != null) habit.streak.value = newStreak;

    print('✅ Toggled completion for $habitId on $dateStr → $newCompleted');
  }

  /// ✅ Calculate streak up to the selected date, not just today
  Future<int> _calculateStreak(String habitId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 0;

    var current = selectedDate.value.toUtc(); // use currently selected date
    var streak = 0;

    // Check backward day-by-day until break
    for (int i = 0; i < 365; i++) {
      final d = dateUTCString(current);
      final doc = await _db
          .collection('users')
          .doc(uid)
          .collection('logs')
          .doc('${habitId}_$d')
          .get(const GetOptions(source: Source.serverAndCache)); // use both cache & server
      if (doc.exists && (doc.data()?['completed'] == true)) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }


  /// ✅ Create a new habit
  Future<void> createHabit(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('habits').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ✅ Update habit
  Future<void> updateHabit(String id, Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(id)
        .update({...data, 'updatedAt': FieldValue.serverTimestamp()});
  }

  /// ✅ Delete habit
  Future<void> removeHabit(String habitId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habitId)
        .delete();
  }
  /// 🔹 Open Edit Habit Screen
  void openEditHabit(HabitItem habit) {
    // Navigate to CreateHabitScreen in edit mode with existing data
    Get.to(() => CreateNewHabitScreen(
      existingHabit: habit,
    ));
  }

  /// 🔹 Navigate to AI Chat (for AI-generated habit creation)
  Future<void> navigateToAIChat() async {
    try {
      Get.put(OpenAIService(), permanent: true);
      Get.put(AICoachController());

      final result = await Get.to(() => AICoachChatScreen());

      if (result is HabitTemplate) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) return;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('habits')
            .add({
          'title': result.title,
          'subtitle': 'AI-generated habit',
          'iconCode': Icons.auto_awesome.codePoint,
          'cadence': 'daily',
          'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
          'category': result.category ?? 'general',
          'reminders': false,
          'isDynamic': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        Get.snackbar(
          'AI Habit Created',
          'Your AI-generated habit has been added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create AI habit: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      print('⚠️ navigateToAIChat failed: $e');
    }
  }
  /// 🔹 Calculate weekly progress percentage (0–1)
  double calculateWeeklyProgress() {
    if (habits.isEmpty) return 0.0;

    // Count how many habits are completed today
    final completedCount = todayCompletions.values.where((done) => done).length;

    // Return as a ratio (e.g., 0.75 means 75%)
    return completedCount / habits.length;
  }

  /// 🔹 Return completion stats (completed, total, and percentage)
  Map<String, int> getCompletionStats() {
    final completed = todayCompletions.values.where((done) => done).length;
    final total = habits.length;
    return {
      'completed': completed,
      'total': total,
      'percentage': total > 0 ? ((completed / total) * 100).round() : 0,
    };
  }

  void navigateToCreateHabit() => Get.to(() => const CreateNewHabitScreen());
  void navigateToProgress() => Get.to(() => ProgressScreen());

  @override
  void onClose() {
    _hSub?.cancel();
    _lSub?.cancel();
    super.onClose();
  }
}

class HabitTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HabitTrackerController());
  }
}
