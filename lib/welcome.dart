import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/firestore_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _customHabitController = TextEditingController();
  final FirestoreService _firestore = FirestoreService();
  Set<String> selectedHabits = {};
  bool _loading = false;

  final List<Map<String, dynamic>> predefinedHabits = [
    {
      'title': 'Stay Hydrated',
      'icon': Icons.water_drop,
      'color': const Color(0xFF6366F1),
    },
    {
      'title': 'Exercise Daily',
      'icon': Icons.directions_run,
      'color': const Color(0xFF2C2C2E),
    },
    {
      'title': 'Read More',
      'icon': Icons.menu_book,
      'color': const Color(0xFF2C2C2E),
    },
    {
      'title': 'Meditate',
      'icon': Icons.self_improvement,
      'color': const Color(0xFF2C2C2E),
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedHabits.add(predefinedHabits[0]['title']);
  }

  @override
  void dispose() {
    _customHabitController.dispose();
    super.dispose();
  }

  Future<void> _saveAndNavigate() async {
    List<String> chosenHabits = [];

    if (selectedHabits.isNotEmpty) {
      chosenHabits = selectedHabits.toList();
    } else if (_customHabitController.text.isNotEmpty) {
      chosenHabits = [_customHabitController.text.trim()];
    }

    if (chosenHabits.isEmpty) {
      Get.snackbar("Select Habit", "Please select or enter at least one habit",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => _loading = true);
    try {
      await _firestore.saveUserHabits(chosenHabits);
      Get.offAllNamed('/habit_tracker', arguments: chosenHabits);
    } catch (e) {
      Get.snackbar("Error", "Failed to save habits: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xff2A2A2A),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Let's create your",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                          ),
                          const Text(
                            "first habit!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "What habit do you want to\nbuild?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.1,
                            ),
                            itemCount: predefinedHabits.length,
                            itemBuilder: (context, index) {
                              final habit = predefinedHabits[index];
                              final isSelected =
                              selectedHabits.contains(habit['title']);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedHabits.remove(habit['title']);
                                    } else {
                                      selectedHabits.add(habit['title']);
                                    }
                                    if (selectedHabits.isNotEmpty) {
                                      _customHabitController.clear();
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? habit['color']
                                        : const Color(0xFF677FEB),
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected
                                        ? Border.all(
                                        color: habit['color'], width: 2)
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        habit['icon'],
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        habit['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Or create your own:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _customHabitController,
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  selectedHabits.clear();
                                }
                              });
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter custom habit...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF444444),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF6366F1),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _saveAndNavigate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ).copyWith(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                    (states) => null),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6875DE), Color(0xFF7353AE)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Start My Journey',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: _loading ? null : _saveAndNavigate,
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
