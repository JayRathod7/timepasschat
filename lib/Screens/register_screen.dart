// lib/Screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../Constants/app_colors.dart';
import '../Controller/register_controller.dart';
import '../Utils/app_images.dart';
import '../Utils/app_system_ui.dart';
import '../Widgets/common_button.dart';
import '../Widgets/custom_text_field.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.background,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Form(
                key: controller.formKey,
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: AppColors.border),
                        ),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const Gap(16),
                      Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.14),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            AppImages.googleIcon,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Gap(20),
                      const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        'Register with your details to start your TimePass Chat journey.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Gap(24),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: controller.firstNameController,
                                    labelText: 'First name',
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Icon(
                                      Icons.person_outline_rounded,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Enter first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: AppTextField(
                                    controller: controller.lastNameController,
                                    labelText: 'Last name',
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Icon(
                                      Icons.badge_outlined,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Enter last name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Gap(16),
                            AppTextField(
                              controller: controller.emailController,
                              labelText: 'Email address',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(
                                Icons.mail_outline_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!GetUtils.isEmail(value.trim())) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const Gap(16),
                            AppTextField(
                              controller: controller.dobController,
                              labelText: 'Date of birth',
                              readOnly: true,
                              onTap: () => controller.pickDob(context),
                              prefixIcon: const Icon(
                                Icons.calendar_month_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select date of birth';
                                }
                                return null;
                              },
                            ),
                            const Gap(16),
                            AppTextField(
                              controller: controller.passwordController,
                              labelText: 'Password',
                              obscureText: controller.obscurePassword.value,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.obscurePassword.value =
                                      !controller.obscurePassword.value;
                                },
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter password';
                                }
                                if (value.trim().length < 6) {
                                  return 'Minimum 6 characters';
                                }
                                return null;
                              },
                            ),
                            const Gap(16),
                            AppTextField(
                              controller: controller.confirmPasswordController,
                              labelText: 'Confirm password',
                              obscureText:
                                  controller.obscureConfirmPassword.value,
                              textInputAction: TextInputAction.done,
                              prefixIcon: const Icon(
                                Icons.lock_person_outlined,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.obscureConfirmPassword.value =
                                      !controller.obscureConfirmPassword.value;
                                },
                                icon: Icon(
                                  controller.obscureConfirmPassword.value
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please confirm password';
                                }
                                if (value.trim() !=
                                    controller.passwordController.text.trim()) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                controller.registerWithEmailPassword();
                              },
                            ),
                            const Gap(18),
                            AppButton(
                              text: 'Register',
                              isLoading: controller.isLoading.value,
                              onPressed: controller.registerWithEmailPassword,
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.border,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or register with',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.border,
                            ),
                          ),
                        ],
                      ),
                      const Gap(18),
                      AppOutlineButton(
                        text: 'Continue with Google',
                        isLoading: controller.isGoogleLoading.value,
                        onPressed: controller.signUpWithGoogle,
                        imageAsset: AppImages.googleIcon,
                      ),
                      const Gap(18),
                      Center(
                        child: Wrap(
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: controller.goToLogin,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
