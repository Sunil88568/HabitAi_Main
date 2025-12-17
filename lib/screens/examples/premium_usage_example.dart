import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/revenue_cat_service.dart';
import '../../widgets/premium_gate.dart';
import '../paywall/paywall_screen.dart';

// Example of how to use premium features in your app
class PremiumUsageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = Get.find<RevenueCatService>();
    
    return Scaffold(
      appBar: AppBar(title: Text('Premium Features Example')),
      body: Column(
        children: [
          // Show habit limit warning
          HabitLimitWidget(),
          
          // Create habit button with premium gate
          PremiumGate(
            feature: 'unlimited_habits',
            child: ElevatedButton(
              onPressed: () {
                if (service.canCreateHabit()) {
                  // Create habit logic
                  _createHabit();
                } else {
                  // This shouldn't happen due to PremiumGate, but safety check
                  Get.to(() => PaywallScreen());
                }
              },
              child: Text('Create New Habit'),
            ),
          ),
          
          // AI Coach with limit
          AICoachLimitWidget(
            child: ElevatedButton(
              onPressed: () {
                if (service.canUseAICoach()) {
                  service.incrementAIUsage();
                  _useAICoach();
                } else {
                  Get.to(() => PaywallScreen());
                }
              },
              child: Text('Ask AI Coach'),
            ),
          ),
          
          // Premium-only features
          PremiumGate(
            feature: 'advanced_stats',
            child: Card(
              child: ListTile(
                title: Text('Advanced Statistics'),
                subtitle: Text('Detailed analytics and insights'),
                trailing: Icon(Icons.analytics),
                onTap: () => _showAdvancedStats(),
              ),
            ),
          ),
          
          PremiumGate(
            feature: 'premium_themes',
            child: Card(
              child: ListTile(
                title: Text('Premium Themes'),
                subtitle: Text('Beautiful custom themes'),
                trailing: Icon(Icons.palette),
                onTap: () => _showThemeSelector(),
              ),
            ),
          ),
          
          // Manual paywall trigger
          ElevatedButton(
            onPressed: () => Get.to(() => PaywallScreen()),
            child: Text('Show Paywall'),
          ),
          
          // Premium status display
          Obx(() => Card(
            color: service.isPremium.value ? Colors.green : Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    service.isPremium.value ? 'Premium Active' : 'Free Version',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!service.isPremium.value) ...[
                    Text('Habits: ${service.habitCount.value}/${RevenueCatService.maxFreeHabits}'),
                    Text('AI Prompts: ${service.aiCoachUsage.value}/${RevenueCatService.maxFreeAIPrompts}'),
                  ],
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
  
  void _createHabit() {
    // Your habit creation logic
    final service = Get.find<RevenueCatService>();
    service.updateHabitCount(service.habitCount.value + 1);
    Get.snackbar('Success', 'Habit created!');
  }
  
  void _useAICoach() {
    // Your AI coach logic
    Get.snackbar('AI Coach', 'AI response here...');
  }
  
  void _showAdvancedStats() {
    Get.snackbar('Premium', 'Advanced stats would open here');
  }
  
  void _showThemeSelector() {
    Get.snackbar('Premium', 'Theme selector would open here');
  }
}