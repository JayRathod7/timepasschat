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
        body: Obx(
          () => Stack(
            children: [
              Container(
                height: 340,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
              ),

              Positioned(
                top: -30,
                right: -25,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                top: 110,
                left: -25,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.18),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.16),
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),

                        Container(
                          height: 82,
                          width: 82,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            AppImages.appLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Gap(18),

                        const Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const Gap(8),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            'Register with your details and start your TimePass Chat journey today.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const Gap(26),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Register Account',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Gap(6),
                              const Text(
                                'Fill all required details below',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const Gap(22),

                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller:
                                          controller.firstNameController,
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
                                controller:
                                    controller.confirmPasswordController,
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
                                        !controller
                                            .obscureConfirmPassword
                                            .value;
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
                                      controller.passwordController.text
                                          .trim()) {
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
                              const Gap(22),

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: AppColors.border,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
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
                            ],
                          ),
                        ),

                        const Gap(20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.goToLogin,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
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
            ],
          ),
        ),
      ),
    );
  }
}
