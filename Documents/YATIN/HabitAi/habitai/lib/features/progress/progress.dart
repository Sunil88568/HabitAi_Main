import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './progress_controlelr.dart';
import '../../theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final ProgressController controller = Get.put(ProgressController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Your Progress',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onBackground,
            )),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshProgress,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Circular Progress
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Obx(() => CircularProgressIndicator(
                                  value: controller.weeklyProgress,
                                  strokeWidth: 12,
                                  backgroundColor: const Color(0xFF2C2C2E),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4ECDC4),
                                  ),
                                )),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => Text(
                                  "${(controller.weeklyProgress * 100).toInt()}%"
                                  ,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onBackground,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Text(
                                  'This Week',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _buildStatCard(
                            context,
                            controller.overallCurrentStreak
                                .toString(),
                                'Current\nStreak',
                              )),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Obx(() => _buildStatCard(
                            context,
                            controller.overallLongestStreak
                                .toString(),
                                'Best Streak',
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _buildStatCard(
                            context,
                            controller.totalCompletedToday
                                .toString(),
                                'Total\nCompleted',
                              )),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Obx(() => _buildStatCard(
                            context,
                            "${(controller.successRateToday * 100).toInt()}%"
                            ,
                                'Success\nRate',
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Habit',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      // if no top habit → show nothing
                      if (controller.topHabitTitle.isEmpty) {
                        return Text(
                          "No habits tracked yet",
                          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                        );
                      }

                      return Row(
                        children: [
                          // Icon circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: Theme.of(context).brightness == Brightness.dark
                                    ? [AppColors.darkPrimary, AppColors.darkSecondary]
                                    : [AppColors.lightPrimary, AppColors.lightSecondary],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.star,  // optional: dynamic icon later
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Habit title + subtitle + percent
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.topHabitTitle,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${(controller.topHabitPercent * 100).toInt()}% completion",
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Text(
                            '🏆',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSuccess : AppColors.lightSuccess,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
