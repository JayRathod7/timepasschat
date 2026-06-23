// lib/Bindings/register_binding.dart
import 'package:get/get.dart';

import '../Controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
