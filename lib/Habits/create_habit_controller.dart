import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'habit_controller.dart';

class CreateHabitController extends GetxController {
  final HabitItem? existing;
  CreateHabitController(this.existing);

  final habitNameController = TextEditingController();
  final goalController = TextEditingController();

  var selectedIconIndex = 0.obs;
  var selectedFrequency = 'Daily'.obs;
  var selectedCategory = 'General'.obs;
  var remindersEnabled = false.obs;

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
    }
  }

  Future<void> saveHabit(bool isEdit, HabitItem? existingHabit) async {
    final name = habitNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a habit name');
      return;
    }

    final data = {
      'title': name,
      'subtitle': goalController.text.trim(),
      'iconCode': habitIcons[selectedIconIndex.value].codePoint,
      'cadence': selectedFrequency.value.toLowerCase(),
      'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
      'category': selectedCategory.value.toLowerCase(),
      'reminders': remindersEnabled.value,
      'isDynamic': false,
    };

    final habitCtrl = Get.find<HabitTrackerController>();

    if (isEdit && existingHabit != null) {
      await habitCtrl.updateHabit(existingHabit.id, data);
      Get.snackbar('Success', 'Habit updated successfully!',
          backgroundColor: Colors.blue, colorText: Colors.white);
    } else {
      await habitCtrl.createHabit(data);
      Get.snackbar('Success', 'Habit created successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
    }

    Get.back();
  }

  void selectIcon(int i) => selectedIconIndex.value = i;
  void selectFrequency(String f) => selectedFrequency.value = f;

  @override
  void onClose() {
    habitNameController.dispose();
    goalController.dispose();
    super.onClose();
  }
}
