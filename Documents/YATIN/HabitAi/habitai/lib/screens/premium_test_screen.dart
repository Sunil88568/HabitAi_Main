import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/revenue_cat_service.dart';
import '../widgets/premium_gate.dart';
import 'paywall/paywall_screen.dart';

class PremiumTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = Get.find<RevenueCatService>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Premium Features Test'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => service.isPremium.value = false, // Reset to free
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Premium Status Card
            Obx(() => Card(
              color: service.isPremium.value ? Colors.green : Colors.grey.shade800,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      service.isPremium.value ? Icons.star : Icons.star_border,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      service.isPremium.value ? 'PREMIUM ACTIVE' : 'FREE VERSION',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (!service.isPremium.value) ...[
                      SizedBox(height: 8),
                      Text('Habits: ${service.habitCount.value}/${RevenueCatService.maxFreeHabits}'),
                      Text('AI Prompts: ${service.aiCoachUsage.value}/${RevenueCatService.maxFreeAIPrompts}'),
                    ],
                  ],
                ),
              ),
            )),
            
            SizedBox(height: 20),
            
            // Show Paywall Button
            ElevatedButton(
              onPressed: () => Get.to(() => PaywallScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Show Paywall', style: TextStyle(fontSize: 16)),
            ),
            
            SizedBox(height: 20),
            
            // Test Buttons
            Text('Test Premium Features:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            
            // Create Habit Test
            ElevatedButton(
              onPressed: () {
                if (service.canCreateHabit()) {
                  service.updateHabitCount(service.habitCount.value + 1);
                  Get.snackbar('Success', 'Habit created! Total: ${service.habitCount.value}');
                } else {
                  Get.to(() => PaywallScreen());
                }
              },
              child: Text('Create Habit (${service.habitCount.value}/${service.isPremium.value ? "∞" : RevenueCatService.maxFreeHabits})'),
            ),
            
            // AI Coach Test
            ElevatedButton(
              onPressed: () {
                if (service.canUseAICoach()) {
                  service.incrementAIUsage();
                  Get.snackbar('AI Coach', 'AI prompt used! Remaining: ${RevenueCatService.maxFreeAIPrompts - service.aiCoachUsage.value}');
                } else {
                  Get.to(() => PaywallScreen());
                }
              },
              child: Text('Use AI Coach (${service.aiCoachUsage.value}/${service.isPremium.value ? "∞" : RevenueCatService.maxFreeAIPrompts})'),
            ),
            
            // Premium Features
            PremiumGate(
              feature: 'advanced_stats',
              child: ElevatedButton(
                onPressed: () => Get.snackbar('Premium', 'Advanced stats opened!'),
                child: Text('Advanced Stats'),
              ),
            ),
            
            PremiumGate(
              feature: 'premium_themes',
              child: ElevatedButton(
                onPressed: () => Get.snackbar('Premium', 'Theme selector opened!'),
                child: Text('Premium Themes'),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Reset Button
            TextButton(
              onPressed: () {
                service.isPremium.value = false;
                service.aiCoachUsage.value = 0;
                service.habitCount.value = 0;
                Get.snackbar('Reset', 'Returned to free version');
              },
              child: Text('Reset to Free Version'),
            ),
          ],
        ),
      ),
    );
  }
}