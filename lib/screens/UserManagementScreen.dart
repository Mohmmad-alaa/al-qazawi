import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatefulWidget {
  String role;
  UserManagementScreen(this.role);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String searchQuery = '';
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }

  // التحقق من إذا كان المستخدم الحالي هو Admin
  Future<void> _checkIfAdmin() async {
    setState(() {
      isAdmin = widget.role == 'admin';
    });

    if (!isAdmin) {
      _redirectToHome();
    }
  }

  void _redirectToHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      print("back");
    });
  }

  // تحديث دور المستخدم
  void _updateUserRole(String userId, String newRole) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'role': newRole,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث دور المستخدم بنجاح.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحديث الدور: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdmin) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن مستخدم...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // قائمة المستخدمين
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد مستخدمين حاليًا'),
                  );
                }

                final users = snapshot.data!.docs.where((user) {
                  final userName = user['name'].toLowerCase();
                  final userPhone = user['phone'].toLowerCase();
                  final userRole = user['role'].toLowerCase();
                  return userName.contains(searchQuery) || userPhone.contains(searchQuery) ||
                      userRole.contains(searchQuery);
                }).toList();

                if (users.isEmpty) {
                  return const Center(
                    child: Text('لا توجد نتائج مطابقة للبحث'),
                  );
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userId = user.id;
                    final userName = user['name'];
                    final userPhone = user['phone'];
                    final userRole = user['role'];

                    return userRole != 'admin' ? ListTile(
                      title: Text('$userName\n$userPhone'),
                      subtitle: Text('الدور الحالي: $userRole'),
                      trailing: DropdownButton<String>(
                        value: userRole,
                        onChanged: (newRole) {
                          if (newRole != null) {
                            _updateUserRole(userId, newRole);
                          }
                        },
                        items: ['customer', 'employee'].map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                      ),
                    ):Text('') ;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
