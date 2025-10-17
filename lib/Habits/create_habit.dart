// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:habit_ai/Habits/create_habit_controller.dart';
//
// class CreateNewHabitScreen extends StatelessWidget {
//   const CreateNewHabitScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CreateHabitController());
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Create New Habit',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Habit Name Section
//             const Text(
//               'Habit Name',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2A2A2A),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextField(
//                 controller: controller.habitNameController,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(16),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 32),
//
//             // Choose Icon Section
//             const Text(
//               'Choose Icon',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Icon Grid
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1,
//               ),
//               itemCount: controller.habitIcons.length,
//               itemBuilder: (context, index) {
//                 return Obx(() {
//                   final isSelected = controller.selectedIconIndex.value == index;
//                   return GestureDetector(
//                     onTap: () => controller.selectIcon(index),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF2A2A2A),
//                         borderRadius: BorderRadius.circular(12),
//                         border: isSelected
//                             ? Border.all(color: const Color(0xFF6C5CE7), width: 2)
//                             : null,
//                       ),
//                       child: Icon(
//                         controller.habitIcons[index],
//                         color: isSelected
//                             ? const Color(0xFF6C5CE7)
//                             : Colors.grey,
//                         size: 28,
//                       ),
//                     ),
//                   );
//                 });
//               },
//             ),
//
//             const SizedBox(height: 32),
//
//             // Frequency Section
//             const Text(
//               'Frequency',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Frequency Buttons
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: controller.frequencies.map((frequency) {
//                 return Obx(() {
//                   final isSelected = controller.selectedFrequency.value == frequency;
//                   return  GestureDetector(
//                     onTap: () => controller.selectFrequency(frequency),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       decoration: BoxDecoration(
//                         gradient: isSelected
//                             ? const LinearGradient(
//                           colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         )
//                             : null,
//                         color: isSelected
//                             ? null
//                             : const Color(0xFF2A2A2A),
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Text(
//                         frequency,
//                         style: TextStyle(
//                           color: isSelected
//                               ? Colors.white
//                               : Colors.grey,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   );
//                 });
//               }).toList(),
//             ),
//
//             const SizedBox(height: 32),
//
//             // Goal Section
//             const Text(
//               'Goal',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2A2A2A),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextField(
//                 controller: controller.goalController,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(16),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 48),
//
//             // Create Habit Button
//             SizedBox(
//               width: double.infinity,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: controller.createHabit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                     shadowColor: Colors.transparent,
//                   ),
//                   child: const Text(
//                     'Create Habit',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './create_habit_controller.dart';

class CreateNewHabitScreen extends StatelessWidget {
  const CreateNewHabitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateHabitController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create New Habit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Name',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.habitNameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Choose Icon',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: controller.habitIcons.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final isSelected = controller.selectedIconIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.selectIcon(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF6C5CE7), width: 2)
                            : null,
                      ),
                      child: Icon(
                        controller.habitIcons[index],
                        color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey,
                        size: 28,
                      ),
                    ),
                  );
                });
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Frequency',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
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
            ),
            const SizedBox(height: 32),
            const Text(
              'Goal',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.goalController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 48),
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
                  onPressed: controller.createHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Create Habit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}