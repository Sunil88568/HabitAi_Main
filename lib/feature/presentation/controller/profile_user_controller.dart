import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:question_app/utils/appUtils.dart';

import '../../data/models/dataModels/login_model/login_model.dart';
import '../../data/models/dataModels/question_model.dart';
import '../../data/models/repository/iAuthRepository.dart';
import '../../domain/repository/authRepository.dart';

class ProfileUserController extends GetxController {
  static ProfileUserController get find => Get.put(ProfileUserController(), permanent: true);
  final AuthRepository _repo = IAuthRepository();

  RxBool isLoading = false.obs;
  Rx<LoginModel?> userProfile = Rx<LoginModel?>(null);
  RxList<QuestionModel> questionList = <QuestionModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    final response = await _repo.getUserProfile();

    isLoading.value = false;

    if (response.isSuccess) {
      userProfile.value = response.data;
      AppUtils.log("User Name: ${response.data?.name}");
    } else {
      AppUtils.log("Failed to fetch user profile: ${response.message}");

    }
  }



  Future<void> getQuestions() async {
    isLoading.value = true;

    final response = await _repo.getQuestions();

    isLoading.value = false;

    if (response.isSuccess) {
      AppUtils.log("User Question: ${response.data}");
      questionList.value = response.data ?? [];
    } else {
      AppUtils.log("Failed to fetch question: ${response.message}");
    }
  }


  Future<void> logOut() async {
    isLoading.value = true;

    final response = await _repo.logOut();

    isLoading.value = false;

    if (response.isSuccess) {
      AppUtils.log("Logout successful.");
    } else {
      AppUtils.log("Logout failed: ${response.message}");
    }
  }
}
