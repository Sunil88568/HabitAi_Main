import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class UserSettings {
  RxBool dailyReminders = true.obs;
  RxBool darkMode = true.obs;
}

class ProfileScreenController extends GetxController {
  UserSettings settings = UserSettings();
  final RxBool isLoggedIn = false.obs;
  final RxBool isAnonymous = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = AuthService().currentUser;
    if (user != null) {
      isLoggedIn.value = true;
      isAnonymous.value = user.isAnonymous; // true if anonymous
    }
  }

  void toggleDailyReminders() {
    settings.dailyReminders.value = !settings.dailyReminders.value;
  }

  void toggleDarkMode() {
    settings.darkMode.value = !settings.darkMode.value;
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
}

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;
  ProfileScreen({super.key, this.onBack});

  final ProfileScreenController controller =
  Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2A),
      body: SafeArea(
        child: Obx(() {
          if (!controller.isLoggedIn.value) {
            // Not logged in
            return Center(
              child: ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
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
                  const Text(
                    "You are browsing anonymously",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
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
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: onBack ?? () => Get.back(),
                    child: const Text(
                      "← Back",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Header
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
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
                    const Text(
                      "John Doe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "john.doe@email.com",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Preferences Section
                _buildSection(
                  title: "Preferences",
                  children: [
                    _buildToggle(
                      label: "Daily Reminders",
                      value: controller.settings.dailyReminders,
                      onChanged: controller.toggleDailyReminders,
                    ),
                    _buildToggle(
                      label: "Dark Mode",
                      value: controller.settings.darkMode,
                      onChanged: controller.toggleDarkMode,
                    ),
                  ],
                ),

                // Account Section
                _buildSection(
                  title: "Account",
                  children: [
                    _buildActionButton("Export Data", onTap: () {}),
                    _buildActionButton("Premium Features", onTap: () {}),
                  ],
                ),

                // Support Section
                _buildSection(
                  title: "Support",
                  children: [
                    _buildActionButton("Help & FAQ", onTap: () {}),
                  ],
                ),

                _buildSection(
                  title: "Logout",
                  children: [
                    _buildActionButton(
                      "Logout",
                      onTap: controller.logout,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Section Container
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...children
        ],
      ),
    );
  }

  // Toggle row
  Widget _buildToggle({
    required String label,
    required RxBool value,
    required VoidCallback onChanged,
  }) {
    return Obx(
          () => GestureDetector(
        onTap: onChanged,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xFF3B3B50), width: 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 24,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: value.value ? const Color(0xFF06B6D4) : Colors.grey,
                ),
                child: Align(
                  alignment:
                  value.value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Action Button
  Widget _buildActionButton(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xFF3B3B50), width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
