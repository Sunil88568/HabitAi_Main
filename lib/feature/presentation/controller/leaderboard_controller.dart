import 'package:get/get.dart';
import 'package:question_app/feature/data/models/dataModels/leaderboard_model.dart';
import 'package:question_app/services/leaderboard_service.dart';

class LeaderboardController extends GetxController {
  static LeaderboardController get find => Get.put(LeaderboardController());

  RxList<LeaderboardUser> leaderboardUsers = <LeaderboardUser>[].obs;
  Rx<LeaderboardUser?> currentUser = Rx<LeaderboardUser?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    isLoading.value = true;
    
    try {
      final users = await LeaderboardService.getLeaderboard();
      final currentUserData = await LeaderboardService.getCurrentUserRank();
      
      leaderboardUsers.value = users;
      currentUser.value = currentUserData;
    } catch (e) {
      print('Error in leaderboard controller: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int getCurrentUserPosition() {
    if (currentUser.value == null) return 0;
    
    for (int i = 0; i < leaderboardUsers.length; i++) {
      if (leaderboardUsers[i].id == currentUser.value!.id) {
        return i + 1;
      }
    }
    return leaderboardUsers.length + 1;
  }
}