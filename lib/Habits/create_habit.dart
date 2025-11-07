import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_habit_controller.dart';
import 'habit_controller.dart';

class CreateNewHabitScreen extends StatelessWidget {
  final HabitItem? existingHabit;

  const CreateNewHabitScreen({Key? key, this.existingHabit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEdit = existingHabit != null;
    final controller = Get.put(CreateHabitController(existingHabit));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEdit ? 'Edit Habit' : 'Create New Habit',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: isEdit
            ? [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              final c = Get.find<HabitTrackerController>();
              await c.removeHabit(existingHabit!.id);
              Get.back();
            },
          ),
        ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Habit Name'),
            _inputField(controller.habitNameController),
            const SizedBox(height: 24),
            _label('Choose Icon'),
            _iconGrid(controller),
            const SizedBox(height: 24),
            _label('Frequency'),
            _frequencyChips(controller),
            const SizedBox(height: 24),
            _label('Goal'),
            _inputField(controller.goalController),
            const SizedBox(height: 32),
            _saveButton(isEdit, controller, existingHabit),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
  );

  Widget _inputField(TextEditingController c) => Container(
    decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(12)),
    child: TextField(
      controller: c,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
    ),
  );

  Widget _iconGrid(CreateHabitController controller) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemCount: controller.habitIcons.length,
    itemBuilder: (context, index) => Obx(() {
      final isSelected = controller.selectedIconIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectIcon(index),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: const Color(0xFF6C5CE7), width: 2) : null,
          ),
          child: Icon(
            controller.habitIcons[index],
            color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey,
            size: 28,
          ),
        ),
      );
    }),
  );

  Widget _frequencyChips(CreateHabitController controller) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: controller.frequencies.map((frequency) {
      return Obx(() {
        final isSelected = controller.selectedFrequency.value == frequency;
        return GestureDetector(
          onTap: () => controller.selectFrequency(frequency),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
                  : null,
              color: isSelected ? null : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              frequency,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      });
    }).toList(),
  );

  Widget _saveButton(bool isEdit, CreateHabitController controller, HabitItem? existing) =>
      SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            onPressed: () => controller.saveHabit(isEdit, existing),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              isEdit ? 'Save Changes' : 'Create Habit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
}
