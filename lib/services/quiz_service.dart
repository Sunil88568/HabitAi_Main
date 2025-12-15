import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../feature/data/models/dataModels/question_model.dart';
import '../services/storage/preferences.dart';

class QuizService {
  static List<CsvQuestionModel> _allQuestions = [];
  static List<CsvQuestionModel> _premiumQuestions = [];
  static const int questionsPerQuiz = 5;
  static const int premiumQuestionsPerQuiz = 1;
  static const int coinsPerCorrectAnswer = 5;
  static const int bonusCoinsForPerfectScore = 0;

  static Future<void> loadQuestions() async {
    try {
      final String csvData = await rootBundle.loadString('assets/questions.csv');
      final List<String> lines = csvData.split('\n');
      
      _allQuestions = lines
          .skip(1) // Skip header row
          .where((line) => line.trim().isNotEmpty)
          .map((line) => CsvQuestionModel.fromCsv(_parseCsvLine(line)))
          .toList();
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  static Future<void> loadPremiumQuestions() async {
    try {
      final String csvData = await rootBundle.loadString('assets/questions2.csv');
      final List<String> lines = csvData.split('\n');
      
      _premiumQuestions = lines
          .skip(1) // Skip header row
          .where((line) => line.trim().isNotEmpty)
          .map((line) => CsvQuestionModel.fromCsv(_parseCsvLine(line)))
          .toList();
    } catch (e) {
      print('Error loading premium questions: $e');
    }
  }

  static List<String> _parseCsvLine(String line) {
    List<String> result = [];
    bool inQuotes = false;
    String current = '';
    
    for (int i = 0; i < line.length; i++) {
      String char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.trim());
        current = '';
      } else {
        current += char;
      }
    }
    result.add(current.trim());
    return result;
  }

  static List<CsvQuestionModel> getRandomQuestions({bool isPremium = false}) {
    final questions = isPremium ? _premiumQuestions : _allQuestions;
    final questionsCount = isPremium ? premiumQuestionsPerQuiz : questionsPerQuiz;
    
    if (questions.isEmpty) return [];
    
    if (questions.length <= questionsCount) {
      return questions;
    }
    
    questions.shuffle(Random());
    return questions.take(questionsCount).toList();
  }

  static int calculateCoins(int correctAnswers, int totalQuestions) {
    return correctAnswers * coinsPerCorrectAnswer;
  }

  static int calculateCoinsWithTime(int correctAnswers, int totalQuestions, int timeTaken) {
    return correctAnswers * coinsPerCorrectAnswer;
  }

  static Future<void> saveQuizResult(String userId, QuizResult result) async {
    try {
      // Initialize Firebase if not already done
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      
      final DatabaseReference ref = FirebaseDatabase.instance.ref();
      await ref.child('quiz_results').child(userId).push().set(result.toJson());
      
      // Update user stats
      final userStatsRef = ref.child('user_stats').child(userId);
      final snapshot = await userStatsRef.get();
      
      Map<String, dynamic> stats = {};
      if (snapshot.exists) {
        stats = Map<String, dynamic>.from(snapshot.value as Map);
      }
      
      stats['totalQuizzes'] = (stats['totalQuizzes'] ?? 0) + 1;
      stats['totalCoins'] = (stats['totalCoins'] ?? 0) + result.coinsEarned;
      stats['lastQuizDate'] = DateTime.now().toIso8601String();
      
      // Add user name from preferences
      if (Preferences.profile?.name != null) {
        stats['name'] = Preferences.profile!.name;
      }
      
      if (result.correctAnswers == result.totalQuestions) {
        stats['perfectScores'] = (stats['perfectScores'] ?? 0) + 1;
      }
      
      await userStatsRef.set(stats);
      print('Quiz result saved successfully');
    } catch (e) {
      print('Error saving quiz result: $e');
      // Continue without saving if Firebase isn't available
    }
  }
}