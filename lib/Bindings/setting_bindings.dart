// lib/Bindings/settings_binding.dart
import 'package:get/get.dart';

import '../Controller/setting_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}