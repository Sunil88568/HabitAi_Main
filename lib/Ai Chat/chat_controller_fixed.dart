import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitai/Habits/habit_controller.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/revenue_cat_service.dart';

// Models
class HabitCadence {
  final List<String> days;
  final List<String> times;

  HabitCadence({required this.days, required this.times});

  factory HabitCadence.fromJson(Map<String, dynamic> json) {
    return HabitCadence(
      days: List<String>.from(json['days']),
      times: List<String>.from(json['times']),
    );
  }
}

class HabitTemplate {
  final String title;
  final String subtitle;
  final HabitCadence cadence;
  final String category;

  HabitTemplate({
    required this.title,
    required this.subtitle,
    required this.cadence,
    required this.category,
  });

  factory HabitTemplate.fromJson(Map<String, dynamic> json) {
    return HabitTemplate(
      title: json['title'],
      subtitle: json['subtitle'],
      cadence: HabitCadence.fromJson(json['cadence']),
      category: json['category'] ?? 'custom',
    );
  }
}

class CoachResponse {
  final String coachAction;
  final String message;
  final List<String> nextQuestions;
  final HabitTemplate? habitTemplate;
  final String tone;
  final double confidence;

  CoachResponse({
    required this.coachAction,
    required this.message,
    required this.nextQuestions,
    this.habitTemplate,
    required this.tone,
    required this.confidence,
  });

  factory CoachResponse.fromJson(Map<String, dynamic> json) {
    return CoachResponse(
      coachAction: json['coach_action'],
      message: json['message'],
      nextQuestions: List<String>.from(json['next_questions'] ?? []),
      habitTemplate: json['habit_template'] != null
          ? HabitTemplate.fromJson(json['habit_template'])
          : null,
      tone: json['tone'] ?? 'supportive',
      confidence: json['confidence']?.toDouble() ?? 0.5,
    );
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? nextQuestions;
  final String? tone;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.nextQuestions,
    this.tone,
  });
}

// Services
class AILogger {
  static void logTokenUsage(int tokens, int latencyMs, String model) {
    print(
        '🤖 AI Metrics: $tokens tokens, ${latencyMs}ms latency, model: $model');
  }

  static void logSchemaValidation(bool isValid, String error) {
    print(
        '📋 Schema Validation: ${isValid ? "✅ VALID" : "❌ INVALID - $error"}');
  }

  static void logApiCall(String endpoint, int statusCode) {
    print('🌐 API Call: $endpoint - Status: $statusCode');
  }
}

class OpenAIService extends GetxService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue:
    'https://habitai-proxy-9k8kj6eoz-jofus-projects-a8bfd489.vercel.app',
  );

  @override
  void onInit() {
    super.onInit();
    print('Using proxy at: $baseUrl');
  }

  static int totalApiCalls = 0;
  static int successfulValidations = 0;

  static double getSchemaPassRate() {
    if (totalApiCalls == 0) return 0.0;
    return (successfulValidations / totalApiCalls) * 100;
  }

  static void printPassRate() {
    print(
        '📊 Schema Pass Rate: ${getSchemaPassRate().toStringAsFixed(1)}% ($successfulValidations/$totalApiCalls)');
  }

  static const String systemPrompt = '''
You are HabitAI's reflective coach. Follow this flow:
1. Ask "What's your biggest challenge lately?" 
2. Based on their struggle, suggest a specific habit
3. If they agree, create the habit with title/goal/schedule
4. Log completions when they mention doing tasks

Examples:
- Stress → suggest "5-minute meditation" 
- Low energy → suggest "morning stretch"
- Poor sleep → suggest "no screens before bed"

Only create habits after suggesting and getting agreement.''';

  static const Map<String, dynamic> responseSchema = {

    "type": "object",
    "additionalProperties": false,
    "required": [
      "coach_action",
      "message",
      "next_questions",
      "habit_template",
      "reminders",
      "tone",
      "confidence"
    ],
    "properties": {
      "coach_action": {
        "type": "string",
        "enum": [
          "ADVICE",
          "CREATE_HABIT",
          "SCHEDULE_REMINDER",
          "LOG_COMPLETION",
          "REFRAME"
        ]
      },

      "message": {
        "type": "string",
        "minLength": 1,
        "maxLength": 500
      },

      "next_questions": {
        "type": "array",
        "minItems": 0,
        "maxItems": 2,
        "items": {
          "type": "string",
          "minLength": 1,
          "maxLength": 140
        }
      },

      "habit_template": {
        "type": ["object", "null"],
        "additionalProperties": false,
        "required": ["title", "subtitle", "cadence", "category"],
        "properties": {
          "title": {
            "type": "string",
            "minLength": 1,
            "maxLength": 80
          },

          "subtitle": {
            "type": "string",
            "minLength": 1,
            "maxLength": 150
          },

          "cadence": {
            "type": "object",
            "additionalProperties": false,
            "required": ["days", "times"],
            "properties": {
              "days": {
                "type": "array",
                "minItems": 1,
                "maxItems": 7,
                "items": {
                  "type": "string",
                  "enum": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                }
              },
              "times": {
                "type": "array",
                "minItems": 1,
                "maxItems": 3,
                "items": {
                  "type": "string",
                  "pattern": "^(?:[01]\\d|2[0-3]):[0-5]\\d\$"
                }
              }
            }
          },

          "category": {
            "type": "string",
            "enum": [
              "health",
              "work",
              "study",
              "mindfulness",
              "finance",
              "relationships",
              "custom"
            ]
          }
        }
      },

      "reminders": {
        "type": "array",
        "minItems": 0,
        "maxItems": 5,
        "items": {
          "type": "object",
          "additionalProperties": false,
          "required": ["habit_id", "time_local", "days"],
          "properties": {
            "habit_id": {
              "type": ["string", "null"]
            },
            "time_local": {
              "type": "string",
              "pattern": "^(?:[01]\\d|2[0-3]):[0-5]\\d\$"
            },
            "days": {
              "type": "array",
              "minItems": 1,
              "maxItems": 7,
              "items": {
                "type": "string",
                "enum": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
              }
            }
          }
        }
      },

      "tone": {
        "type": "string",
        "enum": ["supportive", "celebratory", "accountable"]
      },

      "confidence": {
        "type": "number",
        "minimum": 0.0,
        "maximum": 1.0
      }
    }
  };



  CoachResponse? getChatCompletion(String userMessage) {
    final msg = userMessage.toLowerCase();
    
    if (msg.contains('stress') || msg.contains('anxious') || msg.contains('overwhelm')) {
      return CoachResponse(
        coachAction: 'ADVICE',
        message: 'I understand stress can be overwhelming. Would you like to try a 5-minute daily meditation to help manage it?',
        nextQuestions: ['Yes, let\'s try meditation', 'I need something else'],
        tone: 'supportive',
        confidence: 0.9,
      );
    }
    
    if (msg.contains('energy') || msg.contains('tired') || msg.contains('fatigue')) {
      return CoachResponse(
        coachAction: 'ADVICE',
        message: 'Low energy can be tough. A simple morning stretch routine might help boost your energy. Shall we create that habit?',
        nextQuestions: ['Yes, create morning stretch', 'Tell me more'],
        tone: 'supportive',
        confidence: 0.9,
      );
    }
    
    if (msg.contains('yes') || msg.contains('create') || msg.contains('let\'s try')) {
      if (msg.contains('meditation')) {
        return CoachResponse(
          coachAction: 'CREATE_HABIT',
          message: 'Perfect! Creating your meditation habit now.',
          nextQuestions: [],
          habitTemplate: HabitTemplate(
            title: '5-Minute Meditation',
            subtitle: 'Daily mindfulness practice',
            cadence: HabitCadence(days: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'], times: ['09:00']),
            category: 'mindfulness',
          ),
          tone: 'celebratory',
          confidence: 1.0,
        );
      }
      if (msg.contains('stretch')) {
        return CoachResponse(
          coachAction: 'CREATE_HABIT',
          message: 'Great choice! Setting up your morning stretch routine.',
          nextQuestions: [],
          habitTemplate: HabitTemplate(
            title: 'Morning Stretch',
            subtitle: 'Energize your day',
            cadence: HabitCadence(days: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'], times: ['07:00']),
            category: 'health',
          ),
          tone: 'celebratory',
          confidence: 1.0,
        );
      }
    }
    
    if (msg.contains('completed') || msg.contains('did it') || msg.contains('finished')) {
      return CoachResponse(
        coachAction: 'LOG_COMPLETION',
        message: '🎉 Awesome! Logged your completion for today. Keep up the great work!',
        nextQuestions: [],
        tone: 'celebratory',
        confidence: 1.0,
      );
    }
    
    return CoachResponse(
      coachAction: 'ADVICE',
      message: 'What\'s been your biggest challenge lately? I\'m here to help you build habits that address what you\'re going through.',
      nextQuestions: ['I\'ve been feeling stressed', 'I lack energy', 'I want to be more productive'],
      tone: 'supportive',
      confidence: 0.8,
    );
  }

  bool _validateResponse(Map<String, dynamic> response) {
    try {
      if (!response.containsKey('coach_action') ||
          !response.containsKey('message') ||
          !response.containsKey('next_questions') ||
          !response.containsKey('tone') ||
          !response.containsKey('confidence')) {
        return false;
      }

      final validActions = [
        'ADVICE',
        'CREATE_HABIT',
        'SCHEDULE_REMINDER',
        'LOG_COMPLETION',
        'REFRAME'
      ];
      if (!validActions.contains(response['coach_action'])) {
        return false;
      }

      final message = response['message'];
      if (message == null ||
          message.toString().isEmpty ||
          message.toString().length > 500) {
        return false;
      }

      final nextQuestions = response['next_questions'];
      if (nextQuestions != null && nextQuestions is List) {
        if (nextQuestions.length > 3) return false;
        for (var question in nextQuestions) {
          if (question.isEmpty || question.length > 140) return false;
        }
      }

      final confidence = response['confidence'];
      if (confidence != null && (confidence < 0.0 || confidence > 1.0)) {
        return false;
      }

      return true;
    } catch (e) {
      print('Validation error: $e');
      return false;
    }
  }
}

// Controllers
class AICoachController extends GetxController
    with GetTickerProviderStateMixin {
  final OpenAIService _openAIService = Get.find<OpenAIService>();
  final TextEditingController chatController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  late AnimationController floatingController;
  late Animation<double> floatingAnimation;

  final RxList<ChatMessage> chatMessages = <ChatMessage>[
    ChatMessage(
      message:
      "Hi! I'm here to help you build meaningful habits. What's been your biggest challenge lately? 🤗",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
      nextQuestions: ["I've been feeling stressed", "I lack energy", "I want to be more productive"],
    ),
  ].obs;

  final RxBool isTyping = false.obs;
  final Rxn<HabitTemplate> createdHabitTemplate = Rxn<HabitTemplate>();

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
  }

  @override
  void onClose() {
    floatingController.dispose();
    chatController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }

  void _initializeAnimations() {
    floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    floatingAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: floatingController,
      curve: Curves.easeInOut,
    ));
  }

  void sendMessage() {
    if (chatController.text.trim().isEmpty || isTyping.value) return;

    final message = chatController.text.trim();
    chatMessages.add(ChatMessage(
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    chatController.clear();
    scrollToBottom();

    _sendAIMessage(message);
  }

  void _sendAIMessage(String message) async {
    final service = Get.find<RevenueCatService>();
    if (!service.canUseAICoach()) {
      Get.snackbar('Premium Required', 'Get Premium to unlock unlimited AI Coach!');
      return;
    }
    
    service.incrementAIUsage();
    isTyping.value = true;

    await Future.delayed(Duration(milliseconds: 800)); // Simulate thinking
    
    final coachResponse = _openAIService.getChatCompletion(message);
    isTyping.value = false;
    
    if (coachResponse != null) {
      chatMessages.add(ChatMessage(
        message: coachResponse.message,
        isUser: false,
        timestamp: DateTime.now(),
        nextQuestions: coachResponse.nextQuestions,
        tone: coachResponse.tone,
      ));
      await _handleCoachAction(coachResponse);
    }
    scrollToBottom();
  }


  Future<void> _handleCoachAction(CoachResponse response) async {
    print('🔍 Coach Action: ${response.coachAction}');
    print('🔍 Has Template: ${response.habitTemplate != null}');

    switch (response.coachAction) {
      case 'CREATE_HABIT':
        if (response.habitTemplate != null) {
          final template = response.habitTemplate!;
          print('📝 Creating habit: ${template.title}');
          print('📝 Subtitle: ${template.subtitle}');
          print('📝 Days: ${template.cadence.days}');
          print('📝 Category: ${template.category}');

          final data = {
            'title': template.title,
            'subtitle': template.subtitle ?? 'AI-generated habit',
            'iconCode': Icons.auto_awesome.codePoint,
            'cadence': 'daily',
            'daysOfWeek': _convertDaysToNumbers(template.cadence.days),
            'category': template.category,
            'reminders': false,
            'isDynamic': true,
          };
          print("data======${data}");
          final habitCtrl = Get.find<HabitTrackerController>();
          await habitCtrl.createHabit2(data);
          print('✅ Habit created successfully!');

          chatMessages.add(ChatMessage(
            message:
            "✅ Great! I've created the habit \"${template.title}\" for you. It's scheduled for ${template.cadence.days.join(', ')} at ${template.cadence.times.join(', ')}. Check your habits list!",
            isUser: false,
            timestamp: DateTime.now(),
            nextQuestions: ["View my habits", "Create another habit"],
          ));

          scrollToBottom();
          update();
        } else {
          print('❌ No habit template in response');
        }
        break;
      case 'LOG_COMPLETION':
        print('📝 Logging habit completion');
        final habitCtrl = Get.find<HabitTrackerController>();
        if (habitCtrl.habits.isNotEmpty) {
          final firstHabit = habitCtrl.habits.first;
          await habitCtrl.toggleHabitCompletion(firstHabit.id);
          chatMessages.add(ChatMessage(
            message: "🎉 Logged your check-in for today! Great job staying consistent!",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        } else {
          chatMessages.add(ChatMessage(
            message: "You don't have any habits to log yet. Let's create one first!",
            isUser: false,
            timestamp: DateTime.now(),
            nextQuestions: ["Create a habit"],
          ));
        }
        scrollToBottom();
        break;
      case 'SCHEDULE_REMINDER':
        print('⏰ Scheduling reminder');
        break;
      case 'ADVICE':
      case 'REFRAME':
      default:
        break;
    }
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
    Get.back(result: createdHabitTemplate.value);
  }

  Color getToneColor(String tone) {
    switch (tone) {
      case 'celebratory':
        return Color(0xFFF59E0B).withOpacity(0.2);
      case 'accountable':
        return Color(0xFFEF4444).withOpacity(0.2);
      default:
        return Color(0xFF10B981).withOpacity(0.2);
    }
  }

  List<int> _convertDaysToNumbers(List<String> days) {
    const map = {
      "Mon": 1,
      "Tue": 2,
      "Wed": 3,
      "Thu": 4,
      "Fri": 5,
      "Sat": 6,
      "Sun": 7,
    };
    return days.map((d) => map[d] ?? 1).toList();
  }
}