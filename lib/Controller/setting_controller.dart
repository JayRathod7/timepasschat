// lib/Controller/settings_controller.dart
import 'package:get/get.dart';

import '../Controller/home_controller.dart';
import '../Routes/app_routes.dart';

class SettingsController extends GetxController {
  void openEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  void showComingSoon(String title) {
    Get.snackbar(
      title,
      'Coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> logout() async {
    final homeController = Get.find<HomeController>();
    await homeController.logout();
  }
}