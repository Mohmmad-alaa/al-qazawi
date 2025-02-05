import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/userModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

import '../screens/UserDetailsPage.dart';

class FirebaseService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> loginOrRegisterUser(
      BuildContext context,
      String phoneNumber,
      Function(bool, String) callback,
      ) async {
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
          'name':''
        });
        _currentUser =
            UserModel(id: docRef.id, phone: phoneNumber, role: 'customer');
        notifyListeners();
        // التنقل إلى صفحة إدخال بيانات المستخدم الجديد
        callback(true, "تم إنشاء حساب جديد، يُرجى إدخال بياناتك.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsPage(userId: docRef.id),
          ),
        );
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

  Future<List<Map<String, dynamic>>> fetchProjectsByUserId(
      String userId) async {
    try {
      // استعلام لجلب المشاريع بناءً على userId
      final snapshot = await _firestore
          .collection('projects')
          .where('userId',
              isEqualTo:
                  userId) // استخدام arrayContains إذا كان الحقل عبارة عن قائمة
          .get();

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

  Future<void> uploadPdfToFirebase(BuildContext context) async {
    // اختيار ملف PDF
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // رفع الملف إلى Firebase Storage
      try {
        String fileName = result.files.single.name;

        // الحصول على مرجع Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child('pdfs/$fileName');

        // رفع الملف
        UploadTask uploadTask = storageRef.putFile(file);

        // متابعة حالة التحميل
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // عرض رسالة النجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم رفع الملف بنجاح: $downloadUrl')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء رفع الملف: $e')),
        );
      }
    } else {
      // المستخدم لم يختار ملفًا
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم اختيار ملف')),
      );
    }
  }
  // دالة لجلب بيانات المستخدم بناءً على userId
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      // جلب الوثيقة من مجموعة "users" باستخدام userId
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // إذا كانت الوثيقة موجودة، قم بإرجاع البيانات
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('المستخدم غير موجود');
        return null;
      }
    } catch (e) {
      print('حدث خطأ أثناء جلب بيانات المستخدم: $e');
      return null;
    }
  }

}


