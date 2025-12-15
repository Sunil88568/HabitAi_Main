// CSV-based QuestionModel for local quiz
class CsvQuestionModel {
  final String question;
  final String correctAnswer;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;

  CsvQuestionModel({
    required this.question,
    required this.correctAnswer,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
  });

  factory CsvQuestionModel.fromCsv(List<String> csvRow) {
    return CsvQuestionModel(
      question: csvRow[0],
      correctAnswer: csvRow[1],
      optionA: csvRow[2],
      optionB: csvRow[3],
      optionC: csvRow[4],
      optionD: csvRow[5],
    );
  }

  List<String> get options => [optionA, optionB, optionC, optionD];
  
  String getCorrectAnswerText() {
    switch (correctAnswer) {
      case 'A': return optionA;
      case 'B': return optionB;
      case 'C': return optionC;
      case 'D': return optionD;
      default: return optionA;
    }
  }
}

// API-based QuestionModel for server quiz
class QuestionModel {
  final String? id;
  final String? question;
  final String? pricePoll;
  final int? count;
  final bool? isSubmitted;
  final List<String>? options;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;
  final int? v;

  QuestionModel({
    this.id,
    this.question,
    this.pricePoll,
    this.count,
    this.isSubmitted,
    this.options,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
    this.v,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'] as String?,
      question: json['question'] as String?,
      pricePoll: json['pricePoll'] as String?,
      count: json['count'] as int?,
      isSubmitted: json['isSubmitted'] as bool?,
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'pricePoll': pricePoll,
      'count': count,
      'isSubmitted': isSubmitted,
      'options': options,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int coinsEarned;
  final List<CsvQuestionModel> questions;
  final List<String> userAnswers;
  final int? timeTaken;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.coinsEarned,
    required this.questions,
    required this.userAnswers,
    this.timeTaken,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;
  
  Map<String, dynamic> toJson() {
    return {
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'coinsEarned': coinsEarned,
      'percentage': percentage,
      'timeTaken': timeTaken,
      'completedAt': DateTime.now().toIso8601String(),
    };
  }
}