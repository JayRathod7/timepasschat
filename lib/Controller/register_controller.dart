// lib/Controller/register_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Routes/app_routes.dart';
import '../Utils/app_logger.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  bool _googleInitialized = false;

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('RegisterController initialized');
  }

  @override
  void onClose() {
    AppLogger.i('RegisterController disposed');
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> _initGoogleSignIn() async {
    if (_googleInitialized) {
      AppLogger.i('GoogleSignIn already initialized');
      return;
    }

    try {
      AppLogger.i('Initializing GoogleSignIn...');

      await _googleSignIn.initialize(serverClientId: 'YOUR_WEB_CLIENT_ID_HERE');

      _googleInitialized = true;
      AppLogger.i('GoogleSignIn initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.e(
        'GoogleSignIn initialization failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> pickDob(BuildContext context) async {
    try {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime(now.year - 18),
        firstDate: DateTime(1950),
        lastDate: now,
      );

      if (picked != null) {
        dobController.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';

        AppLogger.i('DOB selected: ${dobController.text}');
      } else {
        AppLogger.w('DOB picker dismissed without selection');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error while picking DOB', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> registerWithEmailPassword() async {
    if (isLoading.value) {
      AppLogger.w('registerWithEmailPassword ignored: already loading');
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) {
      AppLogger.w(
        'Register form validation failed for email: ${emailController.text.trim()}',
      );
      return;
    }

    try {
      isLoading.value = true;

      final email = emailController.text.trim();
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();

      AppLogger.i('Register started for email: $email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: passwordController.text.trim(),
      );

      AppLogger.i(
        'Firebase user created successfully | uid: ${credential.user?.uid} | email: ${credential.user?.email}',
      );

      await credential.user?.updateDisplayName('$firstName $lastName');

      AppLogger.i(
        'Display name updated: $firstName $lastName | uid: ${credential.user?.uid}',
      );

      if (credential.user != null) {
        AppLogger.i('Navigation to home screen');
        Get.offAllNamed(AppRoutes.home);
      } else {
        AppLogger.w('UserCredential returned but user is null');
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      String message = 'Registration failed. Please try again.';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered. Please login.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak. Use at least 6 characters.';
      } else if (e.code == 'operation-not-allowed') {
        message =
            'Email/Password sign-in is disabled in Firebase Console. Please enable it.';
      }

      AppLogger.e(
        'FirebaseAuthException during register | code: ${e.code} | message: ${e.message} | email: ${emailController.text.trim()}',
        error: e,
        stackTrace: stackTrace,
      );

      Get.snackbar(
        'Register Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.e(
        'Unexpected exception during register | email: ${emailController.text.trim()}',
        error: e,
        stackTrace: stackTrace,
      );

      Get.snackbar(
        'Register Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      AppLogger.i('Register loading finished');
    }
  }

  Future<void> signUpWithGoogle() async {
    if (isGoogleLoading.value) {
      AppLogger.w('signUpWithGoogle ignored: already loading');
      return;
    }

    try {
      isGoogleLoading.value = true;
      AppLogger.i('Google signup started');

      await _initGoogleSignIn();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      AppLogger.i('Google user selected: ${googleUser.email}');

      final GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizeScopes(const ['email', 'profile']);

      final String? accessToken = authorization?.accessToken;
      final String? idToken = googleUser.authentication.idToken;

      AppLogger.i(
        'Google tokens fetched | accessToken null: ${accessToken == null} | idToken null: ${idToken == null}',
      );

      if (accessToken == null || idToken == null) {
        throw Exception('Google token not found.');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      AppLogger.i(
        'Google sign-in success | uid: ${userCredential.user?.uid} | email: ${userCredential.user?.email}',
      );

      if (userCredential.user != null) {
        AppLogger.i('Navigation to home screen after Google signup');
        Get.offAllNamed(AppRoutes.home);
      } else {
        AppLogger.w('Google sign-in completed but user is null');
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.e(
        'FirebaseAuthException during Google signup | code: ${e.code} | message: ${e.message}',
        error: e,
        stackTrace: stackTrace,
      );

      Get.snackbar(
        'Google Register Failed',
        e.message ?? 'Something went wrong.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.e(
        'Unexpected exception during Google signup',
        error: e,
        stackTrace: stackTrace,
      );

      Get.snackbar(
        'Google Register Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGoogleLoading.value = false;
      AppLogger.i('Google signup loading finished');
    }
  }

  void goToLogin() {
    AppLogger.i('Navigating back to login');
    Get.back();
  }
}
