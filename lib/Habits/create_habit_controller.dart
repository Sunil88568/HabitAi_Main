// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // import 'habit_controller.dart';
// //
// // // GetX Controller
// // class CreateHabitController extends GetxController {
// //   final habitNameController = TextEditingController();
// //   final goalController = TextEditingController();
// //
// //   var selectedIconIndex = 3.obs;
// //
// //   // Selected frequency
// //   var selectedFrequency = 'Daily'.obs;
// //
// //   // Available icons
// //   final List<IconData> habitIcons = [
// //     Icons.water_drop,
// //     Icons.directions_run,
// //     Icons.menu_book,
// //     Icons.self_improvement,
// //     Icons.bedtime,
// //     Icons.eco,
// //     Icons.fitness_center,
// //     Icons.edit,
// //     Icons.track_changes,
// //     Icons.rocket_launch,
// //   ];
// //
// //   final List<String> frequencies = ['Daily', 'Weekdays', 'Weekends', 'Custom'];
// //
// //   void selectIcon(int index) {
// //     selectedIconIndex.value = index;
// //   }
// //
// //   void selectFrequency(String frequency) {
// //     selectedFrequency.value = frequency;
// //   }
// //
// //   void createHabit() {
// //     if (habitNameController.text.trim().isEmpty) {
// //       Get.snackbar('Error', 'Please enter habit name');
// //       return;
// //     }
// //
// //     // Create HabitItem object
// //     final newHabit = HabitItem(
// //       icon: habitIcons[selectedIconIndex.value],
// //       title: habitNameController.text,
// //       subtitle: '${selectedFrequency.value} - ${goalController.text}',
// //       isCompleted: false,
// //       isDynamic: false,
// //     );
// //
// //     // Navigate back with result
// //     Get.back(result: newHabit);
// //   }
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     habitNameController.text = 'Morning Yoga';
// //     goalController.text = '15 minutes';
// //   }
// //
// //   @override
// //   void onClose() {
// //     habitNameController.dispose();
// //     goalController.dispose();
// //     super.onClose();
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:habit_ai/Habits/firestore_service.dart';
// import 'package:uuid/uuid.dart';
// import 'habit_controller.dart';
//
// class CreateHabitController extends GetxController {
//   final habitNameController = TextEditingController();
//   final goalController = TextEditingController();
//   var selectedIconIndex = 3.obs;
//   var selectedFrequency = 'Daily'.obs;
//
//   final List<IconData> habitIcons = [
//     Icons.water_drop,
//     Icons.directions_run,
//     Icons.menu_book,
//     Icons.self_improvement,
//     Icons.bedtime,
//     Icons.eco,
//     Icons.fitness_center,
//     Icons.edit,
//     Icons.track_changes,
//     Icons.rocket_launch,
//   ];
//
//   final List<String> frequencies = ['Daily', 'Weekdays', 'Weekends', 'Custom'];
//   final FirestoreService _firestore = FirestoreService();
//
//   void selectIcon(int index) {
//     selectedIconIndex.value = index;
//   }
//
//   void selectFrequency(String frequency) {
//     selectedFrequency.value = frequency;
//   }
//
//   Future<void> createHabit() async {
//     if (habitNameController.text.trim().isEmpty) {
//       Get.snackbar('Error', 'Please enter habit name');
//       return;
//     }
//
//     final habitId = const Uuid().v4();
//     final newHabit = HabitItem(
//       id: habitId,
//       userId: _firestore.userId,
//       icon: habitIcons[selectedIconIndex.value],
//       title: habitNameController.text,
//       subtitle: '${selectedFrequency.value} - ${goalController.text.isEmpty ? '' : goalController.text}',
//       frequency: selectedFrequency.value,
//       goal: goalController.text,
//       isDynamic: false,
//       createdAt: DateTime.now(),
//     );
//
//     await _firestore.addHabit(newHabit);
//
//     Get.back(result: newHabit);
//
//     Get.snackbar(
//       'Success',
//       'New habit "${newHabit.title}" added!',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//     );
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     habitNameController.text = 'Morning Yoga';
//     goalController.text = '15 minutes';
//   }
//
//   @override
//   void onClose() {
//     habitNameController.dispose();
//     goalController.dispose();
//     super.onClose();
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'habit_controller.dart';  // For HabitItem (though not used directly now)

class CreateHabitController extends GetxController {
  final habitNameController = TextEditingController();
  final goalController = TextEditingController();

  var selectedIconIndex = 3.obs;
  var selectedFrequency = 'Daily'.obs;

  // Available icons
  final List<IconData> habitIcons = [
    Icons.water_drop,
    Icons.directions_run,
    Icons.menu_book,
    Icons.self_improvement,
    Icons.bedtime,
    Icons.eco,
    Icons.fitness_center,
    Icons.edit,
    Icons.track_changes,
    Icons.rocket_launch,
  ];

  final List<String> frequencies = ['Daily', 'Weekdays', 'Weekends', 'Custom'];

  void selectIcon(int index) {
    selectedIconIndex.value = index;
  }

  void selectFrequency(String frequency) {
    selectedFrequency.value = frequency;
  }

  Future<void> createHabit() async {
    if (habitNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter habit name');
      return;
    }

    // Prepare data for Firestore
    final data = {
      'title': habitNameController.text.trim(),
      'subtitle': '${selectedFrequency.value} - ${goalController.text.trim()}',
      'iconCode': habitIcons[selectedIconIndex.value].codePoint,
      'frequency': selectedFrequency.value,
      'goal': goalController.text.trim(),
      'isDynamic': false,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('habits').add(data);
      Get.back();  // Navigate back; stream in parent will update
      Get.snackbar(
        'Success',
        'New habit "${habitNameController.text.trim()}" added!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create habit: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    habitNameController.text = 'Morning Yoga';
    goalController.text = '15 minutes';
  }

  @override
  void onClose() {
    habitNameController.dispose();
    goalController.dispose();
    super.onClose();
  }
}