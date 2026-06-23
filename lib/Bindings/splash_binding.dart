// lib/Bindings/splash_binding.dart
import 'package:get/get.dart';

import '../Controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
