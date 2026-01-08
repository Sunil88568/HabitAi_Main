import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:get/get.dart';

class RevenueCatService extends GetxService {
  static const String _apiKey = 'test_ZbOFUnoxfJBhNlcfALIzEdrZLJC';
  
  final RxBool isPremium = false.obs;
  final RxInt aiCoachUsage = 0.obs;
  final RxBool isRestoring = false.obs;
  final RxInt habitCount = 0.obs;
  
  // Free version limits
  static const int maxFreeHabits = 1;
  static const int maxFreeAIPrompts = 5;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initRevenueCat();
    await _checkSubscriptionStatus();
  }

  Future<void> _initRevenueCat() async {
    await Purchases.setLogLevel(LogLevel.info);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      isPremium.value = customerInfo.entitlements.active.isNotEmpty;
      print('Premium status: ${isPremium.value}');
    } catch (e) {
      print('RevenueCat check failed: $e');
      isPremium.value = false;
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      print('Get offerings failed: $e');
      return null;
    }
  }

  Future<bool> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      isPremium.value = result.customerInfo.entitlements.active.isNotEmpty;
      return isPremium.value;
    } catch (e) {
      print('Purchase failed: $e');
      return false;
    }
  }

  Future<void> restorePurchases() async {
    isRestoring.value = true;
    try {
      final customerInfo = await Purchases.restorePurchases();
      isPremium.value = customerInfo.entitlements.active.isNotEmpty;
    } catch (e) {
      print('Restore failed: $e');
    }
    isRestoring.value = false;
  }

  bool canCreateHabit() => isPremium.value || habitCount.value < maxFreeHabits;
  
  bool canUseAICoach() => isPremium.value || aiCoachUsage.value < maxFreeAIPrompts;
  
  void incrementAIUsage() {
    if (!isPremium.value) aiCoachUsage.value++;
  }
  
  void updateHabitCount(int count) {
    habitCount.value = count;
  }
  
  String getAICoachLimitMessage() {
    if (isPremium.value) return '';
    final remaining = maxFreeAIPrompts - aiCoachUsage.value;
    if (remaining <= 0) {
      return 'Get Premium now to unlock your personal AI Coach!';
    }
    return '$remaining AI Coach prompts remaining';
  }
  
  String getHabitLimitMessage() {
    if (isPremium.value) return '';
    if (habitCount.value >= maxFreeHabits) {
      return 'Upgrade to Premium to create unlimited habits';
    }
    return '';
  }
  
  // Check specific entitlements
  bool hasUnlimitedHabits() => isPremium.value;
  bool hasUnlimitedAICoach() => isPremium.value;
  bool hasAdvancedStats() => isPremium.value;
  bool hasPremiumThemes() => isPremium.value;
  bool hasPriorityBackup() => isPremium.value;
}