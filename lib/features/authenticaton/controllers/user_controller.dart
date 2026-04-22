import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance {
    try {
      return Get.find<UserController>();
    } catch (e) {
      return Get.put(UserController(), permanent: true);
    }
  }

  final userName = 'User'.obs;
  final userEmail = ''.obs;
  final userRole = 'recipient'.obs;
  final userProfilePic = ''.obs;

  void updateUserData({String? name, String? email, String? role}) {
    if (name != null) userName.value = name;
    if (email != null) userEmail.value = email;
    if (role != null) userRole.value = role;
  }
}
