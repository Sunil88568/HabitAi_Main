import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitai/Habits/habit_controller.dart';
import '../services/revenue_cat_service.dart';

class SimpleChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? nextQuestions;

  SimpleChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.nextQuestions,
  });
}

class SimpleChatController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController chatController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();
  late AnimationController floatingController;

  final RxList<SimpleChatMessage> chatMessages = <SimpleChatMessage>[
    SimpleChatMessage(
      message: "Hi! I'm here to help you build meaningful habits. What's been your biggest challenge lately? 🤗",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
      nextQuestions: ["I've been feeling stressed", "I lack energy", "I want to be more productive"],
    ),
  ].obs;

  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void onClose() {
    floatingController.dispose();
    chatController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }

  void sendMessage() {
    if (chatController.text.trim().isEmpty || isTyping.value) return;

    final message = chatController.text.trim();
    chatMessages.add(SimpleChatMessage(
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    chatController.clear();
    scrollToBottom();
    _processMessage(message);
  }

  void _processMessage(String message) async {
    final service = Get.find<RevenueCatService>();
    if (!service.canUseAICoach()) {
      Get.snackbar('Premium Required', 'Get Premium to unlock unlimited AI Coach!');
      return;
    }
    
    service.incrementAIUsage();
    isTyping.value = true;
    await Future.delayed(Duration(milliseconds: 800));
    
    final response = _getResponse(message.toLowerCase());
    isTyping.value = false;
    
    chatMessages.add(SimpleChatMessage(
      message: response['message'],
      isUser: false,
      timestamp: DateTime.now(),
      nextQuestions: response['nextQuestions'],
    ));
    
    if (response['createHabit'] != null) {
      await _createHabit(response['createHabit']);
    }
    
    if (response['logCompletion'] == true) {
      await _logCompletion();
    }
    
    scrollToBottom();
  }

  Map<String, dynamic> _getResponse(String msg) {
    // Check-in logging
    if (msg.contains('completed') || msg.contains('did it') || msg.contains('finished') || msg.contains('done')) {
      return {
        'message': '🎉 Amazing! I\'ve logged your completion for today. How does it feel to stay consistent with your habits?',
        'nextQuestions': ['It feels great!', 'Tell me about streaks', 'What\'s next?'],
        'logCompletion': true,
      };
    }
    
    // Reflective follow-ups
    if (msg.contains('feels great') || msg.contains('good') || msg.contains('amazing')) {
      return {
        'message': 'That\'s wonderful! Building habits is all about these small wins. What other area of your life would you like to improve?',
        'nextQuestions': ['Better sleep', 'More energy', 'Less stress'],
      };
    }
    
    // Stress & Mental Health - Reflective approach
    if (msg.contains('stress') || msg.contains('anxious') || msg.contains('overwhelm') || msg.contains('pressure')) {
      return {
        'message': 'I hear that you\'re feeling stressed. That\'s really tough. Can you tell me what\'s been the biggest source of stress for you lately?',
        'nextQuestions': ['Work pressure', 'Personal life', 'I just need to relax'],
      };
    }
    
    if (msg.contains('work pressure') || msg.contains('personal life') || msg.contains('need to relax')) {
      return {
        'message': 'Thank you for sharing that with me. Stress can really impact our well-being. A daily 5-minute meditation could help you find moments of calm. Would you like to try this?',
        'nextQuestions': ['Yes, create meditation habit', 'Tell me more about meditation'],
      };
    }
    
    // Energy & Fatigue - Reflective approach
    if (msg.contains('energy') || msg.contains('tired') || msg.contains('exhausted') || msg.contains('drained')) {
      return {
        'message': 'Low energy can be so frustrating. I\'m curious - when do you typically feel most drained during the day?',
        'nextQuestions': ['Mornings are hard', 'Afternoon crashes', 'Always tired'],
      };
    }
    
    if (msg.contains('mornings are hard') || msg.contains('afternoon crashes') || msg.contains('always tired')) {
      return {
        'message': 'That makes sense. Your body might benefit from gentle movement to boost circulation and energy. A simple morning stretch routine could make a real difference. Shall we create this habit?',
        'nextQuestions': ['Yes, create stretch habit', 'What kind of stretches?'],
      };
    }
    
    // Sleep Issues - Reflective approach
    if (msg.contains('sleep') || msg.contains('cannot sleep') || msg.contains('insomnia') || msg.contains('restless')) {
      return {
        'message': 'Sleep troubles can affect everything in our lives. What do you think might be keeping you awake at night?',
        'nextQuestions': ['Racing thoughts', 'Too much screen time', 'Just can\'t wind down'],
      };
    }
    
    if (msg.contains('racing thoughts') || msg.contains('screen time') || msg.contains('wind down')) {
      return {
        'message': 'Those are common sleep disruptors. Creating a calming bedtime routine, like avoiding screens an hour before bed, can signal to your brain that it\'s time to rest. Would you like to try this?',
        'nextQuestions': ['Yes, create sleep habit', 'What else helps sleep?'],
      };
    }
    
    // Productivity - Reflective approach
    if (msg.contains('productive') || msg.contains('focus') || msg.contains('procrastinate') || msg.contains('distracted')) {
      return {
        'message': 'Productivity challenges are so common these days. What do you find most distracting when you\'re trying to focus?',
        'nextQuestions': ['Social media', 'Lack of planning', 'Too many tasks'],
      };
    }
    
    if (msg.contains('social media') || msg.contains('lack of planning') || msg.contains('too many tasks')) {
      return {
        'message': 'I understand how overwhelming that can feel. Planning your next day the night before can help you start with clarity and purpose. Would you like to build this planning habit?',
        'nextQuestions': ['Yes, create planning habit', 'How does planning help?'],
      };
    }
    
    // Habit creation responses
    if (msg.contains('yes, create meditation')) {
      return {
        'message': 'Perfect! I\'m creating a 5-minute daily meditation habit for you. Even just 5 minutes can help reduce stress and bring more calm to your day.',
        'nextQuestions': ['How do I meditate?', 'Create another habit', 'I\'m done for now'],
        'createHabit': 'meditation',
      };
    }
    
    if (msg.contains('yes, create stretch')) {
      return {
        'message': 'Excellent choice! I\'m setting up a morning stretch routine for you. This will help energize your body and mind for the day ahead.',
        'nextQuestions': ['What stretches work best?', 'Create another habit', 'I\'m done for now'],
        'createHabit': 'stretch',
      };
    }
    
    if (msg.contains('yes, create sleep')) {
      return {
        'message': 'Great decision! I\'m creating a "no screens before bed" habit for you. This will help your mind prepare for restful sleep.',
        'nextQuestions': ['What about reading?', 'Create another habit', 'I\'m done for now'],
        'createHabit': 'sleep',
      };
    }
    
    if (msg.contains('yes, create planning')) {
      return {
        'message': 'Wonderful! I\'m creating a "plan tomorrow tonight" habit for you. This will help you wake up with clarity and direction.',
        'nextQuestions': ['How long should I plan?', 'Create another habit', 'I\'m done for now'],
        'createHabit': 'planning',
      };
    }
    
    // Educational responses
    if (msg.contains('how do i meditate') || msg.contains('tell me more about meditation')) {
      return {
        'message': 'Meditation can be as simple as focusing on your breath for 5 minutes. Find a quiet spot, close your eyes, and just notice your breathing. When your mind wanders, gently bring it back to your breath.',
        'nextQuestions': ['That sounds doable', 'Any apps you recommend?', 'What about other habits?'],
      };
    }
    
    // Default response - more reflective
    return {
      'message': 'I\'m here to help you build habits that support your well-being. What\'s been on your mind lately? What area of your life would you most like to improve?',
      'nextQuestions': ['I feel stressed', 'I lack energy', 'I want better sleep', 'I need to be more productive'],
    };
  }

  Future<void> _createHabit(String habitType) async {
    final habitCtrl = Get.find<HabitTrackerController>();
    
    Map<String, dynamic> habitData;
    
    switch (habitType) {
      case 'meditation':
        habitData = {
          'title': '5-Minute Meditation',
          'subtitle': 'Daily mindfulness practice',
          'iconCode': Icons.self_improvement.codePoint,
          'cadence': 'daily',
          'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
          'category': 'mindfulness',
          'reminders': false,
          'isDynamic': true,
        };
        break;
      case 'stretch':
        habitData = {
          'title': 'Morning Stretch',
          'subtitle': 'Energize your day',
          'iconCode': Icons.directions_run.codePoint,
          'cadence': 'daily',
          'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
          'category': 'health',
          'reminders': false,
          'isDynamic': true,
        };
        break;
      case 'sleep':
        habitData = {
          'title': 'No Screens Before Bed',
          'subtitle': 'Better sleep quality',
          'iconCode': Icons.bedtime.codePoint,
          'cadence': 'daily',
          'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
          'category': 'health',
          'reminders': false,
          'isDynamic': true,
        };
        break;
      case 'planning':
        habitData = {
          'title': 'Plan Tomorrow Tonight',
          'subtitle': 'Better productivity',
          'iconCode': Icons.event_note.codePoint,
          'cadence': 'daily',
          'daysOfWeek': [1, 2, 3, 4, 5, 6, 7],
          'category': 'work',
          'reminders': false,
          'isDynamic': true,
        };
        break;
      default:
        return;
    }
    
    await habitCtrl.createHabit2(habitData);
    
    chatMessages.add(SimpleChatMessage(
      message: "✅ Great! I've created the habit \"${habitData['title']}\" for you. Check your habits list!",
      isUser: false,
      timestamp: DateTime.now(),
      nextQuestions: ["View my habits", "Create another habit"],
    ));
    
    scrollToBottom();
  }

  Future<void> _logCompletion() async {
    final habitCtrl = Get.find<HabitTrackerController>();
    if (habitCtrl.habits.isNotEmpty) {
      final firstHabit = habitCtrl.habits.first;
      await habitCtrl.toggleHabitCompletion(firstHabit.id);
      
      chatMessages.add(SimpleChatMessage(
        message: "✅ Perfect! I've logged your completion. You're building such great momentum with your habits!",
        isUser: false,
        timestamp: DateTime.now(),
        nextQuestions: ["How do I build streaks?", "What's my progress?"],
      ));
    } else {
      chatMessages.add(SimpleChatMessage(
        message: "I'd love to log a completion for you, but it looks like you don't have any habits yet. Let's create your first habit!",
        isUser: false,
        timestamp: DateTime.now(),
        nextQuestions: ["Create my first habit", "Tell me about habits"],
      ));
    }
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onQuestionTap(String question) {
    chatController.text = question;
    sendMessage();
  }

  void onBackPressed() {
    Get.back();
  }
}