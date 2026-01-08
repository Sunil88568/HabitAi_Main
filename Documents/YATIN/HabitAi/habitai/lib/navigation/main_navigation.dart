import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Habits/habit_tracker.dart';
import '../features/progress/progress.dart';
import '../Habits/CalenderScreen.dart';
import '../Components/ProfileScreen.dart';
import '../Ai Chat/ai_chat.dart';
import '../Ai Chat/simple_chat_controller.dart';
class MainNavigationController extends GetxController {
  var selectedIndex = 0.obs;
}
class MainNavigationScreen extends StatelessWidget {
  final controller = Get.put(MainNavigationController());
  Widget _buildAIChatScreen() {
    Get.put(SimpleChatController());
    return AICoachChatScreen();
  }
  List<Widget> get screens => [
        HabitTrackerScreen(),
        ProgressScreen(),
        _buildAIChatScreen(),
        CalendarScreen(),
        ProfileScreen(),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.selectedIndex.value = index,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              const BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Progress'),
              // BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI Chat'),
              BottomNavigationBarItem(
                icon: Image.asset(
                  controller.selectedIndex.value==2
                      ? 'assets/icons/AI_Icon_Active.png' // your active icon path
                      : 'assets/icons/AI_Icon.png', // yourr icon path
                  width: 28, // size of the icon
                  height: 28,
                ),
                label: 'AI Chat',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
              const BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
          )),
    );
  }
}