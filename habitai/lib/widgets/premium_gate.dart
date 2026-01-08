import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/revenue_cat_service.dart';
import '../screens/paywall/paywall_screen.dart';

class PremiumGate extends StatelessWidget {
  final Widget child;
  final String feature;
  final VoidCallback? onPremiumRequired;
  
  const PremiumGate({
    Key? key,
    required this.child,
    required this.feature,
    this.onPremiumRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Get.find<RevenueCatService>();
    
    return Obx(() {
      bool hasAccess = false;
      
      switch (feature) {
        case 'unlimited_habits':
          hasAccess = service.hasUnlimitedHabits() || service.canCreateHabit();
          break;
        case 'ai_coach':
          hasAccess = service.hasUnlimitedAICoach() || service.canUseAICoach();
          break;
        case 'advanced_stats':
          hasAccess = service.hasAdvancedStats();
          break;
        case 'premium_themes':
          hasAccess = service.hasPremiumThemes();
          break;
        case 'priority_backup':
          hasAccess = service.hasPriorityBackup();
          break;
        default:
          hasAccess = service.isPremium.value;
      }
      
      if (hasAccess) {
        return child;
      }
      
      return GestureDetector(
        onTap: () {
          onPremiumRequired?.call();
          _showPaywall();
        },
        child: Stack(
          children: [
            Opacity(opacity: 0.5, child: child),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Premium Feature',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tap to upgrade',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
  
  void _showPaywall() {
    Get.to(() => PaywallScreen(
      onClose: () {
        // User declined premium, continue with free version
      },
    ));
  }
}

class AICoachLimitWidget extends StatelessWidget {
  final Widget child;
  
  const AICoachLimitWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Get.find<RevenueCatService>();
    
    return Obx(() {
      if (!service.canUseAICoach()) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            children: [
              Icon(Icons.smart_toy, color: Colors.orange, size: 48),
              SizedBox(height: 8),
              Text(
                service.getAICoachLimitMessage(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Get.to(() => PaywallScreen()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text('Get Premium'),
              ),
            ],
          ),
        );
      }
      
      return child;
    });
  }
}

class HabitLimitWidget extends StatelessWidget {
  const HabitLimitWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Get.find<RevenueCatService>();
    
    return Obx(() {
      final message = service.getHabitLimitMessage();
      if (message.isEmpty) return SizedBox();
      
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
            TextButton(
              onPressed: () => Get.to(() => PaywallScreen()),
              child: Text('Upgrade'),
            ),
          ],
        ),
      );
    });
  }
}