// lib/features/progress/progress_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Habits/habit_controller.dart';

class ProgressController extends GetxController {
  // Observables for UI
  final _weeklyProgress = 0.0.obs;
  final _topHabits = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get topHabits => _topHabits;

  final _overallCurrentStreak = 0.obs;
  final _overallLongestStreak = 0.obs;

  final _totalCompletedToday = 0.obs;
  final _successRateToday = 0.0.obs;

  final _weeklyCompletionRate = 0.0.obs;
  final _monthlyCompletionRate = 0.0.obs;

  final _bestDays = <int, int>{}.obs; // weekday → count
  final _categoryStats = <String, int>{}.obs;

  // Top habit (computed)
  final _topHabitTitle = ''.obs;
  final _topHabitSubtitle = ''.obs;
  final _topHabitPercent = 0.0.obs;
  final Rx<IconData> _topHabitIcon = Rx<IconData>(Icons.star);

  // Loading flag to avoid initial "0" flash
  final _isReady = false.obs;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  Future<void> refreshProgress() async {
    await _loadStats();
  }

  Future<void> _loadStats() async {
    _isReady.value = false; // start loading
    try {
      final habitController = Get.find<HabitTrackerController>();

      // 1) Weekly progress (today / selectedDate)
      _weeklyProgress.value = habitController.calculateWeeklyProgress();

      // 2) Daily completion stats (selectedDate)
      final todayStats = habitController.getCompletionStats();
      _totalCompletedToday.value = todayStats['completed'] ?? 0;
      final total = (todayStats['total'] ?? 1).clamp(1, double.infinity).toInt();
      _successRateToday.value = _totalCompletedToday.value / total;

      // 3) Overall current streak (sum of all habit current streaks)
      int sum = 0;
      for (final h in habitController.habits) sum += h.streak.value;
      _overallCurrentStreak.value = sum;

      // 4) Overall best streak (max of longestStreak)
      int best = 0;
      for (final h in habitController.habits) {
        if (h.longestStreak.value > best) best = h.longestStreak.value;
      }
      _overallLongestStreak.value = best;

      // 5) Week (7-day) completion rate overall
      _weeklyCompletionRate.value = await habitController.completionRateForWindow(7);

      // 6) Month (30-day) completion rate overall
      _monthlyCompletionRate.value = await habitController.completionRateForWindow(30);

      // 7) Best days of week (last 90 days)
      final b = await habitController.bestDaysOfWeek(days: 90);
      _bestDays.value = b;

      // 8) Category performance (last 30 days)
      final c = await habitController.categoryCompletionStats(days: 30);
      _categoryStats.value = c;

      // 9) Top habit — compute per-habit 7-day completion %
      await _computeTopHabitLastNDays(7, habitController);
    } catch (e, st) {
      print('⚠ ProgressController failed: $e\n$st');
    } finally {
      _isReady.value = true; // finished (success or error)
    }
  }

  /// Computes top habit by counting completed logs for each habit in the last `days` days.
  /// Uses dateUTCString from habit_controller to keep timezone logic uniform (Adelaide).
  Future<void> _computeTopHabitLastNDays(
      int days,
      HabitTrackerController habitController,
      ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _topHabitTitle.value = '';
      _topHabitSubtitle.value = '';
      _topHabitPercent.value = 0.0;
      _topHabitIcon.value = Icons.star;
      return;
    }

    final end = habitController.selectedDate.value;
    final start = end.subtract(Duration(days: days - 1));

    final startStr = dateUTCString(start);
    final endStr = dateUTCString(end);

    // ------------------------------------------------------
    // 1) Fetch ALL logs from last N days in ONE SINGLE QUERY
    // ------------------------------------------------------
    final logsSnap = await _db
        .collection('users')
        .doc(uid)
        .collection('logs')
        .where('dateUTC', isGreaterThanOrEqualTo: startStr)
        .where('dateUTC', isLessThanOrEqualTo: endStr)
        .get(const GetOptions(source: Source.serverAndCache));

    // Count logs per habit
    final Map<String, int> completedMap = {};

    for (var doc in logsSnap.docs) {
      if (doc['completed'] == true) {
        final habitId = doc['habitId'];
        completedMap[habitId] = (completedMap[habitId] ?? 0) + 1;
      }
    }

    // ------------------------------------------------------
    // 2) Evaluate which habit has the highest completion %
    // ------------------------------------------------------
    String bestId = '';
    double bestPct = -1;

    for (final habit in habitController.habits) {
      final count = completedMap[habit.id] ?? 0;
      final pct = count / days;

      if (pct > bestPct) {
        bestPct = pct;
        bestId = habit.id;
      }
    }

    // ------------------------------------------------------
    // 3) Save results
    // ------------------------------------------------------
    if (bestId.isEmpty) {
      _topHabitTitle.value = '';
      _topHabitSubtitle.value = '';
      _topHabitPercent.value = 0.0;
      _topHabitIcon.value = Icons.star;
    } else {
      final h = habitController.habits.firstWhere((x) => x.id == bestId);
      _topHabitTitle.value = h.title;
      _topHabitSubtitle.value = h.subtitle;
      _topHabitPercent.value = bestPct;
      _topHabitIcon.value = h.icon;
    }
  }


  // Getters for UI
  double get weeklyProgress => _weeklyProgress.value;

  int get overallCurrentStreak => _overallCurrentStreak.value;
  int get overallLongestStreak => _overallLongestStreak.value;

  int get totalCompletedToday => _totalCompletedToday.value;
  double get successRateToday => _successRateToday.value;

  double get weeklyCompletionRate => _weeklyCompletionRate.value;
  double get monthlyCompletionRate => _monthlyCompletionRate.value;

  Map<int, int> get bestDays => _bestDays;
  Map<String, int> get categoryStats => _categoryStats;

  // Top habit getters
  String get topHabitTitle => _topHabitTitle.value;
  String get topHabitSubtitle => _topHabitSubtitle.value;
  double get topHabitPercent => _topHabitPercent.value;
  IconData get topHabitIcon => _topHabitIcon.value;

  // Loading flag for UI to avoid showing "0" while loading
  bool get isDataReady => _isReady.value;
}
