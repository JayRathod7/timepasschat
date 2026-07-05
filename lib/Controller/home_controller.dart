// lib/Controller/home_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Rx;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import '../Routes/app_routes.dart';
import '../Utils/app_logger.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final searchController = TextEditingController();

  final RxString searchText = ''.obs;
  final RxBool isSearching = false.obs;

  String get currentUserId => _auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('HomeController initialized');
  }

  @override
  void onClose() {
    searchController.dispose();
    AppLogger.i('HomeController disposed');
    super.onClose();
  }

  void onSearchChanged(String value) {
    searchText.value = value.trim().toLowerCase();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;

    if (!isSearching.value) {
      searchController.clear();
      searchText.value = '';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> recentChatsStream() {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> searchUsersStream() {
    if (searchText.value.isEmpty) {
      return Stream.value([]);
    }

    final query = searchText.value;

    final nameStream = _firestore
        .collection('users')
        .orderBy('nameLower')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .snapshots();

    final emailStream = _firestore
        .collection('users')
        .orderBy('emailLower')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .snapshots();

    return Rx.combineLatest2(
      nameStream,
      emailStream,
          (
          QuerySnapshot<Map<String, dynamic>> nameSnap,
          QuerySnapshot<Map<String, dynamic>> emailSnap,
          ) {
        final map = <String, Map<String, dynamic>>{};

        for (final doc in nameSnap.docs) {
          final data = doc.data();
          if (data['uid'] != currentUserId) {
            map[doc.id] = data;
          }
        }

        for (final doc in emailSnap.docs) {
          final data = doc.data();
          if (data['uid'] != currentUserId) {
            map[doc.id] = data;
          }
        }

        return map.values.toList();
      },
    );
  }

  String generateChatId(String otherUserId) {
    final ids = [currentUserId, otherUserId]..sort();
    return ids.join('_');
  }

  Future<void> openChatWithUser(Map<String, dynamic> otherUser) async {
    try {
      final String otherUserId = otherUser['uid'];
      final String chatId = generateChatId(otherUserId);

      final currentUserDoc =
      await _firestore.collection('users').doc(currentUserId).get();

      final currentUserData = currentUserDoc.data() ?? {};

      final chatRef = _firestore.collection('chats').doc(chatId);
      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) {
        await chatRef.set({
          'chatId': chatId,
          'members': [currentUserId, otherUserId],
          'memberDetails': {
            currentUserId: {
              'name': currentUserData['name'] ?? '',
              'profileImage': currentUserData['profileImage'] ?? '',
            },
            otherUserId: {
              'name': otherUser['name'] ?? '',
              'profileImage': otherUser['profileImage'] ?? '',
            },
          },
          'lastMessage': '',
          'lastMessageAt': FieldValue.serverTimestamp(),
          'lastMessageSenderId': '',
          'unreadCount': {
            currentUserId: 0,
            otherUserId: 0,
          },
          'lastSeenAt': {
            currentUserId: FieldValue.serverTimestamp(),
            otherUserId: null,
          },
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // ✅ Navigate to ChatScreen
      Get.toNamed(
        AppRoutes.chat,
        arguments: {
          'chatId': chatId,
          'otherUserId': otherUserId,
          'otherUserName': otherUser['name'] ?? 'User',
          'otherUserImage': otherUser['profileImage'] ?? '',
        },
      );
    } catch (e, stackTrace) {
      AppLogger.e(
        'Failed to open chat',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar(
        'Error',
        'Failed to open chat',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e, stackTrace) {
      AppLogger.e(
        'Logout failed',
        error: e,
        stackTrace: stackTrace,
      );
      Get.snackbar(
        'Logout Failed',
        'Something went wrong while logout.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}