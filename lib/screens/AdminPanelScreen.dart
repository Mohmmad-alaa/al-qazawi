import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  File? _selectedImage;
  final picker = ImagePicker();
  final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('products/${DateTime.now().toIso8601String()}.jpg');
    await imageRef.putFile(image);
    return await imageRef.getDownloadURL();
  }

  void _addProduct() async {
    if (_productNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال اسم المنتج')),
      );
      return;
    }

    if (_productPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال سعر المنتج')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار صورة للمنتج')),
      );
      return;
    }

    try {
      // رفع الصورة والحصول على رابط الصورة
      String imageUrl = await _uploadImage(_selectedImage!);

      // إضافة المنتج إلى قاعدة البيانات
      await productsRef.add({
        'name': _productNameController.text.trim(),
        'price': double.parse(_productPriceController.text),
        'image': imageUrl,
      });

      // إعادة تعيين الحقول بعد الإضافة
      _productNameController.clear();
      _productPriceController.clear();
      setState(() {
        _selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة المنتج بنجاح')),
      );
    } on FormatException catch (e) {
      // معالجة أخطاء التحويل
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('صيغة السعر غير صحيحة: $e')),
      );
    } catch (e) {
      // معالجة الأخطاء الأخرى
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إضافة المنتج: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحكم'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إضافة منتج جديد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'اسم المنتج'),
              ),
              TextField(
                controller: _productPriceController,
                decoration: InputDecoration(labelText: 'سعر المنتج'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _selectedImage == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                      : Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('إضافة المنتج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
