import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './progress_controlelr.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final ProgressController controller = Get.put(ProgressController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1C1E),
        centerTitle: true,
        title: Text(
          'Your Progress',
          style: TextStyle(
            color: Colors.white,
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
              color: Colors.white,
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
                  color: const Color(0xFF1C1C1E),
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                const Text(
                                  'This Week',
                                  style: TextStyle(
                                    color: Colors.grey,
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
                            controller.overallCurrentStreak
                                .toString(),
                                'Current\nStreak',
                              )),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Obx(() => _buildStatCard(
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
                            controller.totalCompletedToday
                                .toString(),
                                'Total\nCompleted',
                              )),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Obx(() => _buildStatCard(
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
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Habit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      // if no top habit → show nothing
                      if (controller.topHabitTitle.isEmpty) {
                        return const Text(
                          "No habits tracked yet",
                          style: TextStyle(color: Colors.grey),
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
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
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
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "${(controller.topHabitPercent * 100).toInt()}% completion",
                                  style: const TextStyle(
                                    color: Colors.grey,
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

  Widget _buildStatCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF4ECDC4),
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
