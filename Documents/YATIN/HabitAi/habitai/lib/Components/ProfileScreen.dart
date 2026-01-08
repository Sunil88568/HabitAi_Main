import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/push_service.dart';
import '../theme/theme_controller.dart';
import '../theme/app_theme.dart';
class UserSettings {
  RxBool dailyReminders = true.obs;
}
class ProfileScreenController extends GetxController {
  UserSettings settings = UserSettings();
  final RxBool isLoggedIn = false.obs;
  final RxBool isAnonymous = false.obs;
  late final ThemeController themeController;
  final RxString username = 'user'.obs;
  @override
  void onInit() {
    super.onInit();
    themeController = Get.find<ThemeController>();
    final user = AuthService().currentUser;
    if (user != null) {
      isLoggedIn.value = true;
      isAnonymous.value = user.isAnonymous; // true if anonymous
      _loadUsername();
    }

    // Initialize notifications & push services and load persisted setting
    () async {
      await NotificationService()
          .init(); // initializes local notifications & restores scheduled map
      await PushService().init(); // registers FCM handlers
      final enabled = await NotificationService().getDailyRemindersEnabled();
      settings.dailyReminders.value = enabled;
    }();
  }

  Future<void> _loadUsername() async {
    final user = AuthService().currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['username'] != null) {
        username.value = doc.data()!['username'];
      }
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final user = AuthService().currentUser;
    if (user != null && newUsername.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': newUsername.trim(),
      }, SetOptions(merge: true));
      username.value = newUsername.trim();
    }
  }

  // Make async so we can request platform permission when enabling
  Future<void> toggleDailyReminders() async {
    final newValue = !settings.dailyReminders.value;
    if (newValue) {
      // user is enabling → request permission (will no-op on platforms that don't need it)
      final granted = await NotificationService().requestPermissions();
      if (!granted) {
        // user denied, keep setting false
        settings.dailyReminders.value = false;
        await NotificationService().setDailyRemindersEnabled(false);
        return;
      }
    }

    settings.dailyReminders.value = newValue;
    await NotificationService().setDailyRemindersEnabled(newValue);
  }

  Future<void> toggleDarkMode() async {
    await themeController.toggleTheme();
  }

  void login() {
    Get.toNamed('/login');
  }

  void logout() async {
    await AuthService().signOut();
    isLoggedIn.value = false;
    isAnonymous.value = false;
    Get.offAllNamed('/login');
  }

  Future<void> deleteAccount(BuildContext context) async {
    final user = AuthService().currentUser;
    if (user == null) return;

    // Show confirmation dialog
    final confirmed = await _showDeleteConfirmationDialog(context);
    if (!confirmed) return;

    try {
      String? password;

      // Get password for email users
      if (!user.isAnonymous &&
          user.providerData.any((p) => p.providerId == 'password')) {
        password = await _showPasswordDialog(context);
        if (password == null) return;
      }

      // 1. Delete remote data (Firestore)
      await _deleteRemoteData(user.uid);

      // 2. Delete local data (SharedPreferences)
      await _deleteLocalData();

      // 3. Delete Firebase Auth account
      await AuthService().deleteAccount(password: password);

      // Navigate to login
      Get.offAllNamed('/login');
    } catch (e) {
      if (context.mounted) {
        Get.snackbar(
          'Error',
          'Failed to delete account: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
  Future<void> _deleteRemoteData(String uid) async {
    final batch = FirebaseFirestore.instance.batch();
    // Delete user document
    batch.delete(FirebaseFirestore.instance.collection('users').doc(uid));
    // Delete habits subcollection
    final habitsQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('habits')
        .get();

    for (final doc in habitsQuery.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> _deleteLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
  Future<String?> _showPasswordDialog(BuildContext context) async {
    final controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password to confirm',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;
  ProfileScreen({super.key, this.onBack});
  final ProfileScreenController controller = Get.put(ProfileScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (!controller.isLoggedIn.value) {
            // Not logged in
            return Center(
              child: ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            );
          } else if (controller.isAnonymous.value) {
            // Anonymous user
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You are browsing anonymously",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Complete Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          // Fully logged in user
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                    
                //     TextButton(
                //       onPressed: () => _showEditDialog(context),
                //       child: Text(
                //         "Edit",
                //         style: TextStyle(
                //             color: Theme.of(context).colorScheme.primary,
                //             fontSize: 15),
                //       ),
                //     )
                //   ],
                // ),
                const SizedBox(height: 20),
                // Profile Header
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? [AppColors.darkPrimary, AppColors.darkSecondary]
                              : [
                                  AppColors.lightPrimary,
                                  AppColors.lightSecondary
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "👤",
                          style: TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                      controller.username.value,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    const SizedBox(height: 4),
                    Text(
                      AuthService().currentUser?.email ?? "No email",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.6),
                          fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Preferences Section
                _buildSection(
                  context,
                  title: "Preferences",
                  children: [
                    _buildToggle(
                      context,
                      label: "Daily Reminders",
                      value: controller.settings.dailyReminders,
                      onChanged: controller.toggleDailyReminders,
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                    ),
                    Obx(() => _buildToggle(
                          context,
                          label: "Dark Mode",
                          value: controller.themeController.isDarkMode.obs,
                          // onChanged: controller.toggleDarkMode, 
                          onChanged: (){}, 
                        )),
                    Divider(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                    ),
                  ],
                ),
                // Account Section
                _buildSection(
                  context,
                  title: "Account",
                  children: [
                    _buildActionButton(context, "Export Data", onTap: () {}),
                    Divider(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                    ),
                    _buildActionButton(context, "Premium Features",
                        onTap: () {}),
                    Divider(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                    ),
                  ],
                ),
                // Support Section
                _buildSection(
                  context,
                  title: "Support",
                  children: [
                    _buildActionButton(context, "Help & FAQ", onTap: () {}),
                    Divider(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                    ),
                  ],
                ),
                // Logout Section
                _buildSection(
                  context,
                  title: "Logout",
                  children: [
                    _buildActionButton(
                      context,
                      "Logout",
                      onTap: controller.logout,
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.1),
                    ),
                  ],
                ),
                // Delete Account Section
                // _buildSection(
                //   context,
                //   title: "Delete Account",
                //   children: [
                //     _buildActionButton(
                //       context,
                //       "Delete Account",
                //       onTap: () => controller.deleteAccount(context),
                //     ),
                //     Divider(
                //       height: 1,
                //       color: Theme.of(context)
                //           .colorScheme
                //           .onBackground
                //           .withOpacity(0.1),
                //     ),
                //   ],
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Section Container
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
  Widget _buildToggle(
    BuildContext context, {
    required String label,
    required RxBool value,
    required VoidCallback onChanged,
  }) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                ),
              ),
              Switch(
                value: value.value,
                onChanged: (_) => onChanged(),
                activeColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ));
  }

  Widget _buildActionButton(
    BuildContext context,
    String label, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final textController = TextEditingController(text: controller.username.value == 'user' ? '' : controller.username.value);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                await controller.updateUsername(textController.text.trim());
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}