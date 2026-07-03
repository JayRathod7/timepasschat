// lib/Screens/home_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../Constants/app_colors.dart';
import '../Controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();

    if (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day) {
      final hour =
      date.hour > 12 ? date.hour - 12 : date.hour == 0 ? 12 : date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Obx(
              () => Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(controller.currentUserId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            final userData = snapshot.data?.data();
                            final image = userData?['profileImage'];

                            return CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white24,
                              backgroundImage: image != null &&
                                  image.toString().isNotEmpty
                                  ? NetworkImage(image)
                                  : null,
                              child: image == null || image.toString().isEmpty
                                  ? const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                              )
                                  : null,
                            );
                          },
                        ),
                        const Gap(12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Messages',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Search users and start chatting',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: controller.toggleSearch,
                          icon: Icon(
                            controller.isSearching.value
                                ? Icons.close_rounded
                                : Icons.search_rounded,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                  20,
                                  20,
                                  20,
                                  20 + bottomInset,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.settings),
                                      title: const Text('Settings'),
                                      onTap: Get.back,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.logout),
                                      title: const Text('Logout'),
                                      onTap: () {
                                        Get.back();
                                        controller.logout();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (controller.isSearching.value) ...[
                      const Gap(16),
                      TextField(
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search user by name or email',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: controller.isSearching.value &&
                    controller.searchText.value.isNotEmpty
                    ? StreamBuilder<List<Map<String, dynamic>>>(
                  stream: controller.searchUsersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final docs = snapshot.data ?? [];

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text('No users found'),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        16 + bottomInset,
                      ),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final user = docs[index];
                        final image = user['profileImage'];

                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => controller.openChatWithUser(user),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                    const Color(0xFFE9ECF5),
                                    backgroundImage: image != null &&
                                        image.toString().isNotEmpty
                                        ? NetworkImage(image)
                                        : null,
                                    child: image == null ||
                                        image.toString().isEmpty
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['name'] ?? 'User',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Gap(4),
                                        Text(
                                          user['email'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chat_bubble_outline),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.recentChatsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final chats = snapshot.data?.docs ?? [];

                    if (chats.isEmpty) {
                      return const Center(
                        child: Text(
                          'No chats yet.\nSearch user and start conversation.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        16 + bottomInset,
                      ),
                      itemCount: chats.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final chat = chats[index].data();
                        final members =
                        List<String>.from(chat['members'] ?? []);
                        final otherUserId = members.firstWhere(
                              (id) => id != controller.currentUserId,
                        );

                        final memberDetails = Map<String, dynamic>.from(
                          chat['memberDetails'] ?? {},
                        );
                        final otherUser = Map<String, dynamic>.from(
                          memberDetails[otherUserId] ?? {},
                        );

                        final unreadMap = Map<String, dynamic>.from(
                          chat['unreadCount'] ?? {},
                        );
                        final unreadCount =
                        (unreadMap[controller.currentUserId] ?? 0)
                        as int;

                        final profileImage = otherUser['profileImage'];
                        final userName = otherUser['name'] ?? 'User';

                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              Get.toNamed(
                                '/chat',
                                arguments: {
                                  'chatId': chat['chatId'],
                                  'otherUserId': otherUserId,
                                  'otherUserName': userName,
                                  'otherUserImage': profileImage ?? '',
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                    const Color(0xFFE9ECF5),
                                    backgroundImage: profileImage != null &&
                                        profileImage
                                            .toString()
                                            .isNotEmpty
                                        ? NetworkImage(profileImage)
                                        : null,
                                    child: profileImage == null ||
                                        profileImage
                                            .toString()
                                            .isEmpty
                                        ? const Icon(Icons.person_rounded)
                                        : null,
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                userName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  unreadCount > 0
                                                      ? FontWeight.w800
                                                      : FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _formatTime(
                                                chat['lastMessageAt'],
                                              ),
                                              style: TextStyle(
                                                color: unreadCount > 0
                                                    ? AppColors.primary
                                                    : Colors.grey,
                                                fontSize: 12,
                                                fontWeight:
                                                unreadCount > 0
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(6),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                (chat['lastMessage'] ?? '')
                                                    .toString()
                                                    .isEmpty
                                                    ? 'Start conversation'
                                                    : chat['lastMessage'],
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: unreadCount > 0
                                                      ? AppColors
                                                      .textPrimary
                                                      : Colors.grey.shade600,
                                                  fontWeight:
                                                  unreadCount > 0
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            const Gap(10),
                                            if (unreadCount > 0)
                                              Container(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                child: Text(
                                                  unreadCount > 99
                                                      ? '99+'
                                                      : unreadCount
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                  ),
                                                ),
                                              )
                                            else
                                              const Icon(
                                                Icons.done_all_rounded,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}