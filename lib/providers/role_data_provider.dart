import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoleDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getRoleData(String role) {
    return _firestore.collection(role).snapshots();
  }
}
