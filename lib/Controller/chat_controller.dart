// lib/Controller/chat_controller.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/app_logger.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final String chatId;
  late final String otherUserId;
  late final String otherUserName;
  late final String otherUserImage;
  late final String currentUserId;

  final TextEditingController messageController = TextEditingController();
  final RxBool isSending = false.obs;

  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> messages =
      <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messagesSubscription;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    chatId = args?['chatId'] ?? '';
    otherUserId = args?['otherUserId'] ?? '';
    otherUserName = args?['otherUserName'] ?? 'User';
    otherUserImage = args?['otherUserImage'] ?? '';

    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    currentUserId = user.uid;

    _listenToMessages();
    _markMessagesAsSeen();
  }

  void _listenToMessages() {
    _messagesSubscription?.cancel();

    _messagesSubscription = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.assignAll(snapshot.docs);
      _markMessagesAsSeen();
    });
  }

  Future<Map<String, dynamic>> _getCurrentUserData() async {
    final doc = await _firestore.collection('users').doc(currentUserId).get();
    return doc.data() ?? {};
  }

  Future<void> _ensureChatDocument() async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    if (chatDoc.exists) return;

    final currentUserData = await _getCurrentUserData();

    await chatRef.set({
      'chatId': chatId,
      'members': [currentUserId, otherUserId],
      'memberDetails': {
        currentUserId: {
          'name': currentUserData['name'] ?? '',
          'profileImage': currentUserData['profileImage'] ?? '',
        },
        otherUserId: {
          'name': otherUserName,
          'profileImage': otherUserImage,
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
    }, SetOptions(merge: true));
  }

  Future<void> _markMessagesAsSeen() async {
    try {
      if (chatId.isEmpty || currentUserId.isEmpty) return;

      final chatRef = _firestore.collection('chats').doc(chatId);

      await chatRef.set({
        'lastSeenAt': {
          currentUserId: FieldValue.serverTimestamp(),
        },
        'unreadCount': {
          currentUserId: 0,
        },
      }, SetOptions(merge: true));
    } catch (e, st) {
      AppLogger.e('Failed to mark messages as seen', error: e, stackTrace: st);
    }
  }

  bool isMyMessage(Map<String, dynamic> data) {
    return data['senderId'] == currentUserId;
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

    try {
      isSending.value = true;

      await _ensureChatDocument();

      final currentUserData = await _getCurrentUserData();
      final chatRef = _firestore.collection('chats').doc(chatId);

      await chatRef.collection('messages').add({
        'text': text,
        'senderId': currentUserId,
        'receiverId': otherUserId,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'text',
      });

      await chatRef.update({
        'chatId': chatId,
        'members': [currentUserId, otherUserId],
        'lastMessage': text,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'lastMessageSenderId': currentUserId,

        'memberDetails.$currentUserId.name':
        currentUserData['name'] ?? '',
        'memberDetails.$currentUserId.profileImage':
        currentUserData['profileImage'] ?? '',

        'memberDetails.$otherUserId.name': otherUserName,
        'memberDetails.$otherUserId.profileImage': otherUserImage,

        'unreadCount.$currentUserId': 0,
        'unreadCount.$otherUserId': FieldValue.increment(1),

        'lastSeenAt.$currentUserId': FieldValue.serverTimestamp(),
      });

      messageController.clear();
    } catch (e, st) {
      AppLogger.e('Message send failed', error: e, stackTrace: st);
      Get.snackbar(
        'Error',
        'Message send failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    messageController.dispose();
    super.onClose();
  }
}
