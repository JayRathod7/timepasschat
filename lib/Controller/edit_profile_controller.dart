// lib/Controller/edit_profile_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final aboutController = TextEditingController();
  final cityController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final websiteController = TextEditingController();

  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;
  final RxString profileImage = ''.obs;

  String get currentUserId => _auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) {
        Get.back();
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final doc =
      await _firestore.collection('users').doc(user.uid).get();

      final data = doc.data() ?? {};

      nameController.text = data['name'] ?? user.displayName ?? '';
      emailController.text = data['email'] ?? user.email ?? '';
      phoneController.text = data['phone'] ?? '';
      bioController.text = data['bio'] ?? '';
      aboutController.text = data['about'] ?? '';
      cityController.text = data['city'] ?? '';
      genderController.text = data['gender'] ?? '';
      dobController.text = data['dob'] ?? '';
      websiteController.text = data['website'] ?? '';
      profileImage.value = data['profileImage'] ?? '';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changePhoto() {
    Get.snackbar(
      'Profile Photo',
      'Coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    if (currentUserId.isEmpty || isUpdating.value) return;

    try {
      isUpdating.value = true;

      await _firestore.collection('users').doc(currentUserId).set({
        'uid': currentUserId,
        'name': nameController.text.trim(),
        'nameLower': nameController.text.trim().toLowerCase(),
        'email': emailController.text.trim(),
        'emailLower': emailController.text.trim().toLowerCase(),
        'phone': phoneController.text.trim(),
        'bio': bioController.text.trim(),
        'about': aboutController.text.trim(),
        'city': cityController.text.trim(),
        'gender': genderController.text.trim(),
        'dob': dobController.text.trim(),
        'website': websiteController.text.trim(),
        'profileImage': profileImage.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Profile update failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    aboutController.dispose();
    cityController.dispose();
    genderController.dispose();
    dobController.dispose();
    websiteController.dispose();
    super.onClose();
  }
}