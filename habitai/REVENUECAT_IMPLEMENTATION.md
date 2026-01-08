# RevenueCat Implementation Guide

## Overview
Complete RevenueCat integration with paywall flow, limited offers, and entitlement gating.

## Files Created/Modified

### Core Services
- `lib/services/revenue_cat_service.dart` - Main RevenueCat service with entitlements
- `lib/screens/paywall/paywall_screen.dart` - Main paywall screen
- `lib/screens/paywall/limited_offer_screen.dart` - Limited time offer with 2-min timer
- `lib/widgets/premium_gate.dart` - Premium feature gates and limit widgets

### Example Usage
- `lib/screens/examples/premium_usage_example.dart` - Shows how to implement premium features

## Flow Implementation

### 1. Paywall Flow
```
User tries to close paywall → Limited offer screen (2-min timer) → 
If declined → Return to paywall one final time → 
If closed again → Free version
```

### 2. Free Version Limits
- **Habits**: Limited to 1 habit
- **AI Coach**: Limited to 5 prompts
- **Premium Features**: Locked (advanced stats, themes, backup priority)

### 3. Entitlements
- `unlimited_habits` - Create unlimited habits
- `ai_coach` - Unlimited AI Coach usage
- `advanced_stats` - Advanced analytics
- `premium_themes` - Custom themes
- `priority_backup` - Priority cloud backup

## Usage Examples

### Check Premium Status
```dart
final service = Get.find<RevenueCatService>();
if (service.isPremium.value) {
  // Premium features
}
```

### Gate Premium Features
```dart
PremiumGate(
  feature: 'unlimited_habits',
  child: YourWidget(),
)
```

### AI Coach Limits
```dart
AICoachLimitWidget(
  child: YourAICoachWidget(),
)
```

### Habit Creation Check
```dart
if (service.canCreateHabit()) {
  // Create habit
  service.updateHabitCount(newCount);
} else {
  // Show paywall
  Get.to(() => PaywallScreen());
}
```

### AI Coach Usage
```dart
if (service.canUseAICoach()) {
  service.incrementAIUsage();
  // Use AI Coach
} else {
  // Show limit message or paywall
}
```

## Setup Required

### 1. RevenueCat Dashboard
- Create products: weekly, monthly, annual subscriptions
- Set up entitlements
- Configure offerings

### 2. Update API Key
```dart
// In revenue_cat_service.dart
static const String _apiKey = 'your_actual_revenuecat_api_key';
```

### 3. Store Configuration
- iOS: Configure In-App Purchases in App Store Connect
- Android: Configure In-App Products in Google Play Console

## Testing

### Sandbox Testing
- Use sandbox accounts for testing purchases
- Test all flows: purchase success, failure, restore
- Verify entitlements toggle features immediately

### Flow Testing
1. Open paywall → Try to close → Limited offer appears
2. Decline limited offer → Return to paywall
3. Close paywall again → Enter free version
4. Test free version limits (1 habit, 5 AI prompts)
5. Test premium feature gates

## Integration Points

### In Habit Creation Screen
```dart
// Add before habit creation
if (!service.canCreateHabit()) {
  Get.to(() => PaywallScreen());
  return;
}
```

### In AI Coach Screen
```dart
// Wrap AI coach interface
AICoachLimitWidget(
  child: YourAIInterface(),
)
```

### In Settings/Stats Screens
```dart
// Gate premium features
PremiumGate(
  feature: 'advanced_stats',
  child: AdvancedStatsWidget(),
)
```

## Key Features Implemented

✅ Cross-platform IAP (Weekly/Monthly/Annual)
✅ Entitlements gate premium features
✅ Limited offer screen with 2-min timer
✅ Complete paywall flow with proper navigation
✅ Free version with 1 habit + 5 AI prompts limit
✅ AI Coach limit messaging
✅ Restore purchases functionality
✅ Sandbox testing support
✅ Immediate entitlement toggling

## Next Steps

1. Replace `'your_revenuecat_api_key'` with actual API key
2. Configure products in RevenueCat dashboard
3. Set up store listings (iOS App Store, Google Play)
4. Integrate premium gates into existing screens
5. Test thoroughly in sandbox environment
6. Submit for store review