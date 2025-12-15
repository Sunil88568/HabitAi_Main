import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../../../services/quiz_service.dart';
import '../../../services/storage/preferences.dart';
import '../../data/models/dataModels/question_model.dart';

class QuizController extends GetxController {
  static QuizController get find => Get.put(QuizController());

  RxList<CsvQuestionModel> questions = <CsvQuestionModel>[].obs;
  RxList<String> userAnswers = <String>[].obs;
  RxInt currentQuestionIndex = 0.obs;
  RxString selectedAnswer = ''.obs;
  RxBool isQuizCompleted = false.obs;
  RxBool isLoading = false.obs;
  RxInt userCoins = 0.obs;
  RxInt timeRemaining = 30.obs;
  Timer? _timer;
  DateTime? _startTime;
  RxBool canTakeQuiz = false.obs;
  RxBool canTakePremiumQuiz = false.obs;
  RxString quizStatus = ''.obs;
  RxString premiumQuizStatus = ''.obs;
  RxBool isPremiumQuiz = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserCoins();
    checkQuizAvailability();
    checkPremiumQuizAvailability();
  }

  void loadUserCoins() {
    userCoins.value = Preferences.getUserCoins ?? 0;
  }

  Future<void> startQuiz({bool premium = false}) async {
    isLoading.value = true;
    isPremiumQuiz.value = premium;
    
    if (premium) {
      await QuizService.loadPremiumQuestions();
      questions.value = QuizService.getRandomQuestions(isPremium: true);
    } else {
      await QuizService.loadQuestions();
      questions.value = QuizService.getRandomQuestions();
    }
    
    userAnswers.value = List.filled(questions.length, '');
    currentQuestionIndex.value = 0;
    selectedAnswer.value = '';
    isQuizCompleted.value = false;
    timeRemaining.value = premium ? 0 : 30;
    _startTime = DateTime.now();
    
    if (!premium) {
      _startTimer();
    }
    isLoading.value = false;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        completeQuiz();
      }
    });
  }

  void selectAnswer(String answer) {
    selectedAnswer.value = answer;
  }

  void nextQuestion() {
    if (selectedAnswer.value.isNotEmpty) {
      userAnswers[currentQuestionIndex.value] = selectedAnswer.value;
      
      if (currentQuestionIndex.value < questions.length - 1) {
        currentQuestionIndex.value++;
        selectedAnswer.value = userAnswers[currentQuestionIndex.value];
      } else {
        completeQuiz();
      }
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      userAnswers[currentQuestionIndex.value] = selectedAnswer.value;
      currentQuestionIndex.value--;
      selectedAnswer.value = userAnswers[currentQuestionIndex.value];
    }
  }

  void completeQuiz() {
    _timer?.cancel();
    
    if (selectedAnswer.value.isNotEmpty) {
      userAnswers[currentQuestionIndex.value] = selectedAnswer.value;
    }
    isQuizCompleted.value = true;
    
    final result = getQuizResult();
    
    if (!isPremiumQuiz.value) {
      addCoins(result.coinsEarned);
      // Mark quiz as completed for this Monday
      _markQuizCompleted();
      
      // Save result to Firebase for leaderboard
      final userId = Preferences.profile?.id ?? 'guest';
      QuizService.saveQuizResult(userId, result).then((_) {
        print('Quiz result saved to Firebase successfully');
        // Update availability immediately after completion
        canTakeQuiz.value = false;
        quizStatus.value = 'You have already completed this week\'s quiz';
      }).catchError((error) {
        print('Error saving quiz result: $error');
      });
    } else {
      // Premium quiz - mark as completed but don't save to leaderboard
      _markPremiumQuizCompleted();
      // Update availability immediately after completion
      canTakePremiumQuiz.value = false;
      premiumQuizStatus.value = 'You have already completed this week\'s premium quiz';
    }
  }

  QuizResult getQuizResult() {
    int correctAnswers = 0;
    
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i].correctAnswer) {
        correctAnswers++;
      }
    }
    
    int timeTaken = _startTime != null ? DateTime.now().difference(_startTime!).inSeconds : 30;
    int coinsEarned = QuizService.calculateCoinsWithTime(correctAnswers, questions.length, timeTaken);
    
    return QuizResult(
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      coinsEarned: coinsEarned,
      questions: questions,
      userAnswers: userAnswers,
      timeTaken: timeTaken,
    );
  }

  void addCoins(int coins) {
    userCoins.value += coins;
    Preferences.setUserCoins = userCoins.value;
  }

  bool isAnswerCorrect(int questionIndex) {
    return userAnswers[questionIndex] == questions[questionIndex].correctAnswer;
  }
  
  String getCorrectAnswerText(int questionIndex) {
    return questions[questionIndex].getCorrectAnswerText();
  }

  void resetQuiz() {
    _timer?.cancel();
    questions.clear();
    userAnswers.clear();
    currentQuestionIndex.value = 0;
    selectedAnswer.value = '';
    isQuizCompleted.value = false;
    timeRemaining.value = 30;
    _startTime = null;
  }

  void checkQuizAvailability() async {
    final now = DateTime.now();
    final isMonday = now.weekday == DateTime.monday;
    
    if (!isMonday) {
      canTakeQuiz.value = false;
      quizStatus.value = 'Quiz is only available on Mondays';
      return;
    }
    
    // Check if user already completed quiz this Monday
    final mondayKey = _getMondayKey(now);
    final completedQuizzes = await _getCompletedQuizzes();
    
    if (completedQuizzes.contains(mondayKey)) {
      canTakeQuiz.value = false;
      quizStatus.value = 'You have already completed this week\'s quiz';
    } else {
      canTakeQuiz.value = true;
      quizStatus.value = 'Quiz available - Good luck!';
    }
  }

  void checkPremiumQuizAvailability() async {
    final now = DateTime.now();
    final isMonday = now.weekday == DateTime.monday;
    
    if (!isMonday) {
      canTakePremiumQuiz.value = false;
      premiumQuizStatus.value = 'Premium quiz is only available on Mondays';
      return;
    }
    
    // Check if user already completed premium quiz this Monday
    final mondayKey = _getMondayKey(now);
    final completedPremiumQuizzes = await _getCompletedPremiumQuizzes();
    
    if (completedPremiumQuizzes.contains(mondayKey)) {
      canTakePremiumQuiz.value = false;
      premiumQuizStatus.value = 'You have already completed this week\'s premium quiz';
    } else {
      canTakePremiumQuiz.value = true;
      premiumQuizStatus.value = 'Premium quiz available!';
    }
  }
  
  String _getMondayKey(DateTime date) {
    // Get the Monday of current week
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month}-${monday.day}';
  }
  
  Future<List<String>> _getCompletedQuizzes() async {
    final userId = Preferences.profile?.id;
    if (userId == null) return [];
    
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('user_stats').child(userId).child('completedQuizzes').get();
      
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data.keys.cast<String>().toList();
      }
    } catch (e) {
      print('Error fetching completed quizzes: $e');
    }
    return [];
  }
  
  void _markQuizCompleted() {
    final now = DateTime.now();
    final mondayKey = _getMondayKey(now);
    // Store completion in Firebase user stats
    _saveQuizCompletion(mondayKey);
  }
  
  void _saveQuizCompletion(String mondayKey) async {
    final userId = Preferences.profile?.id;
    if (userId != null) {
      try {
        final ref = FirebaseDatabase.instance.ref();
        await ref.child('user_stats').child(userId).child('completedQuizzes').child(mondayKey).set(true);
      } catch (e) {
        print('Error saving quiz completion: $e');
      }
    }
  }

  Future<List<String>> _getCompletedPremiumQuizzes() async {
    final userId = Preferences.profile?.id;
    if (userId == null) return [];
    
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('user_stats').child(userId).child('completedPremiumQuizzes').get();
      
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data.keys.cast<String>().toList();
      }
    } catch (e) {
      print('Error fetching completed premium quizzes: $e');
    }
    return [];
  }

  void _markPremiumQuizCompleted() {
    final now = DateTime.now();
    final mondayKey = _getMondayKey(now);
    _savePremiumQuizCompletion(mondayKey);
  }
  
  void _savePremiumQuizCompletion(String mondayKey) async {
    final userId = Preferences.profile?.id;
    if (userId != null) {
      try {
        final ref = FirebaseDatabase.instance.ref();
        await ref.child('user_stats').child(userId).child('completedPremiumQuizzes').child(mondayKey).set(true);
      } catch (e) {
        print('Error saving premium quiz completion: $e');
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}