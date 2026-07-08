import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/app_colors.dart';
import '../Controller/edit_profile_controller.dart';
import '../Widgets/custom_text_field.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          return Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Obx(
                            () => CircleAvatar(
                          radius: 42,
                          backgroundColor: AppColors.primary.withOpacity(0.10),
                          backgroundImage: controller.profileImage.value.isNotEmpty
                              ? NetworkImage(controller.profileImage.value)
                              : null,
                          child: controller.profileImage.value.isEmpty
                              ? const Icon(
                            Icons.person_rounded,
                            size: 38,
                            color: AppColors.primary,
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.nameController.text.isEmpty
                            ? 'Your Profile'
                            : controller.nameController.text,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.emailController.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: controller.changePhoto,
                        icon: const Icon(Icons.camera_alt_rounded, size: 18),
                        label: const Text('Change Photo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: controller.nameController,
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: controller.emailController,
                        labelText: 'Email',
                        hintText: 'Email address',
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: controller.phoneController,
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: controller.cityController,
                        labelText: 'City',
                        hintText: 'Enter city',
                        prefixIcon: const Icon(Icons.location_city_outlined),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: controller.genderController,
                        labelText: 'Gender',
                        hintText: 'Enter gender',
                        prefixIcon: const Icon(Icons.wc_rounded),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: controller.dobController,
                        labelText: 'Date of Birth',
                        hintText: 'DD/MM/YYYY',
                        prefixIcon: const Icon(Icons.calendar_month_rounded),
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Obx(
                      () => SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : controller.updateProfile,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: controller.isUpdating.value
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}