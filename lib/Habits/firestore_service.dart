// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:habit_ai/Habits/habit_controller.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance; // Defines _db
//   final String userId = 'demo_user'; // TODO: Use FirebaseAuth.instance.currentUser?.uid
//
//   static void enablePersistence() {
//     FirebaseFirestore.instance.settings = const Settings(
//       persistenceEnabled: true,
//       cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
//     );
//   }
//
//   Stream<List<HabitItem>> getHabitsStream() {
//     return _db
//         .collection('habits')
//         .where('userId', isEqualTo: userId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => HabitItem.fromFirestore(doc.data(), doc.id))
//         .toList());
//   }
//
//   Future<void> addHabit(HabitItem habit) async {
//     await _db.collection('habits').doc(habit.id).set(habit.toFirestore());
//   }
//
//   Future<DocumentSnapshot> getLog(String habitId, String date) async {
//     return _db.collection('habit_logs').doc('${habitId}_${date}').get();
//   }
//
//   Future<void> setLog(String habitId, String date, bool completed) async {
//     final log = HabitLog(
//       id: '${habitId}_${date}',
//       habitId: habitId,
//       date: date,
//       completed: completed,
//       timestamp: DateTime.now(),
//     );
//     await _db.collection('habit_logs').doc(log.id).set(log.toFirestore());
//   }
//
//   Stream<List<HabitLog>> getRecentLogsStream(String habitId) {
//     final endDate = DateTime.now();
//     final startDate = endDate.subtract(const Duration(days: 30));
//     return _db
//         .collection('habit_logs')
//         .where('habitId', isEqualTo: habitId)
//         .where('date', isGreaterThanOrEqualTo: _formatDte(startDate))
//         .where('date', isLessThanOrEqualTo: _formatDate(endDate))
//         .orderBy('date')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => HabitLog.fromFirestore(doc.data(), doc.id))
//         .toList());
//   }
//
//   String _formatDate(DateTime date) =>
//       '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
// }