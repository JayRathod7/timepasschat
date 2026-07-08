// lib/Screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/app_colors.dart';
import '../Controller/setting_controller.dart';
import '../Widgets/setting_tiles.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

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
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
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
      body: GridView.count(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.3,
        children: [
          SettingsGridCard(
            icon: Icons.person_rounded,
            title: 'Profile',
            subtitle: 'Edit your personal details',
            tag: 'Account',
            onTap: controller.openEditProfile,
          ),
          SettingsGridCard(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy',
            subtitle: 'Privacy policy and permissions',
            tag: 'Policy',
            onTap: () => controller.showComingSoon('Privacy Policy'),
            gradient: [
              AppColors.secondary.withOpacity(0.18),
              AppColors.primary.withOpacity(0.10),
            ],
          ),
          SettingsGridCard(
            icon: Icons.notifications_active_rounded,
            title: 'Notifications',
            subtitle: 'Manage app alerts',
            tag: 'Alerts',
            onTap: () => controller.showComingSoon('Notifications'),
            gradient: [
              AppColors.primary.withOpacity(0.14),
              const Color(0xFFEFF6FF),
            ],
          ),
          SettingsGridCard(
            icon: Icons.lock_rounded,
            title: 'Security',
            subtitle: 'App lock and account safety',
            tag: 'Secure',
            onTap: () => controller.showComingSoon('Security'),
            gradient: [
              const Color(0xFFEDE9FE),
              AppColors.secondary.withOpacity(0.10),
            ],
          ),
          SettingsGridCard(
            icon: Icons.palette_rounded,
            title: 'Appearance',
            subtitle: 'Theme and app look',
            tag: 'Style',
            onTap: () => controller.showComingSoon('Appearance'),
            gradient: [
              const Color(0xFFEEF2FF),
              AppColors.primary.withOpacity(0.12),
            ],
          ),
          SettingsGridCard(
            icon: Icons.help_center_rounded,
            title: 'Help & Support',
            subtitle: 'Support and FAQ',
            tag: 'Help',
            onTap: () => controller.showComingSoon('Help & Support'),
            gradient: [
              const Color(0xFFF5F3FF),
              AppColors.secondary.withOpacity(0.12),
            ],
          ),
          SettingsGridCard(
            icon: Icons.info_rounded,
            title: 'About App',
            subtitle: 'Version and app details',
            tag: 'Info',
            onTap: () => controller.showComingSoon('About App'),
            gradient: [
              AppColors.primary.withOpacity(0.12),
              AppColors.secondary.withOpacity(0.08),
            ],
          ),
          SettingsGridCard(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle: 'Sign out from your account',
            tag: 'Exit',
            onTap: controller.logout,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}