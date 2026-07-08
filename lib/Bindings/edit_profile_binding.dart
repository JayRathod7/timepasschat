// lib/Bindings/edit_profile_binding.dart
import 'package:get/get.dart';
import '../Controller/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}