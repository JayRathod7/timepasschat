// lib/Controller/splash_controller.dart
import 'package:get/get.dart';

import '../Routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _goToLogin();
  }

  Future<void> _goToLogin() async {
    await Future.delayed(const Duration(seconds: 5));
    Get.offNamed(AppRoutes.login);
  }
}
