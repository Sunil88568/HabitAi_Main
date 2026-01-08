import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/firestore_service.dart';
import '../theme/app_theme.dart';


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
    },
    {
      'title': 'Exercise Daily',
      'icon': Icons.directions_run,
    },
    {
      'title': 'Read More',
      'icon': Icons.menu_book,
    },
    {
      'title': 'Meditate',
      'icon': Icons.self_improvement,
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkError : AppColors.lightError, 
          colorText: Colors.white);
      return;
    }

    setState(() => _loading = true);
    try {
      await _firestore.saveUserHabits(chosenHabits);
      Get.offAllNamed('/habit_tracker', arguments: chosenHabits);
    } catch (e) {
      Get.snackbar("Error", "Failed to save habits: $e",
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkError : AppColors.lightError, 
          colorText: Colors.white);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Let's create your",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(height: 1.2),
                          ),
                          Text(
                            "first habit!",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(height: 1.2),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "What habit do you want to\nbuild?",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.3),
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
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected
                                        ? Border.all(
                                        color: Theme.of(context).primaryColor, width: 2)
                                        : Border.all(
                                        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder, width: 1),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        habit['icon'],
                                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onBackground,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        habit['title'],
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: isSelected ? Colors.white : Theme.of(context).colorScheme.onBackground,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Or create your own:",
                            style: Theme.of(context).textTheme.bodyLarge,
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
                            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                            decoration: InputDecoration(
                              hintText: 'Enter custom habit...',
                              hintStyle: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                                fontSize: 16,
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
                              gradient: LinearGradient(
                                colors: Theme.of(context).brightness == Brightness.dark
                                    ? [AppColors.darkPrimary, AppColors.darkSecondary]
                                    : [AppColors.lightPrimary, AppColors.lightSecondary],
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
                            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
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