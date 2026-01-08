// lib/Habits/habit_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitai/Habits/NewHabitScreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../Ai Chat/ai_chat.dart';
import '../Ai Chat/simple_chat_controller.dart';
import 'create_habit.dart';
import '../features/progress/progress.dart';
import 'package:habitai/services/notification_service.dart';
import '../services/revenue_cat_service.dart';
import '../screens/paywall/paywall_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// ---------------------------------------------------------------------------
///  UTILITY — Adelaide timezone date (YYYY-MM-DD)
/// ---------------------------------------------------------------------------
bool _tzInitialized = false;

String dateUTCString([DateTime? date]) {
  if (!_tzInitialized) {
    tz.initializeTimeZones();
    _tzInitialized = true;
  }

  final adelaide = tz.getLocation('Australia/Adelaide');
  final dt = tz.TZDateTime.from(date ?? DateTime.now(), adelaide);

  final mm = dt.month.toString().padLeft(2, '0');
  final dd = dt.day.toString().padLeft(2, '0');
  return '${dt.year}-$mm-$dd';
}

/// ---------------------------------------------------------------------------
///  HABIT MODEL
/// ---------------------------------------------------------------------------
class HabitItem {
  final String id;
  final String title;
  final String subtitle;
  final int iconCode;
  final int habitColor;
  final String cadence;
  final List<int> daysOfWeek;
  final String category;
  final bool reminders;
  final bool isDynamic;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? goalPeriod;
  final int? goalValue;
  final String? goalUnit;
  final String? timeRange;
  final String? reminderText;
  final String? reminderType;
  final String? taskValue;
  final List<String>? selectedDays;
  final List<int>? selectedMonthDays;
  final int? daysPerWeek;
  final int? daysPerMonth;

  // persisted reminder time
  final int reminderHour;
  final int reminderMinute;

  final RxBool isCompleted = false.obs;
  final RxInt streak = 0.obs;
  final RxInt longestStreak = 0.obs;

  HabitItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconCode,
    required this.habitColor,
    required this.cadence,
    required this.daysOfWeek,
    required this.category,
    required this.reminders,
    required this.isDynamic,
    required this.createdAt,
    required this.updatedAt,
    required this.reminderHour,
    required this.reminderMinute,
    this.goalPeriod,
    this.goalValue,
    this.goalUnit,
    this.timeRange,
    this.reminderText,
    this.reminderType,
    this.taskValue,
    this.selectedDays,
    this.selectedMonthDays,
    this.daysPerWeek,
    this.daysPerMonth,
  });

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
  Color get color => Color(habitColor);
  
  /// Check if habit should be visible on given date based on task value
  bool isVisibleOnDate(DateTime date) {
    print('🔍 Checking visibility for habit: $title');
    print('🔍 Task value: $taskValue');
    print('🔍 Selected days: $selectedDays');
    print('🔍 Date: $date (weekday: ${date.weekday})');
    
    if (taskValue == null) {
      print('🔍 No task value, showing habit');
      return true; // Default: show every day
    }
    
    switch (taskValue) {
      case 'Every Day':
        print('🔍 Every Day mode, showing habit');
        return true;
      case 'Specific days of the week':
        if (selectedDays == null || selectedDays!.isEmpty) {
          print('🔍 No selected days, showing habit');
          return true;
        }
        // Convert full day names to abbreviated format to match stored data
        final dayAbbreviations = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
        final dayAbbr = dayAbbreviations[date.weekday - 1];
        final isVisible = selectedDays!.contains(dayAbbr);
        print('🔍 Day abbr: $dayAbbr, Selected days: $selectedDays, Visible: $isVisible');
        return isVisible;
      case 'Number of days per week':
        print('🔍 Number of days per week mode, showing habit');
        return true; // Show every day for this mode
      case 'Specific days of the month':
        if (selectedMonthDays == null || selectedMonthDays!.isEmpty) {
          print('🔍 No selected month days, showing habit');
          return true;
        }
        final isVisible = selectedMonthDays!.contains(date.day);
        print('🔍 Day: ${date.day}, Selected month days: $selectedMonthDays, Visible: $isVisible');
        return isVisible;
      case 'Number of days per month':
        print('🔍 Number of days per month mode, showing habit');
        return true; // Show every day for this mode
      default:
        print('🔍 Unknown task value, showing habit');
        return true;
    }
  }

  factory HabitItem.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    final item = HabitItem(
      id: doc.id,
      title: d['title'] ?? '',
      subtitle: d['subtitle'] ?? '',
      iconCode: d['iconCode'] ?? Icons.check_circle.codePoint,
      habitColor: d['habitColor'] ?? 0xFF2196F3,
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
      reminderHour: (d['reminderHour'] is int) ? d['reminderHour'] as int : (d['reminder_hour'] is int ? d['reminder_hour'] as int : 9),
      reminderMinute: (d['reminderMinute'] is int) ? d['reminderMinute'] as int : (d['reminder_minute'] is int ? d['reminder_minute'] as int : 0),
      goalPeriod: d['goalPeriod'] as String?,
      goalValue: d['goalValue'] as int?,
      goalUnit: d['goalUnit'] as String?,
      timeRange: d['timeRange'] as String?,
      reminderText: d['reminderText'] as String?,
      reminderType: d['reminderType'] as String?,
      taskValue: d['taskValue'] as String?,
      selectedDays: (d['selectedDays'] as List?)?.cast<String>(),
      selectedMonthDays: (d['selectedMonthDays'] as List?)?.cast<int>(),
      daysPerWeek: d['daysPerWeek'] as int?,
      daysPerMonth: d['daysPerMonth'] as int?,
    );

    item.streak.value = d['streak'] ?? 0;
    item.longestStreak.value = d['longestStreak'] ?? 0;

    return item;
  }
}

/// ---------------------------------------------------------------------------
///  CONTROLLER
/// ---------------------------------------------------------------------------
class Badge {
  final String id;
  final String name;
  final String description;
  final int streakRequired;
  final String emoji;
  
  Badge(this.id, this.name, this.description, this.streakRequired, this.emoji);
}

class HabitTrackerController extends GetxController {
  final RxList<HabitItem> habits = <HabitItem>[].obs;
  final RxMap<String, bool> todayCompletions = <String, bool>{}.obs;
  final selectedDate = DateTime.now().obs;
  final RxInt totalXP = 0.obs;
  final RxList<Badge> unlockedBadges = <Badge>[].obs;
  final RxList<Badge> newBadges = <Badge>[].obs;
  final RxMap<String, bool> xpAwarded = <String, bool>{}.obs;
  
  /// Get habits that should be visible on the selected date
  List<HabitItem> get visibleHabits {
    return habits.where((habit) => habit.isVisibleOnDate(selectedDate.value)).toList();
  }
  
  static const int dailyCheckInXP = 10;
  static final List<Badge> allBadges = [
    Badge('week_warrior', 'Week Warrior', '7-day streak', 7, '🔥'),
    Badge('monthly_master', 'Monthly Master', '30-day streak', 30, '💪'),
    Badge('quarterly_champion', 'Quarterly Champion', '90-day streak', 90, '🏆'),
    Badge('half_year_hero', 'Half Year Hero', '180-day streak', 180, '⭐'),
    Badge('nine_month_ninja', 'Nine Month Ninja', '270-day streak', 270, '🥷'),
    Badge('yearly_legend', 'Yearly Legend', '365-day streak', 365, '👑'),
  ];

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  StreamSubscription? _hSub;
  StreamSubscription? _lSub;

  @override
  void onInit() {
    super.onInit();
    _enablePersistence();
    _loadBadgeData();
    _watchHabits();
    _watchLogsForSelectedDate();
  }

  Future<void> _enablePersistence() async {
    try {
      _db.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (_) {}
  }

  /// -------------------------------------------------------------------------
  ///  FETCH HABITS STREAM
  /// -------------------------------------------------------------------------
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
      
      // Update RevenueCat service with current habit count
      try {
        final service = Get.find<RevenueCatService>();
        service.updateHabitCount(habits.length);
      } catch (e) {
        print('⚠ RevenueCat service not found: $e');
      }
      
      _refreshCompletionsForSelectedDate();

      // NEW: sync local scheduled reminders with the current habit list.
      // Fire-and-forget; log errors if sync fails.
      try {
        NotificationService().syncWithHabits(habits.toList()).catchError((e) {
          print('⚠ Notification sync failed: $e');
        });
      } catch (e) {
        print('⚠ Notification sync threw: $e');
      }
    });
  }
  Future<void> createHabit2(Map<String, dynamic> data) async {
    print('🚀 createHabit2 called');
    print('📝 Data: $data');

    final uid = _auth.currentUser?.uid;
    print('👤 User ID: $uid');

    if (uid == null) {
      print('❌ No user logged in!');
      return;
    }

    try {
      print('💾 Writing to Firestore...');
      await _db.collection('users').doc(uid).collection('habits').add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Habit saved to Firebase successfully!');
    } catch (e) {
      print('❌ Firestore Error: $e');
    }
  }

  /// -------------------------------------------------------------------------
  ///  FETCH DAILY LOGS FOR SELECTED DATE
  /// -------------------------------------------------------------------------
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
          m[doc['habitId']] = doc['completed'] ?? false;
        }

        todayCompletions.value = m;

        for (final h in habits) {
          h.isCompleted.value = m[h.id] ?? false;
        }
      });
    });

    selectedDate.refresh();
  }

  void _refreshCompletionsForSelectedDate() {
    for (final h in habits) {
      h.isCompleted.value = todayCompletions[h.id] ?? false;
    }
  }

  HabitItem? _findHabitById(String id) {
    final i = habits.indexWhere((h) => h.id == id);
    return i == -1 ? null : habits[i];
  }

  /// -------------------------------------------------------------------------
  ///  TOGGLE COMPLETION + SAVE STREAKS IN FIRESTORE
  /// -------------------------------------------------------------------------
  Future<void> toggleHabitCompletion(String habitId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final selected = selectedDate.value;
    final todayStr = dateUTCString(selected);
    final todayId = '${habitId}_$todayStr';

    final logsRef = _db.collection('users').doc(uid).collection('logs');
    final habitsRef = _db.collection('users').doc(uid).collection('habits');

    // ---- 1. Toggle today's completion ----
    final wasCompletedBefore = todayCompletions[habitId] ?? false;
    final isCompletedToday = !wasCompletedBefore;
    todayCompletions[habitId] = isCompletedToday;

    final habit = _findHabitById(habitId);
    if (habit != null) habit.isCompleted.value = isCompletedToday;

    await logsRef.doc(todayId).set({
      'habitId': habitId,
      'dateUTC': todayStr,
      'completed': isCompletedToday,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // ---- 2. Streak calculation now becomes SUPER simple ----

    int newStreak = 0;

    if (isCompletedToday) {
      // Check yesterday
      final yesterday = selected.subtract(const Duration(days: 1));
      final yesterdayStr = dateUTCString(yesterday);
      final yesterdayId = '${habitId}_$yesterdayStr';

      final yesterdayDoc = await logsRef.doc(yesterdayId)
          .get(const GetOptions(source: Source.serverAndCache));

      final completedYesterday =
          yesterdayDoc.exists && (yesterdayDoc['completed'] == true);

      if (completedYesterday) {
        newStreak = (habit?.streak.value ?? 0) + 1;
      } else {
        newStreak = 1;
      }
    } else {
      // If today is uncompleted → streak breaks
      newStreak = 0;
    }

    // ---- 3. Longest streak update ----
    final newLongest = (habit?.longestStreak.value ?? 0);
    final updatedLongest = newStreak > newLongest ? newStreak : newLongest;

    if (habit != null) {
      habit.streak.value = newStreak;
      habit.longestStreak.value = updatedLongest;
    }

    // ---- 4. Save streak + longest streak in Firestore ----
    await habitsRef.doc(habitId).update({
      'streak': newStreak,
      'longestStreak': updatedLongest,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ---- 5. Award XP and check for badges (only once per habit per day) ----
    final xpKey = '${habitId}_$todayStr';
    if (isCompletedToday && !(xpAwarded[xpKey] ?? false)) {
      await awardDailyXP();
      xpAwarded[xpKey] = true;
      final newBadgesList = await checkStreakAndAwardBadges(newStreak);
      if (newBadgesList.isNotEmpty) {
        _showBadgeAnimation(newBadgesList.first, newStreak);
      }
    }

    print("🔥 Updated streak: $newStreak | longest: $updatedLongest");
  }


  /// -------------------------------------------------------------------------
  ///  STREAK LOGIC
  /// -------------------------------------------------------------------------
  Future<int> _calculateStreak(String habitId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 0;

    int streak = 0;
    var cursor = selectedDate.value.toUtc();

    for (int i = 0; i < 365; i++) {
      final d = dateUTCString(cursor);

      final doc = await _db
          .collection('users')
          .doc(uid)
          .collection('logs')
          .doc('${habitId}_$d')
          .get(const GetOptions(source: Source.serverAndCache));

      if (doc.exists && doc['completed'] == true) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  Future<int> _calculateLongestStreak(String habitId,
      {int daysBack = 365}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 0;

    int longest = 0;
    int running = 0;

    var cursor =
    selectedDate.value.toUtc().subtract(Duration(days: daysBack));

    for (int i = 0; i < daysBack; i++) {
      final d = dateUTCString(cursor);

      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('logs')
          .doc('${habitId}_$d')
          .get(const GetOptions(source: Source.serverAndCache));

      if (snap.exists && snap['completed'] == true) {
        running++;
        if (running > longest) longest = running;
      } else {
        running = 0;
      }

      cursor = cursor.add(const Duration(days: 1));
    }
    return longest;
  }

  /// -------------------------------------------------------------------------
  ///  ANALYTICS — REQUIRED BY PROGRESS CONTROLLER
  /// -------------------------------------------------------------------------
  Future<double> completionRateForWindow(int days) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || habits.isEmpty) return 0;

    int totalCompleted = 0;
    final end = selectedDate.value.toUtc();

    for (int i = 0; i < days; i++) {
      final d = dateUTCString(end.subtract(Duration(days: i)));

      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('logs')
          .where('dateUTC', isEqualTo: d)
          .get(const GetOptions(source: Source.serverAndCache));

      for (var doc in snap.docs) {
        if (doc['completed'] == true) totalCompleted++;
      }
    }

    final denom = habits.length * days;
    return denom == 0 ? 0 : totalCompleted / denom;
  }

  Future<Map<int, int>> bestDaysOfWeek({int days = 90}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return {};

    final end = selectedDate.value.toUtc();
    final map = {1:0,2:0,3:0,4:0,5:0,6:0,7:0};

    for (int i = 0; i < days; i++) {
      final d = end.subtract(Duration(days: i));
      final dateStr = dateUTCString(d);

      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('logs')
          .where('dateUTC', isEqualTo: dateStr)
          .get(const GetOptions(source: Source.serverAndCache));

      for (var doc in snap.docs) {
        if (doc['completed'] == true) {
          final weekday = d.weekday;
          map[weekday] = (map[weekday] ?? 0) + 1;
        }
      }
    }
    return map;
  }

  Future<Map<String, int>> categoryCompletionStats({int days = 30}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return {};

    final end = selectedDate.value.toUtc();
    final result = <String, int>{};

    final categories = {
      for (final h in habits) h.id: h.category,
    };

    for (int i = 0; i < days; i++) {
      final d = end.subtract(Duration(days: i));
      final dateStr = dateUTCString(d);

      final snap = await _db
          .collection('users')
          .doc(uid)
          .collection('logs')
          .where('dateUTC', isEqualTo: dateStr)
          .get(const GetOptions(source: Source.serverAndCache));

      for (var doc in snap.docs) {
        if (doc['completed'] == true) {
          final hid = doc['habitId'];
          final cat = categories[hid] ?? 'general';
          result[cat] = (result[cat] ?? 0) + 1;
        }
      }
    }
    return result;
  }

  /// -------------------------------------------------------------------------
  ///  CRUD
  /// -------------------------------------------------------------------------
  Future<String?> createHabit(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final ref = await _db.collection('users').doc(uid).collection('habits').add({
      ...data,
      'streak': 0,
      'longestStreak': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> updateHabit(String id, Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final habit = _findHabitById(id);

    await _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(id)
        .update({
      ...data,
      'streak': habit?.streak.value ?? 0,
      'longestStreak': habit?.longestStreak.value ?? 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

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

  /// -------------------------------------------------------------------------
  ///  NAVIGATION
  /// -------------------------------------------------------------------------
  void openEditHabit(HabitItem habit) {
    Get.to(() => CreateNewHabitScreen(existingHabit: habit));
  }

  void navigateToCreateHabit() {
    final service = Get.find<RevenueCatService>();
    service.updateHabitCount(habits.length);
    if (!service.canCreateHabit()) {
      Get.to(() => PaywallScreen());
      return;
    }
    // Get.to(() => const CreateNewHabitScreen());
    Get.to(() => const NewHabitScreen());
  }

  void navigateToCustomHabit() {
    Get.to(() => const CreateNewHabitScreen());
  }

  void navigateToProgress() =>
      Get.to(() => ProgressScreen());

  Future<void> navigateToAIChat() async {
    final service = Get.find<RevenueCatService>();
    if (!service.canUseAICoach()) {
      Get.to(() => PaywallScreen());
      return;
    }
    
    service.incrementAIUsage();
    
    // Clear existing controllers to ensure fresh chat
    Get.delete<SimpleChatController>(force: true);
    Get.put(SimpleChatController());
    
    await Get.to(() => AICoachChatScreen());
  }

  /// -------------------------------------------------------------------------
  ///  PROGRESS HELPERS
  /// -------------------------------------------------------------------------
  double calculateWeeklyProgress() {
    if (habits.isEmpty) return 0;
    int count = 0;
    for (final h in habits) {
      if (todayCompletions[h.id] == true) {
        count++;
      }
    }
    return habits.isEmpty ? 0 : count / habits.length;

  }
  Future<List<Map<String, dynamic>>> topHabits({int days = 30}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final end = selectedDate.value.toUtc();
    final List<Map<String, dynamic>> list = [];

    for (final habit in habits) {
      int completed = 0;

      for (int i = 0; i < days; i++) {
        final d = dateUTCString(end.subtract(Duration(days: i)));

        final doc = await _db
            .collection('users')
            .doc(uid)
            .collection('logs')
            .doc('${habit.id}_$d')
            .get(const GetOptions(source: Source.serverAndCache));

        if (doc.exists && doc['completed'] == true) {
          completed++;
        }
      }

      final rate = days == 0 ? 0 : (completed / days);

      list.add({
        'habit': habit,
        'completionRate': rate,
      });
    }

    // Highest completion first
    list.sort((a, b) =>
        (b['completionRate'] as double).compareTo(a['completionRate'] as double));

    return list;
  }

  Map<String, int> getCompletionStats() {
    // OLD METHOD counted duplicate logs → WRONG
// final completed = todayCompletions.values.where((x) => x == true).length;

// NEW: completion = number of habits completed today, not number of log entries
    int completed = 0;
    for (final h in habits) {
      if (todayCompletions[h.id] == true) {
        completed++;
      }
    }

    final total = habits.length;


    return {
      'completed': completed,
      'total': total,
      'percentage': total == 0
          ? 0
          : ((completed / total) * 100).round(),
    };
  }

  /// -------------------------------------------------------------------------
  ///  BADGE SYSTEM
  /// -------------------------------------------------------------------------
  Future<void> _loadBadgeData() async {
    final prefs = await SharedPreferences.getInstance();
    totalXP.value = prefs.getInt('total_xp') ?? 0;
    final badgeIds = prefs.getStringList('unlocked_badges') ?? [];
    unlockedBadges.value = allBadges.where((b) => badgeIds.contains(b.id)).toList();
    
    final xpAwardedJson = prefs.getString('xp_awarded') ?? '{}';
    final xpAwardedMap = Map<String, dynamic>.from(jsonDecode(xpAwardedJson));
    xpAwarded.value = xpAwardedMap.map((k, v) => MapEntry(k, v as bool));
  }
  
  Future<void> _saveBadgeData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_xp', totalXP.value);
    await prefs.setStringList('unlocked_badges', unlockedBadges.map((b) => b.id).toList());
    await prefs.setString('xp_awarded', jsonEncode(xpAwarded));
  }
  
  Future<List<Badge>> checkStreakAndAwardBadges(int currentStreak) async {
    final newlyUnlocked = <Badge>[];
    
    for (final badge in allBadges) {
      if (currentStreak >= badge.streakRequired && !_hasBadge(badge.id)) {
        unlockedBadges.add(badge);
        newlyUnlocked.add(badge);
      }
    }
    
    if (newlyUnlocked.isNotEmpty) {
      await _saveBadgeData();
    }
    
    return newlyUnlocked;
  }
  Future<void> awardDailyXP() async {
    totalXP.value += dailyCheckInXP;
    await _saveBadgeData();
  }
  bool _hasBadge(String badgeId) => unlockedBadges.any((b) => b.id == badgeId);
  void _showBadgeAnimation(Badge badge, int streak) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.emoji, style: TextStyle(fontSize: 80)),
            SizedBox(height: 16),
            Text('You\'ve conquered the day!', 
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Great work!', 
              style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 16),
            Text(badge.name, 
              style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('$streak-day streak!', 
              style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// -------------------------------------------------------------------------
  ///  CLEANUP
  /// -------------------------------------------------------------------------
  @override
  void onClose() {
    _hSub?.cancel();
    _lSub?.cancel();
    super.onClose();
  }
}

/// Bindings
class HabitTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HabitTrackerController());
  }
}
