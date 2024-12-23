import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/userModel.dart';

class FirebaseService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> loginOrRegisterUser(
      String phoneNumber, Function(bool, String) callback) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // المستخدم موجود
        final doc = snapshot.docs.first;
        _currentUser =
            UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        notifyListeners();
        callback(true, "تم تسجيل الدخول بنجاح!");
      } else {
        // المستخدم جديد
        final docRef = await _firestore.collection('users').add({
          'phone': phoneNumber,
          'role': 'customer',
          'created_at': FieldValue.serverTimestamp(),
        });
        _currentUser =
            UserModel(id: docRef.id, phone: phoneNumber, role: 'customer');
        notifyListeners();
        callback(true, "تم إنشاء حساب جديد وتسجيل الدخول!");
      }
    } catch (e) {
      callback(false, "حدث خطأ أثناء تسجيل الدخول: ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchProjects() async {
    try {
      final snapshot = await _firestore.collection('projects').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // لحفظ معرف المستند
          ...doc.data(), // تضمين جميع البيانات
        };
      }).toList();
    } catch (e) {
      print('Error fetching projects: $e');
      throw Exception('Failed to fetch projects');
    }
  }
}
