import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:question_app/feature/data/models/dataModels/leaderboard_model.dart';
import 'package:question_app/services/storage/preferences.dart';

class LeaderboardService {
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();

  static Future<List<LeaderboardUser>> getLeaderboard() async {
    try {
      // Initialize Firebase if not already done
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      
      final snapshot = await _database.child('user_stats').get();
      
      print('Firebase snapshot exists: ${snapshot.exists}');
      print('Firebase data: ${snapshot.value}');
      
      if (!snapshot.exists) return [];

      List<LeaderboardUser> users = [];
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((userId, userData) {
        print('Processing user: $userId, data: $userData');
        if (userData is Map) {
          users.add(LeaderboardUser(
            id: userId.toString(),
            name: userData['name'] ?? 'Anonymous',
            points: userData['totalCoins'] ?? 0,
            image: userData['image'],
          ));
        }
      });

      print('Total users found: ${users.length}');
      
      // Sort by points descending
      users.sort((a, b) => b.points.compareTo(a.points));
      
      return users;
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  static Future<LeaderboardUser?> getCurrentUserRank() async {
    try {
      // Initialize Firebase if not already done
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      
      final currentUserId = Preferences.profile?.id;
      if (currentUserId == null) return null;

      final snapshot = await _database.child('user_stats').child(currentUserId).get();
      
      if (!snapshot.exists) return null;

      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      
      return LeaderboardUser(
        id: currentUserId,
        name: userData['name'] ?? Preferences.profile?.name ?? 'You',
        points: userData['totalCoins'] ?? 0,
        image: userData['image'],
      );
    } catch (e) {
      print('Error fetching current user rank: $e');
      return null;
    }
  }
}