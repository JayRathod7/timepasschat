// lib/Routes/app_pages.dart
import 'package:get/get.dart';

import '../Bindings/edit_profile_binding.dart';
import '../Bindings/home_binding.dart';
import '../Bindings/login_binding.dart';
import '../Bindings/setting_bindings.dart';
import '../Bindings/splash_binding.dart';
import '../Screens/edit_profile_screen.dart';
import '../Screens/home_screen.dart';
import '../Screens/login_screen.dart';
import '../Screens/setting_screen.dart';
import '../Screens/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
    ),
  ];
}