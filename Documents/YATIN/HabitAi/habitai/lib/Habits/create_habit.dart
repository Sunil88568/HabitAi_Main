import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart'; // add for formatting time
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'create_habit_controller.dart';
import 'habit_controller.dart';
import 'GoalPeriodScreen.dart';
import '../theme/app_theme.dart';
import 'location_picker_screen.dart';

class CreateNewHabitScreen extends StatelessWidget {
  final HabitItem? existingHabit;
  final String? initialHabitName;
  const CreateNewHabitScreen(
      {Key? key, this.existingHabit, this.initialHabitName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isEdit = existingHabit != null;
    final controller =
        Get.put(CreateHabitController(existingHabit, initialHabitName));
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEdit ? 'Edit Habit' : 'Create New Habit',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: isEdit
            ? [
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkError
                          : AppColors.lightError),
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
            _label(context, 'Habit Name'),
            _inputField(context, controller.habitNameController),
            const SizedBox(height: 24),
            _label(context, 'Choose Icon'),
            _iconGrid(context, controller),
            const SizedBox(height: 24),
            _label(context, 'Goal'),
            _inputField(context, controller.goalController),
            const SizedBox(height: 24),
            _label(context, 'Choose Color'),
            _colorPicker(context),
            const SizedBox(height: 24),
            _goalSection(context, controller),
            const SizedBox(height: 24),
            _label(context, 'Frequency'),
            _frequencyChips(context, controller),
            const SizedBox(height: 24),
            _label(context, 'Time Range'),
            _timeRangeChips(context, controller),
            const SizedBox(height: 24),
            // Reminders toggle + Time picker
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(context, 'Reminders'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          'Enable reminders for this habit',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkSecondaryText
                                      : AppColors.lightSecondaryText),
                        )),
                        Switch(
                          value: controller.remindersEnabled.value,
                          onChanged: (v) =>
                              controller.remindersEnabled.value = v,
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    if (controller.remindersEnabled.value) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Time',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkSecondaryText
                                            : AppColors.lightSecondaryText)),

                                FilledButton(
                                    onPressed: () =>
                                        _reminderSheet(context, controller),
                                    child: const Icon(Icons.add_rounded,
                                        color: Colors.white))
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: controller.reminderTextController,
                              style: Theme.of(context).textTheme.bodyLarge,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                hintText: 'You can do this!',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkSecondaryText
                                      : AppColors.lightSecondaryText,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.darkSecondaryText
                                            .withOpacity(0.2)
                                        : AppColors.lightSecondaryText
                                            .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                )),
            const SizedBox(height: 32),
            _saveButton(context, isEdit, controller, existingHabit),
          ],
        ),
      ),
    );
  }
  
  Widget _label(BuildContext context, String text) => Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
              fontWeight: FontWeight.w500,
            ),
      );

  Widget _inputField(BuildContext context, TextEditingController c) =>
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12)),
        child: TextField(
          controller: c,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: const InputDecoration(
              border: InputBorder.none, contentPadding: EdgeInsets.all(16)),
        ),
      );

  Widget _iconGrid(BuildContext context, CreateHabitController controller) =>
      GridView.builder(
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
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).primaryColor, width: 2)
                    : null,
              ),
              child: Icon(
                controller.habitIcons[index],
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText),
                size: 28,
              ),
            ),
          );
        }),
      );

  Widget _frequencyChips(
          BuildContext context, CreateHabitController controller) =>
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.frequencies.map((frequency) {
          return Obx(() {
            final isSelected = controller.selectedFrequency.value == frequency;
            return GestureDetector(
              onTap: () => controller.selectFrequency(frequency),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? [AppColors.darkPrimary, AppColors.darkSecondary]
                              : [
                                  AppColors.lightPrimary,
                                  AppColors.lightSecondary
                                ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: isSelected ? null : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  frequency,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          });
        }).toList(),
      );

  Widget _timeRangeChips(
          BuildContext context, CreateHabitController controller) =>
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.timeRanges.map((range) {
          return Obx(() {
            final isSelected = controller.selectedTimeRange.value == range;
            return GestureDetector(
              onTap: () => controller.selectTimeRange(range),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? [AppColors.darkPrimary, AppColors.darkSecondary]
                              : [
                                  AppColors.lightPrimary,
                                  AppColors.lightSecondary
                                ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: isSelected ? null : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  range,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          });
        }).toList(),
      );

  Widget _saveButton(BuildContext context, bool isEdit,
          CreateHabitController controller, HabitItem? existing) =>
      SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [AppColors.darkPrimary, AppColors.darkSecondary]
                  : [AppColors.lightPrimary, AppColors.lightSecondary],
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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

  Widget _goalSection(BuildContext context, CreateHabitController controller) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label(context, 'Goal Period'),
              GestureDetector(
                onTap: () => _showGoalPeriodDialog(context, controller),
                child: Row(
                  children: [
                    Obx(() => Text(controller.selectedGoalPeriod.value,
                        style: Theme.of(context).textTheme.titleMedium)),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text('Goal Value',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                SizedBox(
                  width: 60,
                  height: 25,
                  child: TextField(
                    controller: controller.goalValueController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showUnitDialog(context, controller),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() => Text(controller.selectedUnit.value,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => Text(
                    controller.selectedGoalPeriod.value == 'Day-Long'
                        ? '/ Day'
                        : controller.selectedGoalPeriod.value == 'Week-Long'
                            ? '/ Week'
                            : '/ Month',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                        ))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Get.to(() => GoalPeriodScreen(controller: controller)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).cardColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text('Task Value',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  Obx(() => Text(controller.selectedTaskValue.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.lightSecondaryText,
                          ))),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      );
 
  void _showGoalPeriodDialog(
      BuildContext context, CreateHabitController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Goal Period',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ...['Day-Long', 'Week-Long', 'Month-Long']
                .map(
                  (period) => Obx(() => InkWell(
                        onTap: () {
                          controller.selectGoalPeriod(period);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                period,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.selectedGoalPeriod.value ==
                                          period
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color:
                                        controller.selectedGoalPeriod.value ==
                                                period
                                            ? Theme.of(context).primaryColor
                                            : (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.darkSecondaryText
                                                : AppColors.lightSecondaryText),
                                    width: 2,
                                  ),
                                ),
                                child: controller.selectedGoalPeriod.value ==
                                        period
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      )),
                )
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _colorPicker(BuildContext context) {
    final controller = Get.find<CreateHabitController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Color Preview
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Obx(() => Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: controller.selectedColor.value,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.2)),
                      ),
                    )),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Color Palette
        Text(
          'Quick Colors',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _colorCircle(Colors.red, controller),
            _colorCircle(Colors.orange, controller),
            _colorCircle(Colors.yellow, controller),
            _colorCircle(Colors.green, controller),
            _colorCircle(Colors.blue, controller),
            _colorCircle(Colors.purple, controller),
            _colorCircle(Colors.pink, controller),
            _colorCircle(Colors.teal, controller),
            _colorCircle(Colors.indigo, controller),
            _colorCircle(Colors.brown, controller),
            _colorCircle(Colors.grey, controller),
            _colorCircle(Colors.black, controller),
            CircleAvatar(
              child: IconButton(
                  onPressed: () {
                    _showColorWheel(context, controller);
                  },
                  icon: Icon(Icons.add_rounded,
                      color: Theme.of(context).colorScheme.onBackground)),
            )
          ],
        ),
      ],
    );
  }

  Widget _colorCircle(Color color, CreateHabitController controller) => Obx(() {
        final isSelected = controller.selectedColor.value == color;
        return GestureDetector(
          onTap: () => controller.selectColor(color),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
                if (isSelected)
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
          ),
        );
      });

  void _showColorWheel(BuildContext context, CreateHabitController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: controller.selectedColor.value,
            onColorChanged: (color) => controller.selectColor(color),
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showUnitDialog(BuildContext context, CreateHabitController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.36,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select Unit',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Obx(() => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectUnitTab('Quantity'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  controller.selectedUnitTab.value == 'Quantity'
                                      ? (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Quantity',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: controller.selectedUnitTab.value ==
                                            'Quantity'
                                        ? Colors.white
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkSecondaryText
                                            : AppColors.lightSecondaryText),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectUnitTab('Time'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedUnitTab.value == 'Time'
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Time',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: controller.selectedUnitTab.value ==
                                            'Time'
                                        ? Colors.white
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkSecondaryText
                                            : AppColors.lightSecondaryText),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() => controller.selectedUnitTab.value == 'Time'
                    ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['sec', 'min', 'hr']
                            .map(
                              (unit) => GestureDetector(
                                onTap: () {
                                  controller.selectUnit(unit);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: controller.selectedUnit.value == unit
                                        ? (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary)
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkSecondaryText
                                                .withOpacity(0.2)
                                            : AppColors.lightSecondaryText
                                                .withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    unit,
                                    style: TextStyle(
                                      color: controller.selectedUnit.value ==
                                              unit
                                          ? Colors.white
                                          : (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? AppColors.darkSecondaryText
                                              : AppColors.lightSecondaryText),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2 / 1,
                        children: [
                          ...[
                            'count',
                            'steps',
                            'm',
                            'km',
                            'mile',
                            'ml',
                            'oz',
                            'Cal',
                            'g',
                            'mg',
                            'drink'
                          ].map((unit) => GestureDetector(
                                onTap: () {
                                  controller.selectUnit(unit);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: controller.selectedUnit.value == unit
                                        ? (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary)
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.darkSecondaryText
                                                .withOpacity(0.2)
                                            : AppColors.lightSecondaryText
                                                .withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      unit,
                                      style: TextStyle(
                                        color: controller.selectedUnit.value ==
                                                unit
                                            ? Colors.white
                                            : (Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.darkSecondaryText
                                                : AppColors.lightSecondaryText),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          GestureDetector(
                            onTap: () =>
                                _showCustomUnitDialog(context, controller),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.darkSecondaryText
                                        .withOpacity(0.2)
                                    : AppColors.lightSecondaryText
                                        .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkSecondaryText
                                          .withOpacity(0.5)
                                      : AppColors.lightSecondaryText
                                          .withOpacity(0.5),
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.darkSecondaryText
                                      : AppColors.lightSecondaryText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCustomUnitDialog(
      BuildContext context, CreateHabitController controller) {
    final customUnitController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Custom Unit',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: customUnitController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: 'Enter custom unit',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkSecondaryText.withOpacity(0.3)
                          : AppColors.lightSecondaryText.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkSecondaryText
                              : AppColors.lightSecondaryText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? [AppColors.darkPrimary, AppColors.darkSecondary]
                              : [
                                  AppColors.lightPrimary,
                                  AppColors.lightSecondary
                                ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final customUnit = customUnitController.text.trim();
                          if (customUnit.isNotEmpty) {
                            controller.selectUnit(customUnit);
                            Navigator.pop(context);
                            Navigator.pop(context); // Close unit dialog too
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text('Add'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reminderSheet(BuildContext context, CreateHabitController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showCupertinoTimePicker(context, controller);
                  },
                  child: const Text('Time'),
                ),
              ),
              // const SizedBox(width: 16),
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //       Get.to(() => LocationPickerScreen());
              //     },
              //     child: const Text('Location'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoTimePicker(
      BuildContext context, CreateHabitController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.close,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkSecondaryText
                            : AppColors.lightSecondaryText),
                  ),
                  Text('Select Time',
                      style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Done',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: Duration(
                      hours: controller.reminderHour.value,
                      minutes: controller.reminderMinute.value,
                    ),
                    onTimerDurationChanged: (duration) {
                      controller.setReminderTime(
                          duration.inHours, duration.inMinutes % 60);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}