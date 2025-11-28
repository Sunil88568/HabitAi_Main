import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitai/Habits/habit_controller.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HabitCadence {
  final List<String> days;
  final List<String> times;
  HabitCadence({required this.days, required this.times});
  factory HabitCadence.fromJson(Map<String, dynamic> json) => HabitCadence(
    days: List<String>.from(json['days']),
    times: List<String>.from(json['times']),
  );
}

class HabitTemplate {
  final String title;
  final HabitCadence cadence;
  final String category;
  HabitTemplate({required this.title, required this.cadence, required this.category});
  factory HabitTemplate.fromJson(Map<String, dynamic> json) => HabitTemplate(
    title: json['title'],
    cadence: HabitCadence.fromJson(json['cadence']),
    category: json['category'] ?? 'custom',
  );
}

class CoachResponse {
  final String coachAction;
  final String message;
  final List<String> nextQuestions;
  final HabitTemplate? habitTemplate;
  final String tone;
  final double confidence;
  CoachResponse({required this.coachAction, required this.message, required this.nextQuestions, this.habitTemplate, required this.tone, required this.confidence});
  factory CoachResponse.fromJson(Map<String, dynamic> json) => CoachResponse(
    coachAction: json['coach_action'],
    message: json['message'],
    nextQuestions: List<String>.from(json['next_questions'] ?? []),
    habitTemplate: json['habit_template'] != null ? HabitTemplate.fromJson(json['habit_template']) : null,
    tone: json['tone'] ?? 'supportive',
    confidence: json['confidence']?.toDouble() ?? 0.5,
  );
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? nextQuestions;
  final String? tone;
  ChatMessage({required this.message, required this.isUser, required this.timestamp, this.nextQuestions, this.tone});
}

class OpenAIService extends GetxService {
  static const String baseUrl = 'https://habitai-proxy-9k8kj6eoz-jofus-projects-a8bfd489.vercel.app';
  
  static const String systemPrompt = '''You are HabitAI Coach. When user wants to create a habit, ask for: 1) habit name, 2) goal, 3) time. Only use CREATE_HABIT after collecting all 3. Use ADVICE while collecting info.''';

  Future<CoachResponse?> getChatCompletion(String userMessage, {List<Map<String, String>>? conversationHistory}) async {
    try {
      final messages = [{'role': 'system', 'content': systemPrompt}, ...(conversationHistory ?? [])];
      final response = await http.post(Uri.parse('$baseUrl/api/chat'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'model': 'gpt-4o-mini', 'messages': messages}));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return CoachResponse.fromJson(jsonDecode(content));
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}

class AICoachController extends GetxController with GetTickerProviderStateMixin {
  final OpenAIService _openAIService = Get.find<OpenAIService>();
  final TextEditingController chatController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();
  late AnimationController floatingController;
  late Animation<double> floatingAnimation;
  final RxList<ChatMessage> chatMessages = <ChatMessage>[ChatMessage(message: "Hi! I'm your AI habit coach. What habit would you like to create?", isUser: false, timestamp: DateTime.now(), nextQuestions: ["I want to start a new habit"])].obs;
  final RxBool isTyping = false.obs;
  final List<Map<String, String>> _conversationHistory = [];

  @override
  void onInit() {
    super.onInit();
    floatingController = AnimationController(duration: Duration(seconds: 3), vsync: this)..repeat(reverse: true);
    floatingAnimation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(parent: floatingController, curve: Curves.easeInOut));
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
    chatMessages.add(ChatMessage(message: message, isUser: true, timestamp: DateTime.now()));
    chatController.clear();
    scrollToBottom();
    _sendAIMessage(message);
  }

  void _sendAIMessage(String message) async {
    isTyping.value = true;
    try {
      _conversationHistory.add({'role': 'user', 'content': message});
      final coachResponse = await _openAIService.getChatCompletion(message, conversationHistory: _conversationHistory);
      isTyping.value = false;
      if (coachResponse != null) {
        _conversationHistory.add({'role': 'assistant', 'content': coachResponse.message});
        chatMessages.add(ChatMessage(message: coachResponse.message, isUser: false, timestamp: DateTime.now(), nextQuestions: coachResponse.nextQuestions, tone: coachResponse.tone));
        await _handleCoachAction(coachResponse);
      }
      scrollToBottom();
    } catch (e) {
      isTyping.value = false;
      chatMessages.add(ChatMessage(message: "Something went wrong. Please try again.", isUser: false, timestamp: DateTime.now()));
      scrollToBottom();
    }
  }

  Future<void> _handleCoachAction(CoachResponse response) async {
    print('Action: ${response.coachAction}, Has Template: ${response.habitTemplate != null}');
    if (response.coachAction == 'CREATE_HABIT' && response.habitTemplate != null) {
      final template = response.habitTemplate!;
      final data = {
        'title': template.title,
        'subtitle': 'AI habit',
        'iconCode': Icons.auto_awesome.codePoint,
        'cadence': 'daily',
        'daysOfWeek': _convertDaysToNumbers(template.cadence.days),
        'category': template.category,
        'reminders': false,
        'isDynamic': true,
      };
      try {
        final habitCtrl = Get.find<HabitTrackerController>();
        await habitCtrl.createHabit2(data);
        print('✅ Habit created!');
      } catch (e) {
        print('Creating directly: $e');
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('users').doc(uid).collection('habits').add({...data, 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()});
        }
      }
      chatMessages.add(ChatMessage(message: "✅ Created \"${template.title}\"! Go back to see it.", isUser: false, timestamp: DateTime.now()));
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(chatScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void onQuestionTap(String question) {
    chatController.text = question;
    sendMessage();
  }

  void onBackPressed() => Get.back();

  Color getToneColor(String tone) {
    switch (tone) {
      case 'celebratory': return Color(0xFFF59E0B).withOpacity(0.2);
      case 'accountable': return Color(0xFFEF4444).withOpacity(0.2);
      default: return Color(0xFF10B981).withOpacity(0.2);
    }
  }

  List<int> _convertDaysToNumbers(List<String> days) {
    const map = {"Mon": 1, "Tue": 2, "Wed": 3, "Thu": 4, "Fri": 5, "Sat": 6, "Sun": 7};
    return days.map((d) => map[d] ?? 1).toList();
  }
}
