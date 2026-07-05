// lib/Screens/chat_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Controller/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.find<ChatController>();
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF7F8FC),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            _ChatHeader(
              topInset: topInset,
              controller: controller,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFF7F8FC),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6C63FF).withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -25,
                    bottom: 100,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4F46E5).withOpacity(0.04),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final msgs = controller.messages;

                          if (msgs.isEmpty) {
                            return Center(
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 28),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x12000000),
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Color(0xFFEDEBFF),
                                      child: Icon(
                                        Icons.forum_rounded,
                                        color: Color(0xFF5B4CF0),
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      'No messages yet',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Start a lovely conversation by sending your first message.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.fromLTRB(14, 18, 14, 10),
                            itemCount: msgs.length,
                            itemBuilder: (context, index) {
                              final doc = msgs[index];
                              final data = doc.data();
                              final isMe = controller.isMyMessage(data);

                              return _MessageBubble(
                                docId: doc.id,
                                text: data['text'] ?? '',
                                isMe: isMe,
                                time: _formatTime(data['createdAt']),
                                chatId: controller.chatId,
                              );
                            },
                          );
                        }),
                      ),
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            14,
                            8,
                            14,
                            bottomInset > 0 ? 10 : 14,
                          ),
                          child: _ChatComposer(controller: controller),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(dynamic createdAt) {
    if (createdAt == null) return '';
    try {
      final ts = (createdAt as Timestamp).toDate();
      final hour = ts.hour > 12 ? ts.hour - 12 : ts.hour == 0 ? 12 : ts.hour;
      final min = ts.minute.toString().padLeft(2, '0');
      final period = ts.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$min $period';
    } catch (_) {
      return '';
    }
  }
}

class _ChatHeader extends StatelessWidget {
  final double topInset;
  final ChatController controller;

  const _ChatHeader({
    required this.topInset,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final image = controller.otherUserImage;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14, topInset + 8, 14, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5B4CF0), Color(0xFF6D5DF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x225B4CF0),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _GlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: Get.back,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        backgroundImage:
                        image.isNotEmpty ? NetworkImage(image) : null,
                        child: image.isEmpty
                            ? Text(
                          controller.otherUserName.isNotEmpty
                              ? controller.otherUserName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        )
                            : null,
                      ),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.otherUserName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Online now',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _GlassIconButton(
            icon: Icons.call_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _GlassIconButton(
            icon: Icons.more_vert_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  final ChatController controller;

  const _ChatComposer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: TextField(
              controller: controller.messageController,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Write a message...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.sentiment_satisfied_alt_rounded,
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Obx(
              () => Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x336C63FF),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: controller.isSending.value
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            )
                : IconButton(
              onPressed: controller.sendMessage,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String docId;
  final String text;
  final bool isMe;
  final String time;
  final String chatId;

  const _MessageBubble({
    required this.docId,
    required this.text,
    required this.isMe,
    required this.time,
    required this.chatId,
  });

  Future<void> _deleteMessage(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(docId)
          .delete();

      Get.snackbar(
        'Deleted',
        'Message deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete message',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  Future<void> _showMessageOptions(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              if (text.trim().isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.copy_rounded),
                  title: const Text('Copy message'),
                  onTap: () => Navigator.pop(context, 'copy'),
                ),
              if (isMe)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded,
                      color: Colors.red),
                  title: const Text(
                    'Delete message',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.pop(context, 'delete'),
                ),
            ],
          ),
        );
      },
    );

    if (result == 'copy') {
      await Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        'Copied',
        'Message copied',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
    } else if (result == 'delete') {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete message'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await _deleteMessage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(22),
      topRight: const Radius.circular(22),
      bottomLeft: Radius.circular(isMe ? 22 : 6),
      bottomRight: Radius.circular(isMe ? 6 : 22),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () => _showMessageOptions(context),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.74,
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: isMe ? null : Colors.white,
                  borderRadius: bubbleRadius,
                  boxShadow: [
                    BoxShadow(
                      color: isMe
                          ? const Color(0x226C63FF)
                          : const Color(0x10000000),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.white : const Color(0xFF1F2937),
                    fontSize: 14.5,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(
                  left: isMe ? 0 : 6,
                  right: isMe ? 6 : 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.done_all_rounded,
                        size: 14,
                        color: Colors.indigo.shade300,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.14),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
