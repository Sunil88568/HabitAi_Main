import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'habit_controller.dart';
import '../services/notification_service.dart';

class CreateHabitController extends GetxController {
  final HabitItem? existing;
  CreateHabitController(this.existing);

  final habitNameController = TextEditingController();
  final goalController = TextEditingController();

  var selectedIconIndex = 0.obs;
  var selectedFrequency = 'Daily'.obs;
  var selectedCategory = 'General'.obs;
  var remindersEnabled = false.obs;

  // Reminder time (hour/minute) stored in controller for UI & scheduling
  var reminderHour = 9.obs;
  var reminderMinute = 0.obs;

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

  @override
  void onInit() {
    super.onInit();
    if (existing != null) {
      habitNameController.text = existing!.title;
      goalController.text = existing!.subtitle;
      selectedFrequency.value = existing!.cadence.capitalizeFirst ?? 'Daily';
      selectedIconIndex.value =
          habitIcons.indexWhere((i) => i.codePoint == existing!.iconCode);
      // Initialize reminder state from existing if available
      remindersEnabled.value = existing!.reminders;
      // initialize persisted reminder time
      reminderHour.value = existing!.reminderHour;
      reminderMinute.value = existing!.reminderMinute;
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
      'cadence': selectedFrequency.value.toLowerCase(),
      'daysOfWeek': computedDays,
      'category': selectedCategory.value.toLowerCase(),
      'reminders': remindersEnabled.value,
      'reminderHour': reminderHour.value,
      'reminderMinute': reminderMinute.value,
      'isDynamic': false,
    };

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
        Get.back();
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

  void setReminderTime(int hour, int minute) {
    reminderHour.value = hour;
    reminderMinute.value = minute;
  }

  @override
  void onClose() {
    habitNameController.dispose();
    goalController.dispose();
    super.onClose();
  }
}
