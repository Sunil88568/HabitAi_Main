import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserProfile(User user) async {
  final tz = DateFormat('z').format(DateTime.now());
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'email': user.email ?? '',
    'createdAt': FieldValue.serverTimestamp(),
    'timezone': tz,
    'starterHabits': [],
    'hasCompletedOnboarding': true, // <-- add this field
  });
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save habits and mark onboarding as completed
  Future<void> saveUserHabits(List<String> habits) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final now = DateTime.now();
    final tzString = now.timeZoneName;
    await _db.collection('users').doc(user.uid).set({
      'timezone': tzString,
      'starterHabits': habits,
      'hasCompletedOnboarding': true, // <-- mark onboarding complete
    }, SetOptions(merge: true));
  }

  /// Get user habits
  Future<List<String>> getUserHabits() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data()?['habits'] != null) {
      return List<String>.from(doc.data()?['habits']);
    }
    return [];
  }

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return false;

    final data = doc.data();
    return data != null && data['hasCompletedOnboarding'] == true;
  }
}
