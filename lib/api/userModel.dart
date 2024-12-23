class UserModel {
  final String id;
  final String phone;
  final String role;

  UserModel({required this.id, required this.phone, required this.role});

  // دالة لتحويل بيانات Firebase إلى نموذج المستخدم
  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'customer',
    );
  }
}