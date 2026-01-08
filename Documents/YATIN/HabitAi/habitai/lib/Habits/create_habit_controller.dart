import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'habit_controller.dart';
import 'habit_tracker.dart';
import '../services/notification_service.dart';
import '../navigation/main_navigation.dart';

class CreateHabitController extends GetxController {
  final HabitItem? existing;
  final String? initialHabitName;
  CreateHabitController(this.existing, [this.initialHabitName]);

  final habitNameController = TextEditingController();
  final goalController = TextEditingController();
  final goalValueController = TextEditingController();
  final reminderTextController = TextEditingController();

  var selectedIconIndex = 0.obs;
  var selectedFrequency = 'Daily'.obs;
  var selectedCategory = 'General'.obs;
  var remindersEnabled = false.obs;
  var selectedGoalPeriod = 'Day-Long'.obs;
  var selectedUnitTab = 'Quantity'.obs;
  var selectedUnit = 'count'.obs;
  var selectedColor = const Color(0xFF2196F3).obs;
  var selectedTimeRange = 'Anytime'.obs;

  // Reminder time (hour/minute) stored in controller for UI & scheduling
  var reminderHour = 9.obs;
  var reminderMinute = 0.obs;
  var reminderType = 'Time'.obs;
  var selectedTaskValue = 'Every Day'.obs;

  // Selected task value data
  var selectedDays = <String>{}.obs;
  var selectedMonthDays = <int>{}.obs;
  var daysPerWeek = 0.obs;
  var daysPerMonth = 0.obs;

  final habitIcons = [
    Icons.water_drop,
    Icons.directions_run,
    Icons.menu_book,
    Icons.self_improvement,
    Icons.eco,
    Icons.fitness_center,
    Icons.bedtime,
    Icons.rocket_launch,
    Icons.track_changes,
    Icons.work,
  ];

  final frequencies = ['Daily', 'Weekdays', 'Weekends', 'Custom'];
  final timeRanges = ['Anytime', 'Morning', 'Afternoon', 'Evening'];

  @override
  void onInit() {
    super.onInit();
    goalValueController.text = '1'; // Set default value
    if (existing != null) {
      habitNameController.text = existing!.title;
      goalController.text = existing!.subtitle;
      selectedFrequency.value = existing!.cadence.capitalizeFirst ?? 'Daily';
      final iconIndex = habitIcons.indexWhere((i) => i.codePoint == existing!.iconCode);
      selectedIconIndex.value = iconIndex >= 0 ? iconIndex : 0;
      selectedColor.value = Color(existing!.habitColor);
      // Initialize reminder state from existing if available
      remindersEnabled.value = existing!.reminders;
      // initialize persisted reminder time
      reminderHour.value = existing!.reminderHour;
      reminderMinute.value = existing!.reminderMinute;
      // Load goal data if available
      if (existing!.goalPeriod != null) selectedGoalPeriod.value = existing!.goalPeriod!;
      if (existing!.goalValue != null) goalValueController.text = existing!.goalValue.toString();
      if (existing!.goalUnit != null) selectedUnit.value = existing!.goalUnit!;
      if (existing!.timeRange != null) selectedTimeRange.value = existing!.timeRange!;
      if (existing!.reminderText != null) reminderTextController.text = existing!.reminderText!;
      if (existing!.reminderType != null) reminderType.value = existing!.reminderType!;
      if (existing!.taskValue != null) selectedTaskValue.value = existing!.taskValue!;
      
      // Load task data from Firestore
      _loadTaskDataFromFirestore();
    } else if (initialHabitName != null) {
      habitNameController.text = initialHabitName!;
    }
  }

  Future<void> _loadTaskDataFromFirestore() async {
    if (existing == null) return;
    
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('habits')
          .doc(existing!.id)
          .get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['selectedDays'] != null) {
          selectedDays.value = (data['selectedDays'] as List).cast<String>().toSet();
        }
        if (data['selectedMonthDays'] != null) {
          selectedMonthDays.value = (data['selectedMonthDays'] as List).cast<int>().toSet();
        }
        if (data['daysPerWeek'] != null) {
          daysPerWeek.value = data['daysPerWeek'] as int;
        }
        if (data['daysPerMonth'] != null) {
          daysPerMonth.value = data['daysPerMonth'] as int;
        }
      }
    } catch (e) {
      print('Error loading task data: $e');
    }
  }

  Future<void> saveHabit(bool isEdit, HabitItem? existingHabit) async {
    final name = habitNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a habit name');
      return;
    }

    // derive daysOfWeek from selectedFrequency
    List<int> computedDays;
    if (selectedFrequency.value == 'Weekdays') {
      computedDays = [1, 2, 3, 4, 5];
    } else if (selectedFrequency.value == 'Weekends') {
      computedDays = [6, 7];
    } else {
      computedDays = [1, 2, 3, 4, 5, 6, 7];
    }

    final data = {
      'title': name,
      'subtitle': goalController.text.trim(),
      'iconCode': habitIcons[selectedIconIndex.value].codePoint,
      'habitColor': selectedColor.value.value,
      'cadence': selectedFrequency.value.toLowerCase(),
      'daysOfWeek': computedDays,
      'category': selectedCategory.value.toLowerCase(),
      'reminders': remindersEnabled.value,
      'reminderHour': reminderHour.value,
      'reminderMinute': reminderMinute.value,
      'isDynamic': false,
      'goalPeriod': selectedGoalPeriod.value,
      'goalValue': int.tryParse(goalValueController.text.trim()) ?? 1,
      'goalUnit': selectedUnit.value,
      'timeRange': selectedTimeRange.value,
      'reminderText': reminderTextController.text.trim(),
      'reminderType': reminderType.value,
      'taskValue': selectedTaskValue.value,
    };

    // Only store data for the selected task value
    switch (selectedTaskValue.value) {
      case 'Specific days of the week':
        data['selectedDays'] = selectedDays.toList();
        break;
      case 'Number of days per week':
        data['daysPerWeek'] = daysPerWeek.value;
        break;
      case 'Specific days of the month':
        data['selectedMonthDays'] = selectedMonthDays.toList();
        break;
      case 'Number of days per month':
        data['daysPerMonth'] = daysPerMonth.value;
        break;
    }

    final habitCtrl = Get.find<HabitTrackerController>();

    if (isEdit && existingHabit != null) {
      // Update existing habit
      await habitCtrl.updateHabit(existingHabit.id, data);
      await NotificationService().showImmediateHabitSavedNotification(name);

      // Manage reminders: if turned on → schedule; if turned off but previously on → cancel
      // cancel previously scheduled reminders to avoid duplicates before rescheduling
      await NotificationService().cancelHabitReminders(existingHabit.id);

      bool scheduleOk = true;
      if (remindersEnabled.value) {
        // map cadence to daysOfWeek
        List<int>? days;
        if (selectedFrequency.value == 'Weekdays') days = [1, 2, 3, 4, 5];
        else if (selectedFrequency.value == 'Weekends') days = [6, 7];
        else days = null;

        scheduleOk = await NotificationService().scheduleHabitReminder(
            existingHabit.id, reminderHour.value, reminderMinute.value,
            daysOfWeek: days);
      } else {
        // already cancelled above
      }
      // Close screen and show snackbar safely — guard against Get internal race.
      try {
        Get.back();
      } catch (e) {
        // ignore navigation error if Get isn't fully ready
      }
      // Delay slightly to allow navigation stack to settle and Get snackbar controller to initialize.
      await Future.delayed(const Duration(milliseconds: 350));
      try {
        if (scheduleOk) {
          Get.snackbar('Success', 'Habit updated successfully!',
              backgroundColor: Colors.blue, colorText: Colors.white);
        } else {
          Get.snackbar('Saved, but reminder not scheduled',
              'Device prevented scheduling the reminder. Reminders may not fire. Test on a real device or enable exact alarms.',
              backgroundColor: Colors.orange.shade900, colorText: Colors.white);
        }
      } catch (_) {
        // swallow snackbar errors to avoid app crash
      }
    } else {
      // Create new habit and schedule reminder if needed
      final newId = await habitCtrl.createHabit(data);
      bool scheduleOk = true;
      if (newId != null && remindersEnabled.value) {
        List<int>? days;
        if (selectedFrequency.value == 'Weekdays') days = [1, 2, 3, 4, 5];
        else if (selectedFrequency.value == 'Weekends') days = [6, 7];
        else days = null;
        scheduleOk = await NotificationService().scheduleHabitReminder(
            newId, reminderHour.value, reminderMinute.value,
            daysOfWeek: days);
      }
      await NotificationService().showImmediateHabitSavedNotification(name);

      // Close screen and show result safely
      try {
        Get.offAll(() => MainNavigationScreen());
      } catch (e) {}
      await Future.delayed(const Duration(milliseconds: 350));
      try {
        if (scheduleOk) {
          Get.snackbar('Success', 'Habit created successfully!',
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar('Created, but reminder not scheduled',
              'Device prevented scheduling the reminder. Reminders may not fire. Test on a real device or enable exact alarms.',
              backgroundColor: Colors.orange.shade900, colorText: Colors.white);
        }
      } catch (_) {}
    }
  }

  void selectIcon(int i) => selectedIconIndex.value = i;
  void selectFrequency(String f) => selectedFrequency.value = f;
  void selectGoalPeriod(String period) => selectedGoalPeriod.value = period;
  void selectUnitTab(String tab) => selectedUnitTab.value = tab;
  void selectUnit(String unit) => selectedUnit.value = unit;
  void selectColor(Color color) => selectedColor.value = color;
  void selectTimeRange(String range) => selectedTimeRange.value = range;

  void setReminderTime(int hour, int minute) {
    reminderHour.value = hour;
    reminderMinute.value = minute;
  }

  void setReminderType(String type) {
    reminderType.value = type;
  }

  void selectTaskValue(String value) {
    selectedTaskValue.value = value;
  }

  void updateSelectedDays(Set<String> days) {
    selectedDays.value = days;
  }

  void updateSelectedMonthDays(Set<int> days) {
    selectedMonthDays.value = days;
  }

  void updateDaysPerWeek(int days) {
    daysPerWeek.value = days;
  }

  void updateDaysPerMonth(int days) {
    daysPerMonth.value = days;
  }

  @override
  void onClose() {
    habitNameController.dispose();
    goalController.dispose();
    goalValueController.dispose();
    reminderTextController.dispose();
    super.onClose();
  }
}