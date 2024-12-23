import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_service.dart';
import 'Customer_screen.dart';
import 'employee_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشعار
                Image.asset(
                  'assets/images/logo.jpg',
                  height: 120,
                ),
                SizedBox(height: 30),
                // عنوان الصفحة
                Text(
                  'مرحباً بك!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'قم بتسجيل الدخول للمتابعة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 150),
                // حقل إدخال رقم الهاتف
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    hintText: 'أدخل رقم هاتفك',
                    prefixIcon: Icon(Icons.phone, color: Colors.red[300]),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // زر تسجيل الدخول
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () async {
                      String phoneNumber = _phoneController.text.trim();

                      if (phoneNumber.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('يرجى إدخال رقم الهاتف')),
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      // تسجيل الدخول أو إنشاء حساب
                      await firebaseService.loginOrRegisterUser(
                        phoneNumber,
                            (success, message) {
                          setState(() {
                            _isLoading = false;
                          });

                          if (success) {
                            final role = firebaseService.currentUser?.role;
                            final userId = firebaseService.currentUser?.id;

                            if (role != null && userId != null) {
                              if (role == "customer") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MultiStepCategoryScreenn(userId, role),
                                  ),
                                );
                              } else if (role == "employee" || role == "admin") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectsScreen(userId, role),
                                  ),
                                );
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
