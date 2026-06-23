// lib/Screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/app_colors.dart';
import '../Controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.find<SplashController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.chat_bubble_rounded,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'TimePass Chat',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Connect with friends',
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}
