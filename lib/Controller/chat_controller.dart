// lib/Controller/chat_controller.dart
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

  Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream;

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
    _messagesStream = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();

    _messagesStream!.listen((snapshot) {
      messages.assignAll(snapshot.docs);
      _markMessagesAsSeen();
    });
  }

  Future<void> _markMessagesAsSeen() async {
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);

      // Just update lastSeenAt & reset unreadCount for current user
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
    if (text.isEmpty) return;

    isSending.value = true;

    try {
      final now = FieldValue.serverTimestamp();
      final chatRef = _firestore.collection('chats').doc(chatId);
      final msgRef = chatRef.collection('messages').doc();

      await msgRef.set({
        'senderId': currentUserId,
        'text': text,
        'createdAt': now,
        'seen': false,
      });

      // Update chat metadata
      await chatRef.set({
        'lastMessage': text,
        'lastMessageAt': now,
        'lastMessageSenderId': currentUserId,
        'unreadCount': {
          otherUserId: FieldValue.increment(1),
        },
        'lastSeenAt': {
          currentUserId: now,
        },
      }, SetOptions(merge: true));

      
      messageController.clear();
    } catch (e, st) {
      AppLogger.e('Failed to send message', error: e, stackTrace: st);
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}