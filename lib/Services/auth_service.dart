// lib/Services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  UserService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveUser({
    required User user,
    String? name,
    String? profileImage,
  }) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    final resolvedName = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : (user.displayName ?? 'User').trim();

    final resolvedEmail = (user.email ?? '').trim();
    final resolvedImage = profileImage ?? (user.photoURL ?? '');

    final data = {
      'uid': user.uid,
      'name': resolvedName,
      'nameLower': resolvedName.toLowerCase(),
      'email': resolvedEmail,
      'emailLower': resolvedEmail.toLowerCase(),
      'profileImage': resolvedImage,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (!doc.exists) {
      await docRef.set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      await docRef.set(data, SetOptions(merge: true));
    }
  }
}