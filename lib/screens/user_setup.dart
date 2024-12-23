import 'package:flutter/material.dart';

class UserSetupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعداد الحساب")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "إدخال البيانات"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ملء البيانات والانتقال إلى الصفحة الرئيسية
              },
              child: Text("إكمال الإعداد"),
            ),
          ],
        ),
      ),
    );
  }
}
