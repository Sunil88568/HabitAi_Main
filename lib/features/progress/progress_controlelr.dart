import 'package:get/get.dart';

import '../../Habits/habit_controller.dart';

class ProgressController extends GetxController {
  // Observable variables
  final _weeklyProgress = 0.75.obs;
  final _currentStreak = 12.obs;
  final _bestStreak = 28.obs;
  final _totalCompleted = 156.obs;
  final _successRate = 0.92.obs;
  final _currentTime = '9:41'.obs;
  final _batteryLevel = 1.0.obs;
  final _isCharging = true.obs;

  // Getters
  double get weeklyProgress => _weeklyProgress.value;
  int get currentStreak => _currentStreak.value;
  int get bestStreak => _bestStreak.value;
  int get totalCompleted => _totalCompleted.value;
  double get successRate => _successRate.value;
  String get currentTime => _currentTime.value;
  double get batteryLevel => _batteryLevel.value;
  bool get isCharging => _isCharging.value;

  // Computed properties
  String get weeklyProgressPercentage => '${(_weeklyProgress.value * 100).toInt()}%';
  String get successRatePercentage => '${(_successRate.value * 100).toInt()}%';

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _loadProgressFromHabits();
  }
  void _loadProgressFromHabits() {
    // Get the habit tracker controller if it exists
    try {
      final habitController = Get.find<HabitTrackerController>();

      // Calculate progress based on current habits
      final progressValue = habitController.calculateWeeklyProgress();
      _weeklyProgress.value = progressValue;

      // Get completion stats
      final stats = habitController.getCompletionStats();
      _totalCompleted.value = stats['completed']!;

      // Update success rate based on completion ratio
      if (stats['total']! > 0) {
        _successRate.value = stats['completed']! / stats['total']!;
      }

    } catch (e) {
      // Handle case where habit controller doesn't exist
      print('Habit controller not found, using default values');
    }
  }

  // Update the refresh method to recalculate from habits
  Future<void> refreshProgress() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loadProgressFromHabits();
  }
}

  // Methods to update data
  // void updateWeeklyProgress(double progress) {
  //   _weeklyProgress.value = progress;
  // }
  //
  // void updateStreaks(int current, int best) {
  //   _currentStreak.value = current;
  //   _bestStreak.value = best;
  // }
  //
  // void updateStats(int completed, double successRate) {
  //   _totalCompleted.value = completed;
  //   _successRate.value = successRate;
  // }

  void _updateTime() {
    // This could be connected to a real time service
    // For now, keeping the static time
  }

  void _loadProgressData() {
    // This is where you would load data from your data source
    // API calls, local storage, etc.
  }

  // Method to refresh data
  Future<void> refreshProgress() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Update with new data (this would come from your API)
    _loadProgressData();
  }
