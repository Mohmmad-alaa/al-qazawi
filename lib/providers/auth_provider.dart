import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> login(String phone, String password) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (userSnapshot.docs.isEmpty) {
        return 'رقم الهاتف غير موجود!';
      }

      final userData = userSnapshot.docs.first.data();
      if (userData['password'] != password) {
        return 'كلمة المرور غير صحيحة!';
      }

      return userData['role'];
    } catch (e) {
      return 'حدث خطأ: $e';
    }
  }
}
