import 'package:get/get.dart';
import 'package:question_app/utils/appUtils.dart';
import '../../data/models/dataModels/login_model/login_model.dart';
import '../../data/models/dataModels/responseDataModel.dart';
import '../../data/models/repository/iAuthRepository.dart';
import '../../domain/repository/authRepository.dart';

class ProfileUserController extends GetxController {
  final AuthRepository _repo = IAuthRepository();

  RxBool isLoading = false.obs;
  Rxn<LoginModel> userProfile = Rxn<LoginModel>();

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
      // AppUtils.toastError(response.getError);
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
