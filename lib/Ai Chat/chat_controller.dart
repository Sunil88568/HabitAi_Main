// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// // Models
// class HabitCadence {
//   final List<String> days;
//   final List<String> times;
//
//   HabitCadence({required this.days, required this.times});
//
//   factory HabitCadence.fromJson(Map<String, dynamic> json) {
//     return HabitCadence(
//       days: List<String>.from(json['days']),
//       times: List<String>.from(json['times']),
//     );
//   }
// }
//
// class HabitTemplate {
//   final String title;
//   final HabitCadence cadence;
//   final String category;
//
//   HabitTemplate({
//     required this.title,
//     required this.cadence,
//     required this.category,
//   });
//
//   factory HabitTemplate.fromJson(Map<String, dynamic> json) {
//     return HabitTemplate(
//       title: json['title'],
//       cadence: HabitCadence.fromJson(json['cadence']),
//       category: json['category'] ?? 'custom',
//     );
//   }
// }
//
// class CoachResponse {
//   final String coachAction;
//   final String message;
//   final List<String> nextQuestions;
//   final HabitTemplate? habitTemplate;
//   final String tone;
//   final double confidence;
//
//   CoachResponse({
//     required this.coachAction,
//     required this.message,
//     required this.nextQuestions,
//     this.habitTemplate,
//     required this.tone,
//     required this.confidence,
//   });
//
//   factory CoachResponse.fromJson(Map<String, dynamic> json) {
//     return CoachResponse(
//       coachAction: json['coach_action'],
//       message: json['message'],
//       nextQuestions: List<String>.from(json['next_questions'] ?? []),
//       habitTemplate: json['habit_template'] != null
//           ? HabitTemplate.fromJson(json['habit_template'])
//           : null,
//       tone: json['tone'] ?? 'supportive',
//       confidence: json['confidence']?.toDouble() ?? 0.5,
//     );
//   }
// }
//
// class ChatMessage {
//   final String message;
//   final bool isUser;
//   final DateTime timestamp;
//   final List<String>? nextQuestions;
//   final String? tone;
//
//   ChatMessage({
//     required this.message,
//     required this.isUser,
//     required this.timestamp,
//     this.nextQuestions,
//     this.tone,
//   });
// }
//
// // Services
// class AILogger {
//   static void logTokenUsage(int tokens, int latencyMs, String model) {
//     print('🤖 AI Metrics: $tokens tokens, ${latencyMs}ms latency, model: $model');
//   }
//
//   static void logSchemaValidation(bool isValid, String error) {
//     print('📋 Schema Validation: ${isValid ? "✅ VALID" : "❌ INVALID - $error"}');
//   }
//
//   static void logApiCall(String endpoint, int statusCode) {
//     print('🌐 API Call: $endpoint - Status: $statusCode');
//   }
// }
//
// class OpenAIService extends GetxService {
//   static final String baseUrl = const String.fromEnvironment(
//     'API_BASE',
//     defaultValue: 'https://habitai-proxy-9k8kj6eoz-jofus-projects-a8bfd489.vercel.app',
//   );
//
//   @override
//   void onInit() {
//     super.onInit();
//     print('Using proxy at: $baseUrl');
//   }
//   static int totalApiCalls = 0;
//   static int successfulValidations = 0;
//
//   static double getSchemaPassRate() {
//     if (totalApiCalls == 0) return 0.0;
//     return (successfulValidations / totalApiCalls) * 100;
//   }
//
//   static void printPassRate() {
//     print('📊 Schema Pass Rate: ${getSchemaPassRate().toStringAsFixed(1)}% (${successfulValidations}/${totalApiCalls})');
//   }
//
//
//   static const String systemPrompt = '''
// You are HabitAI's Coach. Help users design and stick to small habits.
//
// Rules:
// - Be concise: 1–3 short sentences. No markdown.
// - Default tone: supportive. Use "accountable" when user asks for push; "celebratory" on wins.
// - Ask 1–2 brief follow-up questions if needed to clarify goal, schedule, or blockers.
// - Prefer a single, specific next step (tiny, achievable).
// - Use tool calls when the user clearly wants to: CREATE_HABIT, SCHEDULE_REMINDER, or LOG_COMPLETION.
// - Otherwise use ADVICE; use REFRAME to normalize setbacks and suggest a retry plan.
// - If proposing a habit, include a habit_template with realistic cadence and times in the user's local time.
// - Reminders: 24-hour HH:MM, days as ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"].
// - Keep message ≤ 500 chars; next_questions ≤ 2 items.
// - Safety: no medical/clinical diagnosis or crisis counseling; recommend professional help if needed.
//
// Output:
// Return ONLY valid JSON matching the provided schema with fields:
// coach_action, message, next_questions, habit_template, reminders, tone.
// ''';
//
//   static const Map<String, dynamic> responseSchema = {
//     "type": "object",
//     "additionalProperties": false,
//     "required": ["coach_action", "message", "next_questions", "habit_template", "reminders", "tone", "confidence"],
//     "properties": {
//       "coach_action": {
//         "type": "string",
//         "enum": ["ADVICE", "CREATE_HABIT", "SCHEDULE_REMINDER", "LOG_COMPLETION", "REFRAME"]
//       },
//       "message": {
//         "type": "string",
//         "minLength": 1,
//         "maxLength": 500
//       },
//       "next_questions": {
//         "type": "array",
//         "minItems": 0,
//         "maxItems": 3,
//         "items": {
//           "type": "string",
//           "minLength": 1,
//           "maxLength": 140
//         }
//       },
//       "habit_template": {
//         "type": ["object", "null"],
//         "additionalProperties": false,
//         "required": ["title", "cadence", "category"],
//         "properties": {
//           "title": {
//             "type": "string",
//             "minLength": 1,
//             "maxLength": 80
//           },
//           "cadence": {
//             "type": "object",
//             "additionalProperties": false,
//             "required": ["days", "times"],
//             "properties": {
//               "days": {
//                 "type": "array",
//                 "minItems": 1,
//                 "maxItems": 7,
//                 "items": {
//                   "type": "string",
//                   "enum": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
//                 }
//               },
//               "times": {
//                 "type": "array",
//                 "minItems": 1,
//                 "maxItems": 3,
//                 "items": {
//                   "type": "string",
//                   "pattern": "^(?:[01]\\d|2[0-3]):[0-5]\\d\$"
//                 }
//               }
//             }
//           },
//           "category": {
//             "type": "string",
//             "enum": ["health", "work", "study", "mindfulness", "finance", "relationships", "custom"]
//           }
//         }
//       },
//       "reminders": {
//         "type": "array",
//         "minItems": 0,
//         "maxItems": 5,
//         "items": {
//           "type": "object",
//           "additionalProperties": false,
//           "required": ["habit_id", "time_local", "days"],
//           "properties": {
//             "habit_id": {
//               "type": ["string", "null"]
//             },
//             "time_local": {
//               "type": "string",
//               "pattern": "^(?:[01]\\d|2[0-3]):[0-5]\\d\$"
//             },
//             "days": {
//               "type": "array",
//               "minItems": 1,
//               "maxItems": 7,
//               "items": {
//                 "type": "string",
//                 "enum": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
//               }
//             }
//           }
//         }
//       },
//       "tone": {
//         "type": "string",
//         "enum": ["supportive", "celebratory", "accountable"]
//       },
//       "confidence": {
//         "type": "number",
//         "minimum": 0.0,
//         "maximum": 1.0
//       }
//     }
//   };
//
//   Future<CoachResponse?> getChatCompletion(String userMessage, {int retryCount = 0}) async {
//     final startTime = DateTime.now();
//     totalApiCalls++;
//
//     try {
//       // Use proxy endpoint - NO Authorization header
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/chat'),
//         headers: {
//           'Content-Type': 'application/json',
//           // NO Authorization header - proxy handles it
//         },
//         body: jsonEncode({
//           'model': 'gpt-4o-mini',
//           'messages': [
//             {'role': 'system', 'content': systemPrompt},
//             {'role': 'user', 'content': userMessage}
//           ],
//           'response_format': {
//             'type': 'json_schema',
//             'json_schema': {
//               'name': 'coach_response',
//               'schema': responseSchema,
//               'strict': true
//             }
//           },
//           'max_tokens': 500,
//           'temperature': 0.7,
//         }),
//       );
//
//       final latency = DateTime.now().difference(startTime).inMilliseconds;
//       AILogger.logApiCall('/api/chat', response.statusCode);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final content = data['choices'][0]['message']['content'];
//         final tokens = data['usage']['total_tokens'];
//
//         AILogger.logTokenUsage(tokens, latency, 'gpt-4o-mini');
//
//         try {
//           final responseJson = jsonDecode(content);
//
//           if (_validateResponse(responseJson)) {
//             successfulValidations++;
//             AILogger.logSchemaValidation(true, '');
//             printPassRate(); // Print pass rate after each successful validation
//             final coachResponse = CoachResponse.fromJson(responseJson);
//             return coachResponse;
//           } else {
//             AILogger.logSchemaValidation(false, 'Schema validation failed');
//             printPassRate();
//             if (retryCount < 1) {
//               print('🔄 Retrying API call due to schema validation failure...');
//               return await getChatCompletion(userMessage, retryCount: retryCount + 1);
//             }
//           }
//         } catch (e) {
//           AILogger.logSchemaValidation(false, 'JSON parsing error: $e');
//           printPassRate();
//           if (retryCount < 1) {
//             print('🔄 Retrying API call due to JSON parsing error...');
//             return await getChatCompletion(userMessage, retryCount: retryCount + 1);
//           }
//         }
//       } else {
//         print('❌ API Error: ${response.statusCode} - ${response.body}');
//         printPassRate();
//       }
//     } catch (e) {
//       print('❌ Network Error: $e');
//       printPassRate();
//     }
//
//     return null;
//   }
//
//   bool _validateResponse(Map<String, dynamic> response) {
//     try {
//       // Check required fields
//       if (!response.containsKey('coach_action') ||
//           !response.containsKey('message') ||
//           !response.containsKey('next_questions') ||
//           !response.containsKey('tone') ||
//           !response.containsKey('confidence')) {
//         return false;
//       }
//
//       final validActions = ['ADVICE', 'CREATE_HABIT', 'SCHEDULE_REMINDER', 'LOG_COMPLETION', 'REFRAME'];
//       if (!validActions.contains(response['coach_action'])) {
//         return false;
//       }
//
//       final message = response['message'];
//       if (message == null || message.toString().isEmpty || message.toString().length > 500) {
//         return false;
//       }
//
//       final nextQuestions = response['next_questions'];
//       if (nextQuestions != null && nextQuestions is List && nextQuestions.length > 3) {
//         return false;
//       }
//
//       final confidence = response['confidence'];
//       if (confidence != null && (confidence < 0.0 || confidence > 1.0)) {
//         return false;
//       }
//
//       return true;
//     } catch (e) {
//       print('Validation error: $e');
//       return false;
//     }
//   }
// }
//
// // Controllers
// class AICoachController extends GetxController with GetTickerProviderStateMixin {
//   final OpenAIService _openAIService = Get.find<OpenAIService>();
//   final TextEditingController chatController = TextEditingController();
//   final ScrollController chatScrollController = ScrollController();
//
//   late AnimationController floatingController;
//   late Animation<double> floatingAnimation;
//
//   // Observable variables
//   final RxList<ChatMessage> chatMessages = <ChatMessage>[
//     ChatMessage(
//       message: "Hi! I'm your AI habit coach. I can help you create new habits, provide advice, and keep you motivated. What would you like to work on today? 🎯",
//       isUser: false,
//       timestamp: DateTime.now().subtract(Duration(minutes: 1)),
//       nextQuestions: ["I want to start a new habit", "Help me stay motivated"],
//     ),
//   ].obs;
//
//   final RxBool isTyping = false.obs;
//   final Rxn<HabitTemplate> createdHabitTemplate = Rxn<HabitTemplate>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeAnimations();
//   }
//
//   @override
//   void onClose() {
//     floatingController.dispose();
//     chatController.dispose();
//     chatScrollController.dispose();
//     super.onClose();
//   }
//
//   void _initializeAnimations() {
//     floatingController = AnimationController(
//       duration: Duration(seconds: 3),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     floatingAnimation = Tween<double>(
//       begin: 0,
//       end: 10,
//     ).animate(CurvedAnimation(
//       parent: floatingController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   void sendMessage() {
//     if (chatController.text.trim().isEmpty || isTyping.value) return;
//
//     final message = chatController.text.trim();
//     chatMessages.add(ChatMessage(
//       message: message,
//       isUser: true,
//       timestamp: DateTime.now(),
//     ));
//
//     chatController.clear();
//     scrollToBottom();
//
//     // Send to AI
//     _sendAIMessage(message);
//   }
//
//   void _sendAIMessage(String message) async {
//     isTyping.value = true;
//
//     try {
//       final coachResponse = await _openAIService.getChatCompletion(message);
//
//       isTyping.value = false;
//
//       if (coachResponse != null) {
//         chatMessages.add(ChatMessage(
//           message: coachResponse.message,
//           isUser: false,
//           timestamp: DateTime.now(),
//           nextQuestions: coachResponse.nextQuestions,
//           tone: coachResponse.tone,
//         ));
//
//         await _handleCoachAction(coachResponse);
//       } else {
//         chatMessages.add(ChatMessage(
//           message: "I'm having trouble connecting right now. Please try again in a moment.",
//           isUser: false,
//           timestamp: DateTime.now(),
//         ));
//       }
//
//       scrollToBottom();
//     } catch (e) {
//       isTyping.value = false;
//       chatMessages.add(ChatMessage(
//         message: "Something went wrong. Please try again.",
//         isUser: false,
//         timestamp: DateTime.now(),
//       ));
//       scrollToBottom();
//     }
//   }
//
//   Future<void> _handleCoachAction(CoachResponse response) async {
//     switch (response.coachAction) {
//       case 'CREATE_HABIT':
//         if (response.habitTemplate != null) {
//           await createHabit(response.habitTemplate!);
//
//           // Immediate UI update - add success message to chat
//           chatMessages.add(ChatMessage(
//             message: "✅ Great! I've created the habit \"${response.habitTemplate!.title}\" for you. It's scheduled for ${response.habitTemplate!.cadence.days.join(', ')} at ${response.habitTemplate!.cadence.times.join(', ')}.",
//             isUser: false,
//             timestamp: DateTime.now(),
//             nextQuestions: ["Start tracking today", "Modify this habit"],
//           ));
//
//           scrollToBottom();
//           update(); // Force UI refresh
//         }
//         break;
//       case 'LOG_COMPLETION':
//         print('📝 Logging habit completion');
//         // Add immediate UI feedback
//         chatMessages.add(ChatMessage(
//           message: "🎉 Logged! Great job staying consistent!",
//           isUser: false,
//           timestamp: DateTime.now(),
//         ));
//         scrollToBottom();
//         break;
//       case 'SCHEDULE_REMINDER':
//         print('⏰ Scheduling reminder');
//         break;
//       case 'ADVICE':
//       case 'REFRAME':
//       default:
//         break;
//     }
//   }
//
//   Future<void> createHabit(HabitTemplate template) async {
//     print('🆕 Creating new habit: ${template.title}');
//
//     // Store the created habit template
//     createdHabitTemplate.value = template;
//
//     Get.snackbar(
//       '✅ Habit Created',
//       'New habit "${template.title}" created!',
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: Duration(seconds: 2),
//     );
//
//     HapticFeedback.lightImpact();
//   }
//
//   void scrollToBottom() {
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (chatScrollController.hasClients) {
//         chatScrollController.animateTo(
//           chatScrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   void onQuestionTap(String question) {
//     chatController.text = question;
//     sendMessage();
//   }
//
//   void onBackPressed() {
//     Get.back(result: createdHabitTemplate.value);
//   }
//
//   Color getToneColor(String tone) {
//     switch (tone) {
//       case 'celebratory':
//         return Color(0xFFF59E0B).withOpacity(0.2);
//       case 'accountable':
//         return Color(0xFFEF4444).withOpacity(0.2);
//       default: // supportive
//         return Color(0xFF10B981).withOpacity(0.2);
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  final HabitCadence cadence;
  final String category;

  HabitTemplate({
    required this.title,
    required this.cadence,
    required this.category,
  });

  factory HabitTemplate.fromJson(Map<String, dynamic> json) {
    return HabitTemplate(
      title: json['title'],
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
    print('🤖 AI Metrics: $tokens tokens, ${latencyMs}ms latency, model: $model');
  }

  static void logSchemaValidation(bool isValid, String error) {
    print('📋 Schema Validation: ${isValid ? "✅ VALID" : "❌ INVALID - $error"}');
  }

  static void logApiCall(String endpoint, int statusCode) {
    print('🌐 API Call: $endpoint - Status: $statusCode');
  }
}

class OpenAIService extends GetxService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://habitai-proxy-9k8kj6eoz-jofus-projects-a8bfd489.vercel.app',
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
    print('📊 Schema Pass Rate: ${getSchemaPassRate().toStringAsFixed(1)}% ($successfulValidations/$totalApiCalls)');
  }

  static const String systemPrompt = '''
You are HabitAI's Coach, helping users design and stick to small, achievable habits.

Rules:
- Be concise: 1–3 short sentences, no markdown.
- Default tone: supportive. Use "accountable" for user-requested pushes; "celebratory" for successes.
- Always provide 1–2 actionable next_questions to clarify habit details (e.g., goal, schedule, blockers) or prompt next steps (e.g., start tracking, adjust habit). Avoid vague questions like "What do you prefer?".
- Examples of good next_questions: "When do you want to do this habit?", "What's your goal for this habit?", "Need help with reminders?", "Want to start tracking today?".
- Prefer a single, specific next step (tiny, achievable).
- Use tool calls for: CREATE_HABIT (propose habit with habit_template), SCHEDULE_REMINDER, or LOG_COMPLETION.
- Use ADVICE for general guidance; REFRAME for setbacks with a retry plan.
- For CREATE_HABIT, include habit_template with realistic cadence (days: ["Mon","Tue",...], times: HH:MM in 24-hour format, user’s local time).
- Keep message ≤ 500 chars, next_questions ≤ 2 items, each ≤ 140 chars.
- Safety: No medical/clinical diagnosis or crisis counseling; suggest professional help if needed.

Output:
Return ONLY valid JSON matching the schema:
{
  "coach_action": "ADVICE|CREATE_HABIT|SCHEDULE_REMINDER|LOG_COMPLETION|REFRAME",
  "message": string,
  "next_questions": [string],
  "habit_template": { "title": string, "cadence": { "days": [string], "times": [string] }, "category": string } | null,
  "reminders": [{ "habit_id": string|null, "time_local": string, "days": [string] }],
  "tone": "supportive|celebratory|accountable",
  "confidence": number
}
''';

  static const Map<String, dynamic> responseSchema = {
    "type": "object",
    "additionalProperties": false,
    "required": ["coach_action", "message", "next_questions", "habit_template", "reminders", "tone", "confidence"],
    "properties": {
      "coach_action": {
        "type": "string",
        "enum": ["ADVICE", "CREATE_HABIT", "SCHEDULE_REMINDER", "LOG_COMPLETION", "REFRAME"]
      },
      "message": {
        "type": "string",
        "minLength": 1,
        "maxLength": 500
      },
      "next_questions": {
        "type": "array",
        "minItems": 0,
        "maxItems": 3,
        "items": {
          "type": "string",
          "minLength": 1,
          "maxLength": 140
        }
      },
      "habit_template": {
        "type": ["object", "null"],
        "additionalProperties": false,
        "required": ["title", "cadence", "category"],
        "properties": {
          "title": {
            "type": "string",
            "minLength": 1,
            "maxLength": 80
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
            "enum": ["health", "work", "study", "mindfulness", "finance", "relationships", "custom"]
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

  Future<CoachResponse?> getChatCompletion(String userMessage, {int retryCount = 0}) async {
    final startTime = DateTime.now();
    totalApiCalls++;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage}
          ],
          'response_format': {
            'type': 'json_schema',
            'json_schema': {
              'name': 'coach_response',
              'schema': responseSchema,
              'strict': true
            }
          },
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      final latency = DateTime.now().difference(startTime).inMilliseconds;
      AILogger.logApiCall('/api/chat', response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        final tokens = data['usage']['total_tokens'];

        AILogger.logTokenUsage(tokens, latency, 'gpt-4o-mini');

        try {
          final responseJson = jsonDecode(content);

          if (_validateResponse(responseJson)) {
            successfulValidations++;
            AILogger.logSchemaValidation(true, '');
            printPassRate();
            final coachResponse = CoachResponse.fromJson(responseJson);
            return coachResponse;
          } else {
            AILogger.logSchemaValidation(false, 'Schema validation failed');
            printPassRate();
            if (retryCount < 1) {
              print('🔄 Retrying API call due to schema validation failure...');
              return await getChatCompletion(userMessage, retryCount: retryCount + 1);
            }
          }
        } catch (e) {
          AILogger.logSchemaValidation(false, 'JSON parsing error: $e');
          printPassRate();
          if (retryCount < 1) {
            print('🔄 Retrying API call due to JSON parsing error...');
            return await getChatCompletion(userMessage, retryCount: retryCount + 1);
          }
        }
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        printPassRate();
      }
    } catch (e) {
      print('❌ Network Error: $e');
      printPassRate();
    }

    return null;
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

      final validActions = ['ADVICE', 'CREATE_HABIT', 'SCHEDULE_REMINDER', 'LOG_COMPLETION', 'REFRAME'];
      if (!validActions.contains(response['coach_action'])) {
        return false;
      }

      final message = response['message'];
      if (message == null || message.toString().isEmpty || message.toString().length > 500) {
        return false;
      }

      final nextQuestions = response['next_questions'];
      if (nextQuestions != null && nextQuestions is List) {
        if (nextQuestions.length > 3) return false;
        for (var question in nextQuestions) {
          if (question.isEmpty || question.length > 140) return false;
          // Ensure questions are actionable and habit-related
          if (question.toLowerCase().contains('what do you prefer') ||
              question.toLowerCase().contains('how do you feel')) {
            return false;
          }
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
class AICoachController extends GetxController with GetTickerProviderStateMixin {
  final OpenAIService _openAIService = Get.find<OpenAIService>();
  final TextEditingController chatController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  late AnimationController floatingController;
  late Animation<double> floatingAnimation;

  final RxList<ChatMessage> chatMessages = <ChatMessage>[
    ChatMessage(
      message: "Hi! I'm your AI habit coach. I can help you create new habits, provide advice, and keep you motivated. What would you like to work on today? 🎯",
      isUser: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
      nextQuestions: ["I want to start a new habit", "Help me stay motivated"],
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
    isTyping.value = true;

    try {
      final coachResponse = await _openAIService.getChatCompletion(message);

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
      } else {
        chatMessages.add(ChatMessage(
          message: "I'm having trouble connecting right now. Please try again in a moment.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }

      scrollToBottom();
    } catch (e) {
      isTyping.value = false;
      chatMessages.add(ChatMessage(
        message: "Something went wrong. Please try again.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
      scrollToBottom();
    }
  }

  Future<void> _handleCoachAction(CoachResponse response) async {
    switch (response.coachAction) {
      case 'CREATE_HABIT':
        if (response.habitTemplate != null) {
          await createHabit(response.habitTemplate!);

          chatMessages.add(ChatMessage(
            message: "✅ Great! I've created the habit \"${response.habitTemplate!.title}\" for you. It's scheduled for ${response.habitTemplate!.cadence.days.join(', ')} at ${response.habitTemplate!.cadence.times.join(', ')}.",
            isUser: false,
            timestamp: DateTime.now(),
            nextQuestions: ["Start tracking today", "Modify this habit"],
          ));

          scrollToBottom();
          update();
        }
        break;
      case 'LOG_COMPLETION':
        print('📝 Logging habit completion');
        chatMessages.add(ChatMessage(
          message: "🎉 Logged! Great job staying consistent!",
          isUser: false,
          timestamp: DateTime.now(),
        ));
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

  Future<void> createHabit(HabitTemplate template) async {
    print('🆕 Creating new habit: ${template.title}');

    createdHabitTemplate.value = template;

    Get.snackbar(
      '✅ Habit Created',
      'New habit "${template.title}" created!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    HapticFeedback.lightImpact();
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
      default: // supportive
        return Color(0xFF10B981).withOpacity(0.2);
    }
  }
}